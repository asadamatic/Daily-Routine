import 'dart:async';

import 'package:dailyroutine/DataModels/Routine.dart';
import 'package:dailyroutine/Screens/HomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomeScreen> {

  //Database Setup
  Future<Database> database;

  void initializeDB() async{

    database = openDatabase(
      join(await getDatabasesPath(), 'routine.db'),
      onCreate: (db, version){

        return db.execute("CREATE TABLE ROUTINE(start_time TEXT PRIMARY KEY, end_time TEXT UNIQUE, title TEXT, status TEXT)");
      },
      version: 1,
    );
  }

  Future<void> insert() async{

    Database db = await database;

    Batch batch = db.batch();

    for (int index = 0; index < routineList.length; index++){
      batch.insert('ROUTINE', routineList[index].toMap(), conflictAlgorithm: ConflictAlgorithm.ignore);
    }
    batch.commit();
  }

  void insertData() async{

    await insert();
  }

  Future<List<Map<String, dynamic>>> retrieve() async{

    Database db = await database;
    List<Map<String, dynamic>> list = await db.query('ROUTINE');

    return list;
  }

  void retrieveList() async{

    List<Map<String, dynamic>> tempList = await retrieve();
    List<Routine> tempRoutineList = List();

    for (int index = 0; index < tempList.length; index++){
      tempRoutineList.add(Routine(startTime: tempList[index]['start_time'], endTime: tempList[index]['end_time'], title: tempList[index]['title'], status: getStatus(tempList[index]['status'])));
    }
    setState(() {

      routineListDB = tempRoutineList;
    });

  }

  Future<void> update(Routine routine) async{

    Database db = await database;

    db.update('ROUTINE',
      routine.toMap(),
      where: 'start_time = ?',
      whereArgs: [routine.startTime],
    );
  }

  void updateData(Routine routine) async{

    await update(routine);
  }
  bool getStatus(String value) {

    return value == 'true' ? true : false;
  }
  //Date time controllers
  DateTime time = DateTime.now();

  //Appbar height controller
  double appBarHeight = 270.0;

  //Routine List
  List<Routine> routineList = RoutineList().getList();
  List<Routine> routineListDB = List();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    initializeDB();
    Future.delayed(Duration(seconds: 2)).then((value) {

      insertData();
    });
    Future.delayed(Duration(seconds: 2)).then((value) {

      retrieveList();
    });
  }
  @override
  Widget build(BuildContext context) {
    print(time);
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: <Widget>[

          SliverAppBar(
            expandedHeight: 270.0,
            flexibleSpace: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints){

                appBarHeight = constraints.constrainHeight();
                return appBarHeight > 240 ? FlexibleSpaceBar(
                  background:  Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('Assets/header.jpg'),
                                fit: BoxFit.cover
                            ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: [Colors.greenAccent.withOpacity(.3), Colors.green.withOpacity(.6),
                                ]
                            ),
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(50.0),
                                bottomRight: Radius.circular(50.0)
                            )
                        ),
                      ),
                    ],
                  ),
                  centerTitle: true,
                  title: Container(
                    margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text('GOOD', style: TextStyle(color: Colors.white, fontSize: 36.0, fontWeight: FontWeight.bold),),
                                Text(time.hour >= 4 && time.hour < 12? 'MORNING': time.hour >= 12 && time.hour < 17 ? 'AFTERNOON' : time.hour >= 17 && time.hour < 20 ? 'EVENING': time.hour >= 20 ? 'NIGHT': '', style: TextStyle(color: Colors.white, fontSize: 36.0, fontWeight: FontWeight.bold),),
                              ],
                            ),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10.0),
                          height: 3.0,
                          width: 100.0,
                          color: Colors.white,
                        )
                      ],
                    ),
                  ),
                ) : FlexibleSpaceBar(
                  background:  Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      Image(
                        image: AssetImage('Assets/header.jpg'),
                        fit: BoxFit.cover,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [Colors.greenAccent.withOpacity(.3), Colors.green.withOpacity(.6),
                              ]
                          ),
                        ),
                      ),
                    ],
                  ),
                  centerTitle: true,
                );
              },
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                SizedBox(height: 30.0,)
              ]
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              routineListDB.map((routine) => RoutineCard(key: UniqueKey(), routine: routine, updateData: updateData,),).toList(),
            ),
          )
        ],
      ),
    );
  }
}



class RoutineCard extends StatefulWidget{

  Function updateData;
  Routine routine;
  Key key;
  RoutineCard({this.key, this.routine, this.updateData});

  @override
  State createState() {
    return RoutineCardState();
  }
}

class RoutineCardState extends State<RoutineCard>{

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5.0,
      margin: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
      shape: ContinuousRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.0),
        margin: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
        child: CheckboxListTile(
          value: widget.routine.status,
          controlAffinity: ListTileControlAffinity.leading,
          title: Container(
            margin: EdgeInsets.symmetric(vertical: 10.0),
            child: Text('${widget.routine.startTime} - ${widget.routine.endTime}', style: TextStyle(fontSize: 18.0, color: Colors.black87, fontWeight: FontWeight.bold, letterSpacing: 1.0),),
          ),
          subtitle: Container(
            margin: EdgeInsets.symmetric(vertical: 10.0),
            child: Text('${widget.routine.title}', maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 15.0, color: Colors.black.withOpacity(.7), letterSpacing: 0.8),),
          ),
          secondary: IconButton(
            icon: Icon(
              Icons.edit,
            ),
            onPressed: () async{
               dynamic result = await Navigator.pushNamed(context, '/edit', arguments: {
                'routine': widget.routine,
              });
               if (result != null){
                 setState(() {
                   widget.updateData(result['routine']);
                 });
               }

            },
          ),
          onChanged: (newValue){
            setState(() {
              widget.routine.status = newValue;
            });

            widget.updateData(widget.routine);
          },
        ),
      ),
    );
  }
}
