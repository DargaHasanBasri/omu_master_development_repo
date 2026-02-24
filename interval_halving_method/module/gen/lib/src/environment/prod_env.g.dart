// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prod_env.dart';

// **************************************************************************
// EnviedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// generated_from: assets/env/.prod.env
final class _ProdEnv {
  static const List<int> _enviedkey_baseUrl = <int>[
    3228288917,
    1534494121,
    1482442399,
    1584020011,
  ];

  static const List<int> _envieddata_baseUrl = <int>[
    3228288997,
    1534494171,
    1482442480,
    1584020047,
  ];

  static final String _baseUrl = String.fromCharCodes(
    List<int>.generate(
      _envieddata_baseUrl.length,
      (int i) => i,
      growable: false,
    ).map((int i) => _envieddata_baseUrl[i] ^ _enviedkey_baseUrl[i]),
  );
}
