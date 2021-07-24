import 'dart:convert';

import 'dart:typed_data';

class Secp256k1Signature {
  Secp256k1Signature({
    this.der,
  });
  List<int> der;
  factory Secp256k1Signature.fromRawJson(String str) => Secp256k1Signature.fromJson(json.decode(str));

  String get rawJson => json.encode(jsonMap);

  factory Secp256k1Signature.fromJson(Map<String, dynamic> json) => Secp256k1Signature(
    der: List<int>.from(json["der"].map((x) => x)),
  );

  Map<String, dynamic> get jsonMap => {
    "der": List<dynamic>.from(der.map((x) => x)),
  };
  Uint8List get pbBytes {

  }
}