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
      appBar: AppBar(
        title: const Text('Fim de Jogo'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Resultados Finais',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 48),
              _buildStatRow('Perguntas Respondidas:', '$total'),
              const SizedBox(height: 16),
              _buildStatRow('Total de Acertos:', '$score'),
              const SizedBox(height: 16),
              _buildStatRow('Percentual de Acertos:', '$percentage%'),
              const SizedBox(height: 64),
              ElevatedButton.icon(
                icon: const Icon(Icons.home),
                label: const Text('Voltar ao Menu Principal'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                onPressed: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 18, color: Colors.black54),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}