import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late ConfettiController _confettiControllerLeft;
  late ConfettiController _confettiControllerCenter;
  late ConfettiController _confettiControllerRight;

  late AudioCache _audioCache;

  late AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();

    _confettiControllerLeft = ConfettiController(
      duration: Duration(seconds: 10),
    );
    _confettiControllerCenter = ConfettiController(
      duration: Duration(seconds: 10),
    );
    _confettiControllerRight = ConfettiController(
      duration: Duration(seconds: 10),
    );

    _audioCache = AudioCache(prefix: 'assets/sounds/');
    _audioPlayer = AudioPlayer();
    _preloadSound();
    _audioPlayer.audioCache = _audioCache;
  }

  Future<void> _preloadSound() async {
    await _audioCache.load('confetti_sound.mp3');
  }

  @override
  void dispose() {
    _confettiControllerLeft.dispose();
    _confettiControllerCenter.dispose();
    _confettiControllerRight.dispose();
    // _audioPlayer.dispose();

    super.dispose();
  }

  void _play() {
    _confettiControllerLeft.play();
    _confettiControllerCenter.play();
    _confettiControllerRight.play();

    _audioPlayer.play(AssetSource('confetti_sound.mp3'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100],
      body: Stack(
        children: [
          confetti(
            context,
            Alignment.topLeft,
            _confettiControllerLeft,
            pi / 180,
          ),
          confetti(
            context,
            Alignment.topCenter,
            _confettiControllerCenter,
            pi / 2,
          ),
          confetti(context, Alignment.topRight, _confettiControllerRight, pi),
          
          // Align(alignment: Alignment.center,
          // child: Image.asset('assets/images/cake.png'),),

          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Expanded(child: SizedBox()),
                Text(
                  'С днем рождения, писька!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(color: Colors.black, offset: Offset(1, 1)),
                    ],
                  ),
                ),
                Image.asset('assets/images/cake.png'),
                // Expanded(child: SizedBox()),
                Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: ElevatedButton(
                    onPressed: _play,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 15,
                      ),
                      backgroundColor: Colors.pink[200],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      'Нажми на меня',
                      style: TextStyle(fontSize: 20, color: Colors.white, shadows: [
                        Shadow(color: Colors.black, offset: Offset(0.5, 0.5)),
                      ],),
                    ),
                  ),
                ),
                // SizedBox(height: 20,)
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget confetti(
    BuildContext context,
    Alignment alignment,
    ConfettiController controller,
    double blastDirection,
  ) {
    return Align(
      alignment: alignment,
      child: ConfettiWidget(
        confettiController: controller,
        // blastDirectionality: BlastDirectionality.explosive,
        shouldLoop: false,
        colors: [
          Colors.red,
          Colors.blue,
          Colors.green,
          Colors.yellow,
          Colors.purple,
        ],
        emissionFrequency: 0.4,
        gravity: 0.1,
        numberOfParticles: 20,
        strokeWidth: 1,
        blastDirection: blastDirection,
      ),
    );
  }
}
