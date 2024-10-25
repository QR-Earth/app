import 'package:qr_earth/app.dart';
import 'package:qr_earth/network/api_client.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ApiClient.init();
  runApp(const App());
}
