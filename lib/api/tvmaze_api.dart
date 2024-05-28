import 'dart:convert';
import 'package:http/http.dart' as http;

class TvMazeApi {
  static const String _baseUrl = 'https://api.tvmaze.com';

  Future<List<dynamic>> searchShows(String query) async {
    final response = await http.get(Uri.parse('$_baseUrl/search/shows?q=$query'));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return jsonData;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<dynamic> getShowDetails(int showId) async {
    final response = await http.get(Uri.parse('$_baseUrl/shows/$showId'));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return jsonData;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<List<dynamic>> getSeasons(int showId) async {
    final response = await http.get(Uri.parse('$_baseUrl/shows/$showId/seasons'));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return jsonData;
    } else {
      throw Exception('Failed to load seasons');
    }
  }

  Future<List<dynamic>> getEpisodes(int seasonId) async {
    final response = await http.get(Uri.parse('$_baseUrl/seasons/$seasonId/episodes'));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return jsonData;
    } else {
      throw Exception('Failed to load episodes');
    }
  }

  static String getShowImageUrl(String imagePath) {
    return imagePath;
  }

  Future<dynamic> getEpisodeDetails(int episodeId) async {
    final response = await http.get(Uri.parse('$_baseUrl/episodes/$episodeId'));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return jsonData;
    } else {
      throw Exception('Failed to load episode details');
    }
  }

}
