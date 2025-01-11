import 'dart:ffi' as ffi;

final class Input extends ffi.Struct {
  @ffi.Double()
  external double a;

  @ffi.Double()
  external double b;

  @ffi.Double()
  external double c;
}
