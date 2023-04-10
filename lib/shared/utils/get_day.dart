import 'package:intl/intl.dart';

String getDay(DateTime day) {
    final eDay = DateFormat('EEEE').format(day);

    switch (eDay) {
      case 'Monday':
        return "Дав";

      case 'Tuesday':
        return "Мя";

      case 'Wednesday':
        return "Лха";

      case 'Thursday':
        return "Пү";

      case 'Friday':
        return "Ба";

      case 'Saturday':
        return "Бя";

      case 'Sunday':
        return "Ня";
      default:
        return "";
    }
  }