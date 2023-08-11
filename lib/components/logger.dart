import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:gps/provider/LatLngProvider.dart';
import 'package:gps/provider/MoveProvider.dart';
import 'package:logger/logger.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

int index = 1;

class LogModule {
  static final _logger = Logger();

  static Future<void> logging(BuildContext context) async {
    final DateTime now = DateTime.now();
    final gpsProv = Provider.of<LatLngProv>(context, listen: false);
    final movProv = Provider.of<MoveProv>(context, listen: false);

    final logMessage = '''
=====================================
$now     [Log$index]

Latitude: ${gpsProv.Lat}
Longitude: ${gpsProv.Lng}
Accuracy: ${gpsProv.accuracy}
Speed: ${gpsProv.GpsSpeed}
Direction: ${gpsProv.GpsDirect}, ${gpsProv.GpsDirT}
Movement Status: ${movProv.MoveStat}
=====================================
''';

    _logger.i(logMessage);

    await _writeToFile(logMessage); // Save log to file

    index += 1;
  }

  static Future<void> _writeToFile(String content) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/logs.txt');

      if (!file.existsSync()) {
        file.createSync(recursive: true);
      }

      await file.writeAsString(content, mode: FileMode.append);

      print('Log file saved at: ${file.path}');
    } catch (e) {
      print('Error writing to file: $e');
    }
  }

  static Future<String> readLogFile() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/logs.txt');

      if (await file.exists()) {
        return await file.readAsString();
      } else {
        return 'Log file not found.';
      }
    } catch (e) {
      return 'Error reading log: $e';
    }
  }

  static Future<void> initializeLogFile() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/logs.txt');

    if (await file.exists()) {
      await file.writeAsString('');
    }
  }

}
