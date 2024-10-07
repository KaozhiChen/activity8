import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const HalloweenGame());
}

class HalloweenGame extends StatelessWidget {
  const HalloweenGame({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spooky Halloween Game',
      theme: ThemeData.dark(),
      home: const SpookyGameScreen(),
    );
  }
}

class SpookyGameScreen extends StatefulWidget {
  const SpookyGameScreen({super.key});

  @override
  _SpookyGameScreenState createState() => _SpookyGameScreenState();
}

class _SpookyGameScreenState extends State<SpookyGameScreen>
    with SingleTickerProviderStateMixin {
  final Random _random = Random();
  bool isGameWon = false;

  @override
  void initState() {
    super.initState();
  }

  Widget _buildSpookyCharacter(String emoji, bool isCorrectItem) {
    return Positioned(
      top: _random.nextDouble() * 400,
      left: _random.nextDouble() * 300,
      child: GestureDetector(
        child: Text(
          emoji,
          style: const TextStyle(fontSize: 50),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Find the Correct Item!'),
      ),
      body: Stack(
        children: [
          // Background emojis for the spooky forest
          Positioned.fill(
            child: Container(
              color: Colors.black,
              child: const Center(
                child: Text(
                  '🌲🌕🌲',
                  style: TextStyle(fontSize: 100),
                ),
              ),
            ),
          ),
          // Spooky characters and traps
          _buildSpookyCharacter('👻', false), // A spooky trap
          _buildSpookyCharacter('🎃', true), // The correct item
          _buildSpookyCharacter('🦇', false), // Another spooky trap
        ],
      ),
    );
  }
}
