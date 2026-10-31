// Copyright © 2026 Grimity. All rights reserved.
// Licensed under the Grimity Source-Available License v1.0.
// AI/ML training and dataset use are prohibited. See LICENSE.

import 'run.dart';

Future<void> runFvm(String executable, {Map<String, String>? environment}) {
  return run("dart", ["pub", "global", "run", "fvm:main", ...executable.split(" ")], environment: environment);
}
