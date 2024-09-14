import 'dart:convert';
import 'dart:io';

import 'package:qr_earth/scanner/widgets/scanner_overlay.dart';
import 'package:qr_earth/utils/colors.dart';
import 'package:qr_earth/utils/constants.dart';
import 'package:qr_earth/utils/global.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import 'package:http/http.dart' as http;
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

  Future<bool> _checkFixedQR(String code) async {
    final response = await http.get(Uri.parse(
        '${AppConfig.serverBaseUrl}${ApiRoutes.codeCheckFixed}?fixed_code_id=$code'));
    if (response.statusCode == HttpStatus.ok) {
      return true;
    }
    return false;
  }

  Future<http.Response> _checkVariableQR(String code) async {
    final response = await http.post(
      Uri.parse('${AppConfig.serverBaseUrl}${ApiRoutes.codeRedeem}'),
      headers: {
        'accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'code_id': code,
        'user_id': Global.user.id,
      }),
    );
    return response;
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
        if (await _checkFixedQR(code)) {
          HapticFeedback.lightImpact();
          _fixedScanned = true;
          _fixedCode = code;
          setState(() => _bottomText = "🥤\nScan Bottle QR");
        } else {
          HapticFeedback.lightImpact();
          setState(() => _bottomText = "❌\nInvalid Bin QR");
          await Future.delayed(const Duration(seconds: 2));
          setState(() => _bottomText = "🗑️\nScan Bin QR");
        }
      } else {
        final response = await _checkVariableQR(code);
        if (response.statusCode == HttpStatus.ok) {
          HapticFeedback.lightImpact();
          if (!context.mounted) return;
          context.goNamed("scanner_success");
        } else if (response.statusCode == HttpStatus.notFound) {
          HapticFeedback.lightImpact();
          setState(() => _bottomText = "❌\nInvalid Bottle QR");
          await Future.delayed(const Duration(seconds: 2));
          setState(() => _bottomText = "🥤\nScan Bottle QR");
        } else if (response.statusCode == HttpStatus.badRequest) {
          HapticFeedback.lightImpact();
          setState(() => _bottomText = "❌\nAlready Redeemed");
          await Future.delayed(const Duration(seconds: 2));
          setState(() => _bottomText = "🥤\nScan Bottle QR");
        }
      }

      setState(() {
        _isLoading = false;
      });
    }
  }
}
