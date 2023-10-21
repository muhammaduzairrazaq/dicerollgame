import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: DiceRollApp(),
  ));
}

void showInstructionsDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Instructions'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Welcome to the Dice Roll Game!',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text('1. Roll the dice by tapping on it.'),
            Text('2. Try to get the highest score.'),
            Text('3. The game ends after 12 turns.'),
            Text('4. The player with the highest score wins.'),
            SizedBox(height: 20),
            Text(
              'Enjoy the game!',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Close'),
          ),
        ],
      );
    },
  );
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
          actions: [
            IconButton(
              icon: Icon(Icons.help_outline),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Instructions'),
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Welcome to the Dice Roll Game!',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10),
                          Text('1. Roll the dice by tapping on it.'),
                          Text('2. Try to get the highest score.'),
                          Text('3. The game ends after 12 turns 3 turns each.'),
                          Text('4. The player with the highest score wins.'),
                          SizedBox(height: 20),
                          Text(
                            'Enjoy the game!',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Close'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
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

  void rollDice() {
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
        showWinnerDialog();
      } else {
        _currentPlayer = (_currentPlayer % 4) + 1;
      }
    });
  }

  void showWinnerDialog() {
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
                resetGame();
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

  void resetGame() {
    setState(() {
      _currentValue = 1;
      _currentPlayer = 1;
      _playerScores = [0, 0, 0, 0];
      _turnCount = 0;
    });
  }

  String getImagePath(int value) {
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
          child: buildPlayerCard(1, Colors.red),
        ),
        Positioned(
          top: 10,
          right: 10,
          child: buildPlayerCard(2, Colors.green),
        ),
        Positioned(
          bottom: 10,
          left: 10,
          child: buildPlayerCard(3, Colors.blue),
        ),
        Positioned(
          bottom: 10,
          right: 10,
          child: buildPlayerCard(4, Color.fromARGB(255, 238, 130, 29)),
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
                onTap: rollDice,
                child: Container(
                  width: 150.0,
                  height: 150.0,
                  child: Image.asset(
                    getImagePath(_currentValue),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: resetGame,
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

  Widget buildPlayerCard(int playerNumber, Color color) {
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
