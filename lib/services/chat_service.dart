import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:velmora/services/limit_service.dart';
import 'package:velmora/services/analytics_service.dart';
import 'package:velmora/services/notification_service.dart';
import 'package:velmora/services/rate_limit_service.dart';
import 'package:velmora/services/ai_service.dart';
import 'package:flutter/material.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final LimitService _limitService = LimitService();
  final RateLimitService _rateLimitService = RateLimitService();
  final AnalyticsService _analyticsService = AnalyticsService();
  final NotificationService _notificationService = NotificationService();
  final AIService _aiService = AIService();

  String? get currentUserId => _auth.currentUser?.uid;

  /// Get chat messages stream
  Stream<QuerySnapshot> getChatMessages() {
    if (currentUserId == null) {
      return const Stream.empty();
    }

    return _firestore
        .collection('users')
        .doc(currentUserId)
        .collection('chatMessages')
        .orderBy('timestamp', descending: false)
        .limit(50)
        .snapshots();
  }

  /// Send a message
  Future<void> sendMessage(String message) async {
    if (currentUserId == null || message.trim().isEmpty) return;

    try {
      // Check rate limit
      final rateLimitResult = await _rateLimitService.checkRateLimit(
        'ai_message',
      );
      if (!rateLimitResult.allowed) {
        throw rateLimitResult.reason ?? 'Rate limit exceeded';
      }

      // Check if user can send AI message (legacy limit service)
      final canSend = await _limitService.canSendAIMessage();
      if (!canSend) {
        throw 'Daily AI message limit reached. Upgrade to Premium for unlimited access!';
      }

      // Add user message
      await _firestore
          .collection('users')
          .doc(currentUserId)
          .collection('chatMessages')
          .add({
            'message': message.trim(),
            'isUser': true,
            'timestamp': FieldValue.serverTimestamp(),
          });

      // Log analytics
      await _analyticsService.logChatMessage(false, message.length);

      // Generate AI response
      await _generateAIResponse(message.trim());

      // Record rate limit action
      await _rateLimitService.recordAction(
        'ai_message',
        metadata: {'messageLength': message.length},
      );

      // Increment message count (legacy)
      await _limitService.incrementAIMessageCount();

      // Check if limit reached after this message
      final isLimitReached = await _limitService.isLimitReached();
      if (isLimitReached) {
        await _notificationService.showAILimitReachedNotification();
        await _analyticsService.logAILimitReached();
      }
    } catch (e) {
      throw 'Failed to send message: $e';
    }
  }

  /// Generate AI response using Gemini AI via Firebase Cloud Functions
  Future<void> _generateAIResponse(String userMessage) async {
    if (currentUserId == null) return;

    String aiResponse;
    String language = 'en';

    try {
      // Get user language for fallback if needed
      final userDoc = await _firestore
          .collection('users')
          .doc(currentUserId)
          .get();
      language = userDoc.data()?['preferredLanguage'] ?? 'en';

      // Call real AI service
      aiResponse = await _aiService.generateResponse(userMessage);
    } catch (e) {
      // Fallback to rule-based responses if AI service fails
      debugPrint('AI service failed, using fallback: $e');
      aiResponse = _getAIResponse(userMessage.toLowerCase(), language);
    }

    // Add AI response to Firestore
    await _firestore
        .collection('users')
        .doc(currentUserId)
        .collection('chatMessages')
        .add({
          'message': aiResponse,
          'isUser': false,
          'timestamp': FieldValue.serverTimestamp(),
        });

    // Notify user of AI interaction
    await _notificationService.addInAppNotification(
      title: 'New AI Insight',
      body: 'Your AI companion has replied to your recent message.',
      type: 'ai_chat',
    );

    // Log analytics
    await _analyticsService.logChatMessage(true, aiResponse.length);
  }

  /// Check if user can send message
  Future<bool> canSendMessage() async {
    return await _limitService.canSendAIMessage();
  }

  /// Get remaining messages
  Future<int> getRemainingMessages() async {
    return await _limitService.getRemainingAIMessages();
  }

  /// Get reset time
  String getResetTime() {
    return _limitService.getResetTimeFormatted();
  }

  /// Simple rule-based AI responses
  String _getAIResponse(String message, String language) {
    if (language == 'ar') {
      return _getArabicAIResponse(message);
    } else if (language == 'fr') {
      return _getFrenchAIResponse(message);
    }

    // Greetings
    if (message.contains('hello') ||
        message.contains('hi') ||
        message.contains('hey')) {
      return 'Hello! How can I help you with your relationship today?';
    }

    // Love related
    if (message.contains('love') && !message.contains('language')) {
      return 'Love is a beautiful journey! What would you like to know about strengthening your relationship?';
    }

    // Love languages
    if (message.contains('love language')) {
      return 'The 5 love languages are: Words of Affirmation, Quality Time, Receiving Gifts, Acts of Service, and Physical Touch. Understanding your partner\'s love language can greatly improve your relationship!';
    }

    // Communication
    if (message.contains('communication') ||
        message.contains('talk') ||
        message.contains('speak')) {
      return 'Communication is key in any relationship. Try active listening and expressing your feelings openly. Remember to use "I" statements instead of "you" statements to avoid blame.';
    }

    // Trust
    if (message.contains('trust') || message.contains('honest')) {
      return 'Trust is the foundation of a strong relationship. It takes time to build and requires honesty and consistency. Be reliable, keep your promises, and communicate openly.';
    }

    // Date/Romance
    if (message.contains('date') ||
        message.contains('romantic') ||
        message.contains('romance')) {
      return 'Regular date nights are important! Try our Couples Games feature for fun activities together. Even simple activities like cooking together or taking walks can strengthen your bond.';
    }

    // Default response with variety
    final defaultResponses = [
      'That\'s an interesting question! Remember, every relationship is unique. Focus on open communication, mutual respect, and spending quality time together. Would you like specific advice on any aspect of your relationship?',
      'Great question! Building a strong relationship takes effort from both partners. What specific area would you like to work on - communication, trust, intimacy, or quality time?',
    ];

    return defaultResponses[message.length % defaultResponses.length];
  }

  String _getArabicAIResponse(String message) {
    if (message.contains('مرحبا') || message.contains('أهلا')) {
      return 'أهلاً بك! كيف يمكنني مساعدتك في علاقتك اليوم؟';
    }
    if (message.contains('حب')) {
      return 'الحب رحلة جميلة! ماذا تود أن تعرف عن تقوية علاقتك؟';
    }
    if (message.contains('تواصل')) {
      return 'التواصل هو المفتاح في أي علاقة. حاول الاستماع الفعال والتعبير عن مشاعرك بصدق.';
    }
    return 'هذا سؤال مثير للاهتمام! تذكر أن كل علاقة فريدة من نوعها. ركز على التواصل المفتوح، والاحترام المتبادل، وقضاء وقت ممتع معاً.';
  }

  String _getFrenchAIResponse(String message) {
    if (message.contains('bonjour') || message.contains('salut')) {
      return 'Bonjour ! Comment puis-je vous aider avec votre relation aujourd\'hui ?';
    }
    if (message.contains('amour')) {
      return 'L\'amour est un beau voyage ! Que aimeriez-vous savoir sur le renforcement de votre relation ?';
    }
    if (message.contains('communication')) {
      return 'La communication est essentielle dans toute relation. Essayez l\'écoute active et exprimez vos sentiments ouvertement.';
    }
    return 'C\'est une question intéressante ! N\'oubliez pas que chaque relation est unique. Concentrez-vous sur une communication ouverte, le respect mutuel et le fait de passer du temps de qualité ensemble.';
  }

  /// Clear chat history
  Future<void> clearChatHistory() async {
    if (currentUserId == null) return;

    try {
      final messages = await _firestore
          .collection('users')
          .doc(currentUserId)
          .collection('chatMessages')
          .get();

      for (var doc in messages.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      throw 'Failed to clear chat history: $e';
    }
  }
}
