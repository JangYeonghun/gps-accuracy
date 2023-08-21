import 'package:gps/class/sensorfusion/get_out_car.dart';
import 'package:gps/components/gps/background.dart';
import 'package:logger/logger.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';


int index = 1;

class LogModule {
  static final _logger = Logger();

  static Future<void> logging() async {
    final DateTime now = DateTime.now();

    final logMessage = '''
=====================================
$now     [Log$index]

Latitude: $Lat
Longitude: $Lng
Accuracy: ${accuracy}m
Speed: ${gSpeed}Km/h
Moving Direction: $gDirect, $gD2T
View Direction: $compDegree, $compText
Movement Status: $moveStat
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
