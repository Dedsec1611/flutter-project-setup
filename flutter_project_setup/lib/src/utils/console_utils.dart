import 'package:dart_console/dart_console.dart';

class ConsoleUtils {
  
  static String? inputConsole({required String question}) {
  var console = Console();
  console.setForegroundColor(ConsoleColor.cyan);
  console.write(question);
  console.resetColorAttributes();
  String? answer = console.readLine();
  return answer;
}
}