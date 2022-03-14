import 'package:encrypt/encrypt.dart';
import 'package:flutter/material.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScanQR extends StatefulWidget {
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
  String decryptedResults = "";

  final _key = encrypt.Key.fromUtf8('01234567890123456789012345678901');
  final iv = encrypt.IV.fromLength(16);
  var isOk = true;

  @override
  void reassemble() {
    super.reassemble();
    controller!.pauseCamera();
  }

  late Encrypter encrypter;

  @override
  void initState() {
    super.initState();
    encrypter = encrypt.Encrypter(encrypt.AES(_key, mode: encrypt.AESMode.ecb));
  }

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
                      isOk
                          ? decryptedResults.split('//')[2]
                          : 'Code QR incorrect',
                      style: const TextStyle(color: Colors.white, fontSize: 24),
                    )
                  : const Text(
                      'Scan your QR code',
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
        print('Decrypting data...');
        result = scanData;
        try {
          decryptedResults =
              encrypter.decrypt(Encrypted.fromBase64(scanData.code!), iv: iv);
        } catch (e) {
          print('Unexpected Error');
          isOk = false;
        }
        if (decryptedResults != "" && decryptedResults.startsWith('IIT')) {
          isOk = true;
          _addQrData(decryptedResults);
          print(decryptedResults);
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

  void _addQrData(String data) {
    List<String> attendanceData = data.split('//');

    String studentData = attendanceData[4];

    // CollectionReference attendance =
    //     FirebaseFirestore.instance.collection('attendance');
    // attendance
    //     .add({
    //       'heure': DateFormat.yMMMMEEEEd().format(DateTime.now()),
    //       'matricule': studentData,
    //       'presence': true,
    //     })
    //     .then((value) => print("User Added"))
    //     .catchError((error) {
    //       print("Failed to add user: $error");
    //       setState(() {
    //         isOk = false;
    //       });
    //     });
  }
}
