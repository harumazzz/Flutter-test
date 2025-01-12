# Ứng dụng AudioBook

## Thư viện sử dụng

-   [Package bubble](https://pub.dev/packages/bubble)

-   [Package audioplayers](https://pub.dev/packages/audioplayers)

## Giải pháp

-   Sử dụng ChatGPT và sửa code

## Mô tả giải pháp

-   Thay đổi thời gian bằng bộ đếm Timer. Khi khởi tạo Timer, đăng ký một đích lắng nghe sự kiện để
    trigger thay đổi assets trong StatefulWidget và gọi setState để UI được làm mới. Hàm thay đổi
    thời gian:

```dart
_timer = Timer.periodic(Duration(milliseconds: 1), (timer) {
      int currentTime = timer.tick; // Thời gian tính theo mili giây
      _changeImageBasedOnTimestamp(currentTime);
});
```

```dart
void _changeImageBasedOnTimestamp(int currentTime) {
    if (currentTime == 5337) {
      setState(() {
        _currentImage = 'assets/image/lan-say-hello-to-james.jpg'; // Hình ảnh mới
      });
    }
}
```

-   Để chơi được âm thanh, sử dụng `audioplayers`

````dart
// Documentation vì GPT gen code lỗi đoạn này : https://pub.dev/packages/audioplayers
_audioPlayer = AudioPlayer();
_audioPlayer.setReleaseMode(ReleaseMode.stop);
WidgetsBinding.instance.addPostFrameCallback((_) async {
	await _audioPlayer.setSource(AssetSource('audio/ouput.wav'));
	await _audioPlayer.resume();
});
	```

- Thông qua kết quả được ChatGPT lọc, thì thu được mảng thông tin như sau:
```dart
final List<Map<String, dynamic>> dialog = [
    {
      "speaker": "James",
      "text": "Chào Lan! Mình là James, đến từ Hoa Kỳ. Rất vui được gặp bạn.",
      "timestamp": 75,
    },
    {
      "speaker": "Lan",
      "text": "Chào James! Mình là Lan, đến từ Việt Nam. Rất vui được làm quen với bạn.",
      "timestamp": 5337
    },
    {
      "speaker": "James",
      "text": "Bạn làm nghề gì vậy, Lan?",
      "timestamp": 12262,
    },
    {
      "speaker": "Lan",
      "text": "Mình là cô giáo dạy ngoại ngữ. Còn bạn?",
      "timestamp": 14725,
    },
    {
      "speaker": "James",
      "text": "Mình là kỹ sư hàng không.",
      "timestamp": 18800,
    },
    {
      "speaker": "Lan",
      "text": "Nghe thú vị quá! Bạn đến Việt Nam lâu chưa?",
      "timestamp": 20750,
    },
    {
      "speaker": "James",
      "text": "Mình mới đến đây được vài ngày.",
      "timestamp": 24962,
    },
    {
      "speaker": "Lan",s
      "text": "Hy vọng bạn sẽ thích Việt Nam!",
      "timestamp": 26987,
    },
    {
      "speaker": "James",
      "text": "Cảm ơn Lan!",
      "timestamp": 29500,
    },
  ];
````

-   Mặc định, Text không có sự kiện onTap. Wrap nó trong một `GestureDetector` với phương thức
    onTap. Sử dụng hàm seek để đi đến timestamp mà đã lọc từ sẵn khi nhấn vào. Khi người dùng chạm
    vào dòng hội thoại nào thì sẽ bắt đầu chơi lại từ đoạn đó.

```dart
GestureDetector(
	onTap: () async {
		await _audioPlayer.seek(Duration(milliseconds: message['timestamp']));
	},
),
```

## Kết quả

![Result](/02/image/01.png)

## ChatGPT

![Result](/02/image/02.png)

![Result](/02/image/03.png)

![Result](/02/image/04.png)

![Result](/02/image/05.png)

![Result](/02/image/06.png)

```

```
