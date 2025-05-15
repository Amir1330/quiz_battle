import 'dart:async';
import 'package:flutter/material.dart';
import 'package:quizzz/l10n/app_localizations_en.dart';
import 'package:quizzz/l10n/app_localizations_ru.dart';
import 'package:quizzz/l10n/app_localizations_kk.dart';

abstract class AppLocalizations {
  static const delegate = _AppLocalizationsDelegate();

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  // Common texts
  String get appTitle;
  String get theme;
  String get language;
  String get systemTheme;
  String get lightTheme;
  String get darkTheme;

  // Home screen navigation
  String get play;
  String get myQuizzes;
  String get create;
  String get settings;

  // Quiz related
  String get createQuiz;
  String get title;
  String get description;
  String get timeLimit;
  String get timeLimitOptional;
  String get questions;
  String get addQuestion;
  String get editQuestion;
  String get question;
  String get options;
  String get option;
  String get correctOption;
  String get save;
  String get cancel;
  String get delete;
  String get deleteQuiz;
  String get deleteQuizConfirmation;
  String get noQuestionsAdded;
  String get pleaseAddQuestion;
  String get noQuizzesAvailable;
  String get noMyQuizzesAvailable;
  String get quizDeletedSuccessfully;
  String get errorLoadingQuiz;
  String get errorCreatingQuiz;
  String get creatingQuiz;
  String get quizCreatedSuccessfully;
  String get done;

  // Authentication
  String get login;
  String get signup;
  String get email;
  String get password;
  String get confirmPassword;
  String get forgotPassword;
  String get loginError;
  String get signupError;
  String get logout;
  String get loginRequired;

  // Session handling
  String get sessionExpired;
  String get ok;

  // Quiz play
  String get startQuiz;
  String get nextQuestion;
  String get previousQuestion;
  String get submit;
  String get quizResults;
  String get correctAnswers;
  String get totalQuestions;
  String get retry;
  String get quizCompleted;
  String get errorSavingResults;

  // Guest mode
  String get continueAsGuest;
  String get registrationRequired;

  // Quiz history
  String get quizHistory;
  String get noHistoryFound;
  String get score;
  String get timeSpent;
  String get seconds;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'ru', 'kk'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) {
    switch (locale.languageCode) {
      case 'ru':
        return Future.value(AppLocalizationsRu());
      case 'kk':
        return Future.value(AppLocalizationsKk());
      default:
        return Future.value(AppLocalizationsEn());
    }
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
