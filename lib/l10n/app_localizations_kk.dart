import 'package:quizzz/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class AppLocalizationsKk implements AppLocalizations {
  const AppLocalizationsKk();

  @override
  final Locale locale = const Locale('kk');

  // Common texts
  @override
  String get appTitle => 'Викторина шайқасы';
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
  @override
  String get or => 'немесе';
  @override
  String get error => 'Қате';

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
  String get title => 'Тақырып';
  @override
  String get description => 'Сипаттама';
  @override
  String get enterQuizTitle => 'Викторина тақырыбын енгізіңіз';
  @override
  String get enterQuizDescription => 'Викторина сипаттамасын енгізіңіз';
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
  String get noQuizzesAvailable =>
      'Әзірге викториналар жоқ. Алғашқы болып жасаңыз!';
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
  @override
  String get completedAt => 'Аяқталды';
  
  // Form validation
  @override
  String get pleaseEnterTitle => 'Атауын енгізіңіз';
  @override
  String get pleaseEnterDescription => 'Сипаттаманы енгізіңіз';
  @override
  String get pleaseEnterEmail => 'Электрондық поштаңызды енгізіңіз';
  @override
  String get pleaseEnterValidEmail => 'Жарамды электрондық поштаны енгізіңіз';
  @override
  String get pleaseEnterPassword => 'Құпия сөзіңізді енгізіңіз';
  @override
  String get passwordMinLength => 'Құпия сөз кемінде 6 таңбадан тұруы керек';

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
  String get loginError =>
      'Кіру сәтсіз аяқталды. Тіркелгі деректерін тексеріңіз.';
  @override
  String get signupError => 'Тіркелу сәтсіз аяқталды. Қайталап көріңіз.';
  @override
  String get logout => 'Шығу';
  @override
  String get loginRequired => 'Викторина жасау үшін жүйеге кіруіңіз керек';
  @override
  String get noAccount => 'Тіркелгіңіз жоқ па? Тіркеліңіз';

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

  // Guest mode
  @override
  String get continueAsGuest => 'Қонақ ретінде жалғастыру';

  @override
  String get registrationRequired => 'Викторина жасау үшін тіркелу қажет';

  @override
  String get quizHistory => 'Викторина тарихы';

  @override
  String get noHistoryFound => 'Викторина тарихы табылмады';

  @override
  String get quizCompleted => 'Викторина аяқталды';

  @override
  String get errorSavingResults => 'Викторина нәтижелерін сақтау қатесі';

  @override
  String get timeSpent => 'Жұмсалған уақыт';

  @override
  String get score => 'Ұпай';

  @override
  String get seconds => 'секунд';

  @override
  String get quizSavedOffline => 'Квиз офлайн режимінде сақталды. Желіге қосылған кезде синхрондалады.';
  @override
  String get offlineMode => 'Сіз қазір офлайн режиміндесіз. Өзгерістер жергілікті сақталады және желіге қосылған кезде синхрондалады.';

  @override
  String get(String key) {
    switch (key) {
      case 'home':
        return 'Басты бет';
      case 'profile':
        return 'Профиль';
      case 'about':
        return 'Қолданба туралы';
      case 'login':
        return 'Кіру';
      case 'register':
        return 'Тіркелу';
      case 'logout':
        return 'Шығу';
      case 'email':
        return 'Электрондық пошта';
      case 'password':
        return 'Құпия сөз';
      case 'confirmPassword':
        return 'Құпия сөзді растау';
      case 'createQuiz':
        return 'Викторина жасау';
      case 'myQuizzes':
        return 'Менің викториналарым';
      case 'allQuizzes':
        return 'Барлық викториналар';
      case 'quizHistory':
        return 'Викторина тарихы';
      case 'score':
        return 'Ұпай';
      case 'time':
        return 'Уақыт';
      case 'start':
        return 'Бастау';
      case 'next':
        return 'Келесі';
      case 'finish':
        return 'Аяқтау';
      case 'retry':
        return 'Қайталау';
      case 'cancel':
        return 'Бас тарту';
      case 'delete':
        return 'Жою';
      case 'edit':
        return 'Өңдеу';
      case 'save':
        return 'Сақтау';
      case 'success':
        return 'Сәтті';
      case 'loading':
        return 'Жүктелуде...';
      case 'noInternet':
        return 'Интернет байланысы жоқ';
      case 'sync':
        return 'Синхрондау';
      case 'guestMode':
        return 'Қонақ режимі';
      case 'pleaseLogin':
        return 'Бұл мүмкіндікке қол жеткізу үшін кіріңіз';
      case 'invalidEmail':
        return 'Жарамсыз электрондық пошта мекенжайы';
      case 'invalidPassword':
        return 'Құпия сөз кемінде 6 таңбадан тұруы керек';
      case 'passwordsDontMatch':
        return 'Құпия сөздер сәйкес келмейді';
      case 'quizTitle':
        return 'Викторина тақырыбы';
      case 'addOption':
        return 'Опция қосу';
      case 'selectCorrectOption':
        return 'Дұрыс опцияны таңдаңыз';
      case 'loginRequired':
        return 'Кіру қажет';
      case 'sessionExpired':
        return 'Сессияңыз аяқталды. Қайта кіріңіз.';
      case 'ok':
        return 'Жарайды';
      case 'errorLoadingQuizzes':
        return 'Викториналарды жүктеу қатесі';
      case 'noQuizzesYet':
        return 'Әлі викториналар жоқ. Бірінші болып жасаңыз!';
      case 'retry':
        return 'Қайталау';
      case 'myQuizzesTitle':
        return 'Менің викториналарым';
      case 'deleteConfirmation':
        return 'Сіз бұл викторинаны жойғыңыз келетініне сенімдісіз бе?';
      case 'yes':
        return 'Иә';
      case 'no':
        return 'Жоқ';
      case 'errorDeletingQuiz':
        return 'Викторинаны жою қатесі';
      case 'registrationRequired':
        return 'Бұл мүмкіндікке қол жеткізу үшін тіркелу қажет.';
      case 'signup':
        return 'Тіркелу';
      case 'play':
        return 'Ойнау';
      case 'quizResults':
        return 'Викторина нәтижелері';
      case 'correctAnswers':
        return 'Дұрыс жауаптар';
      case 'done':
        return 'Дайын';
      case 'timeSpent':
        return 'Өткізілген уақыт';
      case 'seconds':
        return 'секунд';
      case 'quizCompleted':
        return 'Викторина аяқталды';
      case 'errorSavingResults':
        return 'Нәтижелерді сақтау қатесі';
      case 'history':
        return 'Тарих';
      case 'date':
        return 'Күні';
      case 'viewDetails':
        return 'Егжей-тегжейлі қарау';
      case 'scoreOutOfTotal':
        return 'Ұпай: %1\$d/%2\$d';
      case 'timeSpentSeconds':
        return 'Өткізілген уақыт: %1\$d с';
      case 'noHistoryYet':
        return 'Әлі тарих жоқ';
      case 'errorLoadingHistory':
        return 'Тарихты жүктеу қатесі';
      case 'quizDetails':
        return 'Викторина егжей-тегжейлі';
      case 'creator':
        return 'Жасаған';
      case 'noTimeLimit':
        return 'Уақыт шектеуі жоқ';
      case 'submit':
        return 'Жіберу';
      case 'confirmSubmission':
        return 'Викторинаны жібергіңіз келеді ме?';
      case 'youScored':
        return 'Сіз ұпай жинадыңыз';
      case 'ofTotal':
        return 'барлығы';
      case 'settingsTitle':
        return 'Параметрлер';
      case 'general':
        return 'Жалпы';
      case 'account':
        return 'Аккаунт';
      case 'deleteAccount':
        return 'Аккаунтты жою';
      case 'deleteAccountConfirmation':
        return 'Сіз аккаунтыңызды жойғыңыз келетініне сенімдісіз бе? Бұл әрекетті болдырмау мүмкін емес.';
      case 'themeSettings':
        return 'Тақырып параметрлері';
      case 'darkMode':
        return 'Қараңғы режим';
      case 'lightMode':
        return 'Ашық режим';
      case 'systemDefault':
        return 'Жүйелік әдепкі';
      case 'languageSettings':
        return 'Тіл параметрлері';
      case 'selectLanguage':
        return 'Тілді таңдау';
      case 'syncSettings':
        return 'Синхрондау параметрлері';
      case 'lastSynced':
        return 'Соңғы синхрондау: %1\$s';
      case 'syncNow':
        return 'Қазір синхрондау';
      case 'syncing':
        return 'Синхрондалуда...';
      case 'syncSuccessful':
        return 'Синхрондау сәтті аяқталды!';
      case 'syncFailed':
        return 'Синхрондау қатесі: %1\$s';
      case 'aboutApp':
        return 'Қолданба туралы';
      case 'versionInfo':
        return 'Нұсқа: %1\$s';
      case 'licenses':
        return 'Лицензиялар';
      case 'privacyPolicy':
        return 'Құпиялылық саясаты';
      case 'termsOfService':
        return 'Қызмет көрсету шарттары';
      case 'contactUs':
        return 'Бізбен байланысу';
      case 'sendFeedback':
        return 'Кері байланыс жіберу';
      case 'rateApp':
        return 'Қолданбаны бағалау';
      case 'welcome':
        return 'Қош келдіңіз!';
      case 'anonymousGuest':
        return 'Анонимді қонақ';
      default:
        return key;
    }
  }
}
