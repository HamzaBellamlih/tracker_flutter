import 'package:intl/intl.dart';

class AppDateUtils {
  static String formatDate(DateTime date) =>
      DateFormat('dd/MM/yyyy').format(date);

  static String formatMonth(DateTime date) =>
      DateFormat('MMMM yyyy', 'fr_FR').format(date);

  static String monthKey(DateTime date) =>
      DateFormat('yyyy-MM').format(date);
}
