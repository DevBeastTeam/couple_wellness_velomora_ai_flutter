import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:velmora/services/notification_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:velmora/services/rate_limit_service.dart';

/// GameService handles all game-related Firestore operations
class GameService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final RateLimitService _rateLimitService = RateLimitService();

  /// Get current user ID
  String? get currentUserId => _auth.currentUser?.uid;

  /// Collection references
  CollectionReference get _gamesCollection => _firestore.collection('games');

  CollectionReference get _userGamesCollection =>
      _firestore.collection('user_games');

  /// Get all available games
  Future<List<Map<String, dynamic>>> getAvailableGames() async {
    try {
      final QuerySnapshot snapshot = await _gamesCollection.get();
      return snapshot.docs
          .map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>})
          .toList();
    } catch (e) {
      throw 'Failed to fetch games: $e';
    }
  }

  /// Start a new game session
  Future<String> startGameSession({
    required String gameType,
    required String partnerId,
  }) async {
    try {
      // Check rate limit
      final rateLimitResult = await _rateLimitService.checkRateLimit(
        'game_play',
      );
      if (!rateLimitResult.allowed) {
        throw rateLimitResult.reason ?? 'Rate limit exceeded';
      }

      final sessionData = {
        'userId': currentUserId,
        'partnerId': partnerId,
        'gameType': gameType,
        'status': 'active',
        'currentQuestionIndex': 0,
        'score': 0,
        'startedAt': FieldValue.serverTimestamp(),
        'responses': [],
      };

      final docRef = await _userGamesCollection.add(sessionData);

      // Record rate limit action
      await _rateLimitService.recordAction(
        'game_play',
        metadata: {'gameType': gameType},
      );

      return docRef.id;
    } catch (e) {
      throw 'Failed to start game: $e';
    }
  }

  /// Save user response to a question
  Future<void> saveResponse({
    required String sessionId,
    required String questionId,
    required String response,
    required int questionIndex,
  }) async {
    try {
      final responseData = {
        'questionId': questionId,
        'response': response,
        'answeredAt': FieldValue.serverTimestamp(),
      };

      await _userGamesCollection.doc(sessionId).update({
        'responses': FieldValue.arrayUnion([responseData]),
        'currentQuestionIndex': questionIndex + 1,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw 'Failed to save response: $e';
    }
  }

  /// Update game score
  Future<void> updateScore({
    required String sessionId,
    required int score,
  }) async {
    try {
      await _userGamesCollection.doc(sessionId).update({
        'score': score,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw 'Failed to update score: $e';
    }
  }

  /// Complete game session
  Future<void> completeGameSession(String sessionId) async {
    try {
      await _userGamesCollection.doc(sessionId).update({
        'status': 'completed',
        'completedAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      NotificationService().addInAppNotification(
        title: 'Game Completed',
        body: 'You successfully completed a game session!',
        type: 'game',
      );
    } catch (e) {
      throw 'Failed to complete game: $e';
    }
  }

  /// Get user's game history
  Future<List<Map<String, dynamic>>> getUserGameHistory() async {
    try {
      final QuerySnapshot snapshot = await _userGamesCollection
          .where('userId', isEqualTo: currentUserId)
          .orderBy('startedAt', descending: true)
          .get();
      return snapshot.docs
          .map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>})
          .toList();
    } catch (e) {
      throw 'Failed to fetch game history: $e';
    }
  }

  /// Get active game session
  Future<Map<String, dynamic>?> getActiveSession() async {
    try {
      final QuerySnapshot snapshot = await _userGamesCollection
          .where('userId', isEqualTo: currentUserId)
          .where('status', isEqualTo: 'active')
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        return {
          'id': snapshot.docs.first.id,
          ...snapshot.docs.first.data() as Map<String, dynamic>,
        };
      }
      return null;
    } catch (e) {
      throw 'Failed to fetch active session: $e';
    }
  }

  /// Delete game session
  Future<void> deleteGameSession(String sessionId) async {
    try {
      await _userGamesCollection.doc(sessionId).delete();
    } catch (e) {
      throw 'Failed to delete game session: $e';
    }
  }

  /// Stream of user's game sessions for real-time updates
  Stream<QuerySnapshot> get userGameSessionsStream {
    return _userGamesCollection
        .where('userId', isEqualTo: currentUserId)
        .orderBy('startedAt', descending: true)
        .snapshots();
  }

  // ==================== MISSING METHODS FOR GAME SCREEN ====================

  /// Alias for getAvailableGames - used by GamesScreen
  Future<List<Map<String, dynamic>>> getAllGames() async {
    return getAvailableGames();
  }

  /// Get or create user game progress document
  Future<Map<String, dynamic>> getUserGameProgress() async {
    try {
      final userProgressDoc = _firestore
          .collection('user_game_progress')
          .doc(currentUserId);

      final doc = await userProgressDoc.get();

      if (!doc.exists) {
        // Create default progress document
        final defaultProgress = {
          'userId': currentUserId,
          'playedGames': [],
          'sessions': [],
          'totalScore': 0,
          'favoriteGames': [],
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        };
        await userProgressDoc.set(defaultProgress);
        return defaultProgress;
      }

      return doc.data() as Map<String, dynamic>;
    } catch (e) {
      throw 'Failed to fetch user progress: $e';
    }
  }

  /// Check if user can play a specific game (premium check)
  Future<bool> canPlayGame(String gameId) async {
    try {
      // Get user subscription status
      final userDoc = await _firestore
          .collection('users')
          .doc(currentUserId)
          .get();
      final userData = userDoc.data();

      if (userData == null) return false;

      final subscriptionStatus = userData['subscriptionStatus'] ?? 'free';
      final featuresAccess =
          userData['featuresAccess'] as Map<String, dynamic>?;

      // Premium users can play all games
      if (subscriptionStatus == 'premium') return true;

      // Trial users with games access
      if (subscriptionStatus == 'trial' && featuresAccess?['games'] == true) {
        return true;
      }

      // Free users - only allow specific free games
      final freeGames = ['truth_or_truth']; // Define free games
      return freeGames.contains(gameId);
    } catch (e) {
      return false;
    }
  }

  /// Start game session with just gameId (for GamesScreen)
  Future<String> startGameSessionById(String gameId) async {
    try {
      // Check rate limit
      final rateLimitResult = await _rateLimitService.checkRateLimit(
        'game_play',
      );
      if (!rateLimitResult.allowed) {
        throw rateLimitResult.reason ?? 'Rate limit exceeded';
      }

      final sessionData = {
        'userId': currentUserId,
        'gameId': gameId,
        'gameType': gameId,
        'status': 'active',
        'currentQuestionIndex': 0,
        'score': 0,
        'startedAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'responses': [],
      };

      final docRef = await _userGamesCollection.add(sessionData);

      // Update user progress
      await _updateUserProgressOnStart(gameId);

      // Record rate limit action
      await _rateLimitService.recordAction(
        'game_play',
        metadata: {'gameId': gameId},
      );

      return docRef.id;
    } catch (e) {
      throw 'Failed to start game session: $e';
    }
  }

  /// Update user progress when starting a game
  Future<void> _updateUserProgressOnStart(String gameId) async {
    try {
      final userProgressDoc = _firestore
          .collection('user_game_progress')
          .doc(currentUserId);

      final doc = await userProgressDoc.get();

      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        final playedGames = List<dynamic>.from(data['playedGames'] ?? []);

        // Check if game already in played games
        final existingIndex = playedGames.indexWhere((g) {
          if (g is Map) return g['gameId'] == gameId;
          if (g is String) return g == gameId;
          return false;
        });

        if (existingIndex == -1) {
          // Add new game to played games
          await userProgressDoc.update({
            'playedGames': FieldValue.arrayUnion([
              {'gameId': gameId, 'startedAt': FieldValue.serverTimestamp()},
            ]),
            'sessions': FieldValue.arrayUnion([
              {'gameId': gameId, 'startedAt': FieldValue.serverTimestamp()},
            ]),
            'updatedAt': FieldValue.serverTimestamp(),
          });
        } else {
          // Just add to sessions
          await userProgressDoc.update({
            'sessions': FieldValue.arrayUnion([
              {'gameId': gameId, 'startedAt': FieldValue.serverTimestamp()},
            ]),
            'updatedAt': FieldValue.serverTimestamp(),
          });
        }
      }
    } catch (e) {
      // Silently fail - not critical
    }
  }

  // ==================== END MISSING METHODS ====================

  /// Add game to favorites
  Future<void> addToFavorites(String gameId) async {
    try {
      final userDoc = _firestore.collection('users').doc(currentUserId);
      await userDoc.update({
        'favoriteGames': FieldValue.arrayUnion([gameId]),
      });
    } catch (e) {
      throw 'Failed to add to favorites: $e';
    }
  }

  /// Remove game from favorites
  Future<void> removeFromFavorites(String gameId) async {
    try {
      final userDoc = _firestore.collection('users').doc(currentUserId);
      await userDoc.update({
        'favoriteGames': FieldValue.arrayRemove([gameId]),
      });
    } catch (e) {
      throw 'Failed to remove from favorites: $e';
    }
  }
}
