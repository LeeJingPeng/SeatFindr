import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:bordered_text/bordered_text.dart';

class layout extends StatefulWidget {
  final BluetoothDevice server;
  const layout({this.server});

  @override
  _layout createState() => _layout();
}

class _Message {
  int whom;
  String text;

  _Message(this.whom, this.text);
}

class Table {
  String table_name;
  int chairs_left;
  int max_chairs;
  bool display_clean = true;
  bool clean = true;
  String presses = "";
  String clear = "1121";
  Table(String tableName, int chairsLeft) {
    this.table_name = tableName;
    this.max_chairs = chairsLeft;
    this.chairs_left = chairsLeft;
  }

  void check_status(String button_state, String curr_task) {
    if (button_state == "1") {
      this.display_clean = true;
    }
    if (curr_task == "short_press") {
      this.display_clean = this.clean;
      this.presses += "1";
    } else if (curr_task == "long_press") {
      this.display_clean = this.clean;
      this.presses += "2";
    } else if (curr_task == "left_table") {
      this.display_clean = false;
      this.clean = false;
      this.presses = "";
    }
    if (this.presses.contains(this.clear)) {
      this.display_clean = true;
      this.clean = true;
      this.presses = "";
    }
  }

  void change_clean(bool new_status) {
    this.display_clean = new_status;
    this.clean = new_status;
  }

  void change_chairs(bool add) {
    if (add) {
      if (this.chairs_left < this.max_chairs) {
        this.chairs_left++;
      }
    } else {
      if (this.chairs_left > 0) {
        this.chairs_left--;
      }
    }
  }

  List display_status() {
    String str_chairs_left = this.chairs_left.toString();
    String str_max_chairs = this.max_chairs.toString();
    if (this.display_clean) {
      return ["Cleaned", str_chairs_left, str_max_chairs];
    } else {
      return ["Unclean", str_chairs_left, str_max_chairs];
    }
  }

  String get_name() {
    return this.table_name;
  }
}

class Chair {
  String chair_name;
  Table parent_table;
  bool occupied = false;
  Chair(String chairName, Table parentTable) {
    this.chair_name = chairName;
    this.parent_table = parentTable;
  }

  void check_status(String button_state, String curr_task) {
    if (curr_task != "left_table") {
      if (button_state == "1" && this.occupied == false) {
        this.occupied = true;
        this.parent_table.change_chairs(false);
      } else if (button_state == "0" && this.occupied == true) {
        if (this.occupied == true) {
          this.occupied = false;
          this.parent_table.change_chairs(true);
        }
      }
    }
  }

  String get_name() {
    return this.parent_table.get_name();
  }

  bool show_occupied() {
    return this.occupied;
  }
}

Table Table1 = Table("Table1", 3);
Table Table2 = Table("Table2", 2);
Chair Chair2_1 = Chair("Chair2_1", Table2);
Chair Chair2_2 = Chair("Chair2_2", Table2);
Table Table3 = Table("Table3", 2);
Chair Chair3_1 = Chair("Chair3_1", Table3);
Chair Chair3_2 = Chair("Chair3_2", Table3);
Table Table4 = Table("Table4", 3);
Table Table5 = Table("Table5", 2);
Chair Chair5_1 = Chair("Chair5_1", Table5);
Chair Chair5_2 = Chair("Chair5_2", Table5);
Table Table6 = Table("Table6", 2);
Table Table7 = Table("Table7", 3);
Table Table8 = Table("Table8", 2);
Table Table9 = Table("Table9", 2);
Chair Chair9_1 = Chair("Chair9_1", Table9);
Chair Chair9_2 = Chair("Chair9_2", Table9);
Table Table10 = Table("Table10", 3);
Chair Chair10_1 = Chair("Chair10_1", Table10);
Chair Chair10_2 = Chair("Chair10_2", Table10);
Chair Chair10_3 = Chair("Chair10_3", Table10);
Table Table11 = Table("Table11", 4); // delete

