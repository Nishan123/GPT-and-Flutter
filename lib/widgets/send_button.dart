import 'package:flutter/material.dart';

class SendButton extends StatelessWidget {
  final VoidCallback onTap;
  const SendButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      style: IconButton.styleFrom(
        backgroundColor: Colors.black54,
        foregroundColor: Colors.white,
        shape: CircleBorder(),
        padding: EdgeInsets.all(16),

        elevation: 0,
      ),
      onPressed: onTap,
      icon: Center(child: Icon(Icons.send_rounded)),
    );
  }
}
