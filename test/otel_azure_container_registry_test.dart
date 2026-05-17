// Licensed under the Apache License, Version 2.0
// Copyright 2025, Mindful Software LLC, All rights reserved.

import 'package:otel_azure_container_registry/otel_azure_container_registry.dart';
import 'package:test/test.dart';

void main() {
  group('otel_azure_container_registry', () {
    test('suppression toggles in zone', () async {
      expect(azureContainerRegistryInstrumentationSuppressed(), isFalse);
      await runWithoutAzureContainerRegistryInstrumentationAsync(() async {
        expect(azureContainerRegistryInstrumentationSuppressed(), isTrue);
      });
      expect(azureContainerRegistryInstrumentationSuppressed(), isFalse);
    });

    test('AzureContainerRegistryResult fields default null', () {
      const r = AzureContainerRegistryResult();
      expect(r.statusCode, isNull);
    });
  });
}
