// Licensed under the Dartastic Pro Software License Agreement.
// Copyright 2025-2026 Mindful Software LLC d/b/a Dartastic.io, All rights reserved.

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
