import 'package:quizzz/l10n/app_localizations.dart';

class AppLocalizationsEn implements AppLocalizations {
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
}
