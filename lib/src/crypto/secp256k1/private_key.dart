import 'dart:math' show Random;
import 'dart:typed_data' show Uint8List;

import 'public_key.dart' show WitPublicKey;
import 'signature.dart' show WitSignature;
import 'secp256k1.dart' show secp256k1, getPointByBigInt;

import '../message.dart' show Message;
import '../number_theory.dart' show inverseMulti, positiveMod;

import 'package:witnet/utils.dart' show bytesToBigInt, bigIntToBytes;

class WitPrivateKey {
  late BigInt D;
  late WitPublicKey publicKey;

  WitPrivateKey({required Uint8List bytes}) {
    BigInt bts = bytesToBigInt(bytes);
    assert(bts < secp256k1.n, 'Key Larger Than Curve Order');
    D = bts;
    final point = getPointByBigInt(D, secp256k1.p, secp256k1.a, secp256k1.G);

    publicKey = WitPublicKey(X: point[0], Y: point[1]);
  }

  Message get bytes => Message.fromBytes(bigIntToBytes(this.D));

  WitSignature signature(String hash) {
    final rs = _sign(secp256k1.n, secp256k1.p, secp256k1.a, D, secp256k1.G,
        BigInt.parse(hash, radix: 16));
    return WitSignature(rs[0], rs[1]);
  }
}

List<BigInt> _sign(BigInt n, BigInt p, BigInt a, BigInt d, List<BigInt> pointG,
    BigInt bigHash) {
  BigInt k;
  List<BigInt> R;
  var r = BigInt.zero;

  while (true) {
    k = getPrivKeyByRand(n);
    if (k < BigInt.one || k >= n - BigInt.one) continue;

    R = getPointByBigInt(k, p, a, pointG);
    r = positiveMod(R[0], n);
    if (r == BigInt.zero) continue;

    var e = bigHash;
    var s = positiveMod((e + (r * d)) * inverseMulti(k, n), n);

    if (s == BigInt.zero) continue;

    return [r, s];
  }
}

BigInt getPrivKeyByRand(BigInt n) {
  var nHex = n.toRadixString(16);
  var privteKeyList = <String>[];
  var random = Random.secure();

  for (var i = 0; i < nHex.length; i++) {
    var rand16Num =
        (random.nextInt(100) / 100 * int.parse(nHex[i], radix: 16)).round();
    privteKeyList.add(rand16Num.toRadixString(16));
  }

  var D = BigInt.parse(privteKeyList.join(''), radix: 16);
  if (D == BigInt.zero) {
    return getPrivKeyByRand(n);
  }

  return D;
}
