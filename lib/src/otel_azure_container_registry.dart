// Licensed under the Apache License, Version 2.0
// Copyright 2025-2026 Mindful Software LLC d/b/a Dartastic.io, All rights reserved.

import 'package:dartastic_opentelemetry_api/dartastic_opentelemetry_api.dart';

import 'otel_azure_container_registry_suppression.dart';

class AzureContainerRegistryResult {
  /// Creates a result.
  const AzureContainerRegistryResult({
    this.subscriptionId,
    this.resourceGroup,
    this.registry,
    this.repository,
    this.imageDigest,
    this.imageTag,
    this.imageSize,
    this.region,
    this.statusCode,
    this.errorCode,
    this.errorMessage,
  });

  final String? subscriptionId;
  final String? resourceGroup;
  final String? registry;
  final String? repository;
  final String? imageDigest;
  final String? imageTag;
  final int? imageSize;
  final String? region;
  final int? statusCode;
  final String? errorCode;
  final String? errorMessage;
}

/// What a traced call returned: the value for the caller plus fields
/// recorded on the span.
class AzureContainerRegistryCallResult<T> {
  /// Creates a call result.
  const AzureContainerRegistryCallResult({required this.value, this.result});

  /// The value returned to the caller.
  final T value;
  final AzureContainerRegistryResult? result;
}

Future<T> tracedAzureContainerRegistry<T>({
  required String operation,
  required Future<AzureContainerRegistryCallResult<T>> Function() invoke,
  APITracer? tracer,
}) async {
  if (azureContainerRegistryInstrumentationSuppressed()) {
    final r = await invoke();
    return r.value;
  }
  final t = tracer ??
      OTelAPI.tracerProvider().getTracer('otel_azure_container_registry');
  final span = t.startSpan('acr $operation', kind: SpanKind.client);
  try {
    span.addAttributes(
        OTelAPI.attributes([OTelAPI.attributeString('azure.service', 'acr')]));
    final r = await invoke();
    final res = r.result;
    if (res != null) {
      if (res.subscriptionId != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeString('azure.subscription.id', res.subscriptionId!)
        ]));
      }
      if (res.resourceGroup != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeString('azure.resource_group', res.resourceGroup!)
        ]));
      }
      if (res.registry != null) {
        span.addAttributes(OTelAPI.attributes(
            [OTelAPI.attributeString('azure.acr.registry', res.registry!)]));
      }
      if (res.repository != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeString('azure.acr.repository', res.repository!)
        ]));
      }
      if (res.imageDigest != null) {
        span.addAttributes(OTelAPI.attributes(
            [OTelAPI.attributeString('container.image.id', res.imageDigest!)]));
      }
      if (res.imageTag != null) {
        span.addAttributes(OTelAPI.attributes(
            [OTelAPI.attributeString('container.image.tag', res.imageTag!)]));
      }
      if (res.imageSize != null) {
        span.addAttributes(OTelAPI.attributes(
            [OTelAPI.attributeInt('container.image.size', res.imageSize!)]));
      }
      if (res.region != null) {
        span.addAttributes(OTelAPI.attributes(
            [OTelAPI.attributeString('cloud.region', res.region!)]));
      }
      if (res.statusCode != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeInt('http.response.status_code', res.statusCode!)
        ]));
      }
      if (res.errorCode != null) {
        span.addAttributes(OTelAPI.attributes(
            [OTelAPI.attributeString('acr.error.code', res.errorCode!)]));
      }
      final fail = res.errorCode != null ||
          (res.statusCode != null && res.statusCode! >= 400);
      if (fail) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeString(
            ErrorAttributes.errorType.key,
            res.errorCode ?? 'acr.error',
          )
        ]));
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
