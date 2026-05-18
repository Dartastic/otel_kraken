// Licensed under the Dartastic Pro Software License Agreement.
// Copyright 2025-2026 Mindful Software LLC d/b/a Dartastic.io, All rights reserved.

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
