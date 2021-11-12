import 'package:flutter/material.dart';
import 'package:linetrace_robot_app/widgets/drawer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '컨트롤러 메인',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _buttonPressed = false;
  bool _loopActive = false;
  bool _activeAutopilot = false;

  void _increaseCounterWhilePressed() async {
    // make sure that only one loop is active
    if (_loopActive) return;

    _loopActive = true;

    while (_buttonPressed) {
      // do your thing
      print(DateTime.now());

      // wait a bit
      await Future.delayed(Duration(milliseconds: 200));
    }

    _loopActive = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('라인트레이싱 컨트롤러'),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(
                    '자동주행 꺼짐',
                    style: TextStyle(fontSize: 24),
                  ),
                  SizedBox(height: 4),
                  Text('수동주행 모드입니다.')
                ]),
                Switch(
                  value: _activeAutopilot,
                  onChanged: (value) {
                    setState(() {
                      _activeAutopilot = value;
                    });
                  },
                ),
              ],
            ),
            Divider(height: 30),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Listener(
                      onPointerDown: (details) {
                        _buttonPressed = true;
                        _increaseCounterWhilePressed();
                      },
                      onPointerUp: (details) {
                        _buttonPressed = false;
                      },
                      child: SizedBox(
                        height: 70,
                        child: ElevatedButton(
                          onPressed: () {},
                          child: Row(
                            children: [
                              RotationTransition(
                                turns: AlwaysStoppedAnimation(90 / 360),
                                child: Icon(
                                  Icons.arrow_back,
                                  size: 36,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Listener(
                      onPointerDown: (details) {
                        _buttonPressed = true;
                        _increaseCounterWhilePressed();
                      },
                      onPointerUp: (details) {
                        _buttonPressed = false;
                      },
                      child: SizedBox(
                        height: 70,
                        child: ElevatedButton(
                          onPressed: () {},
                          child: Row(
                            children: [
                              Icon(
                                Icons.arrow_back,
                                size: 36,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Listener(
                      onPointerDown: (details) {
                        _buttonPressed = true;
                        _increaseCounterWhilePressed();
                      },
                      onPointerUp: (details) {
                        _buttonPressed = false;
                      },
                      child: SizedBox(
                        height: 70,
                        child: ElevatedButton(
                          onPressed: () {},
                          child: Row(
                            children: [
                              RotationTransition(
                                turns: AlwaysStoppedAnimation(90 / 360),
                                child: Icon(
                                  Icons.arrow_forward,
                                  size: 36,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Listener(
                      onPointerDown: (details) {
                        _buttonPressed = true;
                        _increaseCounterWhilePressed();
                      },
                      onPointerUp: (details) {
                        _buttonPressed = false;
                      },
                      child: SizedBox(
                        height: 70,
                        child: ElevatedButton(
                          onPressed: () {},
                          child: Row(
                            children: [
                              Icon(
                                Icons.arrow_forward,
                                size: 36,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
      drawer: MainDrawer(parentContext: context),
    );
  }
}
