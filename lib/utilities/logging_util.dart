import 'package:ansicolor/ansicolor.dart';
import 'package:logging/logging.dart';

final Logger logger = Logger('MyAppLogger');

void configureLogging() {
  // Define AnsiPen for different log levels
  final AnsiPen infoPen = AnsiPen()..blue();
  final AnsiPen warningPen = AnsiPen()..yellow();
  final AnsiPen errorPen = AnsiPen()..red();
  final AnsiPen debugPen = AnsiPen()..green();
  final AnsiPen defaultPen = AnsiPen()..white();

  Logger.root.level = Level.ALL; // Set the root logger to handle all levels
  Logger.root.onRecord.listen((LogRecord record) {
    AnsiPen pen;

    // Select pen color based on log level
    switch (record.level.name) {
      case 'INFO':
        pen = infoPen;
        break;
      case 'WARNING':
        pen = warningPen;
        break;
      case 'SEVERE':
        pen = errorPen;
        break;
      case 'FINE':
      case 'FINER':
      case 'FINEST':
        pen = debugPen;
        break;
      default:
        pen = defaultPen;
    }

    print(pen('${record.level.name}: ${record.time}: ${record.loggerName}: ${record.message}'));
  });
}
