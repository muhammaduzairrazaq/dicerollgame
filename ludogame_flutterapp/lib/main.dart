import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(DiceRollApp());
}

class DiceRollApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Dice Roll Game'),
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

class _DiceRollScreenState extends State<DiceRollScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  int _currentValue = 1;
  int _currentPlayer = 1;
  List<int> _playerScores = [0, 0, 0, 0];
  int _turnCount = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );

    _animation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    )..addListener(() {
      setState(() {
        _currentValue = (_animation.value * 6).ceil();
      });
    });

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reset();
        setState(() {
          _currentValue = Random().nextInt(6) + 1;
          _playerScores[_currentPlayer - 1] += _currentValue;

          if (++_turnCount >= 12) {
            _showWinnerDialog();
          } else {
            _currentPlayer = (_currentPlayer % 4) + 1;
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _rollDice() {
    if (_controller.isAnimating) {
      return;
    }
    _controller.forward();
  }

  void _showWinnerDialog() {
    showDialog(
      context: context,
      builder: (context) {
        int maxScore = _playerScores.reduce(max);
        List<int> winners = [];
        for (int i = 0; i < _playerScores.length; i++) {
          if (_playerScores[i] == maxScore) {
            winners.add(i + 1);
          }
        }
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
            children: <Widget>[
              Text(
                'Player $_currentPlayer\'s Turn',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              GestureDetector(
                onTap: _rollDice,
                child: AnimatedSwitcher(
                  duration: Duration(milliseconds: 500),
                  switchInCurve: Curves.easeInOut,
                  switchOutCurve: Curves.easeInOut,
                  transitionBuilder: (child, animation) {
                    return RotationTransition(
                      turns: animation,
                      child: child,
                    );
                  },
                  child: Container(
                    key: ValueKey<int>(_currentValue),
                    width: 200.0,
                    height: 200.0,
                    child: Image.asset(
                      _getImagePath(_currentValue),
                    ),
                  ),
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
          mainAxisSize: MainAxisSize.min,
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

