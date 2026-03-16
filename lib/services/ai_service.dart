import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

/// AI Service for Gemini AI integration with Firestore control
///
/// AI configuration is stored in Firestore for remote control
/// API key is stored securely in Firestore config document
class AIService {
  static final AIService _instance = AIService._internal();
  factory AIService() => _instance;
  AIService._internal();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Gemini API configuration
  String? _apiKey;
  String _apiUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent';

  // AI Settings from Firestore
  Map<String, dynamic> _aiSettings = {};
  bool _isInitialized = false;

  // Requirement 9.3: Cap context window to 3-5 messages
  static const int _chatHistoryLimit = 4;

  /// Initialize the AI service - load config from Firestore
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      await _loadAIConfig();
      _isInitialized = true;
      debugPrint('AI Service initialized');
    } catch (e) {
      debugPrint('Error initializing AI service: $e');
    }
  }

  /// Load AI configuration from Firestore
  /// Config is stored in: ai_config/doc
  Future<void> _loadAIConfig() async {
    try {
      // Load AI configuration from Firestore
      final configDoc = await _firestore
          .collection('ai_config')
          .doc('settings')
          .get();

      if (configDoc.exists) {
        _aiSettings = configDoc.data() ?? {};
        _apiKey = _aiSettings['apiKey'] as String?;

        // Override API URL if custom model is set
        final model = _aiSettings['model'] as String?;
        if (model != null && model.isNotEmpty) {
          _apiUrl =
              'https://generativelanguage.googleapis.com/v1beta/models/$model:generateContent';
        }
      }

      // Fallback: If no config in Firestore, set to null
      if (_apiKey == null || _apiKey!.isEmpty) {
        _apiKey = null;
        debugPrint(
          'No API key found in Firestore. Please configure in ai_config/settings document.',
        );
      }
    } catch (e) {
      debugPrint('Error loading AI config: $e');
      _apiKey = null;
    }
  }

  /// Update AI config in Firestore (for admin use)
  Future<void> updateAIConfig(Map<String, dynamic> config) async {
    try {
      await _firestore.collection('ai_config').doc('settings').update(config);
      await _loadAIConfig(); // Reload config
      debugPrint('AI config updated');
    } catch (e) {
      debugPrint('Error updating AI config: $e');
      rethrow;
    }
  }

  String? get currentUserId => _auth.currentUser?.uid;

  /// Get conversation history for a user (sliding window - last 5 messages)
  Future<List<Map<String, dynamic>>> _getConversationHistory() async {
    if (currentUserId == null) return [];

    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(currentUserId)
          .collection('chatMessages')
          .orderBy('timestamp', descending: true)
          .limit(_chatHistoryLimit)
          .get();

      final history = <Map<String, dynamic>>[];

      // Reverse to get chronological order
      for (var doc in snapshot.docs.reversed) {
        final data = doc.data();
        history.add({
          'role': (data['isUser'] == true) ? 'user' : 'model',
          'content': data['message'] ?? '',
        });
      }

      return history;
    } catch (e) {
      debugPrint('Error getting conversation history: $e');
      return [];
    }
  }

  /// Get user's preferred language
  Future<String> _getUserLanguage() async {
    if (currentUserId == null) return 'en';

    try {
      final doc = await _firestore.collection('users').doc(currentUserId).get();
      return doc.data()?['preferredLanguage'] ?? 'en';
    } catch (e) {
      debugPrint('Error getting language: $e');
      return 'en';
    }
  }

  /// Generate AI response using Gemini API
  ///
  /// Returns the AI response text or throws an exception on error
  Future<String> generateResponse(String userMessage) async {
    if (_apiKey == null || _apiKey!.isEmpty) {
      throw Exception(
        'AI Service is not configured. Please contact administrator.',
      );
    }

    // Check if AI is enabled in Firestore config
    if (_aiSettings['enabled'] == false) {
      throw Exception('AI chat is currently disabled by admin');
    }

    try {
      // Get conversation history and language
      final history = await _getConversationHistory();
      final language = await _getUserLanguage();

      // Build the prompt with context
      final prompt = _buildPrompt(userMessage, language, history);

      // Call Gemini API
      final response = await _callGeminiAPI(prompt);

      return response;
    } catch (e) {
      debugPrint('AI generation error: $e');

      // If API key error, try reloading config
      if (e.toString().contains('API_KEY') || e.toString().contains('403')) {
        await _loadAIConfig();
        // Retry once with reloaded config
        try {
          final history = await _getConversationHistory();
          final language = await _getUserLanguage();
          final prompt = _buildPrompt(userMessage, language, history);
          return await _callGeminiAPI(prompt);
        } catch (retryError) {
          throw Exception('AI service error. Please try again later.');
        }
      }

      throw Exception('Failed to generate response. Please try again.');
    }
  }

  /// Build the prompt with system instructions and conversation history
  String _buildPrompt(
    String userMessage,
    String language,
    List<Map<String, dynamic>> history,
  ) {
    // Get system instruction from Firestore or use default
    final systemInstruction = _aiSettings['systemInstruction'] as String? ??
        'You are Velmora AI, a helpful relationship coach.';

    // Get language name
    final languageName = _getLanguageName(language);

    // Build conversation context
    final buffer = StringBuffer();
    buffer.writeln(systemInstruction);
    buffer.writeln('IMPORTANT: You MUST respond in $languageName. This is the user\'s preferred language.');
    buffer.writeln();

    // Add recent history (sliding window)
    if (history.isNotEmpty) {
      buffer.writeln('Previous conversation:');
      for (var msg in history) {
        final role = msg['role'] == 'user' ? 'User' : 'Assistant';
        buffer.writeln('$role: ${msg['content']}');
      }
      buffer.writeln();
    }

    buffer.writeln('User: $userMessage');
    buffer.writeln('Assistant:');

    return buffer.toString();
  }

  /// Call Gemini API directly
  Future<String> _callGeminiAPI(String prompt) async {
    if (_apiKey == null || _apiKey!.isEmpty) {
      throw Exception('API key not configured');
    }

    try {
      final url = Uri.parse('$_apiUrl?key=$_apiKey');

      // Get generation config from Firestore or use defaults
      final maxTokens = _aiSettings['maxTokens'] as int? ?? 500;
      final temperature = (_aiSettings['temperature'] as num?)?.toDouble() ?? 0.7;
      final topK = _aiSettings['topK'] as int? ?? 40;
      final topP = (_aiSettings['topP'] as num?)?.toDouble() ?? 0.95;

      // Get safety settings from Firestore or use defaults
      final safetySettings = _aiSettings['safetySettings'] as Map<String, dynamic>? ?? {};
      final dangerousContent = safetySettings['dangerousContent'] as String? ?? 'BLOCK_MEDIUM_AND_ABOVE';
      final harassment = safetySettings['harassment'] as String? ?? 'BLOCK_MEDIUM_AND_ABOVE';
      final hateSpeech = safetySettings['hateSpeech'] as String? ?? 'BLOCK_MEDIUM_AND_ABOVE';
      final sexuallyExplicit = safetySettings['sexuallyExplicit'] as String? ?? 'BLOCK_MEDIUM_AND_ABOVE';

      final requestBody = {
        'contents': [
          {
            'parts': [
              {'text': prompt},
            ],
          },
        ],
        'generationConfig': {
          'maxOutputTokens': maxTokens,
          'temperature': temperature,
          'topK': topK,
          'topP': topP,
        },
        'safetySettings': [
          {
            'category': 'HARM_CATEGORY_SEXUALLY_EXPLICIT',
            'threshold': sexuallyExplicit,
          },
          {
            'category': 'HARM_CATEGORY_HATE_SPEECH',
            'threshold': hateSpeech,
          },
          {
            'category': 'HARM_CATEGORY_HARASSMENT',
            'threshold': harassment,
          },
          {
            'category': 'HARM_CATEGORY_DANGEROUS_CONTENT',
            'threshold': dangerousContent,
          },
        ],
      };

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Extract response text
        if (data['candidates'] != null &&
            data['candidates'].isNotEmpty &&
            data['candidates'][0]['content'] != null &&
            data['candidates'][0]['content']['parts'] != null &&
            data['candidates'][0]['content']['parts'].isNotEmpty) {
          return data['candidates'][0]['content']['parts'][0]['text'];
        }

        throw Exception('Invalid response format from AI');
      } else {
        final errorData = jsonDecode(response.body);
        final errorMessage = errorData['error']?['message'] ?? 'Unknown error';
        debugPrint('Gemini API error (${response.statusCode}): $errorMessage');

        if (response.statusCode == 403) {
          throw Exception('API key invalid or expired');
        } else if (response.statusCode == 429) {
          throw Exception('Rate limit exceeded. Please try again later.');
        } else {
          throw Exception('AI service error: $errorMessage');
        }
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Network error. Please check your connection.');
    }
  }

  /// Get language name from code
  String _getLanguageName(String code) {
    switch (code) {
      case 'ar':
        return 'Arabic';
      case 'fr':
        return 'French';
      default:
        return 'English';
    }
  }

  /// Check if AI service is available
  Future<bool> isAvailable() async {
    try {
      await _loadAIConfig();
      return _apiKey != null &&
          _apiKey!.isNotEmpty &&
          _aiSettings['enabled'] != false;
    } catch (e) {
      return false;
    }
  }

  /// Get AI settings (for admin/debugging)
  Map<String, dynamic> get settings => Map.unmodifiable(_aiSettings);

  /// Generate game content based on game ID
  Future<List<Map<String, dynamic>>> generateGameContent(String gameId) async {
    if (_apiKey == null || _apiKey!.isEmpty) {
      throw Exception('AI Service is not configured.');
    }

    String prompt = '';
    switch (gameId) {
      case 'truth_or_truth':
        prompt = '''Generate 15 "Truth or Truth" questions for couples. 
        The questions should be deep, meaningful, and varied (covering intimacy, future, daily life, emotional bonding).
        Return ONLY a JSON array of objects with the following structure:
        [
          {
            "id": "q1",
            "question": "The question text here",
            "question_translations": {"en": "...", "ar": "...", "fr": "..."},
            "category": "connection",
            "difficulty": "medium"
          }
        ]
        Categories can be: connection, future, understanding, fun.
        Difficulties can be: easy, medium, deep.''';
        break;
      case 'love_language_quiz':
        prompt = '''Generate 5 "Love Language Quiz" questions for couples.
        Each question must have exactly 5 options, one for each love language: words_of_affirmation, quality_time, receiving_gifts, acts_of_service, physical_touch.
        Return ONLY a JSON array of objects with the following structure:
        [
          {
            "id": "q1",
            "question": "Question text here",
            "question_translations": {"en": "...", "ar": "...", "fr": "..."},
            "options": [
              {"text": "Option text", "language": "words_of_affirmation", "text_translations": {"en": "...", "ar": "...", "fr": "..."}},
              {"text": "Option text", "language": "quality_time", "text_translations": {"en": "...", "ar": "...", "fr": "..."}},
              {"text": "Option text", "language": "receiving_gifts", "text_translations": {"en": "...", "ar": "...", "fr": "..."}},
              {"text": "Option text", "language": "acts_of_service", "text_translations": {"en": "...", "ar": "...", "fr": "..."}},
              {"text": "Option text", "language": "physical_touch", "text_translations": {"en": "...", "ar": "...", "fr": "..."}}
            ]
          }
        ]''';
        break;
      case 'reflection_game':
        prompt = '''Generate 10 reflection prompts for couples.
        The prompts should encourage meaningful discussion and shared growth.
        Return ONLY a JSON array of objects with the following structure:
        [
          {
            "id": "q1",
            "question": "Reflection prompt text here",
            "question_translations": {"en": "...", "ar": "...", "fr": "..."},
            "category": "reflection",
            "order": 1
          }
        ]''';
        break;
      default:
        throw Exception('Unknown game ID: $gameId');
    }

    try {
      final response = await _callGeminiAPI(
        "$prompt\n\nIMPORTANT: Return ONLY valid JSON. No markdown formatting, no backticks.",
      );

      // Clean up response if it contains markdown code blocks
      String cleanJson = response.trim();
      if (cleanJson.startsWith('```json')) {
        cleanJson = cleanJson.substring(7, cleanJson.lastIndexOf('```')).trim();
      } else if (cleanJson.startsWith('```')) {
        cleanJson = cleanJson.substring(3, cleanJson.lastIndexOf('```')).trim();
      }

      final List<dynamic> decoded = jsonDecode(cleanJson);
      return decoded.cast<Map<String, dynamic>>();
    } catch (e) {
      debugPrint('Error generating game content for $gameId: $e');
      rethrow;
    }
  }
}
