import 'package:quizzz/l10n/app_localizations.dart';

class AppLocalizationsKk implements AppLocalizations {
  // Common texts
  @override
  String get appTitle => 'Quizzz';
  @override
  String get theme => 'Тақырып';
  @override
  String get language => 'Тіл';
  @override
  String get systemTheme => 'Жүйелік';
  @override
  String get lightTheme => 'Жарық';
  @override
  String get darkTheme => 'Қараңғы';
  
  // Home screen navigation
  @override
  String get play => 'Ойнау';
  @override
  String get myQuizzes => 'Менің Викториналарым';
  @override
  String get create => 'Жасау';
  @override
  String get settings => 'Параметрлер';
  
  // Quiz related
  @override
  String get createQuiz => 'Викторина жасау';
  @override
  String get title => 'Атауы';
  @override
  String get description => 'Сипаттама';
  @override
  String get timeLimit => 'Уақыт шектеуі';
  @override
  String get timeLimitOptional => 'Уақыт шектеуі (секунд, міндетті емес)';
  @override
  String get questions => 'Сұрақтар';
  @override
  String get addQuestion => 'Сұрақ қосу';
  @override
  String get editQuestion => 'Сұрақты өңдеу';
  @override
  String get question => 'Сұрақ';
  @override
  String get options => 'Нұсқалар';
  @override
  String get option => 'Нұсқа';
  @override
  String get correctOption => 'Дұрыс нұсқа';
  @override
  String get save => 'Сақтау';
  @override
  String get cancel => 'Болдырмау';
  @override
  String get delete => 'Жою';
  @override
  String get deleteQuiz => 'Викторинаны жою';
  @override
  String get deleteQuizConfirmation => 'Сіз бұл викторинаны жойғыңыз келе ме?';
  @override
  String get noQuestionsAdded => 'Сұрақтар әлі қосылмаған.';
  @override
  String get pleaseAddQuestion => 'Кем дегенде бір сұрақ қосыңыз';
  @override
  String get noQuizzesAvailable => 'Әзірге викториналар жоқ. Алғашқы болып жасаңыз!';
  @override
  String get noMyQuizzesAvailable => 'Сіз әлі бірде-бір викторина жасамадыңыз.';
  @override
  String get quizDeletedSuccessfully => 'Викторина сәтті жойылды';
  @override
  String get errorLoadingQuiz => 'Викторинаны жүктеу кезінде қате';
  @override
  String get errorCreatingQuiz => 'Викторина жасау сәтсіз аяқталды';
  @override
  String get creatingQuiz => 'Викторина жасалуда...';
  @override
  String get quizCreatedSuccessfully => 'Викторина сәтті жасалды!';
  @override
  String get done => 'Дайын';
  
  // Authentication
  @override
  String get login => 'Кіру';
  @override
  String get signup => 'Тіркелу';
  @override
  String get email => 'Эл. пошта';
  @override
  String get password => 'Құпия сөз';
  @override
  String get confirmPassword => 'Құпия сөзді растаңыз';
  @override
  String get forgotPassword => 'Құпия сөзді ұмыттыңыз ба?';
  @override
  String get loginError => 'Кіру сәтсіз аяқталды. Тіркелгі деректерін тексеріңіз.';
  @override
  String get signupError => 'Тіркелу сәтсіз аяқталды. Қайталап көріңіз.';
  @override
  String get logout => 'Шығу';
  @override
  String get loginRequired => 'Викторина жасау үшін жүйеге кіруіңіз керек';
  
  // Quiz play
  @override
  String get startQuiz => 'Викторинаны бастау';
  @override
  String get nextQuestion => 'Келесі';
  @override
  String get previousQuestion => 'Алдыңғы';
  @override
  String get submit => 'Жіберу';
  @override
  String get quizResults => 'Викторина нәтижелері';
  @override
  String get correctAnswers => 'Дұрыс жауаптар';
  @override
  String get totalQuestions => 'Барлық сұрақтар';
  @override
  String get retry => 'Қайталау';
  
  // Session handling
  @override
  String get sessionExpired => 'Сеансыңыздың мерзімі аяқталды. Қайта кіріңіз.';
  @override
  String get ok => 'OK';
} 