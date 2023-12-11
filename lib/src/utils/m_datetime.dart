import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MDateTime extends DateTime {
  String format;

  MDateTime(
    int year, {
    this.format = 'yyyy-MM-dd HH:mm:ss',
    int month = 1,
    int day = 1,
    int hour = 0,
    int minute = 0,
    int second = 0,
    int millisecond = 0,
    int microsecond = 0,
  }) : super(
          year,
          month,
          day,
          hour,
          minute,
          second,
          millisecond,
          microsecond,
        );

  factory MDateTime.fromDate(
    DateTime dateTime, {
    String format = 'yyyy-MM-dd HH:mm:ss',
  }) =>
      MDateTime(
        format: format,
        dateTime.year,
        month: dateTime.month,
        day: dateTime.day,
        hour: dateTime.hour,
        minute: dateTime.minute,
        second: dateTime.second,
        millisecond: dateTime.millisecond,
        microsecond: dateTime.microsecond,
      );
  factory MDateTime.fromDateAndTImeOfDay(
    DateTime dateTime,
    TimeOfDay time, {
    String format = 'yyyy-MM-dd HH:mm:ss',
  }) =>
      MDateTime(
        dateTime.year,
        format: format,
        month: dateTime.month,
        day: dateTime.day,
        hour: time.hour,
        minute: time.minute,
        second: 0,
      );

  static MDateTime? fromString(
    String date, {
    String format = 'yyyy-MM-dd HH:mm:ss',
  }) {
    try {
      return MDateTime.fromDate(DateFormat(format).parse(date), format: format);
    } catch (e) {
      return null;
    }
  }

  static MDateTime get now => MDateTime.fromDate(DateTime.now());

  static MDateTime get zero => MDateTime(0);

  static Stream<MDateTime> streamNow({
    Duration dailyDuration = const Duration(seconds: 1),
  }) async* {
    while (true) {
      yield MDateTime.now;
      await Future.delayed(dailyDuration);
    }
  }

  setFormat(String format) {
    this.format = format;
  }

  MDateTime operator -(MDateTime other) => MDateTime(
        year - other.year,
        month: month - other.month,
        day: day - other.day,
        hour: hour - other.hour,
        minute: minute - other.minute,
        second: second - other.second,
        millisecond: millisecond - other.millisecond,
        microsecond: microsecond - other.microsecond,
      );

  @override
  String toString() => DateFormat(format).format(this);
}
