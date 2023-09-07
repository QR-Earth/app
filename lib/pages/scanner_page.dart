import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:the_eco_club/utils/constants.dart';
import 'package:the_eco_club/widgets/scanner_overlay.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';

class ScannerPage extends StatefulWidget {
  const ScannerPage({super.key});

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  bool _isLoading = false;
  String _bottomText = "Scan Bin QR";
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
            onDetect: (capture) async {
              if (_isLoading) return;
              setState(() => _isLoading = true);
              final List<Barcode> barcodes = capture.barcodes;
              _isLoading = false;

              if (barcodes.isNotEmpty) {
                final code = barcodes.first;
                debugPrint('Barcode found! ${code.rawValue}');

                if (!_fixedScanned) {
                  if (await _checkFixedQR(code.rawValue!)) {
                    HapticFeedback.lightImpact();
                    _fixedScanned = true;
                    setState(() => _bottomText = "Scan Bottle QR");
                  } else {
                    HapticFeedback.lightImpact();
                    setState(() => _bottomText = "Invalid Bin QR");
                    await Future.delayed(const Duration(seconds: 2));
                    setState(() => _bottomText = "Scan Bin QR");
                  }
                } else {
                  final statusCode = await _checkVariableQR(code.rawValue!);
                  if (statusCode == 200) {
                    HapticFeedback.lightImpact();
                    if (!context.mounted) return;
                    context.goNamed("success");
                  } else if (statusCode == 404) {
                    HapticFeedback.lightImpact();
                    setState(() => _bottomText = "Invalid Bottle QR");
                    await Future.delayed(const Duration(seconds: 2));
                    setState(() => _bottomText = "Scan Bottle QR");
                  } else if (statusCode == 400) {
                    HapticFeedback.lightImpact();
                    setState(() => _bottomText = "Already Scanned");
                    await Future.delayed(const Duration(seconds: 2));
                    setState(() => _bottomText = "Scan Bottle QR");
                  }
                }
              }
              // for (final barcode in barcodes) {
              //   debugPrint('Barcode found! ${barcode.rawValue}');
              // }
            },
          ),
          if (!_isLoading)
            Positioned.fill(
              child: Container(
                decoration: ShapeDecoration(
                  shape: QrScannerOverlayShape(
                    borderColor: Colors.lightGreen,
                    borderRadius: 10,
                    borderLength: 20,
                    borderWidth: 5,
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
                      icon: Icon(Icons.arrow_back_ios_new_rounded),
                      color: Colors.white,
                    ),
                    Expanded(child: Container()),
                    IconButton(
                      color: Colors.white,
                      icon: ValueListenableBuilder(
                        valueListenable: _cameraController.torchState,
                        builder: (context, state, child) {
                          switch (state) {
                            case TorchState.off:
                              return const Icon(
                                Icons.flashlight_off,
                              );
                            case TorchState.on:
                              return const Icon(
                                Icons.flashlight_on,
                                color: Colors.yellow,
                              );
                          }
                        },
                      ),
                      iconSize: 32.0,
                      onPressed: () => _cameraController.toggleTorch(),
                    ),
                    const SizedBox(width: 10.0),
                    IconButton(
                      color: Colors.white,
                      icon: ValueListenableBuilder(
                        valueListenable: _cameraController.cameraFacingState,
                        builder: (context, state, child) {
                          switch (state) {
                            case CameraFacing.front:
                              return const Icon(Icons.camera_front);
                            case CameraFacing.back:
                              return const Icon(Icons.camera_rear);
                          }
                        },
                      ),
                      iconSize: 32.0,
                      onPressed: () => _cameraController.switchCamera(),
                    ),
                    const SizedBox(width: 10.0)
                  ],
                ),
                Expanded(child: Container()),
                Text(
                  _bottomText,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24.0,
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
    final response =
        await http.get(Uri.parse('$BASEURL/codes/check_fixed_id?code=$code'));
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  Future<int> _checkVariableQR(String code) async {
    final response = await http.post(
      Uri.parse('$BASEURL/codes/redeem?code_id=$code&user_id=${USER.id}'),
    );
    return response.statusCode;
  }
}
