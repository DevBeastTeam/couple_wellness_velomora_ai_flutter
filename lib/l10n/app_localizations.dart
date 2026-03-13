import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const List<Locale> supportedLocales = [
    Locale('en', ''),
    Locale('ar', ''),
    Locale('fr', ''),
  ];

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      // Home Screen
      'welcome_back': 'Welcome Back',
      'welcome': 'Welcome',
      'home': 'Home',
      'explore_features': 'Explore our features designed for couples',
      'premium_feature': 'Premium Feature',
      'premium_message':
          'This feature requires a premium subscription. Start your free trial to access all features!',
      'is_a_premium_feature_upgrade_to_unlock_full_access': 'is a premium feature. Upgrade to unlock full access.',
      'upgrade_to_premium': 'Upgrade to Premium',
      'start_48_hour_free_trial': 'Start 48-Hour Free Trial',
      'last_updated': 'Last Updated',
      'loading_content': 'Loading content...',
      'cancel': 'Cancel',
      'start_free_trial': 'Start Free Trial',
      'trial_started': 'Your 48-hour free trial has started!',
      'failed_to_start_trial': 'Failed to start trial',
      'premium_active': 'Premium Active',
      'trial_active': 'Trial Active',
      'start_trial': 'Start your 48-hour free trial',
      'full_access': 'Full access to all features',
      'hours_remaining': 'hours remaining',
      'games': 'Games',
      'couples_games': 'Couples Games',
      'couples_games_subtitle': 'Fun activities to deepen your connection',
      'kegel_exercises': 'Kegel Exercises',
      'kegel_exercises_subtitle': 'Guided routines for intimate wellness',
      'ai_chat': 'AI Chat',
      'ai_chat_subtitle': 'Get personalized relationship guidance',
      'sign_out': 'Sign Out',

      // Games Screen
      'play_together': 'Play together, grow together',
      'game_not_found': 'Game not found!',
      'game_coming_soon': 'Game coming soon!',
      'error_starting_game': 'Error starting game',
      'premium_game_message':
          'This game requires a premium subscription. Upgrade to access all games!',
      'upgrade': 'Upgrade',
      'not_started': 'Not Started',
      'in_progress': 'In Progress',
      'completed': 'Completed',
      'played': 'Played',
      'time': 'time',
      'times': 'times',
      'play_now': 'Play Now',
      'play_again': 'Play Again',
      'retry': 'Retry',

      // Kegel Screen
      'kegel': 'Kegel',
      'intimate_wellness_journey': 'Your intimate wellness journey',
      'your_progress': 'Your Progress',
      'week_streak': 'Week Streak',
      'completed_label': 'Completed',
      'daily_goal': 'Daily Goal',
      'exercise_routines': 'Exercise Routines',
      'beginner_routine': 'Beginner Routine',
      'intermediate_routine': 'Intermediate Routine',
      'advanced_routine': 'Advanced Routine',
      'minutes': 'minutes',
      'sets': 'sets',
      'no_exercises_available': 'No exercises available',
      'about_kegel': 'About Kegel Exercises',
      'about_kegel_content':
          'Kegel exercises strengthen the pelvic floor muscles, which support the bladder, uterus, and bowel. These exercises can improve intimate wellness, bladder control, and enhance physical connection with your partner.',
      'target_muscle': 'Target Muscle',
      'target_muscle_content':
          'Pelvic floor muscles - the muscles you use to stop urination midstream.',
      'how_to_perform': 'How to Perform',
      'step_1_title': 'Identify the Right Muscles',
      'step_1_desc':
          'Imagine stopping urination or holding gas. Those are your pelvic floor muscles.',
      'step_2_title': 'Contract & Hold',
      'step_2_desc':
          'Tighten these muscles and hold for the specified time. Don\'t hold your breath.',
      'step_3_title': 'Relax Completely',
      'step_3_desc': 'Release the muscles fully and rest between repetitions.',
      'step_4_title': 'Stay Consistent',
      'step_4_desc':
          'Practice daily for best results. You should notice improvements within weeks.',
      'important_tips': 'Important Tips',
      'tip_1': 'Don\'t tighten your stomach, thighs, or buttocks',
      'tip_2': 'Breathe normally throughout the exercise',
      'tip_3': 'Start with beginner level and progress gradually',
      'tip_4': 'Practice on an empty bladder for comfort',
      'medical_disclaimer': 'Medical Disclaimer',
      'medical_disclaimer_content':
          'This app is for informational and educational purposes only. Please consult a healthcare professional for any medical advice or concerns.',
      'kegel_challenge': '30-Day Challenge',
      'kegel_challenge_subtitle':
          'Complete 30 days and earn your Mastery badge',
      'view_challenge': 'View Challenge',
      'day': 'Day',
      'kegel_plan': 'Kegel Plan',

      // Chat Screen
      'chat': 'Chat',
      'ai_companion': 'Your AI relationship companion',
      'ai_greeting':
          'Hello! I\'m here to support your relationship journey. How can I help you today?',
      'type_message': 'Type your message...',
      'chat_disclaimer':
          'For informational purposes only. Consult a doctor for medical advice.',

      // Authentication
      'sign_in': 'Sign In',
      'sign_up': 'Sign Up',
      'email': 'Email',
      'password': 'Password',
      'confirm_password': 'Confirm Password',
      'forgot_password': 'Forgot Password?',
      'dont_have_account': 'Don\'t have an account?',
      'already_have_account': 'Already have an account?',
      'or_continue_with': 'Or continue with',
      'google': 'Google',
      'apple': 'Apple',
      'create_account': 'Create Account',
      'welcome_to_velmora': 'Welcome to Together',
      'strengthen_your_relationship':
          'Strengthen your relationship with AI-powered guidance',
      'wellness_for_couples': 'Wellness for couples',
      'enter_player_names': 'Enter Player Names',
      'player_1_name': 'Player 1 Name',
      'player_2_name': 'Player 2 Name',
      'start_quiz': 'Start Quiz',
      'quiz_complete': 'Quiz Complete!',
      'compatibility_score': 'Compatibility Score',
      'back_to_games': 'Back to Games',
      'question_of': 'Question',
      'of': 'of',
      's_turn': '\'s Turn',
      'submit_answer': 'Submit Answer',
      'please_select_answer': 'Please select an answer',
      'words_of_affirmation': 'Words of Affirmation',
      'quality_time': 'Quality Time',
      'receiving_gifts': 'Receiving Gifts',
      'acts_of_service': 'Acts of Service',
      'physical_touch': 'Physical Touch',
      'love_language_words_of_affirmation_desc':
          'Feels most loved through verbal expressions of love, compliments, and encouragement.',
      'love_language_quality_time_desc':
          'Feels most loved when spending meaningful time together with undivided attention.',
      'love_language_receiving_gifts_desc':
          'Feels most loved through thoughtful gifts that show care and consideration.',
      'love_language_acts_of_service_desc':
          'Feels most loved when someone does helpful things for them.',
      'love_language_physical_touch_desc':
          'Feels most loved through physical affection like hugs, kisses, and closeness.',
      'error_loading_quiz': 'Error loading quiz',
      'error_completing_quiz': 'Error completing quiz',
      'please_enter_names': 'Please enter both player names',

      // Onboarding
      'next': 'Next',
      'get_started': 'Get Started',
      'onboarding_title_1': 'Welcome to Together',
      'onboarding_desc_1':
          'Your AI-powered companion for building stronger, healthier relationships',
      'onboarding_title_2': 'Strengthen Your Bond',
      'onboarding_desc_2':
          'Engage in fun games and exercises designed to deepen your connection',
      'onboarding_title_3': 'AI-Powered Guidance',
      'onboarding_desc_3':
          'Get personalized relationship advice powered by advanced AI',
      'onboarding_title_4': 'Choose Your Language',
      'onboarding_desc_4':
          'Select your preferred language for the best experience',
      'english': 'English',
      'arabic': 'العربية',
      'french': 'Français',

      // Settings
      'settings': 'Settings',
      'account': 'Account',
      'notifications': 'Notifications',
      'privacy_security': 'Privacy & Security',
      'help_support': 'Help & Support',
      'about': 'About',
      'logout': 'Logout',
      'logout_msg': 'Are You Sure You want To Logout?',
      'premium_access': 'Premium Access',

      // Account Screen
      'profile': 'Profile',
      'edit_profile': 'Edit Profile',
      'name': 'Name',
      'partner_name': 'Partner Name',
      'relationship_status': 'Relationship Status',
      'anniversary_date': 'Anniversary Date',
      'save': 'Save',
      'delete_account': 'Delete Account',
      'delete_account_warning':
          'This action cannot be undone. All your data will be permanently deleted.',
      'confirm_delete': 'Confirm Delete',

      // Notifications Screen
      'push_notifications': 'Push Notifications',
      'exercise_reminders': 'Exercise Reminders',
      'game_suggestions': 'Game Suggestions',
      'ai_tips': 'AI Tips',
      'daily_reminders': 'Daily Reminders',
      'reminder_time': 'Reminder Time',

      // Privacy & Security
      'biometric_auth': 'Biometric Authentication',
      'use_face_id': 'Use Face ID / Touch ID',
      'change_password': 'Change Password',
      'data_privacy': 'Data Privacy',
      'export_data': 'Export My Data',
      'privacy_policy': 'Privacy Policy',
      'terms_of_service': 'Terms of Service',

      // Help & Support
      'faq': 'Frequently Asked Questions',
      'contact_support': 'Contact Support',
      'report_bug': 'Report a Bug',
      'rate_app': 'Rate Our App',
      'share_app': 'Share App',
      'version': 'Version',
      'get_help': 'Get Help',
      'resources': 'Resources',
      'faqs': 'FAQs',
      'find_answers_to_common_questions': 'Find answers to common questions',
      'get_in_touch_with_our_team': 'Get in touch with our team',
      'help_us_improve_the_app': 'Help us improve the app',
      'read_our_terms_and_conditions': 'Read our terms and conditions',
      'how_we_handle_your_data': 'How we handle your data',
      'strengthening_relationships_through_wellness': 'Strengthening relationships through wellness',
      'frequently_asked_questions': 'Frequently Asked Questions',
      'no_faqs_available_at_the_moment': 'No FAQs available at the moment.',
      'send_us_a_message_and_well_get_back_to_you_soon': 'Send us a message and we\'ll get back to you soon.',
      'message_sent': 'Message sent!',
      'send': 'Send',
      'submit': 'Submit',
      'bug_title': 'Bug Title',
      'description': 'Description',
      'please_describe_what_happened': 'Please describe what happened...',
      'bug_report_submitted': 'Bug report submitted!',
      'please_login_to_see_notifications': 'Please login to see notifications',
      'no_notifications_yet': 'No notifications yet',
      'delete_notification': 'Delete Notification',
      'are_you_sure_you_want_to_delete_this_notification': 'Are you sure you want to delete this notification?',
      'read_our_privacy_policy_and_terms': 'Read our privacy policy and terms',
      'update_your_account_password': 'Update your account password',
      'permanently_delete_your_account': 'Permanently delete your account',
      'are_you_sure_you_want_to_permanently_delete_your_account_this_action_cannot_be_undone_and_you_will_lose_all_your_data': 'Are you sure you want to permanently delete your account? This action cannot be undone and you will lose all your data.',
      'delete': 'Delete',
      'minutes_short_ago': 'm ago',
      'hours_short_ago': 'h ago',
      'days_short_ago': 'd ago',
      'yesterday': 'Yesterday',
      'date_night_ideas': 'Date Night Ideas',
      'would_you_rather': 'Would You Rather',
      'relationship_quiz': 'Relationship Quiz',
      'compliment_game': 'Compliment Game',
      'couples_challenge': 'Couple\'s Challenge',
      'challenge': 'Challenge',
      'round': 'Round',
      'compliments': 'compliments',
      'migration_data': 'Migration Data',
      'no_ideas_available': 'No ideas available',
      'no_questions_available': 'No questions available',
      'no_prompts_available': 'No prompts available',
      'no_challenges_available': 'No challenges available',
      'next_idea': 'Next Idea',
      'see_results': 'See Results',
      'score': 'Score',
      'both_answered': 'Both answered!',
      'would_you_rather_ellipsis': 'Would You Rather...',
      'found_favorite_ideas': 'Found {count} favorite ideas!',
      'you_explored_date_night_ideas_together': 'You explored {count} date night ideas together!',
      'favorites': 'favorites',
      'so_much_love': 'So Much Love!',
      'you_shared_compliments': 'You shared {count} compliments!',
      'give_a_compliment': 'Give Compliment',
      'skip_turn': 'Skip Turn',
      'give_a_compliment_prompt': '{name}, give a compliment!',
      'hint': 'Hint',
      'challenge_complete': 'Challenge Complete!',
      'you_completed_challenges_out_of_total': 'You completed {done} out of {total} challenges!',
      'challenge_completed': 'Challenge Completed!',
      'skip_challenge': 'Skip Challenge',
      'completed_count': 'completed',
      'game_content': 'Game Content',
      'refresh_schedule': 'Refresh Schedule',
      'frequency': 'Frequency',
      'next_refresh': 'Next Refresh',
      'content_refreshes_automatically_every_30_days_with_new_questions': 'Content refreshes automatically every 30 days with new questions',
      'truth_or_truth_desc': 'Deep connection questions for couples',
      'love_language_quiz_desc': 'Discover your love languages together',
      'reflection_discussion_desc': 'Meaningful conversations and growth',
      'new': 'NEW',
      'version_n': 'Version {version}',
      'refresh_available': 'Refresh Available',
      'refresh_content': 'Refresh Content',
      'content_refreshed_successfully': '{name} content refreshed successfully!',
      'all_game_content_refreshed_successfully': 'All game content refreshed successfully!',
      'error_refreshing_content': 'Error refreshing content',
      'no_plans_available': 'No plans available',
      'unable_to_load_subscription_plans': 'Unable to load subscription plans',
      'pay_now': 'Pay Now',
      'or_start_48_hour_free_trial': 'Or start 48-hour free trial',
      'request_cancellation': 'Request Cancellation',
      'cancellation_request_submitted_admin_will_review_it': 'Cancellation request submitted. Admin will review it.',
      'error_loading_plans': 'Error loading plans',
      'error_restoring_purchases': 'Error restoring purchases',
      'failed_to_send_message': 'Failed to send message',
      'error_loading_messages': 'Error loading messages',
      'migration_confirmation_message': 'This will upload ALL data from the bundled migration.json backup (games, questions, your profile defaults, chat seed) to Firebase.\n\nExisting documents will be merged / updated.\n\nContinue?',
      'upload': 'Upload',
      'uploading_to_firebase': 'Uploading to Firebase…',
      'migration_syncing_collections': 'Reading migration.json and syncing all collections.',
      'migration_failed': 'Migration failed',
      'uploaded_with_warnings': 'Uploaded with Warnings',
      'upload_complete': 'Upload Complete',
      'documents_uploaded_to_firebase': '{count} document(s) uploaded to Firebase.',
      'collections_synced': 'Collections synced:',
      'warnings': 'Warnings:',
      'source': 'Source',
      'migrate_new_data': 'Migrate New Data',
      'uploading': 'Uploading…',
      'reset_challenge': 'Reset Challenge',
      'reset': 'Reset',
      'reset_challenge_progress_confirmation': 'Are you sure you want to reset your 30-day challenge progress? This cannot be undone.',
      'percent_complete': '{percent}% Complete',
      'days_completed_out_of_total': '{done} / {total} Days Completed',
      'challenge_completion_message': 'Congratulations on completing 30 days of Kegel exercises. You have earned your Mastery badge!',
      'restart_challenge': 'Restart Challenge',

      // Subscription Screen
      'monthly_plan': 'Monthly Plan',
      'quarterly_plan': '3-Month Plan',
      'yearly_plan': 'Yearly Plan',
      'per_month': '/month',
      'save_33': 'Save 33%',
      'save_50': 'Save 50%',
      'best_value': 'BEST VALUE',
      'free_trial_48h': 'Start your 48-hour free trial',
      'then_price': 'Free for 48 hours, then',
      'cancel_anytime': 'Cancel anytime',
      'restore_purchases': 'Restore',
      'secure_payment': 'Secure payment via Apple & Google',
      'no_commitment': 'Cancel anytime, no commitment',

      // Games
      'truth_or_truth': 'Truth or Truth',
      'love_language_quiz': 'Love Language Quiz',
      'reflection_discussion': 'Reflection & Discussion',
      'player_1': 'Player 1',
      'player_2': 'Player 2',
      'start_game': 'Start Game',
      'next_question': 'Next Question',
      'finish': 'Finish',
      'game_complete': 'Game Complete!',
      'play_another': 'Play Another Game',

      // Common
      'yes': 'Yes',
      'no': 'No',
      'ok': 'OK',
      'done': 'Done',
      'continue': 'Continue',
      'back': 'Back',
      'close': 'Close',
      'error': 'Error',
      'success': 'Success',
      'loading': 'Loading...',
      'try_again': 'Try Again',
      'something_went_wrong': 'Something went wrong',

      // Account Screen
      'edit_name': 'Edit Name',
      'display_name': 'Display Name',
      'choose_profile_picture': 'Choose Profile Picture',
      'camera': 'Camera',
      'gallery': 'Gallery',
      'remove_picture': 'Remove Picture',
      'name_updated': 'Name updated successfully',
      'failed_to_update_name': 'Failed to update name',
      'name_cannot_be_empty': 'Name cannot be empty',
      'subscription': 'Subscription',
      'premium': 'Premium',
      'trial': 'Trial',
      'free': 'Free',
      'no_name_set': 'No Name Set',
      'profile_picture_updated': 'Profile picture updated successfully',
      'profile_picture_removed': 'Profile picture removed',
      'failed_to_upload_picture': 'Failed to upload picture',
      'failed_to_remove_picture': 'Failed to remove picture',
      'uploading_profile_picture': 'Uploading profile picture...',

      // Kegel Play Screen
      'kegel_exercise': 'Kegel Exercise',
      'progress': 'Progress',
      'contract': 'Contract',
      'relax': 'Relax',
      'set': 'Set',
      'great_job': 'Great Job!',
      'you_completed': 'You completed',
      'duration': 'Duration',
      'sets_completed': 'Sets Completed',

      // Reflection & Discussion Game
      'reflection_discussion_game': 'Reflection & Discussion',
      'welcome_to_reflection': 'Welcome to Reflection & Discussion',
      'reflection_welcome_desc':
          'A game to deepen your connection through meaningful conversations and shared reflections.',
      'your_turn': 'Your Turn',
      'share_thoughts': 'Share your thoughts...',
      'congratulations': 'Congratulations!',
      'game_completed_reflection':
          'You have completed the Reflection & Discussion game!',
      'questions_answered': 'You have answered',
      'questions_together':
          'questions together and shared meaningful insights.',
      's_answer': '\'s Answer',
    },
    'ar': {
      // Home Screen
      'welcome_back': 'مرحباً بعودتك',
      'welcome': 'مرحباً',
      'home': 'الرئيسية', // home
      'explore_features': 'استكشف ميزاتنا المصممة للأزواج',
      'premium_feature': 'ميزة مميزة',
      'premium_message':
          'تتطلب هذه الميزة اشتراكاً مميزاً. ابدأ تجربتك المجانية للوصول إلى جميع الميزات!',
      'is_a_premium_feature_upgrade_to_unlock_full_access': 'هي ميزة مميزة. قم بالترقية لفتح الوصول الكامل.',
      'upgrade_to_premium': 'الترقية إلى بريميوم',
      'start_48_hour_free_trial': 'ابدأ تجربة مجانية لمدة 48 ساعة',
      'last_updated': 'آخر تحديث',
      'loading_content': 'جارٍ تحميل المحتوى...',
      'cancel': 'إلغاء',
      'start_free_trial': 'ابدأ التجربة المجانية',
      'trial_started': 'بدأت تجربتك المجانية لمدة 48 ساعة!',
      'failed_to_start_trial': 'فشل بدء التجربة',
      'premium_active': 'الاشتراك المميز نشط',
      'trial_active': 'التجربة نشطة',
      'start_trial': 'ابدأ تجربتك المجانية لمدة 48 ساعة',
      'full_access': 'وصول كامل لجميع الميزات',
      'hours_remaining': 'ساعات متبقية',
      'games': 'ألعاب',
      'couples_games': 'ألعاب الأزواج',
      'couples_games_subtitle': 'أنشطة ممتعة لتعميق علاقتك',
      'kegel_exercises': 'تمارين كيجل',
      'kegel_exercises_subtitle': 'روتينات موجهة للصحة الحميمة',
      'ai_chat': 'الدردشة الذكية',
      'ai_chat_subtitle': 'احصل على إرشادات شخصية للعلاقات',
      'sign_out': 'تسجيل الخروج',

      // Games Screen
      'play_together': 'العبوا معاً، انموا معاً',
      'game_not_found': 'اللعبة غير موجودة!',
      'game_coming_soon': 'اللعبة قريباً!',
      'error_starting_game': 'خطأ في بدء اللعبة',
      'premium_game_message':
          'تتطلب هذه اللعبة اشتراكاً مميزاً. قم بالترقية للوصول إلى جميع الألعاب!',
      'upgrade': 'ترقية',
      'not_started': 'لم تبدأ',
      'in_progress': 'قيد التقدم',
      'completed': 'مكتملة',
      'played': 'لعبت',
      'time': 'مرة',
      'times': 'مرات',
      'play_now': 'العب الآن',
      'play_again': 'العب مرة أخرى',
      'retry': 'إعادة المحاولة',

      // Kegel Screen
      'kegel': 'كيجل',
      'intimate_wellness_journey': 'رحلة صحتك الحميمة',
      'your_progress': 'تقدمك',
      'week_streak': 'سلسلة الأسبوع',
      'completed_label': 'مكتمل',
      'daily_goal': 'الهدف اليومي',
      'exercise_routines': 'روتينات التمارين',
      'beginner_routine': 'روتين المبتدئين',
      'intermediate_routine': 'روتين متوسط',
      'advanced_routine': 'روتين متقدم',
      'minutes': 'دقائق',
      'sets': 'مجموعات',
      'no_exercises_available': 'لا توجد تمارين متاحة',
      'about_kegel': 'حول تمارين كيجل',
      'about_kegel_content':
          'تمارين كيجل تقوي عضلات قاع الحوض التي تدعم المثانة والرحم والأمعاء. يمكن لهذه التمارين تحسين الصحة الحميمة والتحكم في المثانة وتعزيز الاتصال الجسدي مع شريكك.',
      'target_muscle': 'العضلة المستهدفة',
      'target_muscle_content':
          'عضلات قاع الحوض - العضلات التي تستخدمها لإيقاف التبول في منتصف الطريق.',
      'how_to_perform': 'كيفية الأداء',
      'step_1_title': 'حدد العضلات الصحيحة',
      'step_1_desc':
          'تخيل إيقاف التبول أو حبس الغازات. هذه هي عضلات قاع الحوض.',
      'step_2_title': 'انقبض واحتفظ',
      'step_2_desc': 'شد هذه العضلات واحتفظ بها للوقت المحدد. لا تحبس أنفاسك.',
      'step_3_title': 'استرخ تماماً',
      'step_3_desc': 'أطلق العضلات بالكامل واسترح بين التكرارات.',
      'step_4_title': 'كن متسقاً',
      'step_4_desc':
          'مارس يومياً للحصول على أفضل النتائج. يجب أن تلاحظ تحسينات في غضون أسابيع.',
      'important_tips': 'نصائح مهمة',
      'tip_1': 'لا تشد معدتك أو فخذيك أو أردافك',
      'tip_2': 'تنفس بشكل طبيعي طوال التمرين',
      'tip_3': 'ابدأ بمستوى المبتدئين وتقدم تدريجياً',
      'tip_4': 'مارس على مثانة فارغة للراحة',
      'medical_disclaimer': 'إخلاء المسؤولية الطبية',
      'medical_disclaimer_content':
          'هذا التطبيق لأغراض إعلامية وتعليمية فقط. يرجى استشارة أخصائي رعاية صحية للحصول على أي نصيحة أو مخاوف طبية.',

      // Chat Screen
      'chat': 'دردشة',
      'ai_companion': 'رفيقك الذكي للعلاقات',
      'ai_greeting':
          'مرحباً! أنا هنا لدعم رحلة علاقتك. كيف يمكنني مساعدتك اليوم؟',
      'type_message': 'اكتب رسالتك...',
      'chat_disclaimer':
          'لأغراض إعلامية فقط. استشر طبيباً للحصول على نصيحة طبية.',

      // Authentication
      'sign_in': 'تسجيل الدخول',
      'sign_up': 'إنشاء حساب',
      'email': 'البريد الإلكتروني',
      'password': 'كلمة المرور',
      'confirm_password': 'تأكيد كلمة المرور',
      'forgot_password': 'نسيت كلمة المرور؟',
      'dont_have_account': 'ليس لديك حساب؟',
      'already_have_account': 'لديك حساب بالفعل؟',
      'or_continue_with': 'أو تابع مع',
      'google': 'جوجل',
      'apple': 'آبل',
      'create_account': 'إنشاء حساب',
      'welcome_to_velmora': 'مرحباً بك في Together',
      'strengthen_your_relationship':
          'عزز علاقتك بإرشادات مدعومة بالذكاء الاصطناعي',
      'wellness_for_couples': 'الصحة للعائلات',
      'enter_player_names': 'أدخل أسماء اللاعبين',
      'player_1_name': 'اسم اللاعب 1',
      'player_2_name': 'اسم اللاعب 2',
      'start_quiz': 'ابدأ الاختبار',
      'quiz_complete': 'اكتمل الاختبار!',
      'compatibility_score': 'درجة التوافق',
      'back_to_games': 'العودة إلى الألعاب',
      'question_of': 'السؤال',
      'of': 'من',
      's_turn': 'دور',
      'submit_answer': 'إرسال الإجابة',
      'please_select_answer': 'الرجاء اختيار إجابة',
      'words_of_affirmation': 'كلمات التأكيد',
      'quality_time': 'وقت الجودة',
      'receiving_gifts': 'تلقي الهدايا',
      'acts_of_service': 'أفعال الخدمة',
      'physical_touch': 'اللمس الجسدي',
      'love_language_words_of_affirmation_desc':
          'يشعر بأنه الأكثر حباً من خلال التعبيرات اللفظية عن الحب والمجاملات والتشجيع.',
      'love_language_quality_time_desc':
          'يشعر بأنه الأكثر حباً عند قضاء وقت ذي معنى معاً مع انتباه كامل.',
      'love_language_receiving_gifts_desc':
          'يشعر بأنه الأكثر حباً من خلال الهدايا المدروسة التي تظهر الاهتمام.',
      'love_language_acts_of_service_desc':
          'يشعر بأنه الأكثر حباً عندما يفعل شخص ما أشياء مفيدة له.',
      'love_language_physical_touch_desc':
          'يشعر بأنه الأكثر حباً من خلال المودة الجسدية مثل العناق والقبلات والقرب.',
      'error_loading_quiz': 'خطأ في تحميل الاختبار',
      'error_completing_quiz': 'خطأ في إكمال الاختبار',
      'please_enter_names': 'الرجاء إدخال اسمي اللاعبين',
      'truth_or_truth': 'حقيقة أو حقيقة',
      'enter_names': 'أدخل أسماء اللاعبين',
      'start_game': 'ابدأ اللعبة',
      'game_complete': 'اكتملت اللعبة!',
      'final_scores': 'النتائج النهائية',
      'wins': 'يفوز!',
      'its_a_tie': 'تعادل!',
      'vs': 'ضد',
      'question_count': 'السؤال',
      'your_answer': 'إجابتك',
      'type_answer_here': 'اكتب إجابتك هنا...',
      'skip': 'تخطي',
      'please_enter_answer': 'الرجاء إدخال إجابتك',
      'error_loading_game': 'خطأ في تحميل اللعبة',
      'error_completing_game': 'خطأ في إكمال اللعبة',
      'language': 'اللغة',
      'reflection_discussion_game': 'التأمل والنقاش',
      'notifications': 'الإشعارات',
      'reminder_time': 'وقت التذكير',
      'low': 'منخفض',
      'medium': 'متوسط',
      'high': 'عالي',
      'manual': 'يدوي',
      'auto': 'تلقائي',
      'edit_name': 'تعديل الاسم',
      'display_name': 'اسم العرض',
      'choose_profile_picture': 'اختر صورة الملف الشخصي',
      'camera': 'الكاميرا',
      'gallery': 'المعرض',
      'remove_picture': 'إزالة الصورة',
      'name_updated': 'تم تحديث الاسم',
      'failed_to_update_name': 'فشل تحديث الاسم',
      'name_cannot_be_empty': 'لا يمكن أن يكون الاسم فارغاً',
      'subscription': 'الاشتراك',
      'premium': 'مميز',
      'trial': 'تجريبي',
      'free': 'مجاني',
      'no_name_set': 'لم يتم تعيين اسم',
      'profile_picture_updated': 'تم تحديث صورة الملف الشخصي',
      'profile_picture_removed': 'تم إزالة صورة الملف الشخصي',
      'failed_to_upload_picture': 'فشل تحميل الصورة',
      'failed_to_remove_picture': 'فشل إزالة الصورة',
      'kegel_exercise': 'تمرين كيجل',
      'progress': 'التقدم',
      'contract': 'انقباض',
      'relax': 'استرخاء',
      'set': 'مجموعة',
      'great_job': 'عمل رائع!',
      'you_completed': 'لقد أكملت',
      'duration': 'المدة',
      'sets_completed': 'المجموعات المكتملة',
      'done': 'تم',
      'uploading_profile_picture': 'جاري تحميل صورة الملف الشخصي...',
      'kegel_challenge': 'تحدي 30 يوماً',
      'kegel_challenge_subtitle': 'أكمل 30 يوماً واحصل على شارة الإتقان',
      'view_challenge': 'عرض التحدي',
      'day': 'يوم',
      'kegel_plan': 'خطة كيجل',

      // Onboarding
      'next': 'التالي',
      'get_started': 'ابدأ',
      'onboarding_title_1': 'مرحباً بك في Together',
      'onboarding_desc_1':
          'رفيقك المدعوم بالذكاء الاصطناعي لبناء علاقات أقوى وأكثر صحة',
      'onboarding_title_2': 'عزز رابطتك',
      'onboarding_desc_2': 'شارك في ألعاب وتمارين ممتعة مصممة لتعميق اتصالك',
      'onboarding_title_3': 'إرشادات مدعومة بالذكاء الاصطناعي',
      'onboarding_desc_3':
          'احصل على نصائح شخصية للعلاقات مدعومة بالذكاء الاصطناعي المتقدم',
      'onboarding_title_4': 'اختر لغتك',
      'onboarding_desc_4': 'اختر لغتك المفضلة للحصول على أفضل تجربة',
      'english': 'الإنجليزية',
      'arabic': 'العربية',
      'french': 'الفرنسية',

      // Settings
      'settings': 'الإعدادات',
      'account': 'الحساب',
      'privacy_security': 'الخصوصية والأمان',
      'help_support': 'المساعدة والدعم',
      'about': 'حول',
      'logout': 'تسجيل الخروج',
      'logout_msg': 'هل أنت متأكد من تسجيل الخروج؟',
      'premium_access': 'الوصول المميز',

      // Account Screen
      'profile': 'الملف الشخصي',
      'edit_profile': 'تعديل الملف الشخصي',
      'name': 'الاسم',
      'partner_name': 'اسم الشريك',
      'relationship_status': 'حالة العلاقة',
      'anniversary_date': 'تاريخ الذكرى السنوية',
      'save': 'حفظ',
      'delete_account': 'حذف الحساب',
      'delete_account_warning':
          'لا يمكن التراجع عن هذا الإجراء. سيتم حذف جميع بياناتك نهائياً.',
      'confirm_delete': 'تأكيد الحذف',

      // Notifications Screen
      'push_notifications': 'الإشعارات الفورية',
      'exercise_reminders': 'تذكيرات التمارين',
      'game_suggestions': 'اقتراحات الألعاب',
      'ai_tips': 'نصائح الذكاء الاصطناعي',
      'daily_reminders': 'التذكيرات اليومية',

      // Privacy & Security
      'biometric_auth': 'المصادقة البيومترية',
      'use_face_id': 'استخدام Face ID / Touch ID',
      'change_password': 'تغيير كلمة المرور',
      'data_privacy': 'خصوصية البيانات',
      'export_data': 'تصدير بياناتي',
      'privacy_policy': 'سياسة الخصوصية',
      'terms_of_service': 'شروط الخدمة',

      // Help & Support
      'faq': 'الأسئلة الشائعة',
      'contact_support': 'اتصل بالدعم',
      'report_bug': 'الإبلاغ عن خطأ',
      'rate_app': 'قيم تطبيقنا',
      'share_app': 'شارك التطبيق',
      'version': 'الإصدار',
      'get_help': 'احصل على المساعدة',
      'resources': 'الموارد',
      'faqs': 'الأسئلة الشائعة',
      'find_answers_to_common_questions': 'اعثر على إجابات للأسئلة الشائعة',
      'get_in_touch_with_our_team': 'تواصل مع فريقنا',
      'help_us_improve_the_app': 'ساعدنا في تحسين التطبيق',
      'read_our_terms_and_conditions': 'اقرأ الشروط والأحكام',
      'how_we_handle_your_data': 'كيف نتعامل مع بياناتك',
      'strengthening_relationships_through_wellness': 'تقوية العلاقات من خلال العافية',
      'frequently_asked_questions': 'الأسئلة الشائعة',
      'no_faqs_available_at_the_moment': 'لا توجد أسئلة شائعة متاحة حالياً.',
      'send_us_a_message_and_well_get_back_to_you_soon': 'أرسل لنا رسالة وسنرد عليك قريباً.',
      'message_sent': 'تم إرسال الرسالة!',
      'send': 'إرسال',
      'submit': 'إرسال',
      'bug_title': 'عنوان الخطأ',
      'description': 'الوصف',
      'please_describe_what_happened': 'يرجى وصف ما حدث...',
      'bug_report_submitted': 'تم إرسال تقرير الخطأ!',
      'please_login_to_see_notifications': 'يرجى تسجيل الدخول لرؤية الإشعارات',
      'no_notifications_yet': 'لا توجد إشعارات حتى الآن',
      'delete_notification': 'حذف الإشعار',
      'are_you_sure_you_want_to_delete_this_notification': 'هل أنت متأكد أنك تريد حذف هذا الإشعار؟',
      'read_our_privacy_policy_and_terms': 'اقرأ سياسة الخصوصية والشروط الخاصة بنا',
      'update_your_account_password': 'قم بتحديث كلمة مرور حسابك',
      'permanently_delete_your_account': 'احذف حسابك نهائياً',
      'are_you_sure_you_want_to_permanently_delete_your_account_this_action_cannot_be_undone_and_you_will_lose_all_your_data': 'هل أنت متأكد أنك تريد حذف حسابك نهائياً؟ لا يمكن التراجع عن هذا الإجراء وستفقد جميع بياناتك.',
      'delete': 'حذف',
      'minutes_short_ago': 'د قبل',
      'hours_short_ago': 'س قبل',
      'days_short_ago': 'ي قبل',
      'yesterday': 'أمس',
      'date_night_ideas': 'أفكار لموعد غرامي',
      'would_you_rather': 'ماذا تفضل',
      'relationship_quiz': 'اختبار العلاقة',
      'compliment_game': 'لعبة المجاملات',
      'couples_challenge': 'تحدي الأزواج',
      'challenge': 'تحدي',
      'round': 'جولة',
      'compliments': 'مجاملات',
      'migration_data': 'بيانات الترحيل',
      'no_ideas_available': 'لا توجد أفكار متاحة',
      'no_questions_available': 'لا توجد أسئلة متاحة',
      'no_prompts_available': 'لا توجد مطالبات متاحة',
      'no_challenges_available': 'لا توجد تحديات متاحة',
      'next_idea': 'الفكرة التالية',
      'see_results': 'عرض النتائج',
      'score': 'النتيجة',
      'both_answered': 'أجاب الاثنان!',
      'would_you_rather_ellipsis': 'ماذا تفضل...',
      'found_favorite_ideas': 'تم العثور على {count} فكرة مفضلة!',
      'you_explored_date_night_ideas_together': 'استكشفتم {count} من أفكار المواعدة معاً!',
      'favorites': 'مفضلات',
      'so_much_love': 'الكثير من الحب!',
      'you_shared_compliments': 'تبادلتما {count} مجاملة!',
      'give_a_compliment': 'قدّم مجاملة',
      'skip_turn': 'تخطي الدور',
      'give_a_compliment_prompt': '{name}، قدّم مجاملة!',
      'hint': 'تلميح',
      'challenge_complete': 'اكتمل التحدي!',
      'you_completed_challenges_out_of_total': 'أكملتما {done} من أصل {total} تحديات!',
      'challenge_completed': 'تم إكمال التحدي!',
      'skip_challenge': 'تخطي التحدي',
      'completed_count': 'مكتمل',
      'game_content': 'محتوى الألعاب',
      'refresh_schedule': 'جدول التحديث',
      'frequency': 'التكرار',
      'next_refresh': 'التحديث التالي',
      'content_refreshes_automatically_every_30_days_with_new_questions': 'يتم تحديث المحتوى تلقائياً كل 30 يوماً بأسئلة جديدة',
      'truth_or_truth_desc': 'أسئلة تواصل عميقة للأزواج',
      'love_language_quiz_desc': 'اكتشفا لغات الحب الخاصة بكما معاً',
      'reflection_discussion_desc': 'محادثات ذات معنى ونمو',
      'new': 'جديد',
      'version_n': 'الإصدار {version}',
      'refresh_available': 'التحديث متاح',
      'refresh_content': 'تحديث المحتوى',
      'content_refreshed_successfully': 'تم تحديث محتوى {name} بنجاح!',
      'all_game_content_refreshed_successfully': 'تم تحديث جميع محتويات الألعاب بنجاح!',
      'error_refreshing_content': 'خطأ في تحديث المحتوى',
      'no_plans_available': 'لا توجد خطط متاحة',
      'unable_to_load_subscription_plans': 'تعذر تحميل خطط الاشتراك',
      'pay_now': 'ادفع الآن',
      'or_start_48_hour_free_trial': 'أو ابدأ تجربة مجانية لمدة 48 ساعة',
      'request_cancellation': 'طلب الإلغاء',
      'cancellation_request_submitted_admin_will_review_it': 'تم إرسال طلب الإلغاء. سيقوم المسؤول بمراجعته.',
      'error_loading_plans': 'خطأ في تحميل الخطط',
      'error_restoring_purchases': 'خطأ في استعادة المشتريات',
      'failed_to_send_message': 'فشل في إرسال الرسالة',
      'error_loading_messages': 'خطأ في تحميل الرسائل',
      'migration_confirmation_message': 'سيؤدي هذا إلى رفع جميع البيانات من النسخة الاحتياطية المضمنة migration.json (الألعاب، الأسئلة، إعدادات ملفك الشخصي الافتراضية، بيانات بدء الدردشة) إلى Firebase.\n\nسيتم دمج/تحديث المستندات الموجودة.\n\nمتابعة؟',
      'upload': 'رفع',
      'uploading_to_firebase': 'جارٍ الرفع إلى Firebase…',
      'migration_syncing_collections': 'جارٍ قراءة migration.json ومزامنة جميع المجموعات.',
      'migration_failed': 'فشلت عملية الترحيل',
      'uploaded_with_warnings': 'تم الرفع مع تحذيرات',
      'upload_complete': 'اكتمل الرفع',
      'documents_uploaded_to_firebase': 'تم رفع {count} مستند(ات) إلى Firebase.',
      'collections_synced': 'المجموعات التي تمت مزامنتها:',
      'warnings': 'تحذيرات:',
      'source': 'المصدر',
      'migrate_new_data': 'ترحيل بيانات جديدة',
      'uploading': 'جارٍ الرفع…',
      'reset_challenge': 'إعادة تعيين التحدي',
      'reset': 'إعادة تعيين',
      'reset_challenge_progress_confirmation': 'هل أنت متأكد أنك تريد إعادة تعيين تقدم تحدي 30 يوماً؟ لا يمكن التراجع عن هذا الإجراء.',
      'percent_complete': '{percent}% مكتمل',
      'days_completed_out_of_total': '{done} / {total} يوم مكتمل',
      'challenge_completion_message': 'تهانينا على إكمال 30 يوماً من تمارين كيجل. لقد حصلت على شارة الإتقان!',
      'restart_challenge': 'إعادة بدء التحدي',

      // Subscription Screen
      'monthly_plan': 'الخطة الشهرية',
      'quarterly_plan': 'خطة 3 أشهر',
      'yearly_plan': 'الخطة السنوية',
      'per_month': '/شهر',
      'save_33': 'وفر 33%',
      'save_50': 'وفر 50%',
      'best_value': 'أفضل قيمة',
      'free_trial_48h': 'ابدأ تجربتك المجانية لمدة 48 ساعة',
      'then_price': 'مجاناً لمدة 48 ساعة، ثم',
      'cancel_anytime': 'إلغاء في أي وقت',
      'restore_purchases': 'استعادة',
      'secure_payment': 'دفع آمن عبر Apple و Google',
      'no_commitment': 'إلغاء في أي وقت، بدون التزام',

      // Games
      'love_language_quiz': 'اختبار لغة الحب',
      'reflection_discussion': 'التأمل والنقاش',
      'player_1': 'اللاعب 1',
      'player_2': 'اللاعب 2',
      'next_question': 'السؤال التالي',
      'finish': 'إنهاء',
      'play_another': 'العب لعبة أخرى',

      // Common
      'yes': 'نعم',
      'no': 'لا',
      'ok': 'حسناً',
      'continue': 'متابعة',
      'back': 'رجوع',
      'close': 'إغلاق',
      'error': 'خطأ',
      'success': 'نجح',
      'loading': 'جاري التحميل...',
      'try_again': 'حاول مرة أخرى',
      'something_went_wrong': 'حدث خطأ ما',
    },
    'fr': {
      // Home Screen
      'welcome_back': 'Bienvenue\nde retour',
      'welcome': 'Bienvenue',
      'home': 'Accueil', // home
      'explore_features':
          'Explorez nos fonctionnalités conçues pour les couples',
      'premium_feature': 'Fonctionnalité Premium',
      'premium_message':
          'Cette fonctionnalité nécessite un abonnement premium. Commencez votre essai gratuit pour accéder à toutes les fonctionnalités!',
      'is_a_premium_feature_upgrade_to_unlock_full_access': 'est une fonctionnalité premium. Passez à l’abonnement pour débloquer l’accès complet.',
      'upgrade_to_premium': 'Passer à Premium',
      'start_48_hour_free_trial': 'Commencer l’essai gratuit de 48 heures',
      'last_updated': 'Dernière mise à jour',
      'loading_content': 'Chargement du contenu...',
      'cancel': 'Annuler',
      'start_free_trial': 'Commencer l\'essai gratuit',
      'trial_started': 'Votre essai gratuit de 48 heures a commencé!',
      'failed_to_start_trial': 'Échec du démarrage de l\'essai',
      'premium_active': 'Premium Actif',
      'trial_active': 'Essai Actif',
      'start_trial': 'Commencez votre essai gratuit de 48 heures',
      'full_access': 'Accès complet à toutes les fonctionnalités',
      'hours_remaining': 'heures restantes',
      'games': 'Jeux',
      'couples_games': 'Jeux de Couple',
      'couples_games_subtitle':
          'Activités amusantes pour approfondir votre connexion',
      'kegel_exercises': 'Exercices de Kegel',
      'kegel_exercises_subtitle': 'Routines guidées pour le bien-être intime',
      'ai_chat': 'Chat IA',
      'ai_chat_subtitle':
          'Obtenez des conseils personnalisés sur les relations',
      'sign_out': 'Se déconnecter',

      // Games Screen
      'play_together': 'Jouez ensemble, grandissez ensemble',
      'game_not_found': 'Jeu introuvable!',
      'game_coming_soon': 'Jeu bientôt disponible!',
      'error_starting_game': 'Erreur lors du démarrage du jeu',
      'premium_game_message':
          'Ce jeu nécessite un abonnement premium. Mettez à niveau pour accéder à tous les jeux!',
      'upgrade': 'Mettre à niveau',
      'not_started': 'Non commencé',
      'in_progress': 'En cours',
      'completed': 'Terminé',
      'played': 'Joué',
      'time': 'fois',
      'times': 'fois',
      'play_now': 'Jouer maintenant',
      'play_again': 'Rejouer',
      'retry': 'Réessayer',

      // Kegel Screen
      'kegel': 'Kegel',
      'intimate_wellness_journey': 'Votre parcours de bien-être intime',
      'your_progress': 'Votre progression',
      'week_streak': 'Série hebdomadaire',
      'completed_label': 'Terminé',
      'daily_goal': 'Objectif quotidien',
      'exercise_routines': 'Routines d\'exercices',
      'beginner_routine': 'Routine débutant',
      'intermediate_routine': 'Routine intermédiaire',
      'advanced_routine': 'Routine avancée',
      'minutes': 'minutes',
      'sets': 'séries',
      'no_exercises_available': 'Aucun exercice disponible',
      'about_kegel': 'À propos des exercices de Kegel',
      'about_kegel_content':
          'Les exercices de Kegel renforcent les muscles du plancher pelvien qui soutiennent la vessie, l\'utérus et l\'intestin. Ces exercices peuvent améliorer le bien-être intime, le contrôle de la vessie et renforcer la connexion physique avec votre partenaire.',
      'target_muscle': 'Muscle ciblé',
      'target_muscle_content':
          'Muscles du plancher pelvien - les muscles que vous utilisez pour arrêter la miction en cours.',
      'how_to_perform': 'Comment effectuer',
      'step_1_title': 'Identifiez les bons muscles',
      'step_1_desc':
          'Imaginez arrêter la miction ou retenir des gaz. Ce sont vos muscles du plancher pelvien.',
      'step_2_title': 'Contractez et maintenez',
      'step_2_desc':
          'Serrez ces muscles et maintenez pendant le temps spécifié. Ne retenez pas votre respiration.',
      'step_3_title': 'Détendez-vous complètement',
      'step_3_desc':
          'Relâchez complètement les muscles et reposez-vous entre les répétitions.',
      'step_4_title': 'Restez cohérent',
      'step_4_desc':
          'Pratiquez quotidiennement pour de meilleurs résultats. Vous devriez remarquer des améliorations en quelques semaines.',
      'important_tips': 'Conseils importants',
      'tip_1': 'Ne serrez pas votre estomac, vos cuisses ou vos fesses',
      'tip_2': 'Respirez normalement pendant l\'exercice',
      'tip_3': 'Commencez au niveau débutant et progressez graduellement',
      'tip_4': 'Pratiquez avec une vessie vide pour plus de confort',
      'medical_disclaimer': 'Avertissement médical',
      'medical_disclaimer_content':
          'Cette application est à des fins informatives et éducatives uniquement. Veuillez consulter un professionnel de la santé pour tout conseil ou préoccupation médicale.',

      // Chat Screen
      'chat': 'Chat',
      'ai_companion': 'Votre compagnon IA pour les relations',
      'ai_greeting':
          'Bonjour! Je suis là pour soutenir votre parcours relationnel. Comment puis-je vous aider aujourd\'hui?',
      'type_message': 'Tapez votre message...',
      'chat_disclaimer':
          'À des fins informatives uniquement. Consultez un médecin pour des conseils médicaux.',

      // Authentication
      'sign_in': 'Se connecter',
      'sign_up': 'S\'inscrire',
      'email': 'Email',
      'password': 'Mot de passe',
      'confirm_password': 'Confirmer le mot de passe',
      'forgot_password': 'Mot de passe oublié?',
      'dont_have_account': 'Vous n\'avez pas de compte?',
      'already_have_account': 'Vous avez déjà un compte?',
      'or_continue_with': 'Ou continuer avec',
      'google': 'Google',
      'apple': 'Apple',
      'create_account': 'Créer un compte',
      'welcome_to_velmora': 'Bienvenue sur Together',
      'strengthen_your_relationship':
          'Renforcez votre relation avec des conseils alimentés par l\'IA',
      'wellness_for_couples': 'Bien-être pour les couples',
      'enter_player_names': 'Entrez les noms des joueurs',
      'player_1_name': 'Nom du joueur 1',
      'player_2_name': 'Nom du joueur 2',
      'start_quiz': 'Commencer le quiz',
      'quiz_complete': 'Quiz terminé!',
      'compatibility_score': 'Score de compatibilité',
      'back_to_games': 'Retour aux jeux',
      'question_of': 'Question',
      'of': 'de',
      's_turn': 'Tour de',
      'submit_answer': 'Soumettre la réponse',
      'please_select_answer': 'Veuillez sélectionner une réponse',
      'words_of_affirmation': 'Paroles valorisantes',
      'quality_time': 'Moments de qualité',
      'receiving_gifts': 'Recevoir des cadeaux',
      'acts_of_service': 'Services rendus',
      'physical_touch': 'Toucher physique',
      'love_language_words_of_affirmation_desc':
          'Se sent le plus aimé par des expressions verbales d\'amour, des compliments et des encouragements.',
      'love_language_quality_time_desc':
          'Se sent le plus aimé en passant du temps significatif ensemble avec une attention totale.',
      'love_language_receiving_gifts_desc':
          'Se sent le plus aimé par des cadeaux attentionnés qui montrent l\'attention et la considération.',
      'love_language_acts_of_service_desc':
          'Se sent le plus aimé quand quelqu\'un fait des choses utiles pour lui.',
      'love_language_physical_touch_desc':
          'Se sent le plus aimé par l\'affection physique comme les câlins, les baisers et la proximité.',
      'error_loading_quiz': 'Erreur lors du chargement du quiz',
      'error_completing_quiz': 'Erreur lors de la finalisation du quiz',
      'please_enter_names': 'Veuillez entrer les deux noms de joueurs',
      'truth_or_truth': 'Vérité ou Vérité',
      'enter_names': 'Entrez les noms des joueurs',
      'start_game': 'Commencer le jeu',
      'game_complete': 'Jeu terminé!',
      'final_scores': 'Scores finaux',
      'wins': 'gagne!',
      'its_a_tie': 'Égalité!',
      'vs': 'VS',
      'question_count': 'Question',
      'your_answer': 'Votre réponse',
      'type_answer_here': 'Tapez votre réponse ici...',
      'skip': 'Passer',
      'please_enter_answer': 'Veuillez entrer votre réponse',
      'error_loading_game': 'Erreur lors du chargement du jeu',
      'error_completing_game': 'Erreur lors de la finalisation du jeu',
      'language': 'Langue',
      'reflection_discussion_game': 'Réflexion et discussion',
      'notifications': 'Notifications',
      'reminder_time': 'Heure de rappel',
      'low': 'Faible',
      'medium': 'Moyen',
      'high': 'Élevé',
      'manual': 'Manuel',
      'auto': 'Automatique',
      'edit_name': 'Modifier le nom',
      'display_name': 'Nom d\'affichage',
      'choose_profile_picture': 'Choisir une photo de profil',
      'camera': 'Caméra',
      'gallery': 'Galerie',
      'remove_picture': 'Supprimer la photo',
      'name_updated': 'Nom mis à jour',
      'failed_to_update_name': 'Échec de la mise à jour du nom',
      'name_cannot_be_empty': 'Le nom ne peut pas être vide',
      'subscription': 'Abonnement',
      'premium': 'Premium',
      'trial': 'Essai',
      'free': 'Gratuit',
      'no_name_set': 'Aucun nom défini',
      'profile_picture_updated': 'Photo de profil mise à jour',
      'profile_picture_removed': 'Photo de profil supprimée',
      'failed_to_upload_picture': 'Échec du téléchargement de la photo',
      'failed_to_remove_picture': 'Échec de la suppression de la photo',
      'kegel_exercise': 'Exercice Kegel',
      'progress': 'Progrès',
      'contract': 'Contracter',
      'relax': 'Relâcher',
      'set': 'Série',
      'great_job': 'Bravo!',
      'you_completed': 'Vous avez terminé',
      'duration': 'Durée',
      'sets_completed': 'Séries terminées',
      'done': 'Terminé',
      'kegel_challenge': 'Défi de 30 jours',
      'kegel_challenge_subtitle':
          'Complétez 30 jours et obtenez votre badge de Maîtrise',
      'view_challenge': 'Voir le défi',
      'day': 'Jour',
      'kegel_plan': 'Plan Kegel',
      'welcome_to_reflection': 'Bienvenue dans Réflexion et discussion',
      'reflection_welcome_desc':
          'Un jeu pour approfondir votre connexion grâce à des conversations significatives et des réflexions partagées.',
      'your_turn': 'Votre tour',
      'share_thoughts': 'Partagez vos pensées...',
      'congratulations': 'Félicitations!',
      'game_completed_reflection':
          'Vous avez terminé le jeu Réflexion et discussion!',
      'questions_answered': 'Vous avez répondu à',
      'questions_together':
          'questions ensemble et partagé des réflexions significatives.',
      's_answer': 'Réponse de:',

      // Onboarding
      'next': 'Suivant',
      'get_started': 'Commencer',
      'onboarding_title_1': 'Bienvenue sur Together',
      'onboarding_desc_1':
          'Votre compagnon alimenté par l\'IA pour construire des relations plus fortes et plus saines',
      'onboarding_title_2': 'Renforcez votre lien',
      'onboarding_desc_2':
          'Participez à des jeux et exercices amusants conçus pour approfondir votre connexion',
      'onboarding_title_3': 'Conseils alimentés par l\'IA',
      'onboarding_desc_3':
          'Obtenez des conseils relationnels personnalisés alimentés par une IA avancée',
      'onboarding_title_4': 'Choisissez votre langue',
      'onboarding_desc_4':
          'Sélectionnez votre langue préférée pour la meilleure expérience',
      'english': 'Anglais',
      'arabic': 'Arabe',
      'french': 'Français',

      // Settings
      'settings': 'Paramètres',
      'account': 'Compte',
      'privacy_security': 'Confidentialité et sécurité',
      'help_support': 'Aide et support',
      'about': 'À propos',
      'logout': 'Déconnexion',
      'logout_msg': 'Êtes-vous sûr de vouloir vous déconnecter?',
      'premium_access': 'Accès Premium',

      // Account Screen
      'profile': 'Profil',
      'edit_profile': 'Modifier le profil',
      'name': 'Nom',
      'partner_name': 'Nom du partenaire',
      'relationship_status': 'Statut de la relation',
      'anniversary_date': 'Date d\'anniversaire',
      'save': 'Enregistrer',
      'delete_account': 'Supprimer le compte',
      'delete_account_warning':
          'Cette action ne peut pas être annulée. Toutes vos données seront définitivement supprimées.',
      'confirm_delete': 'Confirmer la suppression',

      // Notifications Screen
      'push_notifications': 'Notifications push',
      'exercise_reminders': 'Rappels d\'exercices',
      'game_suggestions': 'Suggestions de jeux',
      'ai_tips': 'Conseils IA',
      'daily_reminders': 'Rappels quotidiens',

      // Privacy & Security
      'biometric_auth': 'Authentification biométrique',
      'use_face_id': 'Utiliser Face ID / Touch ID',
      'change_password': 'Changer le mot de passe',
      'data_privacy': 'Confidentialité des données',
      'export_data': 'Exporter mes données',
      'privacy_policy': 'Politique de confidentialité',
      'terms_of_service': 'Conditions d\'utilisation',

      // Help & Support
      'faq': 'Questions fréquemment posées',
      'contact_support': 'Contacter le support',
      'report_bug': 'Signaler un bug',
      'rate_app': 'Évaluer notre application',
      'share_app': 'Partager l\'application',
      'version': 'Version',
      'get_help': 'Obtenir de l\'aide',
      'resources': 'Ressources',
      'faqs': 'FAQ',
      'find_answers_to_common_questions': 'Trouvez des réponses aux questions courantes',
      'get_in_touch_with_our_team': 'Contactez notre équipe',
      'help_us_improve_the_app': 'Aidez-nous à améliorer l\'application',
      'read_our_terms_and_conditions': 'Lisez nos conditions générales',
      'how_we_handle_your_data': 'Comment nous traitons vos données',
      'strengthening_relationships_through_wellness': 'Renforcer les relations grâce au bien-être',
      'frequently_asked_questions': 'Questions fréquemment posées',
      'no_faqs_available_at_the_moment': 'Aucune FAQ disponible pour le moment.',
      'send_us_a_message_and_well_get_back_to_you_soon': 'Envoyez-nous un message et nous vous répondrons bientôt.',
      'message_sent': 'Message envoyé !',
      'send': 'Envoyer',
      'submit': 'Soumettre',
      'bug_title': 'Titre du bug',
      'description': 'Description',
      'please_describe_what_happened': 'Veuillez décrire ce qui s\'est passé...',
      'bug_report_submitted': 'Rapport de bug soumis !',
      'please_login_to_see_notifications': 'Veuillez vous connecter pour voir les notifications',
      'no_notifications_yet': 'Aucune notification pour le moment',
      'delete_notification': 'Supprimer la notification',
      'are_you_sure_you_want_to_delete_this_notification': 'Êtes-vous sûr de vouloir supprimer cette notification ?',
      'read_our_privacy_policy_and_terms': 'Lisez notre politique de confidentialité et nos conditions',
      'update_your_account_password': 'Mettez à jour le mot de passe de votre compte',
      'permanently_delete_your_account': 'Supprimez définitivement votre compte',
      'are_you_sure_you_want_to_permanently_delete_your_account_this_action_cannot_be_undone_and_you_will_lose_all_your_data': 'Êtes-vous sûr de vouloir supprimer définitivement votre compte ? Cette action est irréversible et vous perdrez toutes vos données.',
      'delete': 'Supprimer',
      'minutes_short_ago': 'min',
      'hours_short_ago': 'h',
      'days_short_ago': 'j',
      'yesterday': 'Hier',
      'date_night_ideas': 'Idées de soirée en amoureux',
      'would_you_rather': 'Tu préfères',
      'relationship_quiz': 'Quiz de relation',
      'compliment_game': 'Jeu de compliments',
      'couples_challenge': 'Défi de couple',
      'challenge': 'Défi',
      'round': 'Tour',
      'compliments': 'compliments',
      'migration_data': 'Données de migration',
      'no_ideas_available': 'Aucune idée disponible',
      'no_questions_available': 'Aucune question disponible',
      'no_prompts_available': 'Aucune invite disponible',
      'no_challenges_available': 'Aucun défi disponible',
      'next_idea': 'Idée suivante',
      'see_results': 'Voir les résultats',
      'score': 'Score',
      'both_answered': 'Les deux ont répondu !',
      'would_you_rather_ellipsis': 'Tu préfères...',
      'found_favorite_ideas': '{count} idées favorites trouvées !',
      'you_explored_date_night_ideas_together': 'Vous avez exploré {count} idées de soirée en amoureux ensemble !',
      'favorites': 'favoris',
      'so_much_love': 'Tellement d\'amour !',
      'you_shared_compliments': 'Vous avez partagé {count} compliments !',
      'give_a_compliment': 'Faire un compliment',
      'skip_turn': 'Passer le tour',
      'give_a_compliment_prompt': '{name}, fais un compliment !',
      'hint': 'Astuce',
      'challenge_complete': 'Défi terminé !',
      'you_completed_challenges_out_of_total': 'Vous avez terminé {done} défis sur {total} !',
      'challenge_completed': 'Défi terminé !',
      'skip_challenge': 'Passer le défi',
      'completed_count': 'terminés',
      'game_content': 'Contenu des jeux',
      'refresh_schedule': 'Programme d\'actualisation',
      'frequency': 'Fréquence',
      'next_refresh': 'Prochaine actualisation',
      'content_refreshes_automatically_every_30_days_with_new_questions': 'Le contenu s\'actualise automatiquement tous les 30 jours avec de nouvelles questions',
      'truth_or_truth_desc': 'Questions de connexion profonde pour les couples',
      'love_language_quiz_desc': 'Découvrez vos langages de l\'amour ensemble',
      'reflection_discussion_desc': 'Conversations significatives et évolution',
      'new': 'NOUVEAU',
      'version_n': 'Version {version}',
      'refresh_available': 'Actualisation disponible',
      'refresh_content': 'Actualiser le contenu',
      'content_refreshed_successfully': 'Le contenu de {name} a été actualisé avec succès !',
      'all_game_content_refreshed_successfully': 'Tout le contenu des jeux a été actualisé avec succès !',
      'error_refreshing_content': 'Erreur lors de l\'actualisation du contenu',
      'no_plans_available': 'Aucun forfait disponible',
      'unable_to_load_subscription_plans': 'Impossible de charger les forfaits d\'abonnement',
      'pay_now': 'Payer maintenant',
      'or_start_48_hour_free_trial': 'Ou commencez un essai gratuit de 48 heures',
      'request_cancellation': 'Demander l\'annulation',
      'cancellation_request_submitted_admin_will_review_it': 'Demande d\'annulation envoyée. L\'administrateur la examinera.',
      'error_loading_plans': 'Erreur lors du chargement des forfaits',
      'error_restoring_purchases': 'Erreur lors de la restauration des achats',
      'failed_to_send_message': 'Échec de l\'envoi du message',
      'error_loading_messages': 'Erreur lors du chargement des messages',
      'migration_confirmation_message': 'Cela va téléverser TOUTES les données de la sauvegarde intégrée migration.json (jeux, questions, valeurs par défaut de votre profil, amorce de chat) vers Firebase.\n\nLes documents existants seront fusionnés / mis à jour.\n\nContinuer ?',
      'upload': 'Téléverser',
      'uploading_to_firebase': 'Téléversement vers Firebase…',
      'migration_syncing_collections': 'Lecture de migration.json et synchronisation de toutes les collections.',
      'migration_failed': 'Échec de la migration',
      'uploaded_with_warnings': 'Téléversé avec des avertissements',
      'upload_complete': 'Téléversement terminé',
      'documents_uploaded_to_firebase': '{count} document(s) téléversé(s) vers Firebase.',
      'collections_synced': 'Collections synchronisées :',
      'warnings': 'Avertissements :',
      'source': 'Source',
      'migrate_new_data': 'Migrer de nouvelles données',
      'uploading': 'Téléversement…',
      'reset_challenge': 'Réinitialiser le défi',
      'reset': 'Réinitialiser',
      'reset_challenge_progress_confirmation': 'Voulez-vous vraiment réinitialiser votre progression du défi de 30 jours ? Cette action est irréversible.',
      'percent_complete': '{percent}% terminé',
      'days_completed_out_of_total': '{done} / {total} jours terminés',
      'challenge_completion_message': 'Félicitations pour avoir terminé 30 jours d\'exercices de Kegel. Vous avez obtenu votre badge Maîtrise !',
      'restart_challenge': 'Recommencer le défi',

      // Subscription Screen
      'monthly_plan': 'Forfait mensuel',
      'quarterly_plan': 'Forfait 3 mois',
      'yearly_plan': 'Forfait annuel',
      'per_month': '/mois',
      'save_33': 'Économisez 33%',
      'save_50': 'Économisez 50%',
      'best_value': 'MEILLEURE VALEUR',
      'free_trial_48h': 'Commencez votre essai gratuit de 48 heures',
      'then_price': 'Gratuit pendant 48 heures, puis',
      'cancel_anytime': 'Annuler à tout moment',
      'restore_purchases': 'Restaurer',
      'secure_payment': 'Paiement sécurisé via Apple et Google',
      'no_commitment': 'Annuler à tout moment, sans engagement',

      // Games
      'love_language_quiz': 'Quiz des langages de l\'amour',
      'reflection_discussion': 'Réflexion et discussion',
      'player_1': 'Joueur 1',
      'player_2': 'Joueur 2',
      'next_question': 'Question suivante',
      'finish': 'Terminer',
      'play_another': 'Jouer à un autre jeu',

      // Common
      'yes': 'Oui',
      'no': 'Non',
      'ok': 'OK',
      'continue': 'Continuer',
      'back': 'Retour',
      'close': 'Fermer',
      'error': 'Erreur',
      'success': 'Succès',
      'loading': 'Chargement...',
      'try_again': 'Réessayer',
      'something_went_wrong': 'Quelque chose s\'est mal passé',
    },
  };

  String translate(String key) {
    return _localizedValues[locale.languageCode]?[key] ?? key;
  }

  // Home Screen
  String get welcomeBack => translate('welcome_back');
  String get welcome => translate('welcome');
  String get home => translate('Home');
  String get exploreFeatures => translate('explore_features');
  String get premiumFeature => translate('premium_feature');
  String get premiumMessage => translate('premium_message');
  String get cancel => translate('cancel');
  String get startFreeTrial => translate('start_free_trial');
  String get trialStarted => translate('trial_started');
  String get failedToStartTrial => translate('failed_to_start_trial');
  String get premiumActive => translate('premium_active');
  String get trialActive => translate('trial_active');
  String get startTrial => translate('start_trial');
  String get fullAccess => translate('full_access');
  String get hoursRemaining => translate('hours_remaining');
  String get games => translate('games');
  String get couplesGames => translate('couples_games');
  String get couplesGamesSubtitle => translate('couples_games_subtitle');
  String get kegelExercises => translate('kegel_exercises');
  String get kegelExercisesSubtitle => translate('kegel_exercises_subtitle');
  String get aiChat => translate('ai_chat');
  String get aiChatSubtitle => translate('ai_chat_subtitle');
  String get signOut => translate('sign_out');

  // Games Screen
  String get playTogether => translate('play_together');
  String get gameNotFound => translate('game_not_found');
  String get gameComingSoon => translate('game_coming_soon');
  String get errorStartingGame => translate('error_starting_game');
  String get premiumGameMessage => translate('premium_game_message');
  String get upgrade => translate('upgrade');
  String get notStarted => translate('not_started');
  String get inProgress => translate('in_progress');
  String get completed => translate('completed');
  String get played => translate('played');
  String get time => translate('time');
  String get times => translate('times');
  String get playNow => translate('play_now');
  String get playAgain => translate('play_again');
  String get retry => translate('retry');

  // Kegel Screen
  String get kegel => translate('kegel');
  String get intimateWellnessJourney => translate('intimate_wellness_journey');
  String get yourProgress => translate('your_progress');
  String get weekStreak => translate('week_streak');
  String get completedLabel => translate('completed_label');
  String get dailyGoal => translate('daily_goal');
  String get exerciseRoutines => translate('exercise_routines');
  String get beginnerRoutine => translate('beginner_routine');
  String get intermediateRoutine => translate('intermediate_routine');
  String get advancedRoutine => translate('advanced_routine');
  String get minutes => translate('minutes');
  String get sets => translate('sets');
  String get noExercisesAvailable => translate('no_exercises_available');
  String get aboutKegel => translate('about_kegel');
  String get aboutKegelContent => translate('about_kegel_content');
  String get targetMuscle => translate('target_muscle');
  String get targetMuscleContent => translate('target_muscle_content');
  String get howToPerform => translate('how_to_perform');
  String get step1Title => translate('step_1_title');
  String get step1Desc => translate('step_1_desc');
  String get step2Title => translate('step_2_title');
  String get step2Desc => translate('step_2_desc');
  String get step3Title => translate('step_3_title');
  String get step3Desc => translate('step_3_desc');
  String get step4Title => translate('step_4_title');
  String get step4Desc => translate('step_4_desc');
  String get importantTips => translate('important_tips');
  String get tip1 => translate('tip_1');
  String get tip2 => translate('tip_2');
  String get tip3 => translate('tip_3');
  String get tip4 => translate('tip_4');
  String get medicalDisclaimer => translate('medical_disclaimer');
  String get medicalDisclaimerContent =>
      translate('medical_disclaimer_content');
  String get kegelChallenge => translate('kegel_challenge');
  String get kegelChallengeSubtitle => translate('kegel_challenge_subtitle');
  String get viewChallenge => translate('view_challenge');
  String get dayLabel => translate('day');
  String get kegelPlan => translate('kegel_plan');

  // Chat Screen
  String get chat => translate('chat');
  String get aiCompanion => translate('ai_companion');
  String get aiGreeting => translate('ai_greeting');
  String get typeMessage => translate('type_message');
  String get chatDisclaimer => translate('chat_disclaimer');

  // Authentication
  String get signIn => translate('sign_in');
  String get signUp => translate('sign_up');
  String get email => translate('email');
  String get password => translate('password');
  String get confirmPassword => translate('confirm_password');
  String get forgotPassword => translate('forgot_password');
  String get dontHaveAccount => translate('dont_have_account');
  String get alreadyHaveAccount => translate('already_have_account');
  String get orContinueWith => translate('or_continue_with');
  String get google => translate('google');
  String get apple => translate('apple');
  String get createAccount => translate('create_account');
  String get welcomeToVelmora => translate('welcome_to_velmora');
  String get strengthenYourRelationship =>
      translate('strengthen_your_relationship');

  // Onboarding
  String get skip => translate('skip');
  String get next => translate('next');
  String get getStarted => translate('get_started');
  String get onboardingTitle1 => translate('onboarding_title_1');
  String get onboardingDesc1 => translate('onboarding_desc_1');
  String get onboardingTitle2 => translate('onboarding_title_2');
  String get onboardingDesc2 => translate('onboarding_desc_2');
  String get onboardingTitle3 => translate('onboarding_title_3');
  String get onboardingDesc3 => translate('onboarding_desc_3');
  String get onboardingTitle4 => translate('onboarding_title_4');
  String get onboardingDesc4 => translate('onboarding_desc_4');
  String get english => translate('english');
  String get arabic => translate('arabic');
  String get french => translate('french');

  // Settings
  String get settings => translate('settings');
  String get account => translate('account');
  String get notifications => translate('notifications');
  String get privacySecurity => translate('privacy_security');
  String get helpSupport => translate('help_support');
  String get about => translate('about');
  String get logout => translate('logout');
  String get logoutMsg => translate('logout_msg');
  String get premiumAccess => translate('premium_access');
  // String get subscription => translate('subscription');

  // Account Screen
  String get profile => translate('profile');
  String get editProfile => translate('edit_profile');
  String get name => translate('name');
  String get partnerName => translate('partner_name');
  String get relationshipStatus => translate('relationship_status');
  String get anniversaryDate => translate('anniversary_date');
  String get save => translate('save');
  String get deleteAccount => translate('delete_account');
  String get deleteAccountWarning => translate('delete_account_warning');
  String get confirmDelete => translate('confirm_delete');

  // Notifications Screen
  String get pushNotifications => translate('push_notifications');
  String get exerciseReminders => translate('exercise_reminders');
  String get gameSuggestions => translate('game_suggestions');
  String get aiTips => translate('ai_tips');
  String get dailyReminders => translate('daily_reminders');
  String get reminderTime => translate('reminder_time');

  // Privacy & Security
  String get biometricAuth => translate('biometric_auth');
  String get useFaceId => translate('use_face_id');
  String get changePassword => translate('change_password');
  String get dataPrivacy => translate('data_privacy');
  String get exportData => translate('export_data');
  String get privacyPolicy => translate('privacy_policy');
  String get termsOfService => translate('terms_of_service');

  // Help & Support
  String get faq => translate('faq');
  String get contactSupport => translate('contact_support');
  String get reportBug => translate('report_bug');
  String get rateApp => translate('rate_app');
  String get shareApp => translate('share_app');
  String get version => translate('version');

  // Subscription Screen
  String get monthlyPlan => translate('monthly_plan');
  String get quarterlyPlan => translate('quarterly_plan');
  String get yearlyPlan => translate('yearly_plan');
  String get perMonth => translate('per_month');
  String get save33 => translate('save_33');
  String get save50 => translate('save_50');
  String get bestValue => translate('best_value');
  String get freeTrial48h => translate('free_trial_48h');
  String get thenPrice => translate('then_price');
  String get cancelAnytime => translate('cancel_anytime');
  String get restorePurchases => translate('restore_purchases');
  String get securePayment => translate('secure_payment');
  String get noCommitment => translate('no_commitment');

  // Games
  String get truthOrTruth => translate('truth_or_truth');
  String get loveLanguageQuiz => translate('love_language_quiz');
  String get reflectionDiscussion => translate('reflection_discussion');
  String get player1 => translate('player_1');
  String get player2 => translate('player_2');
  String get startGame => translate('start_game');
  String get nextQuestion => translate('next_question');
  String get finish => translate('finish');
  String get gameComplete => translate('game_complete');
  String get playAnother => translate('play_another');

  // Common
  String get yes => translate('yes');
  String get no => translate('no');
  String get ok => translate('ok');
  String get done => translate('done');
  String get continueText => translate('continue');
  String get back => translate('back');
  String get close => translate('close');
  String get error => translate('error');
  String get success => translate('success');
  String get loading => translate('loading');
  String get tryAgain => translate('try_again');
  String get somethingWentWrong => translate('something_went_wrong');

  // Splash Screen
  String get wellnessForCouples => translate('wellness_for_couples');

  // Love Language Quiz
  String get enterPlayerNames => translate('enter_player_names');
  String get player1Name => translate('player_1_name');
  String get player2Name => translate('player_2_name');
  String get startQuiz => translate('start_quiz');
  String get quizComplete => translate('quiz_complete');
  String get compatibilityScore => translate('compatibility_score');
  String get backToGames => translate('back_to_games');
  String get questionOf => translate('question_of');
  String get ofLabel => translate('of');
  String get sTurn => translate('s_turn');
  String get submitAnswer => translate('submit_answer');
  String get pleaseSelectAnswer => translate('please_select_answer');
  String get wordsOfAffirmation => translate('words_of_affirmation');
  String get qualityTime => translate('quality_time');
  String get receivingGifts => translate('receiving_gifts');
  String get actsOfService => translate('acts_of_service');
  String get physicalTouch => translate('physical_touch');
  String get loveLanguageWordsOfAffirmationDesc =>
      translate('love_language_words_of_affirmation_desc');
  String get loveLanguageQualityTimeDesc =>
      translate('love_language_quality_time_desc');
  String get loveLanguageReceivingGiftsDesc =>
      translate('love_language_receiving_gifts_desc');
  String get loveLanguageActsOfServiceDesc =>
      translate('love_language_acts_of_service_desc');
  String get loveLanguagePhysicalTouchDesc =>
      translate('love_language_physical_touch_desc');
  String get errorLoadingQuiz => translate('error_loading_quiz');
  String get errorCompletingQuiz => translate('error_completing_quiz');
  String get pleaseEnterNames => translate('please_enter_names');

  // Truth or Truth Game
  String get enterNames => translate('enter_names');
  String get finalScores => translate('final_scores');
  String get wins => translate('wins');
  String get itsATie => translate('its_a_tie');
  String get vs => translate('vs');
  String get questionCount => translate('question_count');
  String get yourAnswer => translate('your_answer');
  String get typeAnswerHere => translate('type_answer_here');
  String get pleaseEnterAnswer => translate('please_enter_answer');
  String get errorLoadingGame => translate('error_loading_game');
  String get errorCompletingGame => translate('error_completing_game');

  // Reflection & Discussion Game
  String get reflectionDiscussionGame =>
      translate('reflection_discussion_game');
  String get welcomeToReflection => translate('welcome_to_reflection');
  String get reflectionWelcomeDesc => translate('reflection_welcome_desc');
  String get yourTurn => translate('your_turn');
  String get shareThoughts => translate('share_thoughts');
  String get congratulations => translate('congratulations');
  String get gameCompletedReflection => translate('game_completed_reflection');
  String get questionsAnswered => translate('questions_answered');
  String get questionsTogether => translate('questions_together');
  String get sAnswer => translate('s_answer');

  // Settings
  String get language => translate('language');

  // Account Screen
  String get editName => translate('edit_name');
  String get displayName => translate('display_name');
  String get chooseProfilePicture => translate('choose_profile_picture');
  String get camera => translate('camera');
  String get gallery => translate('gallery');
  String get removePicture => translate('remove_picture');
  String get nameUpdated => translate('name_updated');
  String get failedToUpdateName => translate('failed_to_update_name');
  String get nameCannotBeEmpty => translate('name_cannot_be_empty');
  String get subscription => translate('subscription');
  String get premium => translate('premium');
  String get trial => translate('trial');
  String get free => translate('free');
  String get noNameSet => translate('no_name_set');
  String get profilePictureUpdated => translate('profile_picture_updated');
  String get profilePictureRemoved => translate('profile_picture_removed');
  String get failedToUploadPicture => translate('failed_to_upload_picture');
  String get failedToRemovePicture => translate('failed_to_remove_picture');
  String get uploadingProfilePicture => translate('uploading_profile_picture');

  // Kegel Play Screen
  String get kegelExercise => translate('kegel_exercise');
  String get progress => translate('progress');
  String get contract => translate('contract');
  String get relax => translate('relax');
  String get set => translate('set');
  String get greatJob => translate('great_job');
  String get youCompleted => translate('you_completed');
  String get duration => translate('duration');
  String get setsCompleted => translate('sets_completed');
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'ar', 'fr'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
