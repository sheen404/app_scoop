import 'package:app_scoop/models/reminder.dart';
import 'package:app_scoop/ui/new_entry/new_entry_bloc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../global_bloc.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
  final Reminder reminder;
  HomePage({this.reminder});
}

DateTime selectedDate = DateTime.now();

class _HomePageState extends State<HomePage> {
  GlobalKey<ScaffoldState> _scaffoldKey;

  void initState() {
    super.initState();
    _scaffoldKey = GlobalKey<ScaffoldState>();
  }

  @override
  Widget build(BuildContext context) {
    final GlobalBloc _globalBloc = Provider.of<GlobalBloc>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        color: Color(0xFFF6F8FC),
        child: Column(
          children: <Widget>[
            Flexible(
              flex: 12,
              child: TopContainer(),
            ),
            SizedBox(
              height: 10,
            ),
            Flexible(
              flex: 7,
              child: Provider<GlobalBloc>.value(
                child: BottomContainer(),
                value: _globalBloc,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TopContainer extends StatefulWidget {
  @override
  _TopContainerState createState() => _TopContainerState();
}

class _TopContainerState extends State<TopContainer> {
  TextEditingController taskController;
  TextEditingController descriptionController;
  NewEntryBloc _newEntryBloc;

  void dispose() {
    super.dispose();
    taskController.dispose();
    descriptionController.dispose();
    _newEntryBloc.dispose();
  }

  void initState() {
    super.initState();
    _newEntryBloc = NewEntryBloc();
    taskController = TextEditingController();
    descriptionController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final GlobalBloc _globalBloc = Provider.of<GlobalBloc>(context);
    return SafeArea(
        child: Provider<NewEntryBloc>.value(
      value: _newEntryBloc,
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Deadline:",
                  style: TextStyle(fontSize: 15),
                ),
                GestureDetector(
                  onTap: () => _selectDate(context),
                  child: Container(
                    margin:
                        EdgeInsets.only(bottom: 10.0, right: 10.0, top: 10.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(color: Colors.grey)),
                    width: 240,
                    height: 50,
                    //padding: EdgeInsets.only(bottom: 10.0, right: 10.0),
                    child: Center(
                      child: Text(
                        "${selectedDate.toLocal()}".split(' ')[0],
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 11.0),
                  child: Text(
                    "Task:",
                    style: TextStyle(fontSize: 15),
                  ),
                ),
                Container(
                  width: 250.0,
                  padding: EdgeInsets.only(bottom: 10.0, right: 10.0),
                  child: TextField(
                      controller: taskController,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                          color: Colors.red,
                          style: BorderStyle.solid,
                        )),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      )),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Text(
                    "Description:",
                    style: TextStyle(fontSize: 15),
                  ),
                ),
                Container(
                  width: 250,
                  padding: EdgeInsets.only(bottom: 10.0, right: 10.0),
                  child: TextField(
                      controller: descriptionController,
                      maxLines: 5,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                          color: Colors.red,
                          style: BorderStyle.solid,
                        )),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      )),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: RaisedButton(
                      onPressed: () {
                        String task;
                        String description;
                        DateTime deadline =
                            _newEntryBloc.selectedDeadline$.value;
                        if (taskController.text != "") {
                          task = taskController.text;
                        }
                        if (descriptionController.text != "") {
                          description = descriptionController.text;
                        }

                        Reminder newEntryReminder = Reminder(
                          task: task,
                          description: description,
                          deadline: deadline,
                        );
                        taskController.clear();
                        descriptionController.clear();
                        _globalBloc.updateReminderList(newEntryReminder);

                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) => HomePage(),
                            ),
                            ModalRoute.withName('/'));
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => SuccessScreen(),
                        //   ),
                        // );
                      },
                      color: Colors.white,
                      child: Text("Add/Save"),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: BorderSide(
                          color: Colors.grey,
                        ),
                      )),
                ),
              ],
            ),
            Divider(
              thickness: 2.0,
              color: Colors.grey,
            ),
            Text(
              "TODO",
              style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
            ),
            Divider(
              thickness: 5.0,
              color: Colors.grey,
            ),
          ])),
    ));
  }

  _selectDate(BuildContext context) async {
    //final NewEntryBloc _newEntryBloc = Provider.of<NewEntryBloc>(context);
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate, // Refer step 1
      firstDate: DateTime.now(),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
    _newEntryBloc.updateDeadline(selectedDate.toLocal());
  }
}

class BottomContainer extends StatelessWidget {
  final Reminder reminder;
  BottomContainer({this.reminder});

  @override
  Widget build(BuildContext context) {
    final GlobalBloc _globalBloc = Provider.of<GlobalBloc>(context);
    return StreamBuilder<List<Reminder>>(
      stream: _globalBloc.reminderList$,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container();
        } else if (snapshot.data.length == 0) {
          return Container(
            color: Color(0xFFF6F8FC),
            child: Center(
              child: Text(
                "Add a Reminder",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 24,
                    color: Color(0xFFC9C9C9),
                    fontWeight: FontWeight.bold),
              ),
            ),
          );
        } else {
          return Container(
            color: Color(0xFFF6F8FC),
            child: ListView.builder(
              padding: EdgeInsets.only(top: 12),
              // gridDelegate:
              //     SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                return ReminderCard(snapshot.data[index]);
              },
            ),
          );
        }
      },
    );
  }
}

class ReminderCard extends StatefulWidget {
  final Reminder reminder;

  ReminderCard(this.reminder);

  @override
  _ReminderCardState createState() => _ReminderCardState();
}

class _ReminderCardState extends State<ReminderCard> {
  bool showValue = false;

  @override
  Widget build(BuildContext context) {
    final GlobalBloc _globalBloc = Provider.of<GlobalBloc>(context);
    var now = new DateTime.now();
    var isSame;
    var date = widget.reminder.deadline.toLocal().toString();
    return GestureDetector(
      onLongPress: () => openAlertBox(context, _globalBloc),
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: InkWell(
          highlightColor: Colors.white,
          splashColor: Colors.grey,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Material(
                    color: Colors.transparent,
                    child: Text(
                      widget.reminder.task,
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Text(
                    date.split(' ')[0],
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: (isSame =
                                widget.reminder.deadline.isAtSameMomentAs(now))
                            ? Colors.red
                            : Colors.black),
                  ),
                  Transform.scale(
                    scale: 1.3,
                    child: Checkbox(
                      value: showValue,
                      checkColor: Colors.green,
                      activeColor: Colors.white,
                      onChanged: (bool value) {
                        setState(() {
                          this.showValue = value;
                        });
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  openAlertBox(BuildContext context, GlobalBloc _globalBloc) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(30.0),
              ),
            ),
            contentPadding: EdgeInsets.only(top: 10.0),
            content: Container(
              width: 300.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(18),
                    child: Center(
                      child: Text(
                        "Delete this Reminder?",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          _globalBloc.removeReminder(widget.reminder);
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) => HomePage(),
                              ),
                              ModalRoute.withName('/'));
                        },
                        child: InkWell(
                          child: Container(
                            width: MediaQuery.of(context).size.width / 2.743,
                            padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                            decoration: BoxDecoration(
                              color: Color(0xFF3EB16F),
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(30.0),
                              ),
                            ),
                            child: Text(
                              "Yes",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: InkWell(
                          child: Container(
                            width: MediaQuery.of(context).size.width / 2.743,
                            padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                            decoration: BoxDecoration(
                              color: Colors.red[700],
                              borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(30.0)),
                            ),
                            child: Text(
                              "No",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }
}
