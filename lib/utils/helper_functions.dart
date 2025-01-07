import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

getDataAndTime(DateTime date) {
  // var dateTime = '2021-08-08T13:05:00';

  var year = date.year;
  var month = date.month;
  var day = date.day;
  var newMonth = month < 10 ? '0$month' : '$month';
  var newDay = day < 10 ? '0$day' : '$day';

  var newDate = '$year-$newMonth-$newDay';
  var hour = date.hour;
  var minute = date.minute;
  var amPm = hour >= 12 ? 'PM' : 'AM';
  hour = hour > 12 ? hour - 12 : hour;
  var newHour = hour < 10 ? '0$hour' : '$hour';
  var newMinute = minute < 10 ? '0$minute' : '$minute';
  var newTime = '$newHour:$newMinute $amPm';

  var newDateTime = '$newDate, $newTime';
  return newDateTime;
}

getTimeNow() {
  String timeString = DateTime.now().toString();
  String timNow = timeString.substring(0, timeString.indexOf('.') + 4);
  return timNow;
}

getValidDateTime(String timeString) {
  String timNow = timeString.substring(0, timeString.indexOf('.') + 4);
  return timNow;
}

testDate(var time) {
  return DateFormat('dd-MM-yyyy').parse(time);
}

getCustomDateLocal(var dateTime) {
  DateTime time = DateTime.parse(dateTime);
  String month = getMonthName(time.month);
  int day = time.day;
  int year = time.year;
  String newDay = day < 10 ? '0$day' : '$day';

  var hour = time.hour;
  var minute = time.minute;
  var amPm = hour >= 12 ? 'PM' : 'AM';
  hour = hour > 12 ? hour - 12 : hour;
  var newHour = hour < 10 ? '0$hour' : '$hour';
  var newMinute = minute < 10 ? '0$minute' : '$minute';
  var newTime = '$newHour:$newMinute $amPm';

  String newDate = '$newDay $month $year';

  return '$newDate, $newTime';
}

getCustomDate(String date) {
  DateTime time = DateTime.parse(date);
  String month = getMonthName(time.month);
  int day = time.day;
  int year = time.year;
  String newDay = day < 10 ? '0$day' : '$day';

  String newDate = '$newDay-$month-$year';

  return newDate;
}

getTimeAgo(String time) {
  DateTime dbDate = DateTime.parse(time);
  final currDate = DateTime.now();

  var difference = currDate.difference(dbDate).inMinutes;

  if (difference < 1) {
    return "Just Now";
  } else if (difference < 60) {
    return "$difference min ago";
  } else if (difference < 1440) {
    return "${(difference / 60).toStringAsFixed(0)} hr ago";
  } else if (difference < 43200) {
    return "${(difference / 1440).toStringAsFixed(0)} days ago";
  } else if (difference < 518400) {
    return "${(difference / 43200).toStringAsFixed(0)} days ago";
  }
}

getDate(String date) {
  DateTime time = DateTime.parse(date);
  int month = time.month;
  int day = time.day;
  int year = time.year;
  String newDay = day < 10 ? '0$day' : '$day';
  String newMonth = month < 10 ? '0$month' : '$month';

  String newDate = '$newDay-$newMonth-$year';

  return newDate;
}

getMonthName(int monthNum) {
  String month = '';

  switch (monthNum) {
    case 1:
      month = 'Jan';
      break;
    case 2:
      month = 'Feb';
      break;
    case 3:
      month = 'Mar';
      break;
    case 4:
      month = 'Apr';
      break;
    case 5:
      month = 'May';
      break;
    case 6:
      month = 'Jun';
      break;
    case 7:
      month = 'July';
      break;
    case 8:
      month = 'Aug';
      break;
    case 9:
      month = 'Sep';
      break;
    case 10:
      month = 'Oct';
      break;
    case 11:
      month = 'Nov';
      break;
    case 12:
      month = 'Dec';
      break;
    default:
      month = '';
      break;
  }

  return month;
}

Future<String> createFileFromString(String imageString) async {
  if (imageString == '') {
    return '';
  } else {
    final encodedStr = imageString;
    Uint8List bytes = base64.decode(encodedStr);
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = File(
        "$dir/" + DateTime.now().millisecondsSinceEpoch.toString() + ".pdf");
    await file.writeAsBytes(bytes);
    return file.path;
  }
}

// String? getStringImage(File? file) {
//   if (file == null) return null;
//   return base64Encode(file.readAsBytesSync());
// }
