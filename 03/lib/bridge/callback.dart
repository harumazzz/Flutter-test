// ignore_for_file: unused_import

import 'dart:ffi' as ffi;
import 'package:ffi/ffi.dart' as ffi;
import 'package:_03/bridge/input.dart';
import 'package:_03/bridge/output.dart';

typedef CallbackNative = ffi.Int32 Function(
  ffi.Pointer<Input> source,
  ffi.Pointer<Output> destination,
);

typedef Callback = int Function(
  ffi.Pointer<Input> source,
  ffi.Pointer<Output> destination,
);
