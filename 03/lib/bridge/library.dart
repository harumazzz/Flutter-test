import 'dart:ffi' as ffi;
import 'package:_03/bridge/callback.dart';
import 'package:_03/bridge/output.dart';
import 'package:ffi/ffi.dart' as ffi;
import 'package:_03/bridge/executor.dart';
import 'package:_03/bridge/input.dart';
import 'package:_03/model/wrapper.dart';

class Library implements Executor {
  late ffi.DynamicLibrary _dylib;
  late Callback _callback;

  Library() {
    // Mở dylib
    _dylib = ffi.DynamicLibrary.open(
      "C:/Users/Admin/Documents/GitHub/Flutter-Test/03/external/out/build/x64-release/external.dll",
    );
    // Khởi tạo finalizer để đóng thư viện khi không cần nữa
    final finalizer = Finalizer<ffi.DynamicLibrary>((dylib) => dylib.close());
    finalizer.attach(this, _dylib);
    // Tìm hàm
    _callback = _dylib.lookup<ffi.NativeFunction<CallbackNative>>('solve').asFunction<Callback>();
  }

  void construct({
    required Wrapper<ffi.Pointer<Input>> source,
    required Wrapper<ffi.Pointer<Output>> destination,
    required double a,
    required double b,
    required double c,
  }) {
    source.value = ffi.calloc<Input>();
    destination.value = ffi.calloc<Output>();
    source.value.ref
      ..a = a
      ..b = b
      ..c = c;
  }

  void destruct({
    required Wrapper<ffi.Pointer<Input>> source,
    required Wrapper<ffi.Pointer<Output>> destination,
  }) {
    if (source.value != ffi.nullptr) {
      ffi.calloc.free(source.value);
      source.value = ffi.nullptr.cast<Input>();
    }
    if (destination.value != ffi.nullptr) {
      ffi.calloc.free(destination.value);
      destination.value = ffi.nullptr.cast<Output>();
    }
  }

  @override
  int execute({
    required double a,
    required double b,
    required double c,
    required Wrapper<double> x1,
    required Wrapper<double> x2,
  }) {
    final source = Wrapper<ffi.Pointer<Input>>(ffi.nullptr.cast<Input>());
    final destination = Wrapper<ffi.Pointer<Output>>(ffi.nullptr.cast<Output>());
    construct(
      a: a,
      b: b,
      c: c,
      source: source,
      destination: destination,
    );
    final state = _callback(source.value, destination.value);
    x1.value = destination.value.ref.x1;
    x2.value = destination.value.ref.x2;
    destruct(
      source: source,
      destination: destination,
    );
    return state;
  }
}
