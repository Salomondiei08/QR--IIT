import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:encrypt/encrypt.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

import 'authentication_servies.dart';
import 'scan_qr.dart';

class HomePage extends StatefulWidget {


  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              //Display Image
              const Image(
                  image: NetworkImage(
                      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQQyYwscUPOH_qPPe8Hp0HAbFNMx-TxRFubpg&usqp=CAU")),

              //create a textfield to enter the email of the user
              Form(
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: "Enter your email",
                        ),
                      ),
                      TextFormField(
                        controller: _passwordController,
                        decoration: const InputDecoration(
                          labelText: "Enter your password",
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              TextButton(
                onPressed: () {
                  context.read<AuthenticationService>().signIn(
                        email: _emailController.text.trim(),
                        password: _passwordController.text.trim(),
                      );

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>  ScanQR(),
                    ),
                  );
                },
                child: Text(
                  "Login",
                  style: TextStyle(color: Colors.indigo[900]),
                ),
                style: TextButton.styleFrom(
                  primary: Colors.indigo[900],
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(color: Colors.indigo),
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
