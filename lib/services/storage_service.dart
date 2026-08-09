import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const _bestScoreKey = 'best_score';
  Future<int> bestScore() async => (await SharedPreferences.getInstance()).getInt(_bestScoreKey) ?? 0;
  Future<int> saveIfBest(int score) async {
    final prefs = await SharedPreferences.getInstance();
    final current = prefs.getInt(_bestScoreKey) ?? 0;
    if (score > current) await prefs.setInt(_bestScoreKey, score);
    return score > current ? score : current;
  }
}
