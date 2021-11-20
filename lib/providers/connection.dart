import 'package:flutter/cupertino.dart';
import 'package:flutter_blue/flutter_blue.dart';

class ConnectionProvider with ChangeNotifier {
  late DeviceIdentifier? connectedDevice;

  ConnectionProvider(this.connectedDevice);
}