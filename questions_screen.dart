import 'package:flutter/material.dart';

import 'data/questions.dart';
import 'models/answer_button.dart';

class QuestionsScreen extends StatefulWidget {
  const QuestionsScreen({super.key, required this.onSelectAnswer});

  final void Function(String answer) onSelectAnswer;

  @override
  State<QuestionsScreen> createState() => _QuestionsScreenState();
}

class _QuestionsScreenState extends State<QuestionsScreen> {
  var currentQuestionIndex = 0;

  // Odpovede sa miešajú raz pre každú otázku, nie pri každom build().
  var shuffledAnswers = questions[0].getShuffledAnswers();

  void answerQuestion(int questionIndex, String selectedAnswer) {
    // Druhý rýchly ťuk by patril k otázke, ktorá je už zodpovedaná.
    if (questionIndex != currentQuestionIndex) {
      return;
    }

    widget.onSelectAnswer(selectedAnswer);

    // Po poslednej otázke prepne obrazovku rodič (Quiz).
    if (currentQuestionIndex + 1 < questions.length) {
      setState(() {
        currentQuestionIndex++;
        shuffledAnswers = questions[currentQuestionIndex].getShuffledAnswers();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final questionIndex = currentQuestionIndex;
    final currentQuestion = questions[questionIndex];

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Otázka ${questionIndex + 1} / ${questions.length}',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 10),
            Text(
              currentQuestion.text,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFFFFE81F),
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 30),
            ...shuffledAnswers.map((answer) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: AnswerButton(
                  answerText: answer,
                  onTap: () => answerQuestion(questionIndex, answer),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
