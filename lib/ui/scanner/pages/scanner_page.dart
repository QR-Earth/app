import 'dart:io';

import 'package:qr_earth/network/api_client.dart';
import 'package:qr_earth/router/router.dart';
import 'package:qr_earth/ui/scanner/widgets/scanner_overlay.dart';
import 'package:qr_earth/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:flutter/services.dart';

class ScannerPage extends StatefulWidget {
  const ScannerPage({super.key});

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  bool _isLoading = false;
  String _bottomText = "🗑️\nScan Dustbin QR";
  bool _fixedScanned = false;
  final MobileScannerController _cameraController = MobileScannerController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          MobileScanner(
            fit: BoxFit.cover,
            controller: _cameraController,
            onDetect: detect,
          ),
          if (!_isLoading)
            Positioned.fill(
              child: Container(
                decoration: ShapeDecoration(
                  shape: QrScannerOverlayShape(
                    borderColor: keyColor,
                    borderRadius: 10,
                    borderLength: 10,
                    borderWidth: 20,
                    overlayColor: Colors.black.withOpacity(0.75),
                    // cutOutSize: 300,
                  ),
                ),
              ),
            ),
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 20.0),
                Row(
                  children: [
                    const SizedBox(width: 10.0),
                    IconButton(
                      onPressed: () => context.goNamed("home"),
                      icon: const Icon(Icons.arrow_back_ios_new_rounded),
                      color: Colors.white,
                    ),
                    Expanded(child: Container()),
                    IconButton(
                      onPressed: () =>
                          ScaffoldMessenger.of(context).showMaterialBanner(
                        MaterialBanner(
                          content: const Text(
                              "Scan the QR code on the dustbin to start recycling"),
                          actions: [
                            TextButton(
                              onPressed: () => ScaffoldMessenger.of(context)
                                  .hideCurrentMaterialBanner(),
                              child: const Text("Got it"),
                            ),
                          ],
                        ),
                      ),
                      icon: const Icon(Icons.help_rounded),
                      color: Colors.white,
                    ),
                    const SizedBox(width: 10.0),
                  ],
                ),
                Expanded(child: Container()),
                Card(
                  color: Colors.black.withOpacity(0.5),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      _bottomText,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24.0,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 50.0),
              ],
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.75),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }

  String? _fixedCode;

  void detect(BarcodeCapture capture) async {
    if (_isLoading) return;

    final List<Barcode> barcodes = capture.barcodes;

    if (barcodes.isNotEmpty) {
      final code = barcodes.first.rawValue!;
      if (_fixedScanned && code == _fixedCode) return;

      setState(() => _isLoading = true);
      debugPrint('Barcode found! $code');

      if (!_fixedScanned) {
        final response = await ApiClient.codeCheckFixed(fixedCodeId: code);
        switch (response.statusCode) {
          case HttpStatus.ok:
            HapticFeedback.lightImpact();
            _fixedScanned = true;
            _fixedCode = code;
            setState(() => _bottomText = "🥤\nScan Bottle QR");
            break;
          default:
            HapticFeedback.lightImpact();
            setState(() => _bottomText = "❌\nInvalid Bin QR");
            await Future.delayed(const Duration(seconds: 2));
            setState(() => _bottomText = "🗑️\nScan Bin QR");
            break;
        }
      } else {
        final response = await ApiClient.codeRedeem(code: code);

        switch (response.statusCode) {
          case HttpStatus.ok:
            HapticFeedback.lightImpact();
            appRouter.goNamed("scanner_success");
            break;
          case HttpStatus.notFound:
            HapticFeedback.lightImpact();
            setState(() => _bottomText = "❌\nInvalid Bottle QR");
            await Future.delayed(const Duration(seconds: 2));
            setState(() => _bottomText = "🥤\nScan Bottle QR");
            break;
          case HttpStatus.badRequest:
            HapticFeedback.lightImpact();
            setState(() => _bottomText = "❌\nCode is Already Redeemed");
            await Future.delayed(const Duration(seconds: 2));
            setState(() => _bottomText = "🥤\nScan Bottle QR");
            break;
          default:
            HapticFeedback.lightImpact();
            setState(() => _bottomText = "❌\nUnknown Error");
            await Future.delayed(const Duration(seconds: 2));
            setState(() => _bottomText = "🥤\nScan Bottle QR");
            break;
        }
      }

      setState(() {
        _isLoading = false;
      });
    }
  }
}
