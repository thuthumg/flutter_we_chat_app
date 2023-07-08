// enum MONTH {
//   JANUARY,
//   FEBRUARY,
//   MARCH,
//   APRIL,
//   MAY,
//   JUNE,
//   JULY,
//   AUGUST,
//   SEPTEMBER,
//   OCTOBER,
//   NOVEMBER,
//   DECEMBER
// }
import 'package:intl/intl.dart';

List<String> monthsList =
    [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
String changeFromTimestampToDate(int timestamp) {
  var dateFormat = DateFormat('yyyy-MM-dd');
  return dateFormat.format(DateTime.fromMillisecondsSinceEpoch(timestamp));
}
String changeMonthTypeFromMonthNumberToMonthName(String month){
  if (month == '1') {
    return monthsList[0] ;
  }
  if (month == '2' ) {
    return monthsList[1];
  }
  if (month == '3') {
    return  monthsList[2];
  }
  if ( month == '4') {
    return  monthsList[3];
  }
  if (month == '5' ) {
    return  monthsList[4];
  }
  if (month == '6') {
    return   monthsList[5];
  }
  if  (month == '7') {
    return monthsList[6];
  }
  if (month == '8') {
    return  monthsList[7];
  }
  if (month == '9') {
    return   monthsList[8];
  }
  if (month == '10') {
    return  monthsList[9];
  }
  if (month == '11') {
    return  monthsList[10];
  }
  if (month == '12') {
    return monthsList[11];
  }else {
    return  monthsList[0] ;
  }
}



String? convertTimeToText(String? dataDate) {
  String? convTime;
  String prefix = "";
  String suffix = "Ago";

  try {
    DateFormat dateFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss", 'en_US');
    DateTime pasTime = dateFormat.parse(dataDate!);
    DateTime nowTime = DateTime.now();
    Duration dateDiff = nowTime.difference(pasTime);

    int second = dateDiff.inSeconds;
    int minute = dateDiff.inMinutes;
    int hour = dateDiff.inHours;
    int day = dateDiff.inDays;

    if (second < 60) {
      convTime = "Just Now";
    } else if (minute < 60) {
      convTime = "$minute Minutes $suffix";
    } else if (hour < 24) {
      convTime = "$hour Hours $suffix";
    } else if (day >= 7) {
      if (day > 360) {
        convTime = (day ~/ 360).toString() + " Years " + suffix;
      } else if (day > 30) {
        convTime = (day ~/ 30).toString() + " Months " + suffix;
      } else {
        convTime = (day ~/ 7).toString() + " Week " + suffix;
      }
    } else if (day < 7) {
      convTime = "$day Days $suffix";
    }
  } catch (e) {
    print(e);
  }

  return convTime;
}