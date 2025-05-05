import 'package:quizzz/l10n/app_localizations.dart';

class AppLocalizationsRu implements AppLocalizations {
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
  
  // Home screen navigation
  @override
  String get play => 'Играть';
  @override
  String get myQuizzes => 'Мои Викторины';
  @override
  String get create => 'Создать';
  @override
  String get settings => 'Настройки';
  
  // Quiz related
  @override
  String get createQuiz => 'Создать Викторину';
  @override
  String get title => 'Название';
  @override
  String get description => 'Описание';
  @override
  String get timeLimit => 'Ограничение времени';
  @override
  String get timeLimitOptional => 'Ограничение времени (секунды, необязательно)';
  @override
  String get questions => 'Вопросы';
  @override
  String get addQuestion => 'Добавить Вопрос';
  @override
  String get editQuestion => 'Редактировать Вопрос';
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
  String get deleteQuiz => 'Удалить Викторину';
  @override
  String get deleteQuizConfirmation => 'Вы уверены, что хотите удалить эту викторину?';
  @override
  String get noQuestionsAdded => 'Вопросы еще не добавлены.';
  @override
  String get pleaseAddQuestion => 'Пожалуйста, добавьте хотя бы один вопрос';
  @override
  String get noQuizzesAvailable => 'Викторины пока недоступны. Будьте первым, кто создаст!';
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
  
  // Authentication
  @override
  String get login => 'Вход';
  @override
  String get signup => 'Регистрация';
  @override
  String get email => 'Эл. почта';
  @override
  String get password => 'Пароль';
  @override
  String get confirmPassword => 'Подтвердите пароль';
  @override
  String get forgotPassword => 'Забыли пароль?';
  @override
  String get loginError => 'Ошибка входа. Проверьте свои учетные данные.';
  @override
  String get signupError => 'Регистрация не удалась. Пожалуйста, попробуйте снова.';
  @override
  String get logout => 'Выйти';
  @override
  String get loginRequired => 'Вы должны войти в систему, чтобы создать викторину';
  
  // Quiz play
  @override
  String get startQuiz => 'Начать Викторину';
  @override
  String get nextQuestion => 'Далее';
  @override
  String get previousQuestion => 'Назад';
  @override
  String get submit => 'Отправить';
  @override
  String get quizResults => 'Результаты Викторины';
  @override
  String get correctAnswers => 'Правильные Ответы';
  @override
  String get totalQuestions => 'Всего Вопросов';
  @override
  String get retry => 'Повторить';
  
  // Session handling
  @override
  String get sessionExpired => 'Срок действия вашей сессии истек. Пожалуйста, войдите снова.';
  @override
  String get ok => 'OK';
} 