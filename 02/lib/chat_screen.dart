import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'dart:async'; // Thư viện Timer

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late Timer _timer;
  String _currentImage = 'assets/image/james-say-hello-to-lan.jpg'; // Hình ảnh mặc định

  late AudioPlayer _audioPlayer;

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
      "speaker": "Lan",
      "text": "Hy vọng bạn sẽ thích Việt Nam!",
      "timestamp": 26987,
    },
    {
      "speaker": "James",
      "text": "Cảm ơn Lan!",
      "timestamp": 29500,
    },
  ];

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _audioPlayer.setReleaseMode(ReleaseMode.stop);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _audioPlayer.setSource(AssetSource('audio/ouput.wav'));
      await _audioPlayer.resume();
    });
    // Khởi tạo Timer để thay đổi hình ảnh theo thời gian
    _timer = Timer.periodic(Duration(milliseconds: 1), (timer) {
      int currentTime = timer.tick; // Thời gian tính theo giây
      _changeImageBasedOnTimestamp(currentTime);
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // Dừng timer khi không sử dụng
    super.dispose();
  }

  // Hàm thay đổi hình ảnh dựa trên timestamp
  void _changeImageBasedOnTimestamp(int currentTime) {
    if (currentTime == 5337) {
      setState(() {
        _currentImage = 'assets/image/lan-say-hello-to-james.jpg'; // Hình ảnh mới
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat Demo"),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            child: Image.asset(
              _currentImage, // Sử dụng hình ảnh hiện tại
              width: 400,
              height: 400,
            ),
          ),
          Divider(),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(10),
              itemCount: dialog.length,
              itemBuilder: (context, index) {
                final message = dialog[index];
                final isJames = message['speaker'] == "James";

                return GestureDetector(
                  onTap: () async {
                    await _audioPlayer.seek(Duration(milliseconds: message['timestamp']));
                  },
                  child: Align(
                    alignment: isJames ? Alignment.centerLeft : Alignment.centerRight,
                    child: Container(
                      margin: EdgeInsets.only(top: 10),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isJames ? Colors.blueAccent.shade100 : Colors.greenAccent.shade100,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: isJames ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                        children: [
                          Text(
                            message['text']!,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
