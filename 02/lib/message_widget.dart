import 'package:bubble/bubble.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class MessageWidget extends StatelessWidget {
  final Map<String, dynamic> message;

  const MessageWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final isJames = message['speaker'] == "James";

    // Dữ liệu định dạng
    final format = [
      {
        'position': [5, "Lan", 3],
        'style': {'color': "#5D8736", 'bold': true, 'italic': false, 'underline': false},
        'hyperlink': {'url': "https://en.wikipedia.org/wiki/Vietnam"}
      },
      {
        'position': [135, "Bạn làm nghề gì vậy", 19],
        'style': {'color': "#5E2736", 'bold': true, 'italic': true, 'underline': false},
        'hyperlink': {'url': "https://en.wikipedia.org/wiki/Vietnam"}
      },
    ];

    return GestureDetector(
      child: Align(
        alignment: isJames ? Alignment.centerLeft : Alignment.centerRight,
        child: Bubble(
          margin: BubbleEdges.only(top: 10),
          nip: isJames ? BubbleNip.leftTop : BubbleNip.rightTop,
          color: isJames ? Colors.blueAccent.shade100 : Colors.greenAccent.shade100,
          child: Column(
            crossAxisAlignment: isJames ? CrossAxisAlignment.start : CrossAxisAlignment.end,
            children: [
              RichText(
                text: _buildFormattedText(message['text']!, format),
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextSpan _buildFormattedText(String text, List<Map<String, dynamic>> format) {
    List<TextSpan> spans = [];
    int lastIndex = 0;

    for (var item in format) {
      final position = item['position'];
      final styleData = item['style'];
      final hyperlink = item['hyperlink'];

      int start = position[0];
      String content = position[1];
      int length = position[2];

      // Kiểm tra nếu start hoặc start + length vượt quá độ dài chuỗi
      if (start < 0 || start >= text.length) {
        print("Warning: Invalid start position $start for text length ${text.length}");
        continue;
      }

      if (start + length > text.length) {
        print("Warning: End position ${start + length} exceeds text length ${text.length}");
        length = text.length - start; // Giới hạn length trong phạm vi cho phép
        content = text.substring(start, start + length);
      }

      // Add normal text before the formatted segment
      if (lastIndex < start) {
        spans.add(TextSpan(
          text: text.substring(lastIndex, start),
          style: TextStyle(color: Colors.black87),
        ));
      }

      // Add formatted segment
      spans.add(TextSpan(
        text: content,
        style: TextStyle(
          color: Color(int.parse(styleData['color']!.replaceFirst('#', '0xFF'))),
          fontWeight: styleData['bold'] ? FontWeight.bold : FontWeight.normal,
          fontStyle: styleData['italic'] ? FontStyle.italic : FontStyle.normal,
          decoration: styleData['underline'] ? TextDecoration.underline : TextDecoration.none,
        ),
        recognizer: hyperlink != null && hyperlink['url'] != null
            ? (TapGestureRecognizer()
              ..onTap = () {
                // Handle hyperlink tap
                launchUrl(hyperlink['url']);
              })
            : null,
      ));

      // Update the last index
      lastIndex = start + length;
    }

    // Add remaining normal text
    if (lastIndex < text.length) {
      spans.add(TextSpan(
        text: text.substring(lastIndex),
        style: TextStyle(color: Colors.black87),
      ));
    }

    return TextSpan(children: spans);
  }

  void launchUrl(String url) {
    // You can use the `url_launcher` package to handle URL launching
    print("Opening URL: $url");
  }
}
