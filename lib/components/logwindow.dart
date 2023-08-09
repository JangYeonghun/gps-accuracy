import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gps/provider/LogProvider.dart';

class LogWindow extends StatefulWidget {
  const LogWindow({Key? key}) : super(key: key);

  @override
  State<LogWindow> createState() => _LogWindowState();
}

class _LogWindowState extends State<LogWindow> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 435,
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: SingleChildScrollView(
        child: Text(
          '${context.watch<LogProv>().Log}',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
