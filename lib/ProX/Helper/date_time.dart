import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// ----- ----- ----- ----- ----- //
String formatDateTime(DateTime dateTime, String format) {
  var newFormat = DateFormat(format);
  return newFormat.format(dateTime);
}

String formatDateTimeFromString(String dateTime, String format) {
  DateTime date = DateTime.parse(dateTime);
  var newFormat = DateFormat(format);
  return newFormat.format(date);
}

String formatDateTimeFromTimeString(String time, String format) {
  DateTime date = DateTime.parse(getCurrentDate() + ' ' + time);
  var newFormat = DateFormat(format);
  return newFormat.format(date);
}

String formatDateTimeFrom(String dateTime, {String? fromFormat, String? toFormat}) {
  DateTime date;
  if (fromFormat == null) {
    date = DateTime.parse(dateTime);
  } else {
    DateFormat formatter = DateFormat(fromFormat);
    date = formatter.parse(dateTime);
  }
  var newFormat = DateFormat(toFormat);
  return newFormat.format(date);
}
// ----- ----- ----- ----- ----- //

String formatTime(TimeOfDay timeOfDay) {
  // H:m:s
  String hour = timeOfDay.hour < 10 ? '0${timeOfDay.hour}' : timeOfDay.hour.toString();
  String minutes = timeOfDay.minute < 10 ? '0${timeOfDay.minute}' : timeOfDay.minute.toString();
  return '$hour:$minutes:00';
}

String formatTimeForDisplay(TimeOfDay timeOfDay) {
  // hh:mm a
  String hour = timeOfDay.hourOfPeriod < 10 ? '0${timeOfDay.hourOfPeriod}' : timeOfDay.hourOfPeriod.toString();
  String minutes = timeOfDay.minute < 10 ? '0${timeOfDay.minute}' : timeOfDay.minute.toString();
  String period = timeOfDay.period == DayPeriod.am ? 'AM' : 'PM';
  return '$hour:$minutes $period';
}

String getCurrentDate({bool withTime = false}) {
  String szDateTime = '';
  DateTime now = DateTime.now();
  String year = now.year.toString();
  String month = now.month < 10 ? '0${now.month}' : now.month.toString();
  String day = now.day < 10 ? '0${now.day}' : now.day.toString();
  szDateTime = '$year-$month-$day';
  if (withTime) {
    String hour = now.hour < 10 ? '0${now.hour}' : now.hour.toString();
    String minutes = now.minute < 10 ? '0${now.minute}' : now.minute.toString();
    szDateTime = ' $hour:$minutes:00';
  }
  return szDateTime;
}

String getTimeZone() {
  // GMT+8
  DateTime now = DateTime.now();
  return now.timeZoneName;
}

class Month {
  final int monthday;
  final String mm;
  final String name;
  final String shortName;
  bool selected;

  Month({
    required this.monthday,
    required this.mm,
    required this.name,
    required this.shortName,
    this.selected = false,
  });

  static List<Month> getFullMonths() {
    List<Month> list = [
      Month(
        monthday: 1,
        mm: '01',
        name: 'January',
        shortName: 'Jan',
      ),
      Month(
        monthday: 2,
        mm: '02',
        name: 'February',
        shortName: 'Feb',
      ),
      Month(
        monthday: 3,
        mm: '03',
        name: 'March',
        shortName: 'Mar',
      ),
      Month(
        monthday: 4,
        mm: '04',
        name: 'April',
        shortName: 'Apr',
      ),
      Month(
        monthday: 5,
        mm: '05',
        name: 'May',
        shortName: 'May',
      ),
      Month(
        monthday: 6,
        mm: '06',
        name: 'June',
        shortName: 'Jun',
      ),
      Month(
        monthday: 7,
        mm: '07',
        name: 'July',
        shortName: 'Jul',
      ),
      Month(
        monthday: 8,
        mm: '08',
        name: 'August',
        shortName: 'Aug',
      ),
      Month(
        monthday: 9,
        mm: '09',
        name: 'September',
        shortName: 'Sep',
      ),
      Month(
        monthday: 10,
        mm: '10',
        name: 'October',
        shortName: 'Oct',
      ),
      Month(
        monthday: 11,
        mm: '11',
        name: 'November',
        shortName: 'Nov',
      ),
      Month(
        monthday: 12,
        mm: '12',
        name: 'December',
        shortName: 'Dec',
      ),
    ];

    return list;
  }
}

class WeekDay {
  final int weekday;
  final String name;
  final String shortName;
  bool selected;

  WeekDay({
    required this.weekday,
    required this.name,
    required this.shortName,
    this.selected = false,
  });

  static List<WeekDay> getFullWorkDays() {
    List<WeekDay> list = [
      WeekDay(
        weekday: 1,
        name: 'Monday',
        shortName: 'Mon',
      ),
      WeekDay(
        weekday: 2,
        name: 'Tuesday',
        shortName: 'Tue',
      ),
      WeekDay(
        weekday: 3,
        name: 'Wednesday',
        shortName: 'Wed',
      ),
      WeekDay(
        weekday: 4,
        name: 'Thursday',
        shortName: 'Thu',
      ),
      WeekDay(
        weekday: 5,
        name: 'Friday',
        shortName: 'Fri',
      ),
      WeekDay(
        weekday: 6,
        name: 'Saturday ',
        shortName: 'Sat',
      ),
      WeekDay(
        weekday: 7,
        name: 'Sunday',
        shortName: 'Sun',
      ),
    ];

    return list;
  }
}
