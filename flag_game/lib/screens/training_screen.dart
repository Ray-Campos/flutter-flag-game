import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_state.dart';

class TrainingScreen extends StatelessWidget {
  const TrainingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Fetch all countries by asking for the 'Aleatório' list from the repository
    final gameState = Provider.of<GameState>(context, listen: false);
    final countries = gameState.repository.getCountriesByContinent('Aleatório');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Modo Treinamento'),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: countries.length,
        itemBuilder: (context, index) {
          final country = countries[index];
          return Card(
            elevation: 2,
            margin: const EdgeInsets.only(bottom: 16),
            child: ListTile(
              contentPadding: const EdgeInsets.all(12),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Image.asset(
                  country.flagAssetPath,
                  width: 60,
                  height: 45,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => 
                      const Icon(Icons.broken_image, size: 45),
                ),
              ),
              title: Text(
                country.name,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                country.continent,
                style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
              ),
            ),
          );
        },
      ),
    );
  }
}