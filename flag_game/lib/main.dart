import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data/country_repository.dart';
import 'providers/game_state.dart';
import 'screens/main_menu_screen.dart';

void main() async {
  // Ensure Flutter bindings are ready before loading assets
  WidgetsFlutterBinding.ensureInitialized();
  
  final repository = CountryRepository();
  await repository.loadCountries();

  runApp(
    ChangeNotifierProvider(
      create: (context) => GameState(repository: repository),
      child: const FlagGameApp(),
    ),
  );
}

class FlagGameApp extends StatelessWidget {
  const FlagGameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flag Game',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MainMenuScreen(),
    );
  }
}