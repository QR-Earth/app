import 'dart:io';

import 'package:qr_earth/ui/home/widgets/safe_padding.dart';
import 'package:qr_earth/models/user.dart';
import 'package:qr_earth/network/api_client.dart';
import 'package:qr_earth/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:qr_earth/utils/global.dart';

class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({super.key});

  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  int totalUsers = 0;

  @override
  void initState() {
    super.initState();
    _fetchLeaderboard();
    _fetchTotalUsers();
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
              trailing: Text('Recycled'),
            ),
            Expanded(
              child: RefreshIndicator.adaptive(
                onRefresh: _fetchLeaderboard,
                child: ListView.builder(
                  itemCount: leaderboardList.length,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 0,
                      color: (leaderboardList[index].username ==
                              Global.user.username)
                          ? keyColor.withOpacity(0.5)
                          : null,
                      child: ListTile(
                        leading: Text('${index + 1} / $totalUsers'),
                        title: Text('@${leaderboardList[index].username}'),
                        trailing: Text(leaderboardList[index]
                            .redeemedCodeCount
                            .toString()),
                      ),
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  List<LeaderboardEntry> leaderboardList = [];
  Future<void> _fetchLeaderboard() async {
    // final response = await http.get(Uri.parse(
    //     '${AppConfig.serverBaseUrl}${ApiRoutes.leaderboard}?limit=10'));
    final response = await ApiClient.leaderboard(limit: 10);

    if (response.statusCode == HttpStatus.ok) {
      Iterable leaderboardResponse = response.data;

      leaderboardList = List<LeaderboardEntry>.from(
        leaderboardResponse.map((x) => LeaderboardEntry.fromJson(x)),
      );

      setState(() {
        leaderboardList = leaderboardList;
      });
    }
  }

  void _fetchTotalUsers() async {
    // final response = await http
    //     .get(Uri.parse('${AppConfig.serverBaseUrl}${ApiRoutes.totalUsers}'));
    final response = await ApiClient.totalUsers();

    if (response.statusCode == HttpStatus.ok) {
      totalUsers = response.data;
      setState(() {});
    }
  }
}
