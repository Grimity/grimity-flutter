// Copyright © 2026 Grimity. All rights reserved.
// Licensed under the Grimity Source-Available License v1.0.
// AI/ML training and dataset use are prohibited. See LICENSE.

import 'src/run.dart';

void main() async {
  await run('dart', ['run', 'pervice_openapi']);
  await run('dart', ['format', '.']);
}
