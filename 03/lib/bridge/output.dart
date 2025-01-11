import 'dart:ffi' as ffi;

final class Output extends ffi.Struct {
  @ffi.Double()
  external double x1;

  @ffi.Double()
  external double x2;
}
