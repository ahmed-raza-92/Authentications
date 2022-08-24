import 'package:authentications/model/TaskModel.dart';
import 'package:authentications/model/ToDoModel.dart';
import 'package:authentications/screens/authentication%20page.dart';
import 'package:authentications/screens/upload_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var titleController = TextEditingController();
    var detailController = TextEditingController();
    return Scaffold(
      backgroundColor: Colors.lightBlue[900],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "TODO APPLICATION",
          style: TextStyle(fontSize: 18),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Drawer Header'),
            ),
            ListTile(
              leading: Icon(
                Icons.home,
              ),
              title: const Text('Authentications'),
              onTap: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AuthenticationUI()));
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.upload_file,
              ),
              title: const Text('Upload Image'),
              onTap: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const UploadFiles()));
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) => Dialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      height: 280,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 15,
                          ),
                          const Text("Enter Details"),
                          const SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 30, right: 30),
                            child: TextField(
                              controller: titleController,
                              decoration: InputDecoration(
                                filled: true,
                                isDense: true,
                                labelText: "Title",
                                border: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        width: 0, style: BorderStyle.none),
                                    borderRadius: BorderRadius.circular(20)),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 30, right: 30),
                            child: TextField(
                              controller: detailController,
                              decoration: InputDecoration(
                                filled: true,
                                isDense: true,
                                labelText: "Details",
                                border: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        width: 0, style: BorderStyle.none),
                                    borderRadius: BorderRadius.circular(20)),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop({
                                      "1": titleController.text,
                                      "2": detailController.text,
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                      shape: const StadiumBorder()),
                                  child: const Text("Add"),
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              SizedBox(
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  style: ElevatedButton.styleFrom(
                                      shape: const StadiumBorder()),
                                  child: const Text("Cancel"),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  )).then((value) {
            if (value != null) {
              var title = value["1"];
              var detail = value["2"];
              Provider.of<ToDoModel>(context, listen: false)
                  .addNewTask(title, detail);
              titleController.text = "";
              detailController.text = "";
            }
          });
        },
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(left: 0),
            child: (Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20,
                ),
                StreamBuilder(
                    stream: Stream.periodic(const Duration(seconds: 40)),
                    builder: (context, snapshot) {
                      return Text(
                        DateFormat('hh:mm a').format(
                          DateTime.now(),
                        ),
                        style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 35,
                            fontWeight: FontWeight.bold),
                      );
                    }),
                const Text(
                  "current time",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(
                  height: 20,
                )
              ],
            ) //to sh
                ),
          ),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50)),
                  color: Colors.white),
              child: Consumer<ToDoModel>(builder: (ctx, todo, child) {
                return ListView.builder(
                    itemCount: todo.taskModel.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.only(
                            bottom: 8, left: 16, right: 16),
                        child: ListTile(
                          contentPadding: const EdgeInsets.only(
                              left: 32, right: 32, top: 8, bottom: 8),
                          title: Text(
                            todo.taskModel[index].title!,
                            style: const TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            todo.taskModel[index].detail!,
                            style: const TextStyle(
                                color: Colors.black45,
                                fontWeight: FontWeight.bold),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () {
                                  bool? flag;
                                  todo.taskModel[index].check
                                      ? flag = false
                                      : flag = true;
                                  Provider.of<ToDoModel>(context, listen: false)
                                      .updateTask(index, flag);
                                },
                                icon: todo.taskModel[index].check
                                    ? const Icon(Icons.check_circle)
                                    : const Icon(Icons.circle),
                                color: Colors.blue,
                              ),
                              IconButton(
                                onPressed: () {
                                  Provider.of<ToDoModel>(context, listen: false)
                                      .removeTask(index);
                                },
                                icon: const Icon(Icons.delete),
                                color: Colors.blue,
                              ),
                            ],
                          ),
                        ),
                      );
                    });
              }),
            ),
          )
        ],
      ),
    );
  }
}
