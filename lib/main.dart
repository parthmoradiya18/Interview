import 'dart:io';
import 'dart:math';
import 'package:interview/view.dart';
import 'package:intl/intl.dart';
import 'package:external_path/external_path.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sqflite/sqflite.dart';


void main()
{
  runApp(MaterialApp(debugShowCheckedModeBanner: false ,home: home(),));
}
class home extends StatefulWidget {
  const home({super.key});
  static Database? database;
  static Directory?dir;

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {

  ImagePicker picker = ImagePicker();
  XFile? image;
  bool t = false;
  TextEditingController t1 = TextEditingController();
  TextEditingController t2 = TextEditingController();
  TextEditingController t3 = TextEditingController();
  TextEditingController t4 = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    get();
    permission();
  }
  get() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'parth.db');
    home.database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
          // When creating the db, create the table
          await db.execute(
              'CREATE TABLE test (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, contact TEXT ,email TEXT,data TEXT, image TEXT)');
        });
  }

  permission()
  async {
    var status = await Permission.storage.status;
    if (status.isDenied) {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.location,
        Permission.storage,
      ].request();
      print(statuses[Permission.location]);
    }
    var path = await ExternalPath.getExternalStoragePublicDirectory(ExternalPath.DIRECTORY_DOWNLOADS)+"/parth";
    print(path);

    home.dir = Directory(path);

    if(!await home.dir!.exists())
    {
      home.dir!.create();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.teal,
        title: const Text("Add data", style: TextStyle(color: Colors.white),),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 100,
                width: 100,
                margin: EdgeInsets.all(20),
                child: (t)?Image.file(fit: BoxFit.fill,File(image!.path)):null,

              ),
              Container(
                child: TextField(
                  controller: t1,
                  decoration: const InputDecoration(
                      labelText: "Enter Name",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)))),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                child: TextField(
                  controller: t2,
                  decoration: const InputDecoration(
                      labelText: "Enter Contact",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)))),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                child: TextField(
                  controller: t3,
                  decoration: const InputDecoration(
                      labelText: "Enter Email",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20))

                      )
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                child: TextField(decoration: InputDecoration(hintText:
                "Enter DATE",labelText: "Enter DATE",border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20)))

                ),

                  controller: t4,
                  onTap: () {
                    showDatePicker(context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1949),
                      lastDate: DateTime(2025),
                    ).then((value) {

                      var month=DateFormat("MM").format(value!);
                      var day=DateFormat("d").format(value!);
                      var year=DateFormat("yyyy").format(value!);
                      String date=month+"/"+day+"/"+year;
                      t4.text=date;
                    });

                  },
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(onPressed: () {
                    showDialog(context: context, builder: (context) {
                      return AlertDialog(
                        title: Text("choose your pic"),
                        actions: [
                          Row(
                            children: [
                              TextButton(onPressed: () async {
                                Navigator.pop(context);
                                image = await picker.pickImage(source: ImageSource.gallery);
                                t = true;
                                setState(() {

                                });

                              }, child: Text("gallery")),
                              TextButton(onPressed: () async {
                                Navigator.pop(context);
                                image = await picker.pickImage(source: ImageSource.camera);
                                t = true;
                                setState(() {

                                });
                              }, child: Text("camera")),
                            ],
                          )
                        ],
                      );
                    },);
                  },
                      style: const ButtonStyle(
                          shape: MaterialStatePropertyAll(
                              StadiumBorder(
                                  side: BorderSide(
                                      color: Colors.orange,
                                      width: 3,
                                      style: BorderStyle.solid))),
                          backgroundColor:
                          MaterialStatePropertyAll(Colors.black)),

                      child: Text("choose")),
                  ElevatedButton(
                      onPressed: () async {
                        String name = t1.text;
                        String contact = t2.text;
                        String email=t3.text;
                        String data =t4.text;
                        int r =Random().nextInt(1000);
                        String img_name = "${r}.jpg";
                        File f = File("${home.dir!.path}/${img_name}");
                        f.writeAsBytes(await image!.readAsBytes());

                        String sql = "insert into test values(null,'$name','$contact','$email','$data','$img_name')";
                        home.database!.rawInsert(sql);

                        setState(() {});
                      }, style: const ButtonStyle(shape: MaterialStatePropertyAll(StadiumBorder(side: BorderSide(color: Colors.orange, width: 3, style: BorderStyle.solid))), backgroundColor: MaterialStatePropertyAll(Colors.black)),
                      child: const Text("submit")),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                          return view();
                        },));
                      },
                      style: const ButtonStyle(
                          shape: MaterialStatePropertyAll(
                              StadiumBorder(
                                  side: BorderSide(
                                      color: Colors.orange,
                                      width: 3,
                                      style: BorderStyle.solid))),
                          backgroundColor:
                          MaterialStatePropertyAll(Colors.black)),
                      child: Text("view")),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
