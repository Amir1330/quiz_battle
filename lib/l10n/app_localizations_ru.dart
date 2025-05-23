import 'package:flutter/material.dart';
import 'package:quizzz/l10n/app_localizations.dart';

class AppLocalizationsRu implements AppLocalizations {
  const AppLocalizationsRu();

  @override
  final Locale locale = const Locale('ru');

  @override
  String get(String key) {
    switch (key) {
      case 'app_name':
        return 'Quizzz';
      case 'login':
        return 'Вход';
      case 'register':
        return 'Регистрация';
      case 'email':
        return 'Email';
      case 'password':
        return 'Пароль';
      case 'confirm_password':
        return 'Подтвердите пароль';
      case 'forgot_password':
        return 'Забыли пароль?';
      case 'or':
        return 'ИЛИ';
      case 'continue_with_google':
        return 'Продолжить с Google';
      case 'continue_with_apple':
        return 'Продолжить с Apple';
      case 'dont_have_account':
        return 'Нет аккаунта?';
      case 'already_have_account':
        return 'Уже есть аккаунт?';
      case 'sign_up':
        return 'Зарегистрироваться';
      case 'sign_in':
        return 'Войти';
      case 'create_quiz':
        return 'Создать викторину';
      case 'my_quizzes':
        return 'Мои викторины';
      case 'settings':
        return 'Настройки';
      case 'profile':
        return 'Профиль';
      case 'logout':
        return 'Выйти';
      case 'language':
        return 'Язык';
      case 'theme':
        return 'Тема';
      case 'dark_mode':
        return 'Темная тема';
      case 'light_mode':
        return 'Светлая тема';
      case 'system':
        return 'Системная';
      case 'about':
        return 'О приложении';
      case 'version':
        return 'Версия';
      case 'privacy_policy':
        return 'Политика конфиденциальности';
      case 'terms_of_service':
        return 'Условия использования';
      case 'contact_us':
        return 'Связаться с нами';
      case 'feedback':
        return 'Обратная связь';
      case 'rate_app':
        return 'Оценить приложение';
      case 'share_app':
        return 'Поделиться приложением';
      case 'error':
        return 'Ошибка';
      case 'success':
        return 'Успешно';
      case 'warning':
        return 'Предупреждение';
      case 'info':
        return 'Информация';
      case 'ok':
        return 'OK';
      case 'cancel':
        return 'Отмена';
      case 'save':
        return 'Сохранить';
      case 'delete':
        return 'Удалить';
      case 'edit':
        return 'Редактировать';
      case 'search':
        return 'Поиск';
      case 'no_results':
        return 'Нет результатов';
      case 'loading':
        return 'Загрузка...';
      case 'retry':
        return 'Повторить';
      case 'offline':
        return 'Вы не в сети';
      case 'sync_error':
        return 'Ошибка синхронизации';
      case 'sync_success':
        return 'Синхронизация успешна';
      case 'sync_in_progress':
        return 'Синхронизация...';
      case 'quiz_title':
        return 'Название викторины';
      case 'quiz_description':
        return 'Описание викторины';
      case 'add_question':
        return 'Добавить вопрос';
      case 'question':
        return 'Вопрос';
      case 'answer':
        return 'Ответ';
      case 'correct_answer':
        return 'Правильный ответ';
      case 'time_limit':
        return 'Ограничение по времени';
      case 'seconds':
        return 'секунд';
      case 'points':
        return 'очков';
      case 'difficulty':
        return 'Сложность';
      case 'easy':
        return 'Легкий';
      case 'medium':
        return 'Средний';
      case 'hard':
        return 'Сложный';
      case 'category':
        return 'Категория';
      case 'tags':
        return 'Теги';
      case 'public':
        return 'Публичный';
      case 'private':
        return 'Приватный';
      case 'start_quiz':
        return 'Начать викторину';
      case 'end_quiz':
        return 'Завершить викторину';
      case 'next':
        return 'Далее';
      case 'previous':
        return 'Назад';
      case 'submit':
        return 'Отправить';
      case 'results':
        return 'Результаты';
      case 'score':
        return 'Счет';
      case 'time':
        return 'Время';
      case 'correct':
        return 'Правильно';
      case 'incorrect':
        return 'Неправильно';
      case 'skipped':
        return 'Пропущено';
      case 'total':
        return 'Всего';
      case 'average':
        return 'Среднее';
      case 'best':
        return 'Лучший';
      case 'worst':
        return 'Худший';
      case 'history':
        return 'История';
      case 'statistics':
        return 'Статистика';
      case 'achievements':
        return 'Достижения';
      case 'leaderboard':
        return 'Таблица лидеров';
      case 'rank':
        return 'Ранг';
      case 'level':
        return 'Уровень';
      case 'experience':
        return 'Опыт';
      case 'streak':
        return 'Серия';
      case 'days':
        return 'дней';
      case 'weeks':
        return 'недель';
      case 'months':
        return 'месяцев';
      case 'years':
        return 'лет';
      default:
        return key;
    }
  }

  // Common texts
  @override
  String get appTitle => 'Quizzz';
  @override
  String get theme => 'Тема';
  @override
  String get language => 'Язык';
  @override
  String get systemTheme => 'Системная';
  @override
  String get lightTheme => 'Светлая';
  @override
  String get darkTheme => 'Темная';
  @override
  String get or => 'или';
  @override
  String get error => 'Ошибка';

