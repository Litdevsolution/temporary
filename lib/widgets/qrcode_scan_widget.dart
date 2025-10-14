import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRCodeScanner extends StatelessWidget {
  final MobileScannerController? controller;
  final Function(BarcodeCapture) onDetect;
  final bool isCameraGranted;

  const QRCodeScanner({
    super.key,
    required this.controller,
    required this.onDetect,
    required this.isCameraGranted,
  });

  @override
  Widget build(BuildContext context) {
    if (!isCameraGranted) {
      return Container(
        height: MediaQuery.of(context).size.width,
        alignment: Alignment.center,
        child: const Text(
          'ກຳລັງຂໍສິດໃຊ້ກ້ອງ...',
          style: TextStyle(fontSize: 18),
        ),
      );
    }

    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.width,
      child: MobileScanner(controller: controller, onDetect: onDetect),
    );
  }
}