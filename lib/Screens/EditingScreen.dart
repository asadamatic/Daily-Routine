import 'package:dailyroutine/DataModels/Routine.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class EditingScreen extends StatefulWidget{

  @override
  State createState() {
    return EditingScreenState();
  }
}

class EditingScreenState extends State<EditingScreen>{

  //Text Editing Controller
  TextEditingController textEditingController;
  Map data = {};
  Routine routine;


  @override
  Widget build(BuildContext context) {

    data = ModalRoute.of(context).settings.arguments;
    routine = data['routine'];
    textEditingController = TextEditingController(text: routine.title);

    return Scaffold(
      appBar: AppBar(
        title: Text('${routine.startTime} - ${routine.endTime}', style: TextStyle(color: Colors.white),),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            child: TextField(
              autofocus: true,
              controller: textEditingController,
              maxLines: 5,
              decoration: InputDecoration(
                border: OutlineInputBorder()
              ),
            ),
          ),
          FlatButton(
            child: Text('Save Changes'),
            color: Colors.blue,
            textColor: Colors.white,
            onPressed: (){
              routine.title = textEditingController.text;
              Navigator.pop(context, {
                'routine': routine,
              });
            },
          )
        ],
      ),
    );
  }
}