  // Home screen navigation
  @override
  String get play => 'Играть';
  @override
  String get myQuizzes => 'Мои викторины';
  @override
  String get create => 'Создать';
  @override
  String get settings => 'Настройки';

  // Quiz related
  @override
  String get createQuiz => 'Создать викторину';
  @override
  String get title => 'Название';
  @override
  String get description => 'Описание';
  @override
  String get enterQuizTitle => 'Введите название викторины';
  @override
  String get enterQuizDescription => 'Введите описание викторины';
  @override
  String get timeLimit => 'Ограничение по времени';
  @override
  String get timeLimitOptional => 'Ограничение по времени (секунды, необязательно)';
  @override
  String get questions => 'Вопросы';
  @override
  String get addQuestion => 'Добавить вопрос';
  @override
  String get editQuestion => 'Редактировать вопрос';
  @override
  String get question => 'Вопрос';
  @override
  String get options => 'Варианты';
  @override
  String get option => 'Вариант';
  @override
  String get correctOption => 'Правильный вариант';
  @override
  String get save => 'Сохранить';
  @override
  String get cancel => 'Отмена';
  @override
  String get delete => 'Удалить';
  @override
  String get deleteQuiz => 'Удалить викторину';
  @override
  String get deleteQuizConfirmation => 'Вы уверены, что хотите удалить эту викторину?';
  @override
  String get noQuestionsAdded => 'Вопросы еще не добавлены.';
  @override
  String get pleaseAddQuestion => 'Пожалуйста, добавьте хотя бы один вопрос';
  @override
  String get noQuizzesAvailable => 'Пока нет доступных викторин. Будьте первым, кто создаст!';
  @override
  String get noMyQuizzesAvailable => 'Вы еще не создали ни одной викторины.';
  @override
  String get quizDeletedSuccessfully => 'Викторина успешно удалена';
  @override
  String get errorLoadingQuiz => 'Ошибка загрузки викторины';
  @override
  String get errorCreatingQuiz => 'Не удалось создать викторину';
  @override
  String get creatingQuiz => 'Создание викторины...';
  @override
  String get quizCreatedSuccessfully => 'Викторина успешно создана!';
  @override
  String get done => 'Готово';
  @override
  String get completedAt => 'Завершено';
  
  // Form validation
  @override
  String get pleaseEnterTitle => 'Пожалуйста, введите название';
  @override
  String get pleaseEnterDescription => 'Пожалуйста, введите описание';
  @override
  String get pleaseEnterEmail => 'Пожалуйста, введите ваш email';
  @override
  String get pleaseEnterValidEmail => 'Пожалуйста, введите корректный email';
  @override
  String get pleaseEnterPassword => 'Пожалуйста, введите пароль';
  @override
  String get passwordMinLength => 'Пароль должен содержать не менее 6 символов';

  // Authentication
  @override
  String get login => 'Вход';
  @override
  String get signup => 'Регистрация';
  @override
  String get email => 'Email';
  @override
  String get password => 'Пароль';
  @override
  String get confirmPassword => 'Подтвердите пароль';
  @override
  String get forgotPassword => 'Забыли пароль?';
  @override
  String get loginError => 'Ошибка входа. Проверьте ваши учетные данные.';
  @override
  String get signupError => 'Ошибка регистрации. Пожалуйста, попробуйте снова.';
  @override
  String get logout => 'Выйти';
  @override
  String get loginRequired => 'Для создания викторины необходимо войти в систему';
  @override
  String get noAccount => 'Нет аккаунта? Зарегистрируйтесь';

  // Quiz play
  @override
  String get startQuiz => 'Начать викторину';
  @override
  String get nextQuestion => 'Далее';
  @override
  String get previousQuestion => 'Назад';
  @override
  String get submit => 'Отправить';
  @override
  String get quizResults => 'Результаты викторины';
  @override
  String get correctAnswers => 'Правильные ответы';
  @override
  String get totalQuestions => 'Всего вопросов';
  @override
  String get retry => 'Повторить';

  // Session handling
  @override
  String get sessionExpired => 'Ваша сессия истекла. Пожалуйста, войдите снова.';
  @override
  String get ok => 'OK';

  // Guest mode
  @override
  String get continueAsGuest => 'Продолжить как гость';

  @override
  String get registrationRequired => 'Для создания викторин требуется регистрация';

  @override
  String get quizHistory => 'История викторин';

  @override
  String get noHistoryFound => 'История викторин не найдена';

  @override
  String get quizCompleted => 'Викторина завершена';

  @override
  String get errorSavingResults => 'Ошибка сохранения результатов викторины';

  @override
  String get timeSpent => 'Затраченное время';

  @override
  String get score => 'Счет';

  @override
  String get seconds => 'секунд';

  @override
  String get quizSavedOffline => 'Викторина сохранена в автономном режиме. Она будет синхронизирована, когда вы вернетесь в сеть.';
  @override
  String get offlineMode => 'Вы сейчас в автономном режиме. Изменения будут сохранены локально и синхронизированы, когда вы вернетесь в сеть.';
}
