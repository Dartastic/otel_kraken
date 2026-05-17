// Licensed under the Apache License, Version 2.0
// Copyright 2025, Mindful Software LLC, All rights reserved.

import 'package:otel_kraken/otel_kraken.dart';
import 'package:test/test.dart';

void main() {
  group('otel_kraken', () {
    test('suppression toggles in zone', () async {
      expect(krakenInstrumentationSuppressed(), isFalse);
      await runWithoutKrakenInstrumentationAsync(() async {
        expect(krakenInstrumentationSuppressed(), isTrue);
      });
      expect(krakenInstrumentationSuppressed(), isFalse);
    });

    test('KrakenResult fields default null', () {
      const r = KrakenResult();
      expect(r.statusCode, isNull);
    });
  });
}
