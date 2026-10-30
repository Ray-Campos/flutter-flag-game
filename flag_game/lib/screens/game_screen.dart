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
      return Colors.green.shade400;
    }
    if (_selectedAnswer == country && !_isAnswerCorrect) {
      return Colors.red.shade400;
    }
    return Colors.white;
  }

  Color _getTextColor(Country country, GameState gameState) {
    if (_selectedAnswer == null) return Colors.black87;
    
    final isThisCorrectAnswer = country.code == gameState.currentQuestion!.correctCountry.code;
    if (isThisCorrectAnswer || _selectedAnswer == country) {
      return Colors.white; // White text on colored background
    }
    return Colors.black87;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Qual é o País?', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Consumer<GameState>(
        builder: (context, gameState, child) {
          final question = gameState.currentQuestion;

          if (question == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Score and Timer Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade100,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.star_rounded, color: Colors.orange, size: 24),
                          const SizedBox(width: 8),
                          Text(
                            '${gameState.score}',
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: gameState.timeRemaining <= 10 ? Colors.red.shade100 : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.timer_rounded, 
                            color: gameState.timeRemaining <= 10 ? Colors.red : Colors.black54, 
                            size: 24
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${gameState.timeRemaining}s',
                            style: TextStyle(
                              fontSize: 18, 
                              fontWeight: FontWeight.bold,
                              color: gameState.timeRemaining <= 10 ? Colors.red : Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                
                const Spacer(flex: 1),
                
                // Flag Image scaled to original ratio
                Center(
                  child: Card(
                    elevation: 10,
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(color: Colors.grey.shade300, width: 1),
                    ),
                    child: Image.asset(
                      question.correctCountry.flagAssetPath,
                      height: 200,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const SizedBox(
                          height: 200,
                          width: 300,
                          child: Center(child: Icon(Icons.broken_image, size: 64, color: Colors.grey)),
                        );
                      },
                    ),
                  ),
                ),
                
                const Spacer(flex: 2),
                
                // Options
                ...question.options.map((country) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _getButtonColor(country, gameState),
                        foregroundColor: _getTextColor(country, gameState),
                        elevation: 2,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: () => _handleAnswer(country, gameState),
                      child: Text(
                        country.name,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                        textAlign: TextAlign.center,
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