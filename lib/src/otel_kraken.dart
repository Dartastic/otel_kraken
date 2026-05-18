// Licensed under the Dartastic Pro Software License Agreement.
// Copyright 2025-2026 Mindful Software LLC d/b/a Dartastic.io, All rights reserved.

import 'package:dartastic_opentelemetry/dartastic_opentelemetry.dart';
import 'package:dartastic_opentelemetry_api/dartastic_opentelemetry_api.dart';

import 'otel_kraken_suppression.dart';

class KrakenResult {
  const KrakenResult({
    this.pair,
    this.side,
    this.orderType,
    this.orderId,
    this.amount,
    this.price,
    this.fee,
    this.status,
    this.statusCode,
    this.errorCode,
    this.errorMessage,
  });

  final String? pair;
  final String? side;
  final String? orderType;
  final String? orderId;
  final double? amount;
  final double? price;
  final double? fee;
  final String? status;
  final int? statusCode;
  final String? errorCode;
  final String? errorMessage;
}

class KrakenCallResult<T> {
  const KrakenCallResult({required this.value, this.result});
  final T value;
  final KrakenResult? result;
}

Future<T> tracedKraken<T>({
  required String operation,
  required Future<KrakenCallResult<T>> Function() invoke,
  Tracer? tracer,
}) async {
  if (krakenInstrumentationSuppressed()) {
    final r = await invoke();
    return r.value;
  }
  final t = tracer ?? OTel.tracerProvider().getTracer('otel_kraken');
  final span = t.startSpan('kraken $operation', kind: SpanKind.client);
  try {
    span.setStringAttribute('rpc.system', 'kraken');
    final r = await invoke();
    final res = r.result;
    if (res != null) {
      if (res.pair != null) {
        span.setStringAttribute('kraken.pair', res.pair!);
      }
      if (res.side != null) {
        span.setStringAttribute('kraken.side', res.side!);
      }
      if (res.orderType != null) {
        span.setStringAttribute('kraken.order.type', res.orderType!);
      }
      if (res.orderId != null) {
        span.setStringAttribute('kraken.order.id', res.orderId!);
      }
      if (res.amount != null) {
        span.setDoubleAttribute('kraken.amount', res.amount!);
      }
      if (res.price != null) {
        span.setDoubleAttribute('kraken.price', res.price!);
      }
      if (res.fee != null) {
        span.setDoubleAttribute('kraken.fee', res.fee!);
      }
      if (res.status != null) {
        span.setStringAttribute('kraken.status', res.status!);
      }
      if (res.statusCode != null) {
        span.setIntAttribute('http.response.status_code', res.statusCode!);
      }
      if (res.errorCode != null) {
        span.setStringAttribute('kraken.error.code', res.errorCode!);
      }
      final fail =
          res.errorCode != null ||
          (res.statusCode != null && res.statusCode! >= 400);
      if (fail) {
        span.setStringAttribute(
          ErrorResource.errorType.key,
          res.errorCode ?? 'kraken.error',
        );
        span.setStatus(SpanStatusCode.Error, res.errorMessage);
      }
    }
    return r.value;
  } catch (e, st) {
    span.recordException(e, stackTrace: st);
    span.setStatus(SpanStatusCode.Error, e.toString());
    rethrow;
  } finally {
    span.end();
  }
}
