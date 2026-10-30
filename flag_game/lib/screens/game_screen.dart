import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_state.dart';
import '../models/country.dart';
import 'result_screen.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  Country? _selectedAnswer;
  bool _isAnswerCorrect = false;

  @override
  void initState() {
    super.initState();
    final gameState = Provider.of<GameState>(context, listen: false);
    gameState.addListener(_checkGameOver);
  }

  @override
  void dispose() {
    final gameState = Provider.of<GameState>(context, listen: false);
    gameState.removeListener(_checkGameOver);
    super.dispose();
  }

  void _checkGameOver() {
    final gameState = Provider.of<GameState>(context, listen: false);
    if (gameState.isGameOver && mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ResultScreen()),
      );
    }
  }

  void _handleAnswer(Country selectedCountry, GameState gameState) {
    if (_selectedAnswer != null || gameState.isGameOver) return;

    final isCorrect = selectedCountry.code == gameState.currentQuestion!.correctCountry.code;

    setState(() {
      _selectedAnswer = selectedCountry;
      _isAnswerCorrect = isCorrect;
    });

    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _selectedAnswer = null;
        });
        gameState.submitAnswer(selectedCountry);
      }
    });
  }

  Color _getButtonColor(Country country, GameState gameState) {
    if (_selectedAnswer == null) return Colors.white;

    final isThisCorrectAnswer = country.code == gameState.currentQuestion!.correctCountry.code;
    
    if (isThisCorrectAnswer) {
      return Colors.green.shade300;
    }
    if (_selectedAnswer == country && !_isAnswerCorrect) {
      return Colors.red.shade300;
    }
    return Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adivinhe a Bandeira'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Consumer<GameState>(
        builder: (context, gameState, child) {
          final question = gameState.currentQuestion;

          if (question == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Pontuação: ${gameState.score}',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Tempo: ${gameState.timeRemaining}s',
                      style: const TextStyle(
                        fontSize: 18, 
                        fontWeight: FontWeight.bold,
                        color: Colors.redAccent,
                      ),
                    ),
                  ],
                ),
                const Spacer(flex: 1),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Image.asset(
                    question.correctCountry.flagAssetPath,
                    height: 200,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const SizedBox(
                        height: 200,
                        child: Center(child: Icon(Icons.broken_image, size: 64)),
                      );
                    },
                  ),
                ),
                const Spacer(flex: 2),
                ...question.options.map((country) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _getButtonColor(country, gameState),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        foregroundColor: Colors.black87,
                      ),
                      onPressed: () => _handleAnswer(country, gameState),
                      child: Text(
                        country.name,
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  );
                }),
                const Spacer(flex: 1),
              ],
            ),
          );
        },
      ),
    );
  }
}