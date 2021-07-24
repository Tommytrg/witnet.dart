import 'dart:convert';
import 'package:witnet/schema.dart';

import '../output_pointer.dart';

class UtxoInfo {
  UtxoInfo({
    this.collateralMin,
    this.utxos,
  });

  int collateralMin;
  List<Utxo> utxos;

  factory UtxoInfo.fromRawJson(String str) => UtxoInfo.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UtxoInfo.fromJson(Map<String, dynamic> json) => UtxoInfo(
    collateralMin: json["collateral_min"],
    utxos: List<Utxo>.from(json["utxos"].map((x) => Utxo.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "collateral_min": collateralMin,
    "utxos": List<dynamic>.from(utxos.map((x) => x.toJson())),
  };
}

class Utxo {
  Utxo({
    this.outputPointer,
    this.timelock,
    this.utxoMature,
    this.value,
  });

  OutputPointer outputPointer;
  int timelock;
  bool utxoMature;
  int value;

  factory Utxo.fromRawJson(String str) => Utxo.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Utxo.fromJson(Map<String, dynamic> json) => Utxo(
    outputPointer: OutputPointer.fromString(json["output_pointer"]),
    timelock: json["timelock"],
    utxoMature: json["utxo_mature"],
    value: json["value"],
  );

  Input toInput() {
    return Input(outputPointer: outputPointer);
  }

  Map<String, dynamic> toJson() => {
    "output_pointer": outputPointer.jsonMap['output_pointer'],
    "timelock": timelock,
    "utxo_mature": utxoMature,
    "value": value,
  };
}