List tables = [
  Table2,
  Chair2_1,
  Chair2_2,
  Table3,
  Chair3_1,
  Chair3_2,
  Table5,
  Chair5_1,
  Chair5_2,
  Table9,
  Chair9_1,
  Chair9_2,
  Table10,
  Chair10_1,
  Chair10_2,
  Chair10_3
];
List table_names = [
  "Table2",
  "Chair2_1",
  "Chair2_2",
  "Table3",
  "Chair3_1",
  "Chair3_2",
  "Table5",
  "Chair5_1",
  "Chair5_2",
  "Table9",
  "Chair9_1",
  "Chair9_2",
  "Table10",
  "Chair10_1",
  "Chair10_2",
  "Chair10_3"
];
// ############################################
// ############################################
// ADD CHAIRS AND TABLES WHEN ARDUINO COMPLETED
// ############################################
// ############################################

Map<String, List> table_details = {
  "Table1": Table1.display_status(),
  "Table2": Table2.display_status(),
  "Table3": Table3.display_status(),
  "Table4": Table4.display_status(),
  "Table5": Table5.display_status(),
  "Table6": Table6.display_status(),
  "Table7": Table7.display_status(),
  "Table8": Table8.display_status(),
  "Table9": Table9.display_status(),
  "Table10": Table10.display_status(),
  "Table11": Table11.display_status(),
};

class _layout extends State<layout> {
  static final clientID = 0;
  BluetoothConnection connection;

  List<_Message> messages = List<_Message>();

  final TextEditingController textEditingController =
      new TextEditingController();
  final ScrollController listScrollController = new ScrollController();

  bool isConnecting = true;
  bool get isConnected => connection != null && connection.isConnected;

  bool isDisconnecting = false;

  String msg = "";

  @override
  void initState() {
    super.initState();

    BluetoothConnection.toAddress(widget.server.address).then((_connection) {
      print('Connected to the device');
      connection = _connection;
      setState(() {
        isConnecting = false;
        isDisconnecting = false;
      });

      connection.input.listen(_onDataReceived).onDone(() {
        // Example: Detect which side closed the connection
        // There should be `isDisconnecting` flag to show are we are (locally)
        // in middle of disconnecting process, should be set before calling
        // `dispose`, `finish` or `close`, which all causes to disconnect.
        // If we except the disconnection, `onDone` should be fired as result.
        // If we didn't except this (no flag set), it means closing by remote.
        if (isDisconnecting) {
          print('Disconnecting locally!');
        } else {
          print('Disconnected remotely!');
        }
        if (this.mounted) {
          setState(() {});
        }
      });
    }).catchError((error) {
      print('Cannot connect, exception occured');
      print(error);
    });
  }

