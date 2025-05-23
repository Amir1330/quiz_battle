import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:quizzz/l10n/app_localizations_en.dart';
import 'package:quizzz/l10n/app_localizations_ru.dart';
import 'package:quizzz/l10n/app_localizations_kk.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'appTitle': 'Quiz Battle',
      'home': 'Home',
      'profile': 'Profile',
      'settings': 'Settings',
      'about': 'About',
      'login': 'Login',
      'register': 'Register',
      'logout': 'Logout',
      'email': 'Email',
      'password': 'Password',
      'confirmPassword': 'Confirm Password',
      'createQuiz': 'Create Quiz',
      'myQuizzes': 'My Quizzes',
      'allQuizzes': 'All Quizzes',
      'quizHistory': 'Quiz History',
      'score': 'Score',
      'time': 'Time',
      'questions': 'Questions',
      'start': 'Start',
      'next': 'Next',
      'finish': 'Finish',
      'retry': 'Retry',
      'cancel': 'Cancel',
      'delete': 'Delete',
      'edit': 'Edit',
      'save': 'Save',
      'error': 'Error',
      'success': 'Success',
      'loading': 'Loading...',
      'noInternet': 'No Internet Connection',
      'sync': 'Sync',
      'guestMode': 'Guest Mode',
      'pleaseLogin': 'Please login to access this feature',
      'invalidEmail': 'Invalid email address',
      'invalidPassword': 'Password must be at least 6 characters',
      'passwordsDontMatch': 'Passwords do not match',
      'quizTitle': 'Quiz Title',
      'addQuestion': 'Add Question',
      'question': 'Question',
      'answer': 'Answer',
      'correctAnswer': 'Correct Answer',
      'options': 'Options',
      'addOption': 'Add Option',
      'theme': 'Theme',
      'language': 'Language',
      'light': 'Light',
      'dark': 'Dark',
      'system': 'System',
    },
    'ru': {
      'appTitle': 'Битва Квизов',
      'home': 'Главная',
      'profile': 'Профиль',
      'settings': 'Настройки',
      'about': 'О приложении',
      'login': 'Войти',
      'register': 'Регистрация',
      'logout': 'Выйти',
      'email': 'Email',
      'password': 'Пароль',
      'confirmPassword': 'Подтвердите пароль',
      'createQuiz': 'Создать квиз',
      'myQuizzes': 'Мои квизы',
      'allQuizzes': 'Все квизы',
      'quizHistory': 'История квизов',
      'score': 'Счет',
      'time': 'Время',
      'questions': 'Вопросы',
      'start': 'Начать',
      'next': 'Далее',
      'finish': 'Завершить',
      'retry': 'Повторить',
      'cancel': 'Отмена',
      'delete': 'Удалить',
      'edit': 'Редактировать',
      'save': 'Сохранить',
      'error': 'Ошибка',
      'success': 'Успешно',
      'loading': 'Загрузка...',
      'noInternet': 'Нет подключения к интернету',
      'sync': 'Синхронизировать',
      'guestMode': 'Гостевой режим',
      'pleaseLogin': 'Пожалуйста, войдите для доступа к этой функции',
      'invalidEmail': 'Неверный email адрес',
      'invalidPassword': 'Пароль должен содержать минимум 6 символов',
      'passwordsDontMatch': 'Пароли не совпадают',
      'quizTitle': 'Название квиза',
      'addQuestion': 'Добавить вопрос',
      'question': 'Вопрос',
      'answer': 'Ответ',
      'correctAnswer': 'Правильный ответ',
      'options': 'Варианты',
      'addOption': 'Добавить вариант',
      'theme': 'Тема',
      'language': 'Язык',
      'light': 'Светлая',
      'dark': 'Темная',
      'system': 'Системная',
    },
    'kk': {
      'appTitle': 'Викторина Шайқасы',
      'home': 'Басты бет',
      'profile': 'Профиль',
      'settings': 'Баптаулар',
      'about': 'Қолданба туралы',
      'login': 'Кіру',
      'register': 'Тіркелу',
      'logout': 'Шығу',
      'email': 'Email',
      'password': 'Құпия сөз',
      'confirmPassword': 'Құпия сөзді растау',
      'createQuiz': 'Викторина құру',
      'myQuizzes': 'Менің викториналарым',
      'allQuizzes': 'Барлық викториналар',
      'quizHistory': 'Викторина тарихы',
      'score': 'Ұпай',
      'time': 'Уақыт',
      'questions': 'Сұрақтар',
      'start': 'Бастау',
      'next': 'Келесі',
      'finish': 'Аяқтау',
      'retry': 'Қайталау',
      'cancel': 'Бас тарту',
      'delete': 'Жою',
      'edit': 'Өңдеу',
      'save': 'Сақтау',
      'error': 'Қате',
      'success': 'Сәтті',
      'loading': 'Жүктелуде...',
      'noInternet': 'Интернет байланысы жоқ',
      'sync': 'Синхрондау',
      'guestMode': 'Қонақ режимі',
      'pleaseLogin': 'Бұл функцияға қол жеткізу үшін жүйеге кіріңіз',
      'invalidEmail': 'Жарамсыз email мекенжайы',
      'invalidPassword': 'Құпия сөз кемінде 6 таңба болуы керек',
      'passwordsDontMatch': 'Құпия сөздер сәйкес келмейді',
      'quizTitle': 'Викторина тақырыбы',
      'addQuestion': 'Сұрақ қосу',
      'question': 'Сұрақ',
      'answer': 'Жауап',
      'correctAnswer': 'Дұрыс жауап',
      'options': 'Нұсқалар',
      'addOption': 'Нұсқа қосу',
      'theme': 'Тақырып',
      'language': 'Тіл',
      'light': 'Ашық',
      'dark': 'Қараңғы',
      'system': 'Жүйелік',
    },
  };

  String get(String key) {
    return _localizedValues[locale.languageCode]?[key] ?? _localizedValues['kk']![key]!;
  }

  // Common texts
  String get appTitle => get('appTitle');
  String get theme => get('theme');
  String get language => get('language');
  String get systemTheme => get('system');
  String get lightTheme => get('light');
  String get darkTheme => get('dark');
  String get or => get('or');
  String get error => get('error');

  // Home screen navigation
  String get play => get('home');
  String get myQuizzes => get('myQuizzes');
  String get create => get('createQuiz');
  String get settings => get('settings');

  // Quiz related
  String get createQuiz => get('createQuiz');
  String get title => get('quizTitle');
  String get description => get('description');
  String get enterQuizTitle => get('quizTitle');
  String get enterQuizDescription => get('description');
  String get timeLimit => get('time');
  String get timeLimitOptional => get('time');
  String get questions => get('questions');
  String get addQuestion => get('addQuestion');
  String get editQuestion => get('edit');
  String get question => get('question');
  String get options => get('options');
  String get option => get('option');
  String get correctOption => get('correctAnswer');
  String get save => get('save');
  String get cancel => get('cancel');
  String get delete => get('delete');
  String get deleteQuiz => get('delete');
  String get deleteQuizConfirmation => get('delete');
  String get noQuestionsAdded => get('noQuestionsAdded');
  String get pleaseAddQuestion => get('pleaseAddQuestion');
  String get noQuizzesAvailable => get('noQuizzesAvailable');
  String get noMyQuizzesAvailable => get('noMyQuizzesAvailable');
  String get quizDeletedSuccessfully => get('quizDeletedSuccessfully');
  String get errorLoadingQuiz => get('errorLoadingQuiz');
  String get errorCreatingQuiz => get('errorCreatingQuiz');
  String get creatingQuiz => get('creatingQuiz');
  String get quizCreatedSuccessfully => get('quizCreatedSuccessfully');
  String get done => get('done');
  String get completedAt => get('completedAt');

  // Form validation
  String get pleaseEnterTitle => get('pleaseEnterTitle');
  String get pleaseEnterDescription => get('pleaseEnterDescription');
  String get pleaseEnterEmail => get('pleaseEnterEmail');
  String get pleaseEnterValidEmail => get('pleaseEnterValidEmail');
  String get pleaseEnterPassword => get('pleaseEnterPassword');
  String get passwordMinLength => get('passwordMinLength');
  
  // Authentication
  String get login => get('login');
  String get signup => get('register');
  String get email => get('email');
  String get password => get('password');
  String get confirmPassword => get('confirmPassword');
  String get forgotPassword => get('forgotPassword');
  String get loginError => get('loginError');
  String get signupError => get('signupError');
  String get logout => get('logout');
  String get loginRequired => get('loginRequired');
  String get noAccount => get('noAccount');

  // Session handling
  String get sessionExpired => get('sessionExpired');
  String get ok => get('ok');

  // Quiz play
  String get startQuiz => get('start');
  String get nextQuestion => get('next');
  String get previousQuestion => get('previous');
  String get submit => get('submit');
  String get quizResults => get('quizResults');
  String get correctAnswers => get('correctAnswers');
  String get totalQuestions => get('totalQuestions');
  String get retry => get('retry');
  String get quizCompleted => get('quizCompleted');
  String get errorSavingResults => get('errorSavingResults');

  // Guest mode
  String get continueAsGuest => get('guestMode');
  String get registrationRequired => get('registrationRequired');

  // Quiz history
  String get quizHistory => get('quizHistory');
  String get noHistoryFound => get('noHistoryFound');
  String get score => get('score');
  String get timeSpent => get('timeSpent');
  String get seconds => get('seconds');

  // Offline mode
  String get quizSavedOffline => get('quizSavedOffline');
  String get offlineMode => get('offlineMode');
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'ru', 'kk'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
