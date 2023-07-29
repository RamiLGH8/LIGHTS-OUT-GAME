import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  List<List<int>> gameBoard = [
    [0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0],
  ];
  Color isOn = Color.fromARGB(255, 24, 180, 4);
  Color isOff = Color.fromARGB(255, 253, 2, 2);
  int generateRandomNumber() {
    Random random = Random();
    return random.nextInt(2);
  }

  void initialState(List<List<int>> gameBoard) {
    for (int i = 0; i < 5; i++) {
      for (int j = 0; j < 5; j++) {
        gameBoard[i][j] = generateRandomNumber();
      }
    }
  }

  int neighbourState(int position) {
    if (position == 0)
      position = 1;
    else
      position = 0;
    return position;
  }

  void changeState(List<List<int>> gameBoard, int row, int col) {
    gameBoard[row][col] = neighbourState(gameBoard[row][col]);
    if ((row >= 1 && row <= 3) && (col >= 1 && col <= 3)) {
      gameBoard[row - 1][col] = neighbourState(gameBoard[row - 1][col]);
      gameBoard[row][col - 1] = neighbourState(gameBoard[row][col - 1]);
      gameBoard[row + 1][col] = neighbourState(gameBoard[row + 1][col]);
      gameBoard[row][col + 1] = neighbourState(gameBoard[row][col + 1]);
    }
    if ((row == 0 || row == 4) && (col >= 1 && col <= 3)) {
      if (row == 0) {
        gameBoard[row][col - 1] = neighbourState(gameBoard[row][col - 1]);
        gameBoard[row + 1][col] = neighbourState(gameBoard[row + 1][col]);
        gameBoard[row][col + 1] = neighbourState(gameBoard[row][col + 1]);
      }
      if (row == 4) {
        gameBoard[row - 1][col] = neighbourState(gameBoard[row - 1][col]);
        gameBoard[row][col - 1] = neighbourState(gameBoard[row][col - 1]);
        gameBoard[row][col + 1] = neighbourState(gameBoard[row][col + 1]);
      }
    }
    if ((col == 0 || col == 4) && (row >= 1 && row <= 3)) {
      if (col == 0) {
        gameBoard[row - 1][col] = neighbourState(gameBoard[row - 1][col]);
        gameBoard[row + 1][col] = neighbourState(gameBoard[row + 1][col]);
        gameBoard[row][col + 1] = neighbourState(gameBoard[row][col + 1]);
      }
      if (col == 4) {
        gameBoard[row - 1][col] = neighbourState(gameBoard[row - 1][col]);
        gameBoard[row][col - 1] = neighbourState(gameBoard[row][col - 1]);
        gameBoard[row + 1][col] = neighbourState(gameBoard[row + 1][col]);
      }
    }

    if (row == 0) {
      if (col == 0) {
        gameBoard[row + 1][col] = neighbourState(gameBoard[row + 1][col]);
        gameBoard[row][col + 1] = neighbourState(gameBoard[row][col + 1]);
      }
      if (col == 4) {
        gameBoard[row + 1][col] = neighbourState(gameBoard[row + 1][col]);
        gameBoard[row][col - 1] = neighbourState(gameBoard[row][col - 1]);
      }
    }
    if (row == 4) {
      if (col == 0) {
        gameBoard[row - 1][col] = neighbourState(gameBoard[row - 1][col]);
        gameBoard[row][col + 1] = neighbourState(gameBoard[row][col + 1]);
      }
      if (col == 4) {
        gameBoard[row - 1][col] = neighbourState(gameBoard[row - 1][col]);
        gameBoard[row][col - 1] = neighbourState(gameBoard[row][col - 1]);
      }
    }
  }

  bool checkForEnd(List<List<int>> gameBoard) {
    int numOfZero = 0;
    for (int i = 0; i < 5; i++) {
      for (int j = 0; j < 5; j++) {
        if (gameBoard[i][j] == 0) numOfZero++;
      }
    }
    if (numOfZero == 25)
      return true;
    else
      return false;
  }

  void resetGame() {
    initialState(gameBoard);
  }

  Color changeFront(int mark) {
    if (mark == 0)
      return isOff;
    else
      return isOn;
  }

  bool isVisible = false;
  Color newColor = Colors.white;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
          child: Scaffold(
              appBar: AppBar(
                title: Center(
                  child: Text('Lights Out'),
                ),
                backgroundColor: Color.fromARGB(255, 49, 2, 126),
              ),
              body: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Colors.blue,
                      Color.fromARGB(255, 43, 19, 177),
                    ],
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 140),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 5,
                          ),
                          itemBuilder: (context, index) {
                            int row = index ~/ 5;
                            int col = index % 5;
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (checkForEnd(gameBoard) == true) {
                                    isVisible = true;
                                  } else {
                                    changeState(gameBoard, row, col);
                                    newColor = changeFront(gameBoard[row][col]);
                                  }
                                });
                              },
                              child: Container(
                                child: Center(),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black),
                                  color: changeFront(gameBoard[row][col]),
                                ),
                              ),
                            );
                          },
                          itemCount: 25,
                        ),
                      ),
                    ),
                    Visibility(
                      child: Text(
                        'YOU WON!!',
                        style: TextStyle(color: Colors.green),
                      ),
                      visible: isVisible,
                    ),
                    ElevatedButton(
                      onPressed: (() {
                        setState(() {
                          initialState(gameBoard);
                          isVisible = false;
                        });
                      }),
                      child: Icon(
                        Icons.restart_alt,
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.green
                      ),
                    ),
                  ],
                ),
              ))),
    );
  }
}
