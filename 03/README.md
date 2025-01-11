# Giải phương trình bậc 2

## Giải pháp

-   Sử dụng: [Package ffi](https://pub.dev/packages/ffi)

-   Viết một dynamic library bằng C++ để xử lý

-   Sử dụng ChatGPT để generate ra hàm giải PT bậc 2 bằng C++

## Mô tả giải pháp

-   Định nghĩa một struct bên Dart làm đầu vào và đầu ra tham chiếu với struct bên C++.

```dart
final class Input extends ffi.Struct {
  @ffi.Double()
  external double a;

  @ffi.Double()
  external double b;

  @ffi.Double()
  external double c;
}
```

```cxx
struct Input {

	double a;

	double b;

	double c;

};
```

```dart
final class Output extends ffi.Struct {
  @ffi.Double()
  external double x1;

  @ffi.Double()
  external double x2;
}
```

```cxx
struct Output {

	double x1;

	double x2;

};
```

-   Định nghĩa hàm native xuất ra symbols, với tham số trả về là int để trả về trạng thái của kết
    quả (vô nghiệm, vô số nghiệm,...):

```dart
typedef CallbackNative = ffi.Int32 Function(
  ffi.Pointer<Input> source,
  ffi.Pointer<Output> destination,
);

typedef Callback = int Function(
  ffi.Pointer<Input> source,
  ffi.Pointer<Output> destination,
);
```

```cxx
// Định nghĩa API xuất ra với Windows và các nền tảng khác
// Tài liệu: https://stackoverflow.com/questions/538134/exporting-functions-from-a-dll-with-dllexport
#if _WIN32
#define M_EXPORT_API extern "C" __declspec(dllexport)
#else
#define M_EXPORT_API extern "C" __attribute__((visibility("default")))
#endif

// Thay vì sử dụng Input* thì dùng Pointer<Input> cho đồng bộ với bên Dart

template <typename T>
using Pointer = T*;

// Phương thức được xuất ra

M_EXPORT_API
auto solve(
    Pointer<Input> input,
    Pointer<Output> output
) -> int
```

-   Định nghĩa một phương thức chạy gọi ra để sử dụng để tránh làm pollute đến các phương thức khác
    trong class

```dart
abstract class Executor {
  int execute({
    required double a,
    required double b,
    required double c,
    required Wrapper<double> x1,
    required Wrapper<double> x2,
  });
}
```

-   Định nghĩa class Library, sử dụng một Finalizer gắn với class và dylib. Khi Library bị Garbage
    collector trong Dart thu thập rác, thì dylib cũng được giải phóng theo class nhằm tránh lãng phí
    bộ nhớ. Sử dụng một biến `_callback` để tìm phương thức từ dylib và gọi ra.

```dart
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
}
```

-   Do phạm vi truy cập biến của Dart trong scope, và sẽ trả lại giá trị cũ khi ra ngoài scope nên
    định nghĩa 1 wrapper class để wrap giá trị và truyền dưới dạng tham chiếu.

```dart
// Documentation: https://stackoverflow.com/questions/18258267/is-there-a-way-to-pass-a-primitive-parameter-by-reference-in-dart
class Wrapper<T> {
  T value;
  Wrapper(this.value);
}
```

-   Định nghĩa 2 phương thức khởi tạo (construct) và tiêu hủy (destruct) để mỗi khi cần sử dụng thì
    sẽ khởi tạo một con trỏ và giải phóng con trỏ khi không cần nữa nhằm tránh rò rỉ bộ nhớ trong
    ứng dụng.

```dart
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
})
{
	if (source.value != ffi.nullptr) {
		ffi.calloc.free(source.value);
		source.value = ffi.nullptr.cast<Input>();
	}
	if (destination.value != ffi.nullptr) {
		ffi.calloc.free(destination.value);
		destination.value = ffi.nullptr.cast<Output>();
	}
}
```

-   Phương thức chạy sử dụng 2 phương thức vừa rồi và callback để gọi hàm từ C++, với việc con trỏ
    luôn được khởi tạo và tiêu hủy trước khi trả về trạng thái, chương trình an toàn về bộ nhớ.

```dart
@override
int execute({
	required double a,
	required double b,
	required double c,
	required Wrapper<double> x1,
	required Wrapper<double> x2,
})
{
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
```

-   Bên UI gọi phương thức thông qua `Library`

```dart
// Định nghĩa
late Executor _executor;

// Khi state khởi tạo (initState)
_executor = Library();

// Trong hàm "solve"

final a = double.tryParse(_aController.text) ?? 0;
final b = double.tryParse(_bController.text) ?? 0;
final c = double.tryParse(_cController.text) ?? 0;
final x1 = Wrapper<double>(0);
final x2 = Wrapper<double>(0);
final state = _executor.execute(
	a: a,
	b: b,
	c: c,
	x1: x1,
	x2: x2,
);
```

## Kết quả

![Result](/03/image/01.png)

![Result](/03/image/02.png)

## ChatGPT

![Result](/03/image/03.png)
