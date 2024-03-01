import 'package:logger/logger.dart';

class LogUtils {
  static void log(var logMsg) {
    var logger = Logger(printer: PrettyPrinter());
    logger.v('My App == > ', error: logMsg);
  }
}