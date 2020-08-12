import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'AgeCalculation.dart';
import 'package:age/age.dart';

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
    Widget birthDateInsert = _buildBirthDateSelect();
    Widget todayInsert = _buildEndDateSelect();
    Widget clearAndCalcButtons = _buildClearCalcRow();
    Widget ageResult = _buildResultsRow(false);
    Widget nextBirthdayResult = _buildResultsRow(true);

    return Padding(
      padding: const EdgeInsets.only(top: 30.0, left: 16, right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          _displayGreyText("Date of Birth"),
          spacing(10),
          birthDateInsert,
          spacing(13),
          _displayGreyText("Today Date"),
          spacing(10),
          todayInsert,
          spacing(13),
          clearAndCalcButtons,
          spacing(13),
          _displayGreyText("Age is"),
          spacing(13),
          ageResult,
          spacing(13),
          _displayGreyText("Next Birth Day in"),
          spacing(13),
          nextBirthdayResult,
        ],
      ),
    );
  }

  var formatter = new DateFormat('dd-MM-yyyy');

  _buildBirthDateSelect() {
    return InkWell(
      onTap: () {
        _showCalender(context);
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
                _displayDate(birthDay),
                style: TextStyle(fontSize: 20, color: Colors.black54),
              ),
              IconButton(
                icon: _displayDateIcon(),
                onPressed: () {
                  _showCalender(context).then((date) {
                    setState(() {
                      birthDay = date;
                    });
                  });
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  _buildEndDateSelect() {
    return InkWell(
      onTap: () {
        _showCalender(context);
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
                _displayDate(today),
                style: TextStyle(fontSize: 20, color: Colors.black54),
              ),
              IconButton(
                icon: _displayDateIcon(),
                onPressed: () {
                  _showCalender(context).then((date) {
                    setState(() {
                      today = date;
                    });
                  });
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  _showCalender(context) {
    return showDatePicker(
      context: context,
      initialDate: DateTime.now(),
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
    );
  }

  Widget _buildClearCalcRow() {
    return IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(child: _buildClearButton()),
            spacing(20),
            Expanded(child: _buildCalculateButton()),
          ],
        ));
  }

  Widget _buildCalculateButton() {
    return FlatButton(
      color: Colors.orange,
      onPressed: () {
        AgeDuration age;
        AgeDuration toNextBirthday;
        if (today.isAfter(birthDay) || today.isAtSameMomentAs(birthDay)) {
          AgeCalculate.calculateAge(context, age).then((result) {
            setState(() {
              yearResult = result.years.toString();
              monthResult = result.months.toString();
              dayResult = result.days.toString();
            });
          });
          AgeCalculate.calculateNextBirthday(context, toNextBirthday).then((result) {
            setState(() {
              monthsNextBirth = result.months.toString();
              daysNextBirth = result.days.toString();
              yearsNextBirth = result.years.toString();
              if (result.years == 0 && result.months == 0 && result.days == 0) {
                yearsNextBirth = "1";
              }
            });
          });
        } else {
          _showAlertDialog(context);
        }
      },
      child: Text("Calculate",
          style: TextStyle(fontSize: 20, color: Colors.white)),
    );
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
        spacing(4),
        _buildResultColumn("Months", nextBirthday),
        spacing(4),
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
      content: Text(
          "Today's date cannot be before your birth date. Enter date again."),
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

  Widget spacing(double size) {
    return SizedBox(
      height: size,
    );
  }

  _displayDate(DateTime date)
  {
    return date == null
        ? formatter.format(DateTime.now()).toString()
        : formatter.format(date).toString();
  }

  _displayDateIcon()
  {
    return Icon(
      Icons.date_range,
      color: Colors.orange,
      size: 38,
    );
  }
}
