import 'package:_02/chat_screen.dart';
import 'package:flutter/material.dart';

class ChatApp extends StatelessWidget {
  const ChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textSelectionTheme: TextSelectionThemeData(
          selectionColor: Colors.yellow.withValues(alpha: 0.4),
          cursorColor: Colors.blue, // Cursor color
          selectionHandleColor: Colors.blue, // Handle color
        ),
      ),
      home: ChatScreen(),
    );
  }
}
