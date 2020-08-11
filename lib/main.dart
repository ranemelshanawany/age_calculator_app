import 'package:age/age.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
            title: Text("Age Calculator"),
            backgroundColor: Colors.orange,
            actions: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.more_vert,
                  color: Colors.white,
                  size: 30,
                ),
                onPressed: () {},
              )
            ]),
        body: SafeArea(child: HomePage()),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    Widget birthDateInsert = _buildDateSelect(birthday);
    Widget todayInsert = _buildDateSelect(endDay);

    Widget clearOrCalcButtons = IntrinsicHeight(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(child: _buildClearButton()),
        SizedBox(width: 20),
        Expanded(child: _buildCalculateButton()),
      ],
    ));
    Widget ageResult = _buildResultsRow(false);
    Widget nextBirthdayResult = _buildResultsRow(true);

    return Padding(
      padding: const EdgeInsets.only(top: 30.0, left: 16, right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          _displayGreyText("Date of Birth"),
          SizedBox(
            height: 10,
          ),
          birthDateInsert,
          SizedBox(
            height: 13,
          ),
          _displayGreyText("Today Date"),
          SizedBox(
            height: 10,
          ),
          todayInsert,
          SizedBox(
            height: 13,
          ),
          clearOrCalcButtons,
          SizedBox(
            height: 13,
          ),
          _displayGreyText("Age is"),
          SizedBox(
            height: 13,
          ),
          ageResult,
          SizedBox(
            height: 13,
          ),
          _displayGreyText("Next Birth Day in"),
          SizedBox(
            height: 13,
          ),
          nextBirthdayResult,
        ],
      ),
    );
  }

  _buildDateSelect(param) {
    return InkWell(
      onTap: () {
        _showCalender(context, param);
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(width: 2, color: Colors.orange),
        ),
        padding: EdgeInsets.only(left: 5),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                param["d"] == null
                    ? formatter.format(DateTime.now()).toString()
                    : formatter.format(param["d"]).toString(),
                style: TextStyle(fontSize: 20, color: Colors.black54),
              ),
              IconButton(
                icon: Icon(
                  Icons.date_range,
                  color: Colors.orange,
                  size: 38,
                ),
                onPressed: () {
                  _showCalender(context, param);
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  var formatter = new DateFormat('dd-MM-yyyy');
  var birthday = {"d": DateTime.now()}; //to pass by reference, turned to var
  var endDay = {"d": DateTime.now()};
  String yearResult = "", monthResult = "", dayResult = "";
  String monthsNextBirth = "", daysNextBirth = "", yearsNextBirth = "";

  _showCalender(context, param) {
    showDatePicker(
            context: context,
            initialDate: param["d"],
            firstDate: DateTime(1900),
            lastDate: DateTime(2100),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.orange,
            ),
          ),
          child: child,
        );
      },
    )
        .then((date) {
      setState(() {
        param["d"] = date;
      });
    });
  }

  Widget _buildCalculateButton() {
    return FlatButton(
      color: Colors.orange,
      onPressed: () {
        AgeDuration age;
        AgeDuration toNextBirthday;
        if (endDay["d"].isAfter(birthday["d"])) {
          _calculateAge(age);
          _calculateNextBirthday(toNextBirthday);
        }
        else
          {
            _showAlertDialog(context);
          }
      },
      child: Text("Calculate",
          style: TextStyle(fontSize: 20, color: Colors.white)),
    );
  }

  _calculateAge(AgeDuration age) {
    if (birthday["d"] != null && endDay["d"] != null) {
      age = Age.dateDifference(fromDate: birthday["d"], toDate: endDay["d"]);
      setState(() {
        yearResult = age.years.toString();
        monthResult = age.months.toString();
        dayResult = age.days.toString();
      });
    }
  }

  _calculateNextBirthday(AgeDuration age) {
    var nextBirthday;
    if (birthday["d"] != null && endDay["d"] != null) {
      if (birthday["d"].isBefore(endDay["d"])) {
        int year = endDay["d"].year + 1;
        int month = birthday["d"].month;
        int day = birthday["d"].day;
        nextBirthday = new DateTime(year, month, day);
      } else {
        int year = endDay["d"].year;
        int month = birthday["d"].month;
        int day = birthday["d"].day;
        nextBirthday = new DateTime(year, month, day);
      }

      setState(() {
        age = Age.dateDifference(fromDate: endDay["d"], toDate: nextBirthday);
        monthsNextBirth = age.months.toString();
        daysNextBirth = age.days.toString();
        yearsNextBirth = age.years.toString();
        if (age.years == 0 && age.months == 0 && age.days == 0) {
          yearsNextBirth = "1";
        }
      });
    }
  }

  Widget _buildClearButton() {
    return FlatButton(
      color: Colors.orange,
      onPressed: () {
        setState(() {
          yearResult = "";
          monthResult = "";
          dayResult = "";
          yearsNextBirth = "";
          monthsNextBirth = "";
          daysNextBirth = "";
        });
      },
      child: Text("Clear", style: TextStyle(fontSize: 20, color: Colors.white)),
    );
  }

  Widget _buildResultColumn(String timeName, bool nextBirthDay) {
    return Expanded(
      child: AspectRatio(
        aspectRatio: 100 / 60,
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                color: Colors.orange,
                child: Center(
                    child: Text(
                  timeName,
                  style: TextStyle(color: Colors.white, fontSize: 20),
                )),
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 2, color: Colors.orange),
                  color: Colors.white,
                ),
                child: Center(
                  child: Text((() {
                        if (timeName == "Years") {
                          if (nextBirthDay) {
                            return yearsNextBirth;
                          }
                          return yearResult;
                        } else if (timeName == "Months") {
                          if (nextBirthDay) {
                            return monthsNextBirth;
                          }
                          return monthResult;
                        } else if (timeName == "Days") {
                          if (nextBirthDay) {
                            return daysNextBirth;
                          }
                          return dayResult;
                        }
                        return " ";
                      })() ??
                      " "),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _buildResultsRow(bool nextBirthday) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        _buildResultColumn("Years", nextBirthday),
        SizedBox(
          width: 4,
        ),
        _buildResultColumn("Months", nextBirthday),
        SizedBox(
          width: 4,
        ),
        _buildResultColumn("Days", nextBirthday)
      ],
    );
  }

  Widget _displayGreyText(String text) {
    return Text(text, style: TextStyle(color: Colors.black54, fontSize: 20));
  }

  _showAlertDialog(BuildContext context) {

    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Input Error!"),
      content: Text("Today's date cannot be before your birth date. Enter date again."),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }


}

