import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(DiceRollApp());
}

class DiceRollApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Dice Roll Game'),
          backgroundColor: Color.fromRGBO(248, 82, 179, 1),
        ),
        body: Center(
          child: DiceRollScreen(),
        ),
      ),
    );
  }
}

class DiceRollScreen extends StatefulWidget {
  @override
  _DiceRollScreenState createState() => _DiceRollScreenState();
}

class _DiceRollScreenState extends State<DiceRollScreen> {
  int _currentValue = 1;
  int _currentPlayer = 1;
  List<int> _playerScores = [0, 0, 0, 0];
  int _turnCount = 0;

  bool _rolling = false;

  void _rollDice() {
    if (_rolling) {
      return;
    }

    int rollValue = Random().nextInt(6) + 1;
    setState(() {
      _rolling = true;
      _currentValue = rollValue;
    });

    setState(() {
      _rolling = false;
      _playerScores[_currentPlayer - 1] += rollValue;

      if (rollValue != 6) {
        _turnCount++;
      }

      if (rollValue == 6) {
        return;
      }

      if (_turnCount >= 12) {
        _showWinnerDialog();
      } else {
        _currentPlayer = (_currentPlayer % 4) + 1;
      }
    });
  }

  void _showWinnerDialog() {
    int maxScore = _playerScores.reduce(max);
    List<int> winners = [];
    for (int i = 0; i < _playerScores.length; i++) {
      if (_playerScores[i] == maxScore) {
        winners.add(i + 1);
      }
    }
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Game Over'),
          content: Text('Player $winners win with a score of $maxScore!'),
          actions: [
            TextButton(
              onPressed: () {
                _resetGame();
                Navigator.of(context).pop();
              },
              child: Text('Play Again'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: Text('Exit'),
            ),
          ],
        );
      },
    );
  }

  void _resetGame() {
    setState(() {
      _currentValue = 1;
      _currentPlayer = 1;
      _playerScores = [0, 0, 0, 0];
      _turnCount = 0;
    });
  }

  String _getImagePath(int value) {
    if (value == 0) {
      value++;
    }
    return 'assets/d$value.png';
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 10,
          left: 10,
          child: _buildPlayerCard(1, Colors.red),
        ),
        Positioned(
          top: 10,
          right: 10,
          child: _buildPlayerCard(2, Colors.green),
        ),
        Positioned(
          bottom: 10,
          left: 10,
          child: _buildPlayerCard(3, Colors.blue),
        ),
        Positioned(
          bottom: 10,
          right: 10,
          child: _buildPlayerCard(4, Color.fromARGB(255, 238, 130, 29)),
        ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Player $_currentPlayer\'s Turn',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              GestureDetector(
                onTap: _rollDice,
                child: Container(
                  width: 150.0,
                  height: 150.0,
                  child: Image.asset(
                    _getImagePath(_currentValue),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: _resetGame,
                child: Text('Reset Game'),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(135, 50),
                  backgroundColor: Color.fromRGBO(248, 82, 179, 1),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPlayerCard(int playerNumber, Color color) {
    return Card(
      color: color,
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Player $playerNumber',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Score: ${_playerScores[playerNumber - 1]}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
