import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LeaderboardEntry {
  final int score;
  final int total;
  final String mode;
  final int time;

  LeaderboardEntry({
    required this.score,
    required this.total,
    required this.mode,
    required this.time,
  });

  Map<String, dynamic> toJson() => {
        'score': score,
        'total': total,
        'mode': mode,
        'time': time,
      };

  factory LeaderboardEntry.fromJson(Map<String, dynamic> json) {
    return LeaderboardEntry(
      score: json['score'] as int,
      total: json['total'] as int,
      mode: json['mode'] as String,
      time: json['time'] as int,
    );
  }
}

class LeaderboardService {
  static const String _key = 'local_leaderboard';

  Future<void> saveScore(LeaderboardEntry entry) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> scoresJson = prefs.getStringList(_key) ?? [];

    final List<LeaderboardEntry> scores = scoresJson
        .map((s) => LeaderboardEntry.fromJson(json.decode(s)))
        .toList();

    scores.add(entry);

    // Sort by highest score first. If scores are equal, sort by highest total accuracy.
    scores.sort((a, b) {
      int scoreComparison = b.score.compareTo(a.score);
      if (scoreComparison != 0) return scoreComparison;
      
      double aAccuracy = a.total > 0 ? a.score / a.total : 0;
      double bAccuracy = b.total > 0 ? b.score / b.total : 0;
      return bAccuracy.compareTo(aAccuracy);
    });

    // Keep only the top 10 records
    if (scores.length > 10) {
      scores.removeRange(10, scores.length);
    }

    await prefs.setStringList(
      _key,
      scores.map((e) => json.encode(e.toJson())).toList(),
    );
  }

  Future<List<LeaderboardEntry>> getScores() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> scoresJson = prefs.getStringList(_key) ?? [];
    return scoresJson
        .map((s) => LeaderboardEntry.fromJson(json.decode(s)))
        .toList();
  }
}