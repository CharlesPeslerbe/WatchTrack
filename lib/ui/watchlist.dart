import 'package:flutter/material.dart';
import '../api/tvmaze_api.dart';
import '../storage/storage_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WatchlistPage extends StatefulWidget {
  final String title;

  const WatchlistPage({Key? key, required this.title}) : super(key: key);

  @override
  _WatchlistPageState createState() => _WatchlistPageState();
}

class _WatchlistPageState extends State<WatchlistPage> {
  late Future<Map<String, dynamic>> _watchlistData;
  final FirebaseStorageService _storageService = FirebaseStorageService();
  final TvMazeApi _api = TvMazeApi();

  @override
  void initState() {
    super.initState();
    _fetchAndSetWatchlistData();
  }

  void _fetchAndSetWatchlistData() {
    setState(() {
      _watchlistData = _fetchWatchlistData();
    });
  }

  Future<Map<String, dynamic>> _fetchWatchlistData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }

    final filePath = '${user.uid}/episodes.json';
    Map<String, dynamic> data;

    try {
      data = await _storageService.downloadJson(filePath);
    } catch (e) {
      // Return an empty map if the file doesn't exist or cannot be fetched
      data = {};
    }

    if (data.isEmpty || data['shows'] == null || data['shows'].isEmpty) {
      return {};
    }

    final Map<String, dynamic> watchlistData = {};
    for (var show in data['shows']) {
      final watchedEpisodes = show['watchedEpisodes'];
      final lastWatchedEpisode = watchedEpisodes.reduce((curr, next) {
        if (curr['season'] > next['season'] ||
            (curr['season'] == next['season'] && curr['number'] > next['number'])) {
          return curr;
        }
        return next;
      });

      try {
        final nextEpisode = await _api.getNextEpisode(show['id'], lastWatchedEpisode['season'], lastWatchedEpisode['number']);
        watchlistData[show['name']] = nextEpisode;
      } catch (e) {
        watchlistData[show['name']] = null;
      }
    }

    return watchlistData;
  }

  Future<void> _refreshData() async {
    _fetchAndSetWatchlistData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: FutureBuilder<Map<String, dynamic>>(
          future: _watchlistData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No data available. Please mark some episodes as watched.'));
            } else {
              final watchlistData = snapshot.data!;
              return ListView.builder(
                itemCount: watchlistData.length,
                itemBuilder: (context, index) {
                  final showName = watchlistData.keys.elementAt(index);
                  final nextEpisode = watchlistData[showName];
                  return ListTile(
                    title: Text(showName),
                    subtitle: nextEpisode != null
                        ? Text('Season ${nextEpisode['season']} Episode ${nextEpisode['number']} - ${nextEpisode['name']}')
                        : Text('No next episode available'),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
