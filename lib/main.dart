import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:linetrace_robot_app/pages/hardware.dart';

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

enum ControlMode { arrow, gyro }

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _buttonPressed = false;
  bool _loopActive = false;
  bool _activeAutopilot = false;

  ControlMode _controlMode = ControlMode.arrow;
  final _pageController = PageController();
  bool isRotated = false;
  int _currentIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _increaseCounterWhilePressed() async {
    if (_loopActive) return;

    _loopActive = true;
    while (_buttonPressed) {
      print(DateTime.now());
      await Future.delayed(Duration(milliseconds: 200));
    }
    _loopActive = false;
  }

  Widget autoModeControlWidget(BuildContext context) {
    return Column(
      children: [],
    );
  }

  Widget manualModeControlWidget(BuildContext context) {
    return Column(
      children: [
        Column(
          children: [
            RadioListTile(
              value: ControlMode.arrow,
              dense: true,
              groupValue: _controlMode,
              onChanged: (ControlMode? value) {
                setState(() {
                  _controlMode = value!;
                });
              },
              title: Text('화살표 키'),
              subtitle: Text('화면에 표시되는 좌우 화살표 키를 사용합니다.'),
            ),
            Divider(height: 0),
            RadioListTile(
              value: ControlMode.gyro,
              dense: true,
              groupValue: _controlMode,
              onChanged: (ControlMode? value) {
                setState(() {
                  _controlMode = value!;
                });
              },
              title: Text('자이로센서 사용'),
              subtitle: Text('디바이스의 기울기에 따라 방향을 조정합니다.'),
            )
          ],
        ),
        Divider(height: 0),
        SizedBox(height: 25),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('라인트레이싱 컨트롤러'),
      ),
      body: SizedBox.expand(
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          physics:
              BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          children: [
            Column(
              children: [
                InkWell(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _activeAutopilot ? '자동주행 켜짐' : '자동주행 꺼짐',
                              style: TextStyle(
                                fontSize: 24,
                                color: _activeAutopilot ? Colors.indigo : null,
                                fontWeight:
                                    _activeAutopilot ? FontWeight.bold : null,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(_activeAutopilot
                                ? '자동 주행 중입니다.'
                                : '수동주행 모드입니다.')
                          ],
                        ),
                        Expanded(child: Container()),
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
                  ),
                  onTap: () {
                    setState(() {
                      _activeAutopilot = !_activeAutopilot;
                    });
                  },
                ),
                Divider(height: 0),
                (_activeAutopilot
                    ? autoModeControlWidget
                    : manualModeControlWidget)(context),
              ],
            ),
            HardwarePage(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.screen_rotation),
        onPressed: () {
          if (isRotated) {
            SystemChrome.setPreferredOrientations(
              [DeviceOrientation.portraitUp],
            );
          } else {
            SystemChrome.setPreferredOrientations([
              DeviceOrientation.landscapeLeft,
              DeviceOrientation.landscapeRight
            ]);
          }
          isRotated = !isRotated;
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          _pageController.animateToPage(
            index,
            duration: Duration(milliseconds: 500),
            curve: Curves.easeOutExpo,
          );
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '메인',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.memory),
            label: '연결',
          )
        ],
      ),
    );
  }
}
