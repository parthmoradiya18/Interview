import 'dart:io';
import 'package:flutter/material.dart';
import 'package:interview/main.dart';
import 'package:interview/update_edit.dart';

class view extends StatefulWidget {
  const view({super.key});

  @override
  State<view> createState() => _viewState();
}

class _viewState extends State<view> {

  List<Map> l = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    geta();
  }
  geta()
  async {
    String sql = "select * from test";
    l = await home.database!.rawQuery(sql);
    print(l);
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Contact book"),
        backgroundColor: Colors.green,
        actions: [
          IconButton(onPressed: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
              return home();
            },));
          }, icon: Icon(Icons.home))
        ],
      ),

      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount:l.length,
              itemBuilder: (context, index) {
                String img_path="${home.dir!.path}/${l[index]['image']}";
                File f=File(img_path);

                return Card(
                  child: ListTile(
                      leading: Container(
                        height: 60,
                        width: 60,
                        child: CircleAvatar(
                          backgroundImage: FileImage(f),
                        ),
                      ),
                      title: Text("${l[index]['name']}"),
                      subtitle: Text("${l[index]['contact']}\n${l[index]['email']}\n${l[index]['data']}"),
                      trailing: Wrap(
                        children: [
                          IconButton(onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) {
                              return edit_data(l[index]['id'],l[index]['name'],l[index]['contact'],l[index]['email'],l[index]['data']);
                            },));
                          }, icon: Icon(Icons.edit)),
                          IconButton(onPressed: () {
                            String sql = "delete from test where id = ${l[index]['id']}";
                            home.database!.rawDelete(sql);
                            setState(() {

                            });
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                              return view();
                            },));
                          }, icon: Icon(Icons.delete)),
                        ],
                      )
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
