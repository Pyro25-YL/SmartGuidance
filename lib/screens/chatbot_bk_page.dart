import 'package:flutter/material.dart';

class ChatbotBKPage extends StatelessWidget {
  const ChatbotBKPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFE0E6),
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: const Text('Chatbot BK'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: const [
                _Bubble(
                  text: 'Halo 👋 Ada yang bisa saya bantu?',
                  isBot: true,
                ),
                _Bubble(
                  text: 'Saya bingung memilih jurusan',
                  isBot: false,
                ),
                _Bubble(
                  text:
                      'Baik 😊 Kamu bisa cek menu rekomendasi jurusan sesuai minatmu.',
                  isBot: true,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Ketik pesan...',
                filled: true,
                fillColor: Colors.white,
                suffixIcon: const Icon(Icons.send),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  final String text;
  final bool isBot;

  const _Bubble({required this.text, required this.isBot});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isBot ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isBot ? Colors.white : Colors.pink[200],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(text),
      ),
    );
  }
}
