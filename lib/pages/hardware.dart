import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:linetrace_robot_app/providers/connection.dart';
import 'package:provider/provider.dart';

class HardwarePage extends StatefulWidget {
  const HardwarePage({Key? key}) : super(key: key);

  @override
  State<HardwarePage> createState() => _HardwarePageState();
}

class _HardwarePageState extends State<HardwarePage> {
  final flutterBlue = FlutterBlue.instance;

  @override
  void initState() {
    super.initState();
    flutterBlue.startScan(timeout: Duration(seconds: 10));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ScanResult>>(
        stream: flutterBlue.scanResults,
        initialData: const [],
        builder:
            (BuildContext context, AsyncSnapshot<List<ScanResult>> snapshot) {
          return RefreshIndicator(
              child: SizedBox(
                height: double.infinity,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  child: Column(
                    children: snapshot.data!
                            .where((e) => e.device.name.isNotEmpty)
                            .map<Widget>((e) {
                          return SizedBox(
                            width: double.infinity,
                            child: Card(
                                child: ListTile(
                              onTap: () async {
                                await e.device.disconnect();
                                await e.device.connect();

                                setState(() {
                                  Provider.of<ConnectionProvider>(
                                    context,
                                    listen: false,
                                  ).connectedDevice = e.device.id;
                                });
                              },
                              leading: const Icon(Icons.devices),
                              title: Text(e.device.name),
                              subtitle: e.device.id ==
                                      Provider.of<ConnectionProvider>(
                                        context,
                                        listen: false,
                                      ).connectedDevice
                                  ? Text('연결됨')
                                  : null,
                            )),
                          );
                        }).toList() +
                        [
                          SizedBox(
                            width: double.infinity,
                            child: Card(
                                child: ListTile(
                              onTap: () async {
                                final devices =
                                    (await flutterBlue.connectedDevices)
                                        .where((e) =>
                                            e.id ==
                                            Provider.of<ConnectionProvider>(
                                              context,
                                              listen: false,
                                            ).connectedDevice);
                                for (final e in devices) {
                                  await e.disconnect();
                                }

                                setState(() {
                                  Provider.of<ConnectionProvider>(
                                    context,
                                    listen: false,
                                  ).connectedDevice = null;
                                });
                              },
                              leading: const Icon(Icons.delete),
                              title: const Text('연결 해제'),
                            )),
                          ),
                        ],
                  ),
                ),
              ),
              onRefresh: () async {
                if (await flutterBlue.isScanning.first) return;
                await flutterBlue.startScan(
                    timeout: const Duration(seconds: 4));
              });
        });
  }
}
