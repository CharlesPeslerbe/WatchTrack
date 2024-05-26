import 'package:flutter/material.dart';

class WatchlistPage extends StatelessWidget {
  final String title;

  const WatchlistPage({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Page 2'),
    );
  }
}