import 'dart:convert';
import 'package:http/http.dart' as http;

class TvMazeApi {
  static const String _baseUrl = 'https://api.tvmaze.com';
  static const String _searchEndpoint = '/search/shows';
  static const String _showEndpoint = '/shows';
  static const String _imageBaseUrl = 'https://static.tvmaze.com/uploads/images';

  Future<dynamic> searchShows(String query) async {
    final response = await http.get(Uri.parse('$_baseUrl$_searchEndpoint?q=$query'));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return jsonData;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<dynamic> getShowDetails(int showId) async {
    final response = await http.get(Uri.parse('$_baseUrl$_showEndpoint/$showId'));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return jsonData;
    } else {
      throw Exception('Failed to load data');
    }
  }

  static String getShowImageUrl(String imagePath) {
    return imagePath;
  }

}
