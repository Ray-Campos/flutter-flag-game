import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_state.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gameState = Provider.of<GameState>(context, listen: false);
    
    final total = gameState.totalAnswered;
    final score = gameState.score;
    final percentage = total > 0 ? (score / total * 100).toStringAsFixed(1) : '0.0';

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text('Fim de Jogo', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.emoji_events_rounded,
                size: 120,
                color: Colors.amber,
              ),
              const SizedBox(height: 24),
              const Text(
                'Tempo Esgotado!',
                style: TextStyle(
                  fontSize: 28, 
                  fontWeight: FontWeight.w900,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 40),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 32.0),
                  child: Column(
                    children: [
                      _buildStatRow(Icons.help_outline_rounded, 'Perguntas:', '$total', Colors.blue),
                      const Divider(height: 32),
                      _buildStatRow(Icons.check_circle_outline_rounded, 'Acertos:', '$score', Colors.green),
                      const Divider(height: 32),
                      _buildStatRow(Icons.percent_rounded, 'Precisão:', '$percentage%', Colors.orange),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 56),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.home_rounded, size: 28),
                  label: const Text(
                    'Menu Principal',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: () {
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatRow(IconData icon, String label, String value, Color iconColor) {
    return Row(
      children: [
        Icon(icon, color: iconColor, size: 28),
        const SizedBox(width: 16),
        Text(
          label,
          style: const TextStyle(fontSize: 18, color: Colors.black54, fontWeight: FontWeight.w600),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
      ],
    );
  }
}