import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:linetrace_robot_app/pages/hardware.dart';

import '../main.dart';

class MainDrawer extends StatefulWidget {
  final BuildContext parentContext;

  const MainDrawer({Key? key, required this.parentContext}) : super(key: key);

  @override
  _MainDrawerState createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  final refreshKey = GlobalKey<RefreshIndicatorState>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            child: Text('메뉴'),
            decoration: BoxDecoration(
              color: Colors.indigo[400],
            ),
          ),
          Divider(height: 0),
          ListTile(
            title: Text('메인'),
            dense: true,
            leading: Icon(Icons.home),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacement(widget.parentContext,
                  MaterialPageRoute(builder: (context) => HomePage()));
            },
          ),
          Divider(height: 0),
          ListTile(
            title: Text('하드웨어 클라이언트'),
            dense: true,
            leading: Icon(Icons.memory),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => HardwarePage()));
            },
          ),
        ],
      ),
    );
  }
}
