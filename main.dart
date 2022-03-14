import 'dart:convert';
import 'package:encrypt/encrypt.dart';


Future<void> main() async {

 const plainText = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit';

  final key = Key.fromUtf8('01234567890123456789012345678901');

  final iv = IV.fromLength(16);

  final encrypter = Encrypter(AES(key));

  final encrypted = encrypter.encrypt(plainText, iv: iv);

  final decrypted = encrypter.decrypt(encrypted, iv: iv);

  print(decrypted); 
  print(encrypted.base64); 
}
