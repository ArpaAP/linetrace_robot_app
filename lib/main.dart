import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:linetrace_robot_app/pages/hardware.dart';
import 'package:linetrace_robot_app/pages/home.dart';
import 'package:linetrace_robot_app/providers/connection.dart';
import 'package:linetrace_robot_app/providers/settings.dart';
import 'package:provider/provider.dart';

import 'defs/enums.dart';

void main() {
  runApp(App());
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final _pageController = PageController();
  int _currentIndex = 0;

  bool isRotated = false;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ListenableProvider(create: (_) => ConnectionProvider(null)),
        ListenableProvider(create: (_) => SettingsProvider(ControlMode.arrow)),
      ],
      child: MaterialApp(
        title: '라인트레이싱 컨트롤러',
        theme: ThemeData(
          primarySwatch: Colors.indigo,
        ),
        home: Scaffold(
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
                HomePage(),
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
        )
      ),
    );
  }
}
