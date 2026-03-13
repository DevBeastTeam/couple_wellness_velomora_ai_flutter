import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Service to manage game questions with AI generation and local storage
class GameQuestionsService {
  static const String _questionsPrefix = 'game_questions_';
  static const String _lastGeneratedPrefix = 'last_generated_';

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Get questions for a specific game
  /// Returns AI-generated questions if available and not expired, otherwise default questions
  Future<List<Map<String, dynamic>>> getQuestions(String gameId) async {
    try {
      // Check if we need to generate new questions
      final shouldGenerate = await _shouldGenerateNewQuestions(gameId);

      if (shouldGenerate) {
        // Try to generate new questions with AI
        await _generateQuestionsWithAI(gameId);
      }

      // Load questions from local storage
      final storedQuestions = await _loadQuestionsFromLocal(gameId);
      if (storedQuestions.isNotEmpty) {
        return storedQuestions;
      }

      // Fallback to default questions
      return _getDefaultQuestions(gameId);
    } catch (e) {
      print('Error getting questions: $e');
      return _getDefaultQuestions(gameId);
    }
  }

  /// Check if we should generate new questions (once per month)
  Future<bool> _shouldGenerateNewQuestions(String gameId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final lastGeneratedStr = prefs.getString('$_lastGeneratedPrefix$gameId');

      if (lastGeneratedStr == null) {
        return true; // Never generated before
      }

      final lastGenerated = DateTime.parse(lastGeneratedStr);
      final now = DateTime.now();

      // Check if it's a new month
      if (now.year > lastGenerated.year ||
          (now.year == lastGenerated.year && now.month > lastGenerated.month)) {
        return true;
      }

      return false;
    } catch (e) {
      return false; // Don't generate on error
    }
  }

  /// Generate new questions using AI and store in local storage
  Future<void> _generateQuestionsWithAI(String gameId) async {
    try {
      // Get AI configuration
      final aiConfigDoc = await _firestore.collection('ai_config').doc('settings').get();

      if (!aiConfigDoc.exists) {
        print('AI config not found');
        return;
      }

      final aiConfig = aiConfigDoc.data()!;
      final enabled = aiConfig['enabled'] ?? false;

      if (!enabled) {
        print('AI is disabled');
        return;
      }

      final apiKey = aiConfig['apiKey'] as String?;
      if (apiKey == null || apiKey == 'PLACEHOLDER_KEY') {
        print('Invalid API key');
        return;
      }

      // Generate questions based on game type
      final prompt = _getPromptForGame(gameId);
      final questions = await _callGeminiAPI(apiKey, prompt, aiConfig);

      if (questions.isNotEmpty) {
        // Save to local storage
        await _saveQuestionsToLocal(gameId, questions);

        // Update last generated timestamp
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(
          '$_lastGeneratedPrefix$gameId',
          DateTime.now().toIso8601String(),
        );
      }
    } catch (e) {
      print('Error generating questions with AI: $e');
      // Silently fail - will use default questions
    }
  }

  /// Call Gemini API to generate questions
  Future<List<Map<String, dynamic>>> _callGeminiAPI(
    String apiKey,
    String prompt,
    Map<String, dynamic> aiConfig,
  ) async {
    try {
      // This is a placeholder - implement actual API call
      // For now, return empty to use default questions
      return [];
    } catch (e) {
      print('Error calling Gemini API: $e');
      return [];
    }
  }

  /// Get prompt for specific game type
  String _getPromptForGame(String gameId) {
    switch (gameId) {
      case 'truth_or_truth':
        return '''Generate 10 deep, meaningful questions for couples to ask each other in a "Truth or Truth" game.
The questions should promote intimacy, understanding, and meaningful conversation.
Return as JSON array with format: [{"question": "...", "category": "..."}]''';

      case 'love_language_quiz':
        return '''Generate 10 quiz questions to help couples discover their love languages.
Include questions about acts of service, quality time, physical touch, words of affirmation, and receiving gifts.
Return as JSON array with format: [{"question": "...", "category": "..."}]''';

      case 'reflection_game':
        return '''Generate 10 reflection prompts for couples to discuss and deepen their connection.
Focus on gratitude, future planning, and understanding each other better.
Return as JSON array with format: [{"question": "...", "category": "..."}]''';

      case 'couples_challenge':
        return '''Generate 10 fun couple challenges with descriptions.
Return as JSON array with format: [{"question": "Challenge Name", "description": "Challenge description"}]''';

      case 'would_you_rather':
        return '''Generate 10 "Would You Rather" scenarios for couples with two options.
Return as JSON array with format: [{"question": "Would you rather...", "optionA": "...", "optionB": "..."}]''';

      case 'date_night_ideas':
        return '''Generate 10 creative date night ideas with titles, descriptions, and budget levels.
Return as JSON array with format: [{"title": "...", "description": "...", "budget": "Low/Medium/High"}]''';

      case 'relationship_quiz':
        return '''Generate 10 relationship quiz questions with multiple choice options where one is correct.
Return as JSON array with format: [{"question": "...", "options": [{"text": "...", "isCorrect": true/false}]}]''';

      case 'compliment_game':
        return '''Generate 10 compliment prompts to help partners express appreciation.
Return as JSON array with format: [{"prompt": "...", "hint": "..."}]''';

      default:
        return 'Generate 10 meaningful questions for couples.';
    }
  }

  /// Load questions from local storage
  Future<List<Map<String, dynamic>>> _loadQuestionsFromLocal(String gameId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final questionsJson = prefs.getString('$_questionsPrefix$gameId');

      if (questionsJson == null) {
        return [];
      }

      final List<dynamic> decoded = json.decode(questionsJson);
      return decoded.map((q) => q as Map<String, dynamic>).toList();
    } catch (e) {
      print('Error loading questions from local storage: $e');
      return [];
    }
  }

  /// Save questions to local storage
  Future<void> _saveQuestionsToLocal(
    String gameId,
    List<Map<String, dynamic>> questions,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final questionsJson = json.encode(questions);
      await prefs.setString('$_questionsPrefix$gameId', questionsJson);
    } catch (e) {
      print('Error saving questions to local storage: $e');
    }
  }

  /// Get default hardcoded questions for each game
  List<Map<String, dynamic>> _getDefaultQuestions(String gameId) {
    switch (gameId) {
      case 'truth_or_truth':
        return [
          {'question': 'What is your favorite memory of us together?', 'category': 'memories'},
          {'question': 'What do you appreciate most about our relationship?', 'category': 'appreciation'},
          {'question': 'What is one thing you would like us to do together?', 'category': 'future'},
          {'question': 'What makes you feel most loved by me?', 'category': 'love'},
          {'question': 'What is something you have always wanted to tell me?', 'category': 'communication'},
          {'question': 'What is your biggest dream for our future together?', 'category': 'future'},
          {'question': 'What is one thing I do that always makes you smile?', 'category': 'happiness'},
          {'question': 'What is your favorite thing about spending time with me?', 'category': 'quality_time'},
          {'question': 'How do you feel when we are apart?', 'category': 'connection'},
          {'question': 'What is one thing you admire about me?', 'category': 'admiration'},
        ];

      case 'love_language_quiz':
        return [
          {'question': 'Do you prefer receiving gifts or spending quality time together?', 'category': 'preference'},
          {'question': 'What makes you feel more appreciated: words of affirmation or acts of service?', 'category': 'appreciation'},
          {'question': 'How important is physical touch in showing love?', 'category': 'physical_touch'},
          {'question': 'Would you rather hear "I love you" or have someone do something helpful for you?', 'category': 'expression'},
          {'question': 'What type of gift means the most to you?', 'category': 'gifts'},
          {'question': 'How do you prefer to spend quality time with your partner?', 'category': 'quality_time'},
          {'question': 'What acts of service make you feel most loved?', 'category': 'service'},
          {'question': 'How do compliments and encouragement affect you?', 'category': 'words'},
          {'question': 'What kind of physical affection do you value most?', 'category': 'touch'},
          {'question': 'How do you show love to others?', 'category': 'giving'},
        ];

      case 'reflection_game':
        return [
          {'question': 'What are three things you are grateful for in our relationship?', 'category': 'gratitude'},
          {'question': 'Where do you see us in five years?', 'category': 'future'},
          {'question': 'What is one challenge we have overcome together?', 'category': 'growth'},
          {'question': 'How have I helped you become a better person?', 'category': 'impact'},
          {'question': 'What is your favorite tradition we have together?', 'category': 'traditions'},
          {'question': 'What is one thing you want to improve in our relationship?', 'category': 'improvement'},
          {'question': 'How do you feel our communication has evolved?', 'category': 'communication'},
          {'question': 'What is your favorite way we support each other?', 'category': 'support'},
          {'question': 'What makes our relationship unique?', 'category': 'uniqueness'},
          {'question': 'What is one goal we should work on together?', 'category': 'goals'},
        ];

      case 'couples_challenge':
        return [
          {'question': 'Would You Rather', 'description': 'Fun scenarios to explore preferences together'},
          {'question': 'Dance Together', 'description': 'Put on your favorite song and dance for 2 minutes'},
          {'question': 'Compliment Battle', 'description': 'Take turns giving each other compliments for 3 minutes'},
          {'question': 'Memory Lane', 'description': 'Share your favorite memory together and why it\'s special'},
          {'question': 'Future Planning', 'description': 'Describe your dream vacation together in detail'},
          {'question': 'Gratitude Circle', 'description': 'List 5 things you appreciate about each other'},
          {'question': 'Eye Contact', 'description': 'Maintain eye contact for 60 seconds without laughing'},
          {'question': 'Love Letter', 'description': 'Write a short love note to each other (2 minutes)'},
          {'question': 'Dream Date', 'description': 'Plan your perfect date night together with no budget limit'},
          {'question': 'Bucket List', 'description': 'Share 3 things you want to do together before next year'},
        ];

      case 'would_you_rather':
        return [
          {'question': 'Would you rather plan a surprise date or be surprised?', 'optionA': 'Plan a surprise date', 'optionB': 'Be surprised'},
          {'question': 'Would you rather have a romantic dinner or a fun adventure?', 'optionA': 'Romantic dinner', 'optionB': 'Fun adventure'},
          {'question': 'Would you rather watch a movie at home or go to the cinema?', 'optionA': 'Watch at home', 'optionB': 'Go to cinema'},
          {'question': 'Would you rather cook together or order takeout?', 'optionA': 'Cook together', 'optionB': 'Order takeout'},
          {'question': 'Would you rather go for a walk or have a picnic?', 'optionA': 'Go for a walk', 'optionB': 'Have a picnic'},
          {'question': 'Would you rather play a game or have deep conversations?', 'optionA': 'Play a game', 'optionB': 'Deep conversations'},
          {'question': 'Would you rather exchange gifts or spend quality time?', 'optionA': 'Exchange gifts', 'optionB': 'Quality time'},
          {'question': 'Would you rather dance together or sing together?', 'optionA': 'Dance together', 'optionB': 'Sing together'},
          {'question': 'Would you rather stay in pajamas all day or dress up?', 'optionA': 'Pajamas all day', 'optionB': 'Dress up'},
          {'question': 'Would you rather take photos together or just enjoy the moment?', 'optionA': 'Take photos', 'optionB': 'Enjoy the moment'},
        ];

      case 'date_night_ideas':
        return [
          {'title': 'Stargazing Picnic', 'description': 'Pack a blanket, snacks, and gaze at the stars together', 'budget': 'Low'},
          {'title': 'Cooking Class', 'description': 'Learn to make a new cuisine together', 'budget': 'Medium'},
          {'title': 'Sunset Beach Walk', 'description': 'Enjoy a romantic walk along the shore at sunset', 'budget': 'Low'},
          {'title': 'Wine Tasting', 'description': 'Visit a local winery or create a home tasting', 'budget': 'Medium'},
          {'title': 'Amusement Park', 'description': 'Relive childhood with rides and games', 'budget': 'High'},
          {'title': 'Art Museum Visit', 'description': 'Explore art and discuss your favorites', 'budget': 'Low'},
          {'title': 'Couples Spa Night', 'description': 'Create a spa experience at home with massages', 'budget': 'Low'},
          {'title': 'Road Trip Adventure', 'description': 'Drive to a nearby town you have never visited', 'budget': 'Medium'},
          {'title': 'Fine Dining Experience', 'description': 'Dress up and enjoy a fancy dinner', 'budget': 'High'},
          {'title': 'DIY Pizza Night', 'description': 'Make personalized pizzas and get creative', 'budget': 'Low'},
        ];

      case 'relationship_quiz':
        return [
          {
            'question': 'What is your partner\'s favorite way to spend a weekend?',
            'options': [
              {'text': 'Going out and exploring', 'isCorrect': false},
              {'text': 'Relaxing at home', 'isCorrect': false},
              {'text': 'It depends on their mood', 'isCorrect': true},
              {'text': 'Working on projects', 'isCorrect': false},
            ],
          },
          {
            'question': 'What is your partner\'s love language?',
            'options': [
              {'text': 'Words of affirmation', 'isCorrect': false},
              {'text': 'Acts of service', 'isCorrect': false},
              {'text': 'Quality time', 'isCorrect': false},
              {'text': 'Physical touch', 'isCorrect': false},
              {'text': 'Receiving gifts', 'isCorrect': false},
            ],
          },
          {
            'question': 'What makes your partner feel most appreciated?',
            'options': [
              {'text': 'When you help with chores', 'isCorrect': false},
              {'text': 'When you give compliments', 'isCorrect': false},
              {'text': 'When you spend time together', 'isCorrect': false},
              {'text': 'Only they can tell you', 'isCorrect': true},
            ],
          },
          {
            'question': 'What is your partner\'s biggest dream?',
            'options': [
              {'text': 'Career success', 'isCorrect': false},
              {'text': 'Starting a family', 'isCorrect': false},
              {'text': 'Traveling the world', 'isCorrect': false},
              {'text': 'Ask them and find out', 'isCorrect': true},
            ],
          },
          {
            'question': 'How does your partner prefer to resolve conflicts?',
            'options': [
              {'text': 'Talk immediately', 'isCorrect': false},
              {'text': 'Take space then talk', 'isCorrect': false},
              {'text': 'Write about it first', 'isCorrect': false},
              {'text': 'Every person is different', 'isCorrect': true},
            ],
          },
          {
            'question': 'What is your partner\'s favorite meal?',
            'options': [
              {'text': 'Italian food', 'isCorrect': false},
              {'text': 'Asian cuisine', 'isCorrect': false},
              {'text': 'Home-cooked comfort food', 'isCorrect': false},
              {'text': 'Think about what they love', 'isCorrect': true},
            ],
          },
          {
            'question': 'What activity makes your partner happiest?',
            'options': [
              {'text': 'Being outdoors', 'isCorrect': false},
              {'text': 'Creative projects', 'isCorrect': false},
              {'text': 'Social gatherings', 'isCorrect': false},
              {'text': 'Reflect on their joy', 'isCorrect': true},
            ],
          },
          {
            'question': 'What is your partner most proud of?',
            'options': [
              {'text': 'Their career', 'isCorrect': false},
              {'text': 'Their relationships', 'isCorrect': false},
              {'text': 'Personal achievements', 'isCorrect': false},
              {'text': 'Consider their values', 'isCorrect': true},
            ],
          },
          {
            'question': 'How does your partner show love?',
            'options': [
              {'text': 'Through gifts', 'isCorrect': false},
              {'text': 'Through actions', 'isCorrect': false},
              {'text': 'Through words', 'isCorrect': false},
              {'text': 'Observe their behavior', 'isCorrect': true},
            ],
          },
          {
            'question': 'What does your partner need most right now?',
            'options': [
              {'text': 'More time together', 'isCorrect': false},
              {'text': 'Support with stress', 'isCorrect': false},
              {'text': 'Encouragement', 'isCorrect': false},
              {'text': 'Open communication', 'isCorrect': true},
            ],
          },
        ];

      case 'compliment_game':
        return [
          {'prompt': 'Tell your partner what you admire most about their personality', 'hint': 'Think about their kindness, humor, or strength'},
          {'prompt': 'Share a moment when your partner made you feel special', 'hint': 'Recall a specific memory'},
          {'prompt': 'Tell your partner how they have helped you grow', 'hint': 'Think about positive changes'},
          {'prompt': 'Compliment your partner\'s appearance today', 'hint': 'Notice something specific'},
          {'prompt': 'Share what you appreciate about how your partner treats others', 'hint': 'Think about their interactions'},
          {'prompt': 'Tell your partner what makes them unique', 'hint': 'What sets them apart'},
          {'prompt': 'Share a quality your partner has that you wish you had', 'hint': 'Admire their strengths'},
          {'prompt': 'Tell your partner how they make you feel loved', 'hint': 'Reflect on their actions'},
          {'prompt': 'Compliment your partner\'s talents or skills', 'hint': 'What are they good at?'},
          {'prompt': 'Share what you look forward to most about your future together', 'hint': 'Think about your dreams'},
        ];

      default:
        return [
          {'question': 'What do you love most about us?', 'category': 'general'},
        ];
    }
  }

  /// Clear stored questions for a game (for testing)
  Future<void> clearStoredQuestions(String gameId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('$_questionsPrefix$gameId');
      await prefs.remove('$_lastGeneratedPrefix$gameId');
    } catch (e) {
      print('Error clearing questions: $e');
    }
  }
}
