import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/quiz_provider.dart';

class CreateQuizScreen extends StatefulWidget {
  const CreateQuizScreen({super.key});

  @override
  State<CreateQuizScreen> createState() => _CreateQuizScreenState();
}

class _CreateQuizScreenState extends State<CreateQuizScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final List<Map<String, dynamic>> _questions = [];
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  Future<void> _createQuiz() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (!authProvider.canCreateQuiz) {
      _showError('Только авторизованные пользователи могут создавать квизы');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final quizData = {
        'title': _titleController.text,
        'description': _descriptionController.text,
        'questions': _questions,
        'createdAt': DateTime.now().toIso8601String(),
      };

      await Provider.of<QuizProvider>(
        context,
        listen: false,
      ).createQuiz(context, quizData);

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Квиз успешно создан'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        _showError(e.toString());
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    if (!authProvider.canCreateQuiz) {
      return Scaffold(
        appBar: AppBar(title: const Text('Создание квиза')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Только авторизованные пользователи могут создавать квизы',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Navigate to login screen
                  Navigator.of(context).pushNamed('/login');
                },
                child: const Text('Войти'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Создание квиза')),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: 'Название квиза',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Пожалуйста, введите название квиза';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Описание квиза',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Пожалуйста, введите описание квиза';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    // Questions list
                    ..._questions.asMap().entries.map((entry) {
                      final index = entry.key;
                      final question = entry.value;
                      return Card(
                        child: ListTile(
                          title: Text(question['text']),
                          subtitle: Text(
                            '${question['options'].length} вариантов ответа',
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              setState(() {
                                _questions.removeAt(index);
                              });
                            },
                          ),
                        ),
                      );
                    }).toList(),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () {
                        // Navigate to add question screen
                        Navigator.of(context).pushNamed('/add-question');
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('Добавить вопрос'),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _createQuiz,
                      child: const Text('Создать квиз'),
                    ),
                  ],
                ),
              ),
    );
  }
}
