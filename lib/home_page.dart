import 'dart:async';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  // Конфетти
  late ConfettiController _confettiControllerLeft;
  late ConfettiController _confettiControllerCenter;
  late ConfettiController _confettiControllerRight;
  final int seconds = 10;

  // Аудио
  late AudioCache _audioCache;
  late AudioPlayer _audioPlayer;

  // Анимация
  late AnimationController _buttonAnimationController;
  bool _isButtonPulsing = true;
  Timer? _timer;

  void _confettiInit() {
    _confettiControllerLeft = ConfettiController(
      duration: Duration(seconds: seconds),
    );
    _confettiControllerCenter = ConfettiController(
      duration: Duration(seconds: seconds),
    );
    _confettiControllerRight = ConfettiController(
      duration: Duration(seconds: seconds),
    );

    /*
    _confettiControllerLeft.addListener(() {
      if (_confettiControllerLeft.state == ConfettiControllerState.stopped) {
        setState(() {
          _isButtonPulsing = true;
        });
        _tapButtonPulse();
      }
      if (_confettiControllerLeft.state == ConfettiControllerState.playing) {
        setState(() {
          _isButtonPulsing = false;
        });
        _tapButtonPulse();
      }
    });


    _confettiControllerCenter.addListener((){
      if (_confettiControllerCenter.state == ConfettiControllerState.stopped) {
        setState(() {
          _isButtonPulsing = true;
        });
        _tapButtonPulse();
      }
    });

    _confettiControllerRight.addListener((){
      if (_confettiControllerRight.state == ConfettiControllerState.stopped) {
        setState(() {
          _isButtonPulsing = true;
        });
        _tapButtonPulse();
      }
    });

 */
  }

  void _audioInit() {
    _audioCache = AudioCache(prefix: 'assets/sounds/');
    _audioPlayer = AudioPlayer();
    // _audioPlayer.setPlayerMode(PlayerMode.lowLatency);
    _preloadSound();
    _audioPlayer.audioCache = _audioCache;
  }

  void _animationInit() {
    _buttonAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );
    _tapButtonPulse();
  }

  void _tapButtonPulse() {
    if (_isButtonPulsing) {
      _buttonAnimationController.repeat(reverse: true);
    } else {
      _buttonAnimationController.stop();
    }
  }

  @override
  void initState() {
    super.initState();

    _confettiInit();

    _audioInit();

    _animationInit();
  }

  Future<void> _preloadSound() async {
    await _audioCache.load('confetti_sound.mp3');
    // _audioPlayer.setSourceAsset('assets/sounds/confetti_sound.mp3');
  }

  @override
  void dispose() {
    _confettiControllerLeft.dispose();
    _confettiControllerCenter.dispose();
    _confettiControllerRight.dispose();
    _audioPlayer.dispose();
    _buttonAnimationController.dispose();

    _timer?.cancel();

    super.dispose();
  }

  Future<void> _play() async {
    _timer?.cancel();

    await _audioPlayer.play(AssetSource('confetti_sound.mp3'));
    // await _audioPlayer.play(UrlSource('assets/sounds/confetti_sound.mp3'));

    setState(() {
      _isButtonPulsing = false;
    });

    _tapButtonPulse();

    _confettiControllerLeft.play();
    _confettiControllerCenter.play();
    _confettiControllerRight.play();

    _timer = Timer(Duration(seconds: seconds), () {
      setState(() {
        _isButtonPulsing = true;
      });
      _tapButtonPulse();
    });

    // await Future.delayed(Duration(seconds: seconds), () {
    //   setState(() {
    //     _isButtonPulsing = true;
    //   });
    //   _tapButtonPulse();
    // });
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
                  'С Днем рождения, писька!',
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
                  child: AnimatedBuilder(
                    animation: _buttonAnimationController,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: 1.0 + (_buttonAnimationController.value * 0.1),
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
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  color: Colors.black,
                                  offset: Offset(0.5, 0.5),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
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
