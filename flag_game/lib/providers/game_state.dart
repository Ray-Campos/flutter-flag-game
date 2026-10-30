import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../models/country.dart';
import '../models/question.dart';
import '../data/country_repository.dart';

class GameState extends ChangeNotifier {
  final CountryRepository repository;
  final Random _random = Random();
  
  List<Country> _availableCountries = [];
  Question? currentQuestion;
  
  int score = 0;
  int totalAnswered = 0;
  
  int timeRemaining = 0;
  int initialTime = 0; 
  String currentMode = ''; 
  
  Timer? _timer;
  bool isGameOver = false;

  GameState({required this.repository});

  void startGame(String continent, int durationInSeconds) {
    currentMode = continent;
    initialTime = durationInSeconds;
    _availableCountries = repository.getCountriesByContinent(continent);
    score = 0;
    totalAnswered = 0;
    timeRemaining = durationInSeconds;
    isGameOver = false;
    
    _generateNextQuestion();
    _startTimer();
    notifyListeners();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timeRemaining > 0) {
        timeRemaining--;
        notifyListeners();
      } else {
        endGame();
      }
    });
  }

  void _generateNextQuestion() {
    if (_availableCountries.isEmpty) return;

    final correctIndex = _random.nextInt(_availableCountries.length);
    final correctCountry = _availableCountries[correctIndex];

    final options = <Country>{correctCountry};
    while (options.length < 4) {
      final wrongIndex = _random.nextInt(_availableCountries.length);
      options.add(_availableCountries[wrongIndex]);
    }

    final shuffledOptions = options.toList()..shuffle(_random);

    currentQuestion = Question(
      correctCountry: correctCountry,
      options: shuffledOptions,
    );
  }

  void submitAnswer(Country selectedCountry) {
    if (isGameOver || currentQuestion == null) return;

    totalAnswered++;
    if (selectedCountry.code == currentQuestion!.correctCountry.code) {
      score++;
    }

    _generateNextQuestion();
    notifyListeners();
  }

  void endGame() {
    _timer?.cancel();
    isGameOver = true;
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}