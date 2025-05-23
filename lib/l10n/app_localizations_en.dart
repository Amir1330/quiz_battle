import 'package:quizzz/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class AppLocalizationsEn implements AppLocalizations {
  const AppLocalizationsEn();

  @override
  final Locale locale = const Locale('en');

  @override
  String get(String key) {
    switch (key) {
      case 'app_name':
        return 'Quizzz';
      case 'login':
        return 'Login';
      case 'register':
        return 'Register';
      case 'email':
        return 'Email';
      case 'password':
        return 'Password';
      case 'confirm_password':
        return 'Confirm Password';
      case 'forgot_password':
        return 'Forgot Password?';
      case 'or':
        return 'OR';
      case 'continue_with_google':
        return 'Continue with Google';
      case 'continue_with_apple':
        return 'Continue with Apple';
      case 'dont_have_account':
        return 'Don\'t have an account?';
      case 'already_have_account':
        return 'Already have an account?';
      case 'sign_up':
        return 'Sign Up';
      case 'sign_in':
        return 'Sign In';
      case 'create_quiz':
        return 'Create Quiz';
      case 'my_quizzes':
        return 'My Quizzes';
      case 'settings':
        return 'Settings';
      case 'profile':
        return 'Profile';
      case 'logout':
        return 'Logout';
      case 'language':
        return 'Language';
      case 'theme':
        return 'Theme';
      case 'dark_mode':
        return 'Dark Mode';
      case 'light_mode':
        return 'Light Mode';
      case 'system':
        return 'System';
      case 'about':
        return 'About';
      case 'version':
        return 'Version';
      case 'privacy_policy':
        return 'Privacy Policy';
      case 'terms_of_service':
        return 'Terms of Service';
      case 'contact_us':
        return 'Contact Us';
      case 'feedback':
        return 'Feedback';
      case 'rate_app':
        return 'Rate App';
      case 'share_app':
        return 'Share App';
      case 'error':
        return 'Error';
      case 'success':
        return 'Success';
      case 'warning':
        return 'Warning';
      case 'info':
        return 'Info';
      case 'ok':
        return 'OK';
      case 'cancel':
        return 'Cancel';
      case 'save':
        return 'Save';
      case 'delete':
        return 'Delete';
      case 'edit':
        return 'Edit';
      case 'search':
        return 'Search';
      case 'no_results':
        return 'No Results';
      case 'loading':
        return 'Loading...';
      case 'retry':
        return 'Retry';
      case 'offline':
        return 'You are offline';
      case 'sync_error':
        return 'Sync Error';
      case 'sync_success':
        return 'Sync Successful';
      case 'sync_in_progress':
        return 'Syncing...';
      case 'quiz_title':
        return 'Quiz Title';
      case 'quiz_description':
        return 'Quiz Description';
      case 'add_question':
        return 'Add Question';
      case 'question':
        return 'Question';
      case 'answer':
        return 'Answer';
      case 'correct_answer':
        return 'Correct Answer';
      case 'time_limit':
        return 'Time Limit';
      case 'seconds':
        return 'seconds';
      case 'points':
        return 'Points';
      case 'difficulty':
        return 'Difficulty';
      case 'easy':
        return 'Easy';
      case 'medium':
        return 'Medium';
      case 'hard':
        return 'Hard';
      case 'category':
        return 'Category';
      case 'tags':
        return 'Tags';
      case 'public':
        return 'Public';
      case 'private':
        return 'Private';
      case 'start_quiz':
        return 'Start Quiz';
      case 'end_quiz':
        return 'End Quiz';
      case 'next':
        return 'Next';
      case 'previous':
        return 'Previous';
      case 'submit':
        return 'Submit';
      case 'results':
        return 'Results';
      case 'score':
        return 'Score';
      case 'time':
        return 'Time';
      case 'correct':
        return 'Correct';
      case 'incorrect':
        return 'Incorrect';
      case 'skipped':
        return 'Skipped';
      case 'total':
        return 'Total';
      case 'average':
        return 'Average';
      case 'best':
        return 'Best';
      case 'worst':
        return 'Worst';
      case 'history':
        return 'History';
      case 'statistics':
        return 'Statistics';
      case 'achievements':
        return 'Achievements';
      case 'leaderboard':
        return 'Leaderboard';
      case 'rank':
        return 'Rank';
      case 'level':
        return 'Level';
      case 'experience':
        return 'Experience';
      case 'streak':
        return 'Streak';
      case 'days':
        return 'days';
      case 'weeks':
        return 'weeks';
      case 'months':
        return 'months';
      case 'years':
        return 'years';
      default:
        return key;
    }
  }

  // Common texts
  @override
  String get appTitle => 'Quizzz';
  @override
  String get theme => 'Theme';
  @override
  String get language => 'Language';
  @override
  String get systemTheme => 'System';
  @override
  String get lightTheme => 'Light';
  @override
  String get darkTheme => 'Dark';
  @override
  String get or => 'or';
  @override
  String get error => 'Error';

  // Home screen navigation
  @override
  String get play => 'Play';
  @override
  String get myQuizzes => 'My Quizzes';
  @override
  String get create => 'Create';
  @override
  String get settings => 'Settings';

  // Quiz related
  @override
  String get createQuiz => 'Create Quiz';
  @override
  String get title => 'Title';
  @override
  String get description => 'Description';
  @override
  String get enterQuizTitle => 'Enter quiz title';
  @override
  String get enterQuizDescription => 'Enter quiz description';
  @override
  String get timeLimit => 'Time Limit';
  @override
  String get timeLimitOptional => 'Time Limit (seconds, optional)';
  @override
  String get questions => 'Questions';
  @override
  String get addQuestion => 'Add Question';
  @override
  String get editQuestion => 'Edit Question';
  @override
  String get question => 'Question';
  @override
  String get options => 'Options';
  @override
  String get option => 'Option';
  @override
  String get correctOption => 'Correct Option';
  @override
  String get save => 'Save';
  @override
  String get cancel => 'Cancel';
  @override
  String get delete => 'Delete';
  @override
  String get deleteQuiz => 'Delete Quiz';
  @override
  String get deleteQuizConfirmation =>
      'Are you sure you want to delete this quiz?';
  @override
  String get noQuestionsAdded => 'No questions added yet.';
  @override
  String get pleaseAddQuestion => 'Please add at least one question';
  @override
  String get noQuizzesAvailable =>
      'No quizzes available yet. Be the first to create one!';
  @override
  String get noMyQuizzesAvailable => 'You haven\'t created any quizzes yet.';
  @override
  String get quizDeletedSuccessfully => 'Quiz deleted successfully';
  @override
  String get errorLoadingQuiz => 'Error loading quiz';
  @override
  String get errorCreatingQuiz => 'Failed to create quiz';
  @override
  String get creatingQuiz => 'Creating Quiz...';
  @override
  String get quizCreatedSuccessfully => 'Quiz created successfully!';
  @override
  String get done => 'Done';
  @override
  String get completedAt => 'Completed';
  
  // Form validation
  @override
  String get pleaseEnterTitle => 'Please enter a title';
  @override
  String get pleaseEnterDescription => 'Please enter a description';
  @override
  String get pleaseEnterEmail => 'Please enter your email';
  @override
  String get pleaseEnterValidEmail => 'Please enter a valid email';
  @override
  String get pleaseEnterPassword => 'Please enter your password';
  @override
  String get passwordMinLength => 'Password must be at least 6 characters long';

  // Authentication
  @override
  String get login => 'Login';
  @override
  String get signup => 'Sign Up';
  @override
  String get email => 'Email';
  @override
  String get password => 'Password';
  @override
  String get confirmPassword => 'Confirm Password';
  @override
  String get forgotPassword => 'Forgot Password?';
  @override
  String get loginError => 'Login failed. Please check your credentials.';
  @override
  String get signupError => 'Sign up failed. Please try again.';
  @override
  String get logout => 'Logout';
  @override
  String get loginRequired => 'You must be logged in to create a quiz';
  @override
  String get noAccount => 'No account? Sign up';

  // Quiz play
  @override
  String get startQuiz => 'Start Quiz';
  @override
  String get nextQuestion => 'Next';
  @override
  String get previousQuestion => 'Previous';
  @override
  String get submit => 'Submit';
  @override
  String get quizResults => 'Quiz Results';
  @override
  String get correctAnswers => 'Correct Answers';
  @override
  String get totalQuestions => 'Total Questions';
  @override
  String get retry => 'Retry';

  // Session handling
  @override
  String get sessionExpired => 'Your session has expired. Please log in again.';
  @override
  String get ok => 'OK';

  // Guest mode
  @override
  String get continueAsGuest => 'Continue as Guest';

  @override
  String get registrationRequired =>
      'Registration is required to create quizzes';

  @override
  String get quizHistory => 'Quiz History';

  @override
  String get noHistoryFound => 'No quiz history found';

  @override
  String get quizCompleted => 'Quiz Completed';

  @override
  String get errorSavingResults => 'Error saving quiz results';

  @override
  String get timeSpent => 'Time Spent';

  @override
  String get score => 'Score';

  @override
  String get seconds => 'seconds';

  @override
  String get quizSavedOffline => 'Quiz saved offline. It will be synced when you are back online.';
  @override
  String get offlineMode => 'You are currently offline. Changes will be saved locally and synced when you are back online.';
}
