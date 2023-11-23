import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:the_eco_club/utils/constants.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  void initState() {
    super.initState();
    fetchHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text('Home Page'),
        title: const Text('History Page'),
      ),
      body: ListView.builder(
        itemCount: historyList.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Text((index + 1).toString()),
            title: Text(historyList[index].redeemed_at),
          );
        },
      ),
    );
  }

  List<UserHistory> historyList = [];

  void fetchHistory() async {
    final response = await http
        .get(Uri.parse('$BASEURL/get/user/history/?user_id=${USER.id}'));

    if (response.statusCode == 200) {
      Iterable userHistoryResponse = json.decode(response.body);
      historyList = List<UserHistory>.from(
          userHistoryResponse.map((x) => UserHistory.fromJson(x)));
      setState(() {
        historyList = historyList;
      });
    }
  }
}
