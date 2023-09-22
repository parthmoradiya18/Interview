import 'dart:io';
import 'dart:math';
import 'package:interview/main.dart';
import 'package:interview/view.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class edit_data extends StatefulWidget {
  int id;
  String name;
  String contact;
  String email;
  String data;
  edit_data(this.id,this.name,this.contact,this.email,this.data);

  @override
  State<edit_data> createState() => _edit_dataState();
}

class _edit_dataState extends State<edit_data> {

  TextEditingController t1 = TextEditingController();
  TextEditingController t2 = TextEditingController();
  TextEditingController t3=TextEditingController();
  TextEditingController t4=TextEditingController();
  ImagePicker picker = ImagePicker();
  XFile? image;
  bool t = false;

  @override
  void initState() {
    // TODO: implement initState
    t1.text = widget.name;
    t2.text = widget.contact;
    t3.text =widget.email;
    t4.text=widget.data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text("add data", style: TextStyle(color: Colors.white)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
                          borderRadius: BorderRadius.all(Radius.circular(20)))),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                child: TextField(decoration: InputDecoration(hintText: "Enter DATE",labelText:
                "Enter DATE",border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20)))
                )
                  ,controller: t4,
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
              ElevatedButton(onPressed: () {
                showDialog(context: context, builder: (context) {
                  return AlertDialog(
                    title: Text("choose your image"),
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
                  child: Text("choose your image")),
              Container(
                height: 100,
                width: 100,
                child: (t)
                    ? Image.file(File(image!.path))
                    : Icon(Icons.account_circle_rounded),
                decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.black)),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                      onPressed: () async{
                        String name = t1.text;
                        String contact = t2.text;
                        String email=t3.text;
                        String data =t4.text;
                        int r =Random().nextInt(100000);
                        String img_name = "${r}.jpg";
                        File f = File("${home.dir!.path}/${img_name}");
                        f.writeAsBytes(await image!.readAsBytes());
                        String sql = "update test set name = '$name',contact = '$contact',email = '$email',data = '$data',image = '$img_name' where id = '${widget.id}'";
                        home.database!.rawUpdate(sql);
                        print(sql);
                        setState(() {});
                      }, style: const ButtonStyle(shape: MaterialStatePropertyAll(StadiumBorder(side: BorderSide(color: Colors.orange, width: 3, style: BorderStyle.solid))), backgroundColor: MaterialStatePropertyAll(Colors.black)),
                      child: const Text("update")),
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
