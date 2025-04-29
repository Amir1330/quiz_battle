import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/quiz.dart';
import '../providers/quiz_provider.dart';
import '../providers/settings_provider.dart';
import '../utils/translations.dart';

class CreateQuizScreen extends StatefulWidget {
  final Quiz? quiz;

  const CreateQuizScreen({super.key, this.quiz});

  @override
  State<CreateQuizScreen> createState() => _CreateQuizScreenState();
}

class _CreateQuizScreenState extends State<CreateQuizScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late List<Question> _questions;
  late String _selectedLanguage;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.quiz?.title ?? '');
    _descriptionController = TextEditingController(text: widget.quiz?.description ?? '');
    _questions = widget.quiz?.questions.toList() ?? [];
    _selectedLanguage = widget.quiz?.language ?? 
        Provider.of<SettingsProvider>(context, listen: false).language;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _addQuestion() {
    showDialog(
      context: context,
      builder: (context) => _QuestionDialog(
        onSave: (question) {
          setState(() {
            _questions.add(question);
          });
        },
      ),
    );
  }

  void _editQuestion(int index) {
    showDialog(
      context: context,
      builder: (context) => _QuestionDialog(
        question: _questions[index],
        onSave: (question) {
          setState(() {
            _questions[index] = question;
          });
        },
      ),
    );
  }

  void _deleteQuestion(int index) {
    setState(() {
      _questions.removeAt(index);
    });
  }

  void _saveQuiz() {
    if (_formKey.currentState!.validate() && _questions.isNotEmpty) {
      final quiz = Quiz(
        id: widget.quiz?.id,
        title: _titleController.text,
        description: _descriptionController.text,
        questions: _questions,
        language: _selectedLanguage,
      );

      final quizProvider = Provider.of<QuizProvider>(context, listen: false);
      if (widget.quiz == null) {
        quizProvider.addQuiz(quiz);
      } else {
        quizProvider.updateQuiz(quiz);
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final language = context.watch<SettingsProvider>().language;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.quiz == null
              ? Translations.get('createQuiz', language)
              : Translations.get('editQuiz', language),
        ),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: Translations.get('title', language),
                border: const OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return Translations.get('title', language);
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: Translations.get('description', language),
                border: const OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return Translations.get('description', language);
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedLanguage,
              decoration: InputDecoration(
                labelText: Translations.get('language', language),
                border: const OutlineInputBorder(),
              ),
              items: [
                DropdownMenuItem(
                  value: 'en',
                  child: Text(Translations.get('english', language)),
                ),
                DropdownMenuItem(
                  value: 'ru',
                  child: Text(Translations.get('russian', language)),
                ),
                DropdownMenuItem(
                  value: 'kk',
                  child: Text(Translations.get('kazakh', language)),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedLanguage = value;
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            Text(
              Translations.get('questions', language),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ...List.generate(
              _questions.length,
              (index) => Card(
                child: ListTile(
                  title: Text(_questions[index].question),
                  subtitle: Text(
                    '${Translations.get('correctAnswer', language)}: ${_questions[index].options[_questions[index].correctOptionIndex]}',
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _editQuestion(index),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _deleteQuestion(index),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _addQuestion,
              icon: const Icon(Icons.add),
              label: Text(Translations.get('addQuestion', language)),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _saveQuiz,
              child: Text(
                widget.quiz == null
                    ? Translations.get('createQuiz', language)
                    : Translations.get('saveChanges', language),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuestionDialog extends StatefulWidget {
  final Question? question;
  final Function(Question) onSave;

  const _QuestionDialog({
    this.question,
    required this.onSave,
  });

  @override
  State<_QuestionDialog> createState() => _QuestionDialogState();
}

class _QuestionDialogState extends State<_QuestionDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _questionController;
  late List<TextEditingController> _optionControllers;
  late int _correctOptionIndex;

  @override
  void initState() {
    super.initState();
    _questionController = TextEditingController(text: widget.question?.question ?? '');
    _optionControllers = List.generate(
      4,
      (index) => TextEditingController(
        text: widget.question?.options[index] ?? '',
      ),
    );
    _correctOptionIndex = widget.question?.correctOptionIndex ?? 0;
  }

  @override
  void dispose() {
    _questionController.dispose();
    for (var controller in _optionControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _saveQuestion() {
    if (_formKey.currentState!.validate()) {
      final question = Question(
        question: _questionController.text,
        options: _optionControllers.map((c) => c.text).toList(),
        correctOptionIndex: _correctOptionIndex,
      );
      widget.onSave(question);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final language = context.watch<SettingsProvider>().language;
    
    return AlertDialog(
      title: Text(
        widget.question == null
            ? Translations.get('addQuestion', language)
            : Translations.get('editQuiz', language),
      ),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _questionController,
                decoration: InputDecoration(
                  labelText: Translations.get('question', language),
                  border: const OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return Translations.get('question', language);
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ...List.generate(
                4,
                (index) => Column(
                  children: [
                    TextFormField(
                      controller: _optionControllers[index],
                      decoration: InputDecoration(
                        labelText: '${Translations.get('option', language)} ${index + 1}',
                        border: const OutlineInputBorder(),
                        suffixIcon: Radio<int>(
                          value: index,
                          groupValue: _correctOptionIndex,
                          onChanged: (value) {
                            setState(() {
                              _correctOptionIndex = value!;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return Translations.get('option', language);
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(Translations.get('cancel', language)),
        ),
        TextButton(
          onPressed: _saveQuestion,
          child: Text(Translations.get('save', language)),
        ),
      ],
    );
  }
}