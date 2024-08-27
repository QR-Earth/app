import 'dart:convert';

import 'package:qr_earth/models/user.dart';
import 'package:qr_earth/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({super.key});

  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  @override
  void initState() {
    super.initState();
    fetchLeaderboard();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text('Home Page'),
        title: const Text('Leaderboards'),
      ),
      body: ListView.builder(
        itemCount: leaderboardList.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(leaderboardList[index].username),
            trailing: Text(leaderboardList[index].points.toString()),
          );
        },
      ),
    );
  }

  List<LeaderboardEntry> leaderboardList = [];
  void fetchLeaderboard() async {
    final response = await http.get(Uri.parse(
        '${AppConfig.serverBaseUrl}${ApiRoutes.leaderboard}?limit=10'));

    if (response.statusCode == 200) {
      // parse the list of objects containg username and thier score
      // and display them in a listview
      Iterable leaderboardResponse = jsonDecode(response.body);
      leaderboardList = List<LeaderboardEntry>.from(
          leaderboardResponse.map((x) => LeaderboardEntry.fromJson(x)));
      setState(() {
        leaderboardList = leaderboardList;
      });
    }
  }
}
