import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/country.dart';

class CountryRepository {
  List<Country> _countries = [];

  Future<void> loadCountries() async {
    final String response = await rootBundle.loadString('assets/data/countries.json');
    final List<dynamic> data = json.decode(response);
    
    _countries = data
        .map((json) => Country.fromJson(json as Map<String, dynamic>))
        .where((country) => country.code.isNotEmpty && country.name != 'Desconhecido')
        .toList();
  }

  List<Country> getCountriesByContinent(String continent) {
    if (continent == 'Aleatório') {
      return _countries;
    }
    return _countries.where((c) => c.continent == continent).toList();
  }
}