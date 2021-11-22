import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:linetrace_robot_app/defs/enums.dart';
import 'package:linetrace_robot_app/providers/connection.dart';
import 'package:provider/provider.dart';
import 'package:sensors_plus/sensors_plus.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final flutterBlue = FlutterBlue.instance;
  bool _buttonPressed = false;
  bool _loopActive = false;
  bool _activeAutopilot = false;

  ControlMode _controlMode = ControlMode.arrow;

  double gyroX = 0;
  double gyroY = 0;
  double gyroZ = 0;

  @override
  void initState() {
    super.initState();
    accelerometerEvents.listen((AccelerometerEvent event) {
      gyroX = event.x;
      gyroY = event.y;
      gyroZ = event.z;
      print(event.y / 9.8 * 100);
    });
  }

  void _sendButtonData(String direction) async {
    if (_loopActive) return;

    _loopActive = true;

    try {
      final device = (await flutterBlue.connectedDevices)
          .where((e) =>
      e.id ==
          Provider.of<ConnectionProvider>(
            context,
            listen: false,
          ).connectedDevice)
          .first;
      final services = await device.discoverServices();

      while (_buttonPressed) {
        print(direction);
        for (var c in services[2].characteristics) {
          if (_controlMode == ControlMode.arrow || direction == "backward") {
            await c.write(utf8.encode('$direction\n'));
          } else {
            if (gyroY / 9.8 * 100 > 45) {
              await c.write(utf8.encode('right\n'));
            } else if (gyroY / 9.8 * 100 < -45) {
              await c.write(utf8.encode('left\n'));
            } else {
              await c.write(utf8.encode('forward\n'));
            }
          }
        }

        await Future.delayed(Duration(milliseconds: 100));
      }
    } finally {
      _loopActive = false;
    }
  }

  Widget autoModeControlWidget(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SpinKitFoldingCube(color: Colors.indigo[400], size: 40),
          SizedBox(height: 16),
          Text(
            '자동 주행 중입니다.',
            style: Theme.of(context).textTheme.headline6,
          )
        ],
      ),
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
              title: Text('가속도센서 사용'),
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
                _sendButtonData("forward");
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
                _sendButtonData("left");
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
                _sendButtonData("backward");
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
                _sendButtonData("right");
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

  void toggleAuto() async {
    final device = (await flutterBlue.connectedDevices)
        .where((e) =>
    e.id ==
        Provider.of<ConnectionProvider>(
          context,
          listen: false,
        ).connectedDevice)
        .first;
    final services = await device.discoverServices();

    for (var c in services[2].characteristics) {
      await c.write(utf8.encode('automode=${_activeAutopilot ? 0 : 1}\n'));
    }

    setState(() {
      _activeAutopilot = !_activeAutopilot;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
                  onChanged: (_) => toggleAuto(),
                ),
              ],
            ),
          ),
          onTap: toggleAuto,
        ),
        Divider(height: 0),
        (_activeAutopilot
            ? autoModeControlWidget
            : manualModeControlWidget)(context),
      ],
    );
  }
}