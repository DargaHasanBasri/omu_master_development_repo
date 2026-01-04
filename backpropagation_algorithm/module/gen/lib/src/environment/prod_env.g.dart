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
    3347783553,
    584097313,
    1034719592,
    3302055087,
  ];

  static const List<int> _envieddata_baseUrl = <int>[
    3347783665,
    584097363,
    1034719495,
    3302055115,
  ];

  static final String _baseUrl = String.fromCharCodes(
    List<int>.generate(
      _envieddata_baseUrl.length,
      (int i) => i,
      growable: false,
    ).map((int i) => _envieddata_baseUrl[i] ^ _enviedkey_baseUrl[i]),
  );
}