  @override
  void dispose() {
    // Avoid memory leak (`setState` after dispose) and disconnect
    if (isConnected) {
      isDisconnecting = true;
      connection.dispose();
      connection = null;
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: (isConnecting
                ? Text('Connecting to ' + widget.server.name + '...')
                : isConnected
                    ? Text('Live update from ' + widget.server.name)
                    : Text('Update log from ' + widget.server.name))),
        body: Row(children: <Widget>[
          Column(children: <Widget>[
            Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
              Container(
                  width: 150,
                  height: 70,
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  margin: const EdgeInsets.only(
                      top: 0.0, bottom: 0.0, left: 120.0, right: 10.0),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: table_details["Table1"][0] == "Cleaned"
                        ? Colors.green[200]
                        : Colors.red[300],
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  child: Column(children: <Widget>[
                    const Text("Table1",
                        style: TextStyle(
                            fontStyle: FontStyle.italic, fontSize: 10.0)),
                    BorderedText(
                        strokeWidth: 2.0,
                        child: Text(table_details["Table1"][1],
                            style: TextStyle(
                                color: table_details["Table1"][1] ==
                                        table_details["Table1"][2]
                                    ? Colors.green
                                    : Colors.red,
                                fontSize: 30))),
                    Text(table_details["Table1"][0],
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 10.0)), // Chairs Left
                  ])),
              Container(
                  width: 80,
                  height: 70,
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  margin: const EdgeInsets.symmetric(
                      vertical: 0.0, horizontal: 10.0),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: table_details["Table2"][0] == "Cleaned"
                        ? Colors.green[200]
                        : Colors.red[300],
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  child: Column(children: <Widget>[
                    const Text("Table2",
                        style: TextStyle(
                            fontStyle: FontStyle.italic, fontSize: 10.0)),
                    BorderedText(
                        strokeWidth: 2.0,
                        child: Text(table_details["Table2"][1],
                            style: TextStyle(
                                color: table_details["Table2"][1] ==
                                        table_details["Table2"][2]
                                    ? Colors.green
                                    : Colors.red,
                                fontSize: 30))),
                    Text(table_details["Table2"][0],
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 10.0)), // Chairs Left
                  ])),
              Container(
                  width: 80,
                  height: 70,
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  margin: const EdgeInsets.symmetric(
                      vertical: 0.0, horizontal: 10.0),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: table_details["Table3"][0] == "Cleaned"
                        ? Colors.green[200]
                        : Colors.red[300],
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  child: Column(children: <Widget>[
                    const Text("Table3",
                        style: TextStyle(
                            fontStyle: FontStyle.italic, fontSize: 10.0)),
                    BorderedText(
                        strokeWidth: 2.0,
                        child: Text(table_details["Table3"][1],
                            style: TextStyle(
                                color: table_details["Table3"][1] ==
                                        table_details["Table3"][2]
                                    ? Colors.green
                                    : Colors.red,
                                fontSize: 30))),
                    Text(table_details["Table3"][0],
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 10.0)), // Chairs Left
                  ])),
              Container(
                  width: 135,
                  height: 70,
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  margin: const EdgeInsets.only(
                      top: 5.0, bottom: 5.0, left: 10.0, right: 10.0),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: table_details["Table4"][0] == "Cleaned"
                        ? Colors.green[200]
                        : Colors.red[300],
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  child: Column(children: <Widget>[
                    const Text("Table4",
                        style: TextStyle(
                            fontStyle: FontStyle.italic, fontSize: 10.0)),
                    BorderedText(
                        strokeWidth: 2.0,
                        child: Text(table_details["Table4"][1],
                            style: TextStyle(
                                color: table_details["Table4"][1] ==
                                        table_details["Table4"][2]
                                    ? Colors.green
                                    : Colors.red,
                                fontSize: 30))),
                    Text(table_details["Table4"][0],
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 10.0)), // Chairs Left
                  ])),
            ]),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              Container(
                  width: 90,
                  height: 90,
                  padding: const EdgeInsets.symmetric(vertical: 12.5),
                  margin: const EdgeInsets.only(
                      top: 0.0, bottom: 5.0, left: 125.0, right: 50.0),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: table_details["Table5"][0] == "Cleaned"
                        ? Colors.green[200]
                        : Colors.red[300],
                    borderRadius: BorderRadius.all(Radius.circular(100.0)),
                  ),
                  child: Column(children: <Widget>[
                    const Text("Table5",
                        style: TextStyle(
                            fontStyle: FontStyle.italic, fontSize: 10.0)),
                    BorderedText(
                        strokeWidth: 2.0,
                        child: Text(table_details["Table5"][1],
                            style: TextStyle(
                                color: table_details["Table5"][1] ==
                                        table_details["Table5"][2]
                                    ? Colors.green
                                    : Colors.red,
                                fontSize: 30))),
                    Text(table_details["Table5"][0],
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 10.0)), // Chairs Left
                  ])),
              Container(
                  width: 90,
                  height: 90,
                  padding: const EdgeInsets.symmetric(vertical: 12.5),
                  margin: const EdgeInsets.only(
                      top: 0.0, bottom: 5.0, left: 50.0, right: 2.5),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: table_details["Table6"][0] == "Cleaned"
                        ? Colors.green[200]
                        : Colors.red[300],
                    borderRadius: BorderRadius.all(Radius.circular(100.0)),
                  ),
                  child: Column(children: <Widget>[
                    const Text("Table6",
                        style: TextStyle(
                            fontStyle: FontStyle.italic, fontSize: 10.0)),
                    BorderedText(
                        strokeWidth: 2.0,
                        child: Text(table_details["Table6"][1],
                            style: TextStyle(
                                color: table_details["Table6"][1] ==
                                        table_details["Table6"][2]
                                    ? Colors.green
                                    : Colors.red,
                                fontSize: 30))),
                    Text(table_details["Table6"][0],
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 10.0)), // Chairs Left
                  ])),
            ]),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              Container(
                  width: 150,
                  height: 70,
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  margin: const EdgeInsets.only(
                      top: 0.0, bottom: 0.0, left: 120.0, right: 10.0),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: table_details["Table7"][0] == "Cleaned"
                        ? Colors.green[200]
                        : Colors.red[300],
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  child: Column(children: <Widget>[
                    const Text("Table7",
                        style: TextStyle(
                            fontStyle: FontStyle.italic, fontSize: 10.0)),
                    BorderedText(
                        strokeWidth: 2.0,
                        child: Text(table_details["Table7"][1],
                            style: TextStyle(
                                color: table_details["Table7"][1] ==
                                        table_details["Table7"][2]
                                    ? Colors.green
                                    : Colors.red,
                                fontSize: 30))),
                    Text(table_details["Table7"][0],
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 10.0)), // Chairs Left
                  ])),
              Container(
                  width: 80,
                  height: 70,
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  margin: const EdgeInsets.symmetric(
                      vertical: 0.0, horizontal: 10.0),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: table_details["Table8"][0] == "Cleaned"
                        ? Colors.green[200]
                        : Colors.red[300],
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  child: Column(children: <Widget>[
                    const Text("Table8",
                        style: TextStyle(
                            fontStyle: FontStyle.italic, fontSize: 10.0)),
                    BorderedText(
                        strokeWidth: 2.0,
                        child: Text(table_details["Table8"][1],
                            style: TextStyle(
                                color: table_details["Table8"][1] ==
                                        table_details["Table8"][2]
                                    ? Colors.green
                                    : Colors.red,
                                fontSize: 30))),
                    Text(table_details["Table8"][0],
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 10.0)), // Chairs Left
                  ])),
              Container(
                  width: 80,
                  height: 70,
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  margin: const EdgeInsets.symmetric(
                      vertical: 0.0, horizontal: 10.0),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: table_details["Table9"][0] == "Cleaned"
                        ? Colors.green[200]
                        : Colors.red[300],
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  child: Column(children: <Widget>[
                    const Text("Table9",
                        style: TextStyle(
                            fontStyle: FontStyle.italic, fontSize: 10.0)),
                    BorderedText(
                        strokeWidth: 2.0,
                        child: Text(table_details["Table9"][1],
                            style: TextStyle(
                                color: table_details["Table9"][1] ==
                                        table_details["Table9"][2]
                                    ? Colors.green
                                    : Colors.red,
                                fontSize: 30))),
                    Text(table_details["Table9"][0],
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 10.0)), // Chairs Left
                  ])),
              Container(
                  width: 135,
                  height: 70,
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  margin: const EdgeInsets.only(
                      top: 5.0, bottom: 5.0, left: 10.0, right: 10.0),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: table_details["Table10"][0] == "Cleaned"
                        ? Colors.green[200]
                        : Colors.red[300],
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  child: Column(children: <Widget>[
                    const Text("Table10",
                        style: TextStyle(
                            fontStyle: FontStyle.italic, fontSize: 10.0)),
                    BorderedText(
                        strokeWidth: 2.0,
                        child: Text(table_details["Table10"][1],
                            style: TextStyle(
                                color: table_details["Table10"][1] ==
                                        table_details["Table10"][2]
                                    ? Colors.green
                                    : Colors.red,
                                fontSize: 30))),
                    Text(table_details["Table10"][0],
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 10.0)), // Chairs Left
                  ]))
            ]),
          ]),
        ]));
  }

  void _onDataReceived(Uint8List data) {
    String data_chunk = ascii.decode(data);
    msg += data_chunk;
    //print("!" + msg + "!");
    var trimmed = msg.trim();
    if (msg[msg.length - 1] == "\n" || trimmed.split(" ").length == 4) {
      // consider changing to "&&"
      print(msg);
      try {
        msg = msg.trim();
        List lst = msg.split(" ");
        String parent_table_name;
        if (lst[0].contains("Chair")) {
          Chair chair = tables[table_names.indexOf(lst[0])];
          chair.check_status(lst[1], lst[2]);
          parent_table_name = chair.get_name();
        } else if (lst[0].contains("Table")) {
          Table table = tables[table_names.indexOf(lst[0])];
          table.check_status(lst[1], lst[2]);
          parent_table_name = table.get_name();
        }
        Table parentTable = tables[table_names.indexOf(parent_table_name)];
        setState(() {
          table_details[parent_table_name] = parentTable.display_status();
        });
        //List all_status = table.display_status();
        //print(all_status);
        msg = "";
      } on Error {
        msg = "";
      }
    } else if (trimmed.split(" ").length > 4) {
      msg = "";
    }
  }
}
