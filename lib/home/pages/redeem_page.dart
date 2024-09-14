import 'package:flutter/material.dart';
import 'package:qr_earth/home/widgets/safe_padding.dart';
import 'package:qr_earth/utils/global.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screen_brightness/screen_brightness.dart';

class RedeemPage extends StatefulWidget {
  const RedeemPage({super.key});

  @override
  State<RedeemPage> createState() => _RedeemPageState();
}

class _RedeemPageState extends State<RedeemPage> {
  @override
  void initState() {
    super.initState();
    ScreenBrightness().setScreenBrightness(1.0);
  }

  @override
  void dispose() {
    ScreenBrightness().resetScreenBrightness();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Redeem'),
      ),
      body: SafePadding(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            const Text(
              "Get your QR code scanned by admin to redeem your points.",
              style: TextStyle(
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 30,
            ),
            Center(
              child: QrImageView(
                data: Global.user.id,
                version: QrVersions.auto,
                size: 320,
                gapless: true,
                backgroundColor: Colors.white,
                padding: const EdgeInsets.all(20),
                eyeStyle: const QrEyeStyle(
                  eyeShape: QrEyeShape.square,
                  color: Colors.black,
                ),
                dataModuleStyle: const QrDataModuleStyle(
                  dataModuleShape: QrDataModuleShape.square,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
