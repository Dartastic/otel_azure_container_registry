// Licensed under the Apache License, Version 2.0
// Copyright 2025, Mindful Software LLC, All rights reserved.

import 'package:dartastic_opentelemetry/dartastic_opentelemetry.dart';
import 'package:dartastic_opentelemetry_api/dartastic_opentelemetry_api.dart';

import 'otel_azure_container_registry_suppression.dart';

class AzureContainerRegistryResult {
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

class AzureContainerRegistryCallResult<T> {
  const AzureContainerRegistryCallResult({required this.value, this.result});
  final T value;
  final AzureContainerRegistryResult? result;
}

Future<T> tracedAzureContainerRegistry<T>({
  required String operation,
  required Future<AzureContainerRegistryCallResult<T>> Function() invoke,
  Tracer? tracer,
}) async {
  if (azureContainerRegistryInstrumentationSuppressed()) {
    final r = await invoke();
    return r.value;
  }
  final t =
      tracer ??
      OTel.tracerProvider().getTracer('otel_azure_container_registry');
  final span = t.startSpan('acr $operation', kind: SpanKind.client);
  try {
    span.setStringAttribute('azure.service', 'acr');
    final r = await invoke();
    final res = r.result;
    if (res != null) {
      if (res.subscriptionId != null) {
        span.setStringAttribute('azure.subscription.id', res.subscriptionId!);
      }
      if (res.resourceGroup != null) {
        span.setStringAttribute('azure.resource_group', res.resourceGroup!);
      }
      if (res.registry != null) {
        span.setStringAttribute('azure.acr.registry', res.registry!);
      }
      if (res.repository != null) {
        span.setStringAttribute('azure.acr.repository', res.repository!);
      }
      if (res.imageDigest != null) {
        span.setStringAttribute('container.image.id', res.imageDigest!);
      }
      if (res.imageTag != null) {
        span.setStringAttribute('container.image.tag', res.imageTag!);
      }
      if (res.imageSize != null) {
        span.setIntAttribute('container.image.size', res.imageSize!);
      }
      if (res.region != null) {
        span.setStringAttribute('cloud.region', res.region!);
      }
      if (res.statusCode != null) {
        span.setIntAttribute('http.response.status_code', res.statusCode!);
      }
      if (res.errorCode != null) {
        span.setStringAttribute('acr.error.code', res.errorCode!);
      }
      final fail =
          res.errorCode != null ||
          (res.statusCode != null && res.statusCode! >= 400);
      if (fail) {
        span.setStringAttribute(
          ErrorResource.errorType.key,
          res.errorCode ?? 'acr.error',
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
