import 'dart:convert';

import 'package:qr_earth/home/widgets/safe_padding.dart';
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
        forceMaterialTransparency: true,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SafePadding(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 20,
            ),
            Image.asset(
              "assets/images/asset3.png",
              height: 200,
            ),
            const SizedBox(
              height: 20,
            ),
            const ListTile(
              leading: Text('Rank'),
              title: Text('Username'),
              trailing: Text('Points'),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: leaderboardList.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      leading: Text((index + 1).toString()),
                      title: Text(leaderboardList[index].username),
                      trailing: Text(leaderboardList[index].points.toString()),
                    ),
                  );
                },
              ),
            )
          ],
        ),
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
