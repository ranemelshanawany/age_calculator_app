import 'package:age/age.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
    Widget ageResult = _buildResultsRow();
    Widget nextBirthdayResult = _buildResultsRow();

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
    return Container(
      decoration: BoxDecoration(
          border: Border.all(width: 2, color: Colors.orange),
          color: Colors.white),
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
                showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime(2100))
                    .then((date) {
                  setState(() {
                    param["d"] = date;
                  });
                });
              },
            )
          ],
        ),
      ),
    );
  }

  var formatter = new DateFormat('dd-MM-yyyy');
  var birthday = {"d": DateTime.now()}; //to pass by reference, turned to var
  var endDay = {"d": DateTime.now()};
  String year, month, day;

  Widget _buildCalculateButton() {
    return FlatButton(
      color: Colors.orange,
      onPressed: () {
        AgeDuration age;
        age = Age.dateDifference(fromDate: birthday["d"], toDate: endDay["d"]);
        print(age);
      },
      child: Text("Calculate", style: TextStyle(fontSize: 20, color: Colors.white)),
    );
  }

  Widget _buildClearButton() {
    return FlatButton(
      color: Colors.orange,
      onPressed: () {
          AgeDuration age;
          age = Age.dateDifference(fromDate: birthday["d"], toDate: endDay["d"]);
      },
      child: Text("Clear", style: TextStyle(fontSize: 20, color: Colors.white)),
    );
  }

  Widget _buildResultColumn(String timeName) {
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
              ),
            )
          ],
        ),
      ),
    );
  }

  _buildResultsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        _buildResultColumn("Years"),
        SizedBox(
          width: 4,
        ),
        _buildResultColumn("Months"),
        SizedBox(
          width: 4,
        ),
        _buildResultColumn("Days")
      ],
    );
  }

  Widget _displayGreyText(String text) {
    return Text(text, style: TextStyle(color: Colors.black54, fontSize: 20));
  }
}
