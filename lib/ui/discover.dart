import 'package:flutter/material.dart';
import '../api/tvmaze_api.dart';
import 'show_info.dart';

class DiscoverPage extends StatefulWidget {
  final String title;

  const DiscoverPage({Key? key, required this.title}) : super(key: key);

  @override
  _DiscoverPageState createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  List<dynamic> _popularShows = [];

  @override
  void initState() {
    super.initState();
    _fetchPopularShows();
  }

  Future<void> _fetchPopularShows() async {
    final api = TvMazeApi();
    final response = await api.searchShows('popular');
    setState(() {
      _popularShows = response;
    });
  }

  Future<void> _refreshPopularShows() async {
    await _fetchPopularShows();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Discover'),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: _refreshPopularShows,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.builder(
            itemCount: _popularShows.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7,
              mainAxisSpacing: 8.0,
              crossAxisSpacing: 8.0,
            ),
            itemBuilder: (BuildContext context, int index) {
              final show = _popularShows[index]['show'];
              final imageUrl = show['image'] != null ? show['image']['medium'] : null;
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ShowInfoPage(show: show),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(8.0)),
                          child: imageUrl != null
                              ? Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                              print('Erreur lors du chargement de $imageUrl: $exception');
                              return Center(
                                child: Text(
                                  'Erreur lors du chargement de l\'image',
                                  style: TextStyle(color: Colors.black),
                                ),
                              );
                            },
                          )
                              : Center(
                            child: Text(
                              'Pas d\'image disponible',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          show['name'],
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
