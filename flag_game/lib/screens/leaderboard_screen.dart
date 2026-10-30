import 'package:flutter/material.dart';
import '../services/leaderboard_service.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  final LeaderboardService _service = LeaderboardService();
  List<LeaderboardEntry> _scores = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadScores();
  }

  Future<void> _loadScores() async {
    final scores = await _service.getScores();
    setState(() {
      _scores = scores;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ranking Local'),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _scores.isEmpty
              ? const Center(
                  child: Text(
                    'Nenhuma partida registrada ainda.',
                    style: TextStyle(fontSize: 18),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _scores.length,
                  itemBuilder: (context, index) {
                    final entry = _scores[index];
                    final percentage = entry.total > 0 
                        ? ((entry.score / entry.total) * 100).toStringAsFixed(1) 
                        : '0.0';

                    return Card(
                      elevation: 2,
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.blue.shade100,
                          child: Text(
                            '#${index + 1}',
                            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                          ),
                        ),
                        title: Text('${entry.score} Acertos (${percentage}%)'),
                        subtitle: Text('Modo: ${entry.mode} | Tempo: ${entry.time}s'),
                      ),
                    );
                  },
                ),
    );
  }
}