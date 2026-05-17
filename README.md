# otel_kraken

Dartastic OpenTelemetry bridge for Kraken (crypto exchange).

Wraps each call in a CLIENT-kind span with vendor-specific attributes following OpenTelemetry semantic conventions where applicable.

```dart
import 'package:otel_kraken/otel_kraken.dart';

await tracedKraken<void>(
  operation: 'someOp',
  invoke: () async {
    final r = await client.someOp();
    return KrakenCallResult(value: r, result: KrakenResult(statusCode: 200));
  },
);
```

Suppress instrumentation within a block:

```dart
await runWithoutKrakenInstrumentationAsync(() async {
  await client.someInternalSync();
});
```
