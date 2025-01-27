import 'package:flutter/material.dart';

//import 'package:login_app/sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirstRoute extends StatefulWidget {
  @override
  _FirstRoute createState() => new _FirstRoute();
}

class _FirstRoute extends State<FirstRoute> {
  final databaseReference = Firestore.instance;
  _FirstRoute createState() => new _FirstRoute();
  String text = "Select Documentation from top left menu";
  String pageTitle = "Documentation";
  String userName = "nick308";
  String buttonText = "";
  String collectionSuffix = "";
  String formVal1 = "";
  String formVal2 = "";
  String formVal3 = "";
  final _formKey = GlobalKey<FormState>();
  final myController1 = TextEditingController();
  final myController2 = TextEditingController();
  final myController3 = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController1.dispose();
    super.dispose();
  }

  void createRecord() async {
    await databaseReference
        .collection(userName + collectionSuffix)
        .document(myController1.text)
        .setData({
      formVal1: myController1.text,
      formVal2: myController2.text,
      formVal3: myController3.text
    });
    myController1.text = "";
    myController2.text = "";
    myController3.text = "";

    getData();
  }

  void createOrSave() async {
    int found = 0;
    QuerySnapshot _myDoc = await Firestore.instance
        .collection(userName + collectionSuffix)
        .getDocuments();
    List<DocumentSnapshot> _myDocCount = _myDoc.documents;
    for (var item in _myDocCount) {
      if (myController1.text == item.documentID) {
        found = 1;
      }
      print(myController1.text + " = " + item.documentID);
    }
    if (found == 1) {
      saveData();
    } else {
      createRecord();
    }
    ; // Count of Documents in Collection
  }

  void updateData(String coll, String doc, String field, String value) {
    try {
      databaseReference
          .collection(coll)
          .document(doc)
          .updateData({field: value});
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void saveData() {
    //text = myController1.text;

    updateData(userName + collectionSuffix, myController1.text, formVal2,
        myController2.text);
    updateData(userName + collectionSuffix, myController1.text, formVal3,
        myController3.text);
    myController1.text = "";
    myController2.text = "";
    myController3.text = "";

    getData();
  }

  void deleteData() {
    try {
      databaseReference
          .collection(userName + collectionSuffix)
          .document(myController1.text)
          .delete();
    } catch (e) {
      print(e.toString());
    }
    myController1.text = "";
    myController2.text = "";
    myController3.text = "";

    getData();
  }

  void getData() {
    String val = "";
    databaseReference
        .collection(userName + collectionSuffix)
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      //snapshot.documents.forEach((f) => print('${f.data.values.elementAt(x)}'));
      snapshot.documents.forEach((f) => val = '${f.data.values.elementAt(1)}' +
          "      " +
          '${f.data.values.elementAt(2)}' +
          "              " +
          '${f.data.values.elementAt(0)}' +
          '\n' +
          val);

      setState(() {
        //text = "name        dosage       schedule" + '\n' + '\n' + val;
        text = val;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      drawer: new Drawer(
        child: new ListView(
          children: <Widget>[
            new Container(child: new DrawerHeader(child: new Container())),
            new Container(
              child: new Column(children: <Widget>[
                new ListTile(
                    leading: new Icon(Icons.info),
                    title: Text('Medications'),
                    onTap: () {
                      buttonText = "Medication";
                      pageTitle = "My Medications";
                      formVal1 = "Name of medication";
                      formVal2 = "Dosage";
                      formVal3 = "Day/Time";
                      collectionSuffix = "_meds";
                      getData();
                      Navigator.pop(context);
                    }),
                new ListTile(
                    leading: new Icon(Icons.info),
                    title: Text('Vitals'),
                    onTap: () {
                      buttonText = "Vitals";
                      pageTitle = "My Vitals";

                      formVal1 = "Vital Type";
                      formVal2 = "Value";
                      formVal3 = "Day/Time";
                      collectionSuffix = "_vitals";
                      getData();
                      Navigator.pop(context);
                    }),
                new ListTile(
                    leading: new Icon(Icons.info),
                    title: Text('Diet'),
                    onTap: () {
                      buttonText = "Meal";
                      pageTitle = "My Diet";
                      formVal1 = "Meal name";
                      formVal2 = "Calories";
                      formVal3 = "Day/Time";
                      collectionSuffix = "_diet";
                      getData();
                      Navigator.pop(context);
                    }),
                new ListTile(
                    leading: new Icon(Icons.info),
                    title: Text('Doctors'),
                    onTap: () {
                      buttonText = "Doctor";
                      pageTitle = "My Doctors";
                      formVal1 = "Doctor Name";
                      formVal2 = "Specialty";
                      formVal3 = "Phone";
                      collectionSuffix = "_doctors";
                      getData();
                      Navigator.pop(context);
                    }),
                new ListTile(
                    leading: new Icon(Icons.info),
                    title: Text('Notes'),
                    onTap: () {
                      buttonText = "Note";
                      pageTitle = "My Notes";

                      formVal1 = "Subject";
                      formVal2 = "Body";
                      formVal3 = "Day/Time";
                      collectionSuffix = "_notes";
                      getData();
                      Navigator.pop(context);
                    }),
              ]),
            )
          ],
        ),
      ),
      appBar: new AppBar(
        centerTitle: true,
        title: Text('Documentation', style: TextStyle(color: Colors.white),),
        elevation: 0,
        backgroundColor: Colors.indigo[500],
      ),
      //body: new Center(
      //child: new Text((text)),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                text,
                style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
              ),
              RaisedButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          content: Stack(
                            overflow: Overflow.visible,
                            children: <Widget>[
                              Positioned(
                                right: -40.0,
                                top: -40.0,
                                child: InkResponse(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: CircleAvatar(
                                    child: Icon(Icons.close),
                                    backgroundColor: Colors.red,
                                  ),
                                ),
                              ),
                              Form(
                                key: _formKey,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.all(1.0),
                                      child: TextFormField(
                                        decoration: InputDecoration(
                                            labelText: formVal1,
                                            border: InputBorder.none),
                                        //hintText: formVal1),
                                        controller: myController1,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(1.0),
                                      child: TextFormField(
                                        decoration: InputDecoration(
                                            labelText: formVal2,
                                            border: InputBorder.none),
                                        //hintText: formVal2),
                                        controller: myController2,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(1.0),
                                      child: TextFormField(
                                        decoration: InputDecoration(
                                            labelText: formVal3,
                                            border: InputBorder.none),
                                        //hintText: formVal3),
                                        controller: myController3,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(1.0),
                                      child: RaisedButton.icon(
                                        icon: Icon(Icons.save),
                                        label: Text("Add/Edit " + buttonText),
                                        onPressed: () {
                                          if (_formKey.currentState
                                              .validate()) {
                                            _formKey.currentState.save();
                                          }

                                          createOrSave();
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(1.0),
                                      child: RaisedButton.icon(
                                        icon: Icon(Icons.create),
                                        label: Text("Delete " + buttonText),
                                        onPressed: () {
                                          if (_formKey.currentState
                                              .validate()) {
                                            _formKey.currentState.save();
                                          }
                                          deleteData();

                                          Navigator.pop(context);
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      });
                },
                child: Text(buttonText),
              ),
              /*
              RaisedButton(
                child: Text(buttonText),
                onPressed: _changeText,
                color: Colors.lightBlue,
                textColor: Colors.white,
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                splashColor: Colors.grey,
              ),*/
            ],
          ),
        ),
      ),
    );
  }
}
