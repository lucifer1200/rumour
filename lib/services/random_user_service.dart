import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:rumour/models/random_user.dart';

class RandomUserService {
  static const String _baseUrl = 'https://randomuser.me/api';
  static const Duration _cacheDuration = Duration(hours: 1);

  static RandomUserResult? _cachedResult;
  static DateTime? _cacheTime;

  /// Fetches a random user from the API (cached for 1 hour)
  Future<RandomUserResult> fetchRandomUser() async {
    // Return cached result if available and not expired
    if (_cachedResult != null && _cacheTime != null) {
      final age = DateTime.now().difference(_cacheTime!);
      if (age < _cacheDuration) {
        return _cachedResult!;
      }
    }

    try {
      final response = await http.get(Uri.parse('$_baseUrl/?seed=rumour')).timeout(
        const Duration(seconds: 10),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        final randomUserResponse = RandomUserResponse.fromJson(json);
        final result = randomUserResponse.results.first;

        // Cache the result
        _cachedResult = result;
        _cacheTime = DateTime.now();

        return result;
      } else {
        throw Exception('Failed to fetch random user: ${response.statusCode}');
      }
    } on SocketException {
      // Return cached result if offline, or use fallback
      if (_cachedResult != null) {
        return _cachedResult!;
      }
      return _getFallbackUser();
    } catch (e) {
      // Return cached result or fallback on error
      if (_cachedResult != null) {
        return _cachedResult!;
      }
      return _getFallbackUser();
    }
  }

  /// Fallback user when API is unavailable
  RandomUserResult _getFallbackUser() {
    return RandomUserResult(
      firstName: 'Anonymous',
      lastName: 'User',
      picture: 'https://i.pravatar.cc/150?img=${DateTime.now().millisecondsSinceEpoch % 70}',
    );
  }

  /// Clears the cache
  void clearCache() {
    _cachedResult = null;
    _cacheTime = null;
  }
}
