import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

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
  late AnimationController _animationController;
  final AudioPlayer _audioPlayer = AudioPlayer();
  List<Offset> _positions = [];
  late Timer _movementTimer;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _initializePositions();
    _startMovingItems();
    _playBackgroundMusic();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _audioPlayer.dispose();
    _movementTimer.cancel();
    super.dispose();
  }

  void _initializePositions() {
    _positions = List.generate(3, (_) => _randomOffset());
  }

  Offset _randomOffset() {
    double top = _random.nextDouble() * 400;
    double left = _random.nextDouble() * 300;
    return Offset(left, top);
  }

  void _startMovingItems() {
    _movementTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      setState(() {
        _positions = List.generate(3, (_) => _randomOffset());
      });
    });
  }

  void _playBackgroundMusic() async {
    await _audioPlayer.setAsset('assets/spooky_background.mp3');
    _audioPlayer.play();
  }

  Future<void> playJumpscareSound() async {
    await _audioPlayer.setAsset('assets/jumpscare.mp3');
    _audioPlayer.play();
  }

  Future<void> playSuccessSound() async {
    await _audioPlayer.setAsset('assets/success.mp3');
    _audioPlayer.play();
  }

  void _onSpookyItemTap(bool isCorrectItem) {
    if (isCorrectItem) {
      setState(() {
        isGameWon = true;
      });
      playSuccessSound();
    } else {
      playJumpscareSound();
    }
  }

  Widget _buildSpookyCharacter(String emoji, bool isCorrectItem, int index) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      top: _positions[index].dy,
      left: _positions[index].dx,
      child: GestureDetector(
        onTap: () => _onSpookyItemTap(isCorrectItem),
        child: Text(
          emoji,
          style: const TextStyle(
            fontSize: 50,
          ),
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
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            _buildSpookyCharacter('👻', false, 0),
            _buildSpookyCharacter('🎃', true, 1), // The correct item
            _buildSpookyCharacter('🦇', false, 2),
            if (isGameWon) _buildWinMessage(),
          ],
        ),
      ),
    );
  }

  Widget _buildWinMessage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'You Found It!',
            style: TextStyle(
              fontSize: 32,
              color: Colors.green,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              setState(() {
                isGameWon = false;
                _initializePositions();
              });
            },
            child: const Text('Play Again'),
          ),
        ],
      ),
    );
  }
}
