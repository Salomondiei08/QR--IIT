import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:qr_code_scanner/qr_code_scanner.dart';

import 'main.dart';

class ScanQR extends StatefulWidget {
  const ScanQR({Key? key}) : super(key: key);

  @override
  _ScanQRState createState() => _ScanQRState();
}

class _ScanQRState extends State<ScanQR> {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

// FirebaseApp QR_IIT = Firebase.app('QR IIT');

// FirebaseFirestore firestore = FirebaseFirestore.instanceFor(app: QR_IIT);

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.

  @override
  void reassemble() {
    super.reassemble();
    controller!.pauseCamera();
  }

  var isOk = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isOk ? Colors.green : Colors.red,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: (result != null)
                  ? Text(
                      isOk ? result!.code! : 'Code QR incorrect',
                      style: const TextStyle(color: Colors.white, fontSize: 24),
                    )
                  : const Text(
                      'Scan a code',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
            ),
            Expanded(
              flex: 14,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: QRView(
                    overlay: QrScannerOverlayShape(),
                    cameraFacing: CameraFacing.back,
                    key: qrKey,
                    onQRViewCreated: _onQRViewCreated,
                  ),
                ),
              ),
            ),
            const Expanded(
              flex: 1,
              child: SizedBox(),
            )
          ],
        ),
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
        if ((result != null || result!.code != "") &&
            result!.code!.startsWith('IIT')) {
          isOk = true;
          _addQrData(result!);
          print(result!.code);
        } else {
          print('Valeur nulle');
          isOk = false;
          
          Future.delayed(const Duration(seconds: 1), () {
           resetValues();

          });
          
        }
      });
    });
  }

  void resetValues() {
    setState(() {
      result = null;
       isOk = true;
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void _addQrData(Barcode data) {
    CollectionReference attendance =
        FirebaseFirestore.instance.collection('attendance');
    attendance
        .add({
          'heure': DateFormat.yMMMMEEEEd().format(DateTime.now()),
          'name': data.code!,
          'presence': true,
        })
        .then((value) => print("User Added"))
        .catchError((error) {
          print("Failed to add user: $error");
          setState(() {
            isOk = false;
          });
        });
  }
}
