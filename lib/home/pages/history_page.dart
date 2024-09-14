import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:qr_earth/home/widgets/safe_padding.dart';

import 'package:qr_earth/models/user.dart';
import 'package:qr_earth/utils/constants.dart';
import 'package:qr_earth/utils/global.dart';
import 'package:flutter/material.dart';

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
        title: const Text('Scan History'),
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
              "assets/images/asset4.png",
              height: 200,
            ),
            const SizedBox(
              height: 20,
            ),
            const ListTile(
              leading: Text(''),
              title: Text('Time'),
              trailing: Text('Points'),
            ),
            Expanded(
              child: RefreshIndicator.adaptive(
                onRefresh: fetchHistory,
                child: ListView.builder(
                  itemCount: historyList.length,
                  itemBuilder: (context, index) {
                    var timeStamp =
                        DateTime.parse(historyList[index].timestamp);
                    var amount = historyList[index].amount;

                    return ListTile(
                      leading: Text((index + 1).toString()),
                      title: Text(
                        "On ${timeStamp.day}/${timeStamp.month}/${timeStamp.year} at ${timeStamp.hour}:${timeStamp.minute}",
                      ),
                      trailing: Text(
                        amount.toString(),
                        style: TextStyle(
                            color: amount > 0 ? Colors.green : Colors.red),
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

  List<UserTransactions> historyList = [];

  Future<void> fetchHistory() async {
    final response = await http.get(Uri.parse(
        '${AppConfig.serverBaseUrl}${ApiRoutes.userTransactions}?user_id=${Global.user.id}&qunatiy=10'));

    if (response.statusCode == HttpStatus.ok) {
      Iterable userHistoryResponse = jsonDecode(response.body);
      historyList = List<UserTransactions>.from(
          userHistoryResponse.map((x) => UserTransactions.fromJson(x)));
      setState(() {
        historyList = historyList;
      });
    }
  }
}
