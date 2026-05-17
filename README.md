# otel_azure_container_registry

Dartastic OpenTelemetry bridge for Azure Container Registry.

Wraps each call in a CLIENT-kind span with vendor-specific attributes following OpenTelemetry semantic conventions where applicable.

```dart
import 'package:otel_azure_container_registry/otel_azure_container_registry.dart';

await tracedAzureContainerRegistry<void>(
  operation: 'someOp',
  invoke: () async {
    final r = await client.someOp();
    return AzureContainerRegistryCallResult(value: r, result: AzureContainerRegistryResult(statusCode: 200));
  },
);
```

Suppress instrumentation within a block:

```dart
await runWithoutAzureContainerRegistryInstrumentationAsync(() async {
  await client.someInternalSync();
});
```
