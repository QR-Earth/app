import 'dart:io';

import 'package:loader_overlay/loader_overlay.dart';
import 'package:qr_earth/network/api_client.dart';
import 'package:qr_earth/router/router.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:flutter/services.dart';
import 'package:qr_earth/utils/colors.dart';

abstract final class BottomText {
  static const String bin = "🗑️\nScan Dustbin QR";
  static const String bottle = "🥤\nScan Bottle QR";
  static const String invalidBin = "❌\nInvalid Bin QR";
  static const String invalidBottle = "❌\nInvalid Bottle QR";
  static const String codeRedeemed = "❌\nCode is Already Redeemed";
  static const String unknownError = "❌\nUnknown Error";
}

class ScannerPage extends StatefulWidget {
  const ScannerPage({super.key});

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  bool _isLoading = false;
  String _bottomText = BottomText.bin;
  bool _binScanned = false;
  final MobileScannerController _cameraController = MobileScannerController();

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () => showAdaptiveDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text("Help"),
                    content: const Text(
                      "Scan the QR code on the dustbin first, then scan the QR code on the bottle to redeem the code.",
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text("Close"),
                      ),
                    ],
                  );
                },
              ),
              icon: const Icon(Icons.help_rounded),
            ),
          ],
          systemOverlayStyle: plainSystemUiOverlayStyle(context),
        ),
        body: Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Expanded(
                child: MobileScanner(
                  fit: BoxFit.contain,
                  controller: _cameraController,
                  onDetect: detect,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                _bottomText,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24.0,
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  String? _binCode;

  void detect(BarcodeCapture capture) async {
    if (_isLoading) return;

    final List<Barcode> barcodes = capture.barcodes;

    if (barcodes.isNotEmpty) {
      final code = barcodes.first.rawValue!;
      if (_binScanned && code == _binCode) return;

      setState(() {
        _isLoading = true;
        context.loaderOverlay.show();
      });

      debugPrint('Barcode found! $code');

      if (!_binScanned) {
        final response = await ApiClient.binInfo(binId: code);
        switch (response.statusCode) {
          case HttpStatus.ok:
            {
              HapticFeedback.lightImpact();
              _binScanned = true;
              _binCode = code;
              setState(() => _bottomText = BottomText.bottle);
            }
            break;
          default:
            {
              HapticFeedback.lightImpact();
              setState(() => _bottomText = BottomText.invalidBin);
              await Future.delayed(const Duration(seconds: 2));
              setState(() => _bottomText = BottomText.bin);
            }
            break;
        }
      } else {
        final response = await ApiClient.codeRedeem(
          code: code,
          binId: _binCode!,
        );

        switch (response.statusCode) {
          case HttpStatus.ok:
            {
              HapticFeedback.lightImpact();
              appRouter.goNamed("scanner_success");
            }
            break;
          case HttpStatus.notFound:
            {
              HapticFeedback.lightImpact();
              setState(() => _bottomText = BottomText.invalidBottle);
              await Future.delayed(const Duration(seconds: 2));
              setState(() => _bottomText = BottomText.bottle);
            }
            break;
          case HttpStatus.badRequest:
            {
              HapticFeedback.lightImpact();
              setState(() => _bottomText = BottomText.codeRedeemed);
              await Future.delayed(const Duration(seconds: 2));
              setState(() => _bottomText = BottomText.bottle);
            }
            break;
          default:
            {
              HapticFeedback.lightImpact();
              setState(() => _bottomText = BottomText.unknownError);
              await Future.delayed(const Duration(seconds: 2));
              setState(() => _bottomText = BottomText.bottle);
            }
            break;
        }
      }

      setState(() {
        _isLoading = false;
        context.loaderOverlay.hide();
      });
    }
  }
}
