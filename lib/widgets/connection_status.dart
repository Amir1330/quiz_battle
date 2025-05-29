import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/quiz_provider.dart';

class ConnectionStatus extends StatelessWidget {
  const ConnectionStatus({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<QuizProvider>(
      builder: (context, quizProvider, child) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          color: quizProvider.isOffline ? Colors.orange : Colors.green,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                quizProvider.isOffline ? Icons.cloud_off : Icons.cloud_done,
                color: Colors.white,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                quizProvider.isOffline ? 'Оффлайн режим' : 'Онлайн',
                style: const TextStyle(color: Colors.white),
              ),
              if (quizProvider.isOffline) ...[
                const SizedBox(width: 8),
                TextButton(
                  onPressed: () async {
                    try {
                      await quizProvider.syncWithServer();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Синхронизация выполнена успешно'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Ошибка синхронизации: $e'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.2),
                  ),
                  child: const Text(
                    'Синхронизировать',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
