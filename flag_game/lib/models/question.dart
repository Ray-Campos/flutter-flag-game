import 'country.dart';

class Question {
  final Country correctCountry;
  final List<Country> options;

  Question({
    required this.correctCountry,
    required this.options,
  });
}