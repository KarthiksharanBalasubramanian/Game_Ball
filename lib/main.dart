import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

void main() => runApp(BucketGame());

class BucketGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bucket Collect Balls',
      debugShowCheckedModeBanner: false,
      home: GameScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  double bucketX = 0;
  double ballX = 0;
  double ballY = -1;
  double ballSpeed = 0.02;
  int score = 0;
  bool gameStarted = false;
  late Timer gameTimer;

  void startGame() {
    resetBall(); // Set initial position and speed
    gameStarted = true;
    gameTimer = Timer.periodic(Duration(milliseconds: 30), (timer) {
      setState(() {
        ballY += ballSpeed;

        if (ballY >= 0.85) {
          if ((ballX - bucketX).abs() < 0.15) {
            score++;
          }
          resetBall();
        }
      });
    });
  }

  void resetBall() {
    ballY = -1;
    ballX = Random().nextDouble() * 2 - 1; // between -1 and 1
    ballSpeed = 0.015 + Random().nextDouble() * 0.02; // 0.015–0.035
  }

  @override
  void dispose() {
    if (gameStarted) gameTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[100],
      body: Column(
        children: [
          SizedBox(height: 30),
          Text(
            "Score: $score",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: GestureDetector(
              onHorizontalDragUpdate: (details) {
                setState(() {
                  bucketX += details.delta.dx / MediaQuery.of(context).size.width * 2;
                  bucketX = bucketX.clamp(-1.0, 1.0);
                });
              },
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment(ballX, ballY),
                    child: Image.asset('assets/ball.png', height: 50),
                  ),
                  Align(
                    alignment: Alignment(bucketX, 0.9),
                    child: Image.asset('assets/bucket.png', height: 80),
                  ),
                ],
              ),
            ),
          ),
          if (!gameStarted)
            ElevatedButton(
              onPressed: startGame,
              child: Text("Start Game"),
            ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
