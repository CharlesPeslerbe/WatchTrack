import 'package:flutter/material.dart';
import 'episode_detail.dart';
import '../api/tvmaze_api.dart';

class ShowInfoPage extends StatefulWidget {
  final Map<String, dynamic> show;

  const ShowInfoPage({Key? key, required this.show}) : super(key: key);

  @override
  _ShowInfoPageState createState() => _ShowInfoPageState();
}

class _ShowInfoPageState extends State<ShowInfoPage> {
  late Future<List<dynamic>> _seasons;
  late Future<List<dynamic>> _episodes;
  int _selectedSeasonId = 1;

  @override
  void initState() {
    super.initState();
    _seasons = _fetchSeasons(widget.show['id']);
    _episodes = _seasons.then((seasons) {
      if (seasons.isNotEmpty) {
        _selectedSeasonId = seasons.first['id'];
        return _fetchEpisodes(_selectedSeasonId);
      } else {
        return [];
      }
    });
  }

  Future<List<dynamic>> _fetchSeasons(int showId) async {
    final api = TvMazeApi();
    return await api.getSeasons(showId);
  }

  Future<List<dynamic>> _fetchEpisodes(int seasonId) async {
    final api = TvMazeApi();
    return await api.getEpisodes(seasonId);
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = widget.show['image'] != null ? widget.show['image']['original'] : null;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.show['name']),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            imageUrl != null
                ? Image.network(
              imageUrl,
              fit: BoxFit.cover,
            )
                : SizedBox(height: 200, child: Center(child: Text('No Image Available'))),
            SizedBox(height: 16.0),
            Text(
              widget.show['name'],
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.0),
            Text(
              widget.show['summary']?.replaceAll(RegExp(r'<[^>]*>'), '') ?? 'No description available',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16.0),
            FutureBuilder<List<dynamic>>(
              future: _seasons,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Text('No seasons available');
                } else {
                  final seasons = snapshot.data!;
                  return DropdownButton<int>(
                    value: _selectedSeasonId,
                    items: seasons.map<DropdownMenuItem<int>>((season) {
                      return DropdownMenuItem<int>(
                        value: season['id'],
                        child: Text('Season ${season['number']}'),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedSeasonId = value!;
                        _episodes = _fetchEpisodes(_selectedSeasonId);
                      });
                    },
                  );
                }
              },
            ),
            SizedBox(height: 16.0),
            FutureBuilder<List<dynamic>>(
              future: _episodes,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Text('No episodes available');
                } else {
                  final episodes = snapshot.data!;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Episodes:',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      ...episodes.map((episode) => ListTile(
                        contentPadding: EdgeInsets.symmetric(vertical: 8.0),
                        title: Text(episode['name']),
                        trailing: IconButton(
                          icon: Icon(Icons.info),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EpisodeDetailPage(episodeId: episode['id']),
                              ),
                            );
                          },
                        ),
                      )),
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
