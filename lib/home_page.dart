import 'package:flutter/material.dart';

import 'generate_qr.dart';
import 'scan_qr.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SizedBox(
      width: 500,
      height: 500,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          //Display Image
          const Image(
              image: NetworkImage(
                  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQQyYwscUPOH_qPPe8Hp0HAbFNMx-TxRFubpg&usqp=CAU")),

          //First Button
          FlatButton(
            padding: const EdgeInsets.all(15),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const ScanQR(),
                ),
              );
            },
            child: Text(
              "Scan QR Code",
              style: TextStyle(color: Colors.indigo[900]),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(color: Colors.indigo[900]!),
            ),
          ),
          const SizedBox(height: 10),

          //Second Button
          FlatButton(
            padding: const EdgeInsets.all(15),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => GenerateQR(),
                ),
              );
            },
            child: Text(
              "Generate QR Code",
              style: TextStyle(color: Colors.indigo[900]),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(color: Colors.indigo[900]!),
            ),
          ),
        ],
      ),
    ));
  }
}
