import 'package:flutter/cupertino.dart';
import 'package:linetrace_robot_app/defs/enums.dart';

class SettingsProvider with ChangeNotifier {
  late ControlMode? controlMode;

  SettingsProvider(this.controlMode);
}