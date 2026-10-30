import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_state.dart';
import 'game_screen.dart';

class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({super.key});

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  String _selectedContinent = 'Aleatório';
  int _selectedTime = 60;

  final List<String> _continents = [
    'Aleatório',
    'África',
    'América',
    'Ásia',
    'Europa',
    'Oceania'
  ];

  final Map<int, String> _timeOptions = {
    30: '30 Segundos',
    60: '60 Segundos',
    180: '3 Minutos',
    300: '5 Minutos',
  };

  void _startGame() {
    final gameState = Provider.of<GameState>(context, listen: false);
    gameState.startGame(_selectedContinent, _selectedTime);

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const GameScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flag Game'),
        centerTitle: true,
        elevation: 2,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Modo de Jogo',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _selectedContinent,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Selecione a Região',
              ),
              items: _continents.map((String continent) {
                return DropdownMenuItem<String>(
                  value: continent,
                  child: Text(continent),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedContinent = newValue;
                  });
                }
              },
            ),
            const SizedBox(height: 24),
            const Text(
              'Configuração do Tempo',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<int>(
              value: _selectedTime,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Tempo de Jogo',
              ),
              items: _timeOptions.entries.map((entry) {
                return DropdownMenuItem<int>(
                  value: entry.key,
                  child: Text(entry.value),
                );
              }).toList(),
              onChanged: (int? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedTime = newValue;
                  });
                }
              },
            ),
            const SizedBox(height: 48),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                textStyle: const TextStyle(fontSize: 20),
              ),
              onPressed: _startGame,
              child: const Text('Iniciar Jogo'),
            ),
          ],
        ),
      ),
    );
  }
}