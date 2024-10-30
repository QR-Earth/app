import 'dart:io';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:qr_earth/ui/home/widgets/safe_padding.dart';
import 'package:qr_earth/models/user.dart';
import 'package:qr_earth/network/api_client.dart';
import 'package:flutter/material.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  static const _pageSize = 10;
  final PagingController<int, UserTransactions> _pagingController =
      PagingController(firstPageKey: 1);

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener((pageKey) {
      _fetchHistory(pageKey);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text('Home Page'),
        title: const Text('Transactions History'),
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
              child: PagedListView<int, UserTransactions>(
                pagingController: _pagingController,
                builderDelegate: PagedChildBuilderDelegate<UserTransactions>(
                  itemBuilder: (context, item, index) => ListTile(
                    leading: Text((index + 1).toString()),
                    title: Text(
                      "On ${item.timeStamp.day}/${item.timeStamp.month}/${item.timeStamp.year} at ${item.timeStamp.hour}:${item.timeStamp.minute}",
                    ),
                    trailing: Text(
                      item.amount.toString(),
                      style: TextStyle(
                        color: item.amount > 0 ? Colors.green : Colors.red,
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _fetchHistory(final int pageKey) async {
    final response = await ApiClient.userTransactions(
      page: pageKey,
      size: _pageSize,
    );

    if (response.statusCode == HttpStatus.ok) {
      Iterable leaderboardResponse = response.data["items"];
      int page = response.data["page"];
      int totalPages = response.data["pages"];

      List<UserTransactions> transactionsList = List<UserTransactions>.from(
        leaderboardResponse.map((x) => UserTransactions.fromJson(x)),
      );

      final isLastPage = page == totalPages;
      if (isLastPage) {
        _pagingController.appendLastPage(transactionsList);
      } else {
        final nextPageKey = page + 1;
        _pagingController.appendPage(transactionsList, nextPageKey);
      }
    }
  }
}
