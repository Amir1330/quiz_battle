class Translations {
  static final Map<String, Map<String, String>> _translations = {
    'en': {
      'appTitle': 'Quiz Battle',
      'play': 'Play',
      'settings': 'Settings',
      'availableQuizzes': 'Available Quizzes',
      'noQuizzes': 'No quizzes available',
      'createQuiz': 'Create Quiz',
      'editQuiz': 'Edit Quiz',
      'deleteQuiz': 'Delete Quiz',
      'deleteQuizConfirm': 'Are you sure you want to delete this quiz?',
      'cancel': 'Cancel',
      'delete': 'Delete',
      'title': 'Title',
      'description': 'Description',
      'language': 'Language',
      'questions': 'Questions',
      'addQuestion': 'Add Question',
      'saveChanges': 'Save Changes',
      'question': 'Question',
      'option': 'Option',
      'correctAnswer': 'Correct answer',
      'save': 'Save',
      'theme': 'Theme',
      'system': 'System',
      'light': 'Light',
      'dark': 'Dark',
      'selectTheme': 'Select Theme',
      'selectLanguage': 'Select Language',
      'english': 'English',
      'russian': 'Русский',
      'kazakh': 'Қазақша',
      'quizResults': 'Quiz Results',
      'score': 'Score',
      'outOf': 'out of',
      'done': 'Done',
      'nextQuestion': 'Next Question',
      'showResults': 'Show Results',
    },
    'ru': {
      'appTitle': 'Битва Викторин',
      'play': 'Играть',
      'settings': 'Настройки',
      'availableQuizzes': 'Доступные Викторины',
      'noQuizzes': 'Нет доступных викторин',
      'createQuiz': 'Создать Викторину',
      'editQuiz': 'Редактировать Викторину',
      'deleteQuiz': 'Удалить Викторину',
      'deleteQuizConfirm': 'Вы уверены, что хотите удалить эту викторину?',
      'cancel': 'Отмена',
      'delete': 'Удалить',
      'title': 'Название',
      'description': 'Описание',
      'language': 'Язык',
      'questions': 'Вопросы',
      'addQuestion': 'Добавить Вопрос',
      'saveChanges': 'Сохранить Изменения',
      'question': 'Вопрос',
      'option': 'Вариант',
      'correctAnswer': 'Правильный ответ',
      'save': 'Сохранить',
      'theme': 'Тема',
      'system': 'Системная',
      'light': 'Светлая',
      'dark': 'Темная',
      'selectTheme': 'Выбрать Тему',
      'selectLanguage': 'Выбрать Язык',
      'english': 'English',
      'russian': 'Русский',
      'kazakh': 'Қазақша',
      'quizResults': 'Результаты Викторины',
      'score': 'Счет',
      'outOf': 'из',
      'done': 'Готово',
      'nextQuestion': 'Следующий Вопрос',
      'showResults': 'Показать Результаты',
    },
    'kk': {
      'appTitle': 'Викторина Қақтығысы',
      'play': 'Ойнау',
      'settings': 'Параметрлер',
      'availableQuizzes': 'Қолжетімді Викториналар',
      'noQuizzes': 'Викторина жоқ',
      'createQuiz': 'Викторина Жасау',
      'editQuiz': 'Викторинаны Өңдеу',
      'deleteQuiz': 'Викторинаны Жою',
      'deleteQuizConfirm': 'Бұл викторинаны жойғыңыз келе ме?',
      'cancel': 'Болдырмау',
      'delete': 'Жою',
      'title': 'Атауы',
      'description': 'Сипаттама',
      'language': 'Тіл',
      'questions': 'Сұрақтар',
      'addQuestion': 'Сұрақ Қосу',
      'saveChanges': 'Өзгерістерді Сақтау',
      'question': 'Сұрақ',
      'option': 'Нұсқа',
      'correctAnswer': 'Дұрыс жауап',
      'save': 'Сақтау',
      'theme': 'Тақырып',
      'system': 'Жүйелік',
      'light': 'Жарық',
      'dark': 'Қараңғы',
      'selectTheme': 'Тақырыпты Таңдау',
      'selectLanguage': 'Тілді Таңдау',
      'english': 'English',
      'russian': 'Русский',
      'kazakh': 'Қазақша',
      'quizResults': 'Викторина Нәтижесі',
      'score': 'Ұпай',
      'outOf': '/',
      'done': 'Дайын',
      'nextQuestion': 'Келесі Сұрақ',
      'showResults': 'Нәтижені Көрсету',
    },
  };

  static String get(String key, String language) {
    return _translations[language]?[key] ?? _translations['en']![key] ?? key;
  }
} 