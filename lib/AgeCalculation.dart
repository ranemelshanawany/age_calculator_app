import 'package:age/age.dart';
import 'package:flutter/cupertino.dart';

DateTime birthDay = DateTime.now();
DateTime today = DateTime.now();
String yearResult = "", monthResult = "", dayResult = "";
String monthsNextBirth = "", daysNextBirth = "", yearsNextBirth = "";

class AgeCalculate
{
  static Future<AgeDuration> calculateAge(context, AgeDuration age) async{

    if (birthDay != null && today != null) {
      age = Age.dateDifference(fromDate: birthDay, toDate: today);
      return age;
    }
    return age;
  }

  static Future<AgeDuration> calculateNextBirthday(context, AgeDuration age) async{
    var nextBirthday;
    if (birthDay != null && today != null) {
      if (birthDay.isBefore(today )) {
        int year = today.year + 1;
        int month = birthDay.month;
        int day = birthDay.day;
        nextBirthday = new DateTime(year, month, day);
      } else {
        int year = today.year;
        int month = birthDay.month;
        int day = birthDay.day;
        nextBirthday = new DateTime(year, month, day);
      }
      age = Age.dateDifference(fromDate: today, toDate: nextBirthday);
      return age;
    }
    return age;
  }
}