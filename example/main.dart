// Licensed under the Apache License, Version 2.0
// Copyright 2025-2026 Mindful Software LLC d/b/a Dartastic.io, All rights reserved.

import 'package:dartastic_opentelemetry/dartastic_opentelemetry.dart';
import 'package:otel_azure_container_registry/otel_azure_container_registry.dart';

/// Traces Azure Container Registry calls with OpenTelemetry.
///
/// `otel_azure_container_registry` depends on the OpenTelemetry API only, so the application
/// initializes an SDK once at startup. Wrap each Azure Container Registry call in
/// [tracedAzureContainerRegistry]; the `invoke` callback makes the real call and reports what
/// came back, which is recorded on the span.
Future<void> main() async {
  await OTel.initialize(serviceName: 'azure-container-registry-example');

  // Traces a Azure Container Registry call.
  final azureContainerRegistryId = await tracedAzureContainerRegistry<String>(
    operation: 'create',
    invoke: () async {
      // Make the Azure Container Registry call here, then report what it returned.
      const id = 'azure_container_registry_8f3a2c';
      return const AzureContainerRegistryCallResult(
          value: id,
          result: AzureContainerRegistryResult(
              subscriptionId: 'subscription_8f3a2c',
              resourceGroup: 'Order',
              registry: 'example',
              repository: 'example',
              imageDigest: 'example',
              imageTag: 'example',
              imageSize: 512,
              region: 'us-east-1',
              statusCode: 201,
              errorCode: 'example',
              errorMessage: 'example'));
    },
  );
  OTelLog.info(
      'tracedAzureContainerRegistry create returned $azureContainerRegistryId');

  // Calls that should not be traced, such as health checks, run inside
  // runWithoutAzureContainerRegistryInstrumentationAsync.
  await runWithoutAzureContainerRegistryInstrumentationAsync(
    () => tracedAzureContainerRegistry<String>(
      operation: 'create',
      invoke: () async {
        const id = 'azure_container_registry_8f3a2c';
        return const AzureContainerRegistryCallResult(
            value: id,
            result: AzureContainerRegistryResult(
                subscriptionId: 'subscription_8f3a2c',
                resourceGroup: 'Order',
                registry: 'example',
                repository: 'example',
                imageDigest: 'example',
                imageTag: 'example',
                imageSize: 512,
                region: 'us-east-1',
                statusCode: 201,
                errorCode: 'example',
                errorMessage: 'example'));
      },
    ),
  );

  await OTel.shutdown();
}
