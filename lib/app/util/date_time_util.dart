import 'package:intl/intl.dart';

class DateTimeUtil {
  static List<String> getOneWeekRange() {
    final now = DateTime.now();
    final start = now.subtract(const Duration(days: 7));
    final format = DateFormat('yyyy-MM-dd');
    return [format.format(start), format.format(now)];
  }
}
