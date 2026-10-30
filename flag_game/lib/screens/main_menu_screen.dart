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
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.public,
                  size: 100,
                  color: Colors.blueAccent,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Flag Game',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color: Colors.black87,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 48),
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Modo de Jogo',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black54),
                        ),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<String>(
                          value: _selectedContinent,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          items: _continents.map((String continent) {
                            return DropdownMenuItem<String>(
                              value: continent,
                              child: Text(continent, style: const TextStyle(fontSize: 16)),
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
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black54),
                        ),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<int>(
                          value: _selectedTime,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          items: _timeOptions.entries.map((entry) {
                            return DropdownMenuItem<int>(
                              value: entry.key,
                              child: Text(entry.value, style: const TextStyle(fontSize: 16)),
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
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 48),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white,
                      elevation: 6,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    icon: const Icon(Icons.play_arrow_rounded, size: 28),
                    label: const Text(
                      'Iniciar Jogo',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    onPressed: _startGame,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}