import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrCodeReader extends StatefulWidget{
  const QrCodeReader({super.key});

  @override
  State<QrCodeReader> createState() => _QrCodeReaderState();
}

class _QrCodeReaderState extends State<QrCodeReader> {
  final MobileScannerController cameraController = MobileScannerController();
  String scannedCode =" " ;
  bool isScanning = true;
  bool isTorchOn = false;
  bool  DarkTheme=true;
  void _ShowDialog(String code){
    showDialog(
      context: context,
      builder: (_) => AlertDialog(

        backgroundColor: DarkTheme ?  Colors.black:Colors.white,
        title: const Text("Scanned Code"),
        scrollable: true,
        content: Text(scannedCode,
          style: TextStyle(
            color: DarkTheme ? Colors.white:Colors.black,
            fontSize: 30,
            fontWeight:FontWeight.bold,
          ),),
        titleTextStyle: TextStyle(
            color: Colors.deepPurple
        ),
        actions: [
          TextButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: scannedCode));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Copied to clipboard")),
              );
            },
            child: const Text("Copy"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                isScanning = true;
              });
            },
            child: const Text("Ok"),
          ),
        ],
      ),
    );
}



  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    DarkTheme = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
          title: const Text("Scan QR/Barcode",),
        backgroundColor: Colors.blue,
      ),
      body: MobileScanner(
            onDetect: (BarcodeCapture capture) {
              if (isScanning) {
                final List<Barcode> barcodes = capture.barcodes;
                for (final barcode in barcodes) {
                  final String? code = barcode.rawValue;
                  if (code != null) {
                    setState(() {
                      scannedCode = code;
                      isScanning = false;
                    });
                    _ShowDialog(scannedCode);
                    break;
                  }
                }
              }
            },
          ),

    );

  }
}
