import 'dart:io';
import 'package:authentications/screens/authentication%20page.dart';
import 'package:authentications/screens/home_Page.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

class UploadFiles extends StatefulWidget {
  const UploadFiles({Key? key}) : super(key: key);

  @override
  State<UploadFiles> createState() => _UploadFileState();
}

class _UploadFileState extends State<UploadFiles> {
  UploadTask? task;
  File? file;
  String? fileURL;

  @override
  Widget build(BuildContext context) {
    final fileName = file != null ? basename(file!.path) : 'No File Selected';
    return Scaffold(
      appBar: AppBar(
        title: const Text("Files Upload"),
        actions: [
          IconButton(
              onPressed: (){
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> const Home()));
              }, icon: const Icon(Icons.home)
          )
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: (Column(
            children: [
              if(fileURL !=null)
              Container(
                height: 200,
                width: 200,

                child:
                Image.network(fileURL!),
                // color: Colors.teal,
              ),
              SizedBox(
                width: 120,
                child: ElevatedButton(
                  onPressed: () async {
                    final result = await FilePicker.platform
                        .pickFiles(allowMultiple: false);
                    if (result == null) return;
                    final path = result.files.single.path!;
                    setState(() {
                      file = File(path);
                    });
                  },
                  style: ElevatedButton.styleFrom(shape: const StadiumBorder()),
                  child: const Text("Select File"),
                ),
              ),
              const SizedBox(
                height: 7,
              ),
              Text(fileName),
              const SizedBox(
                height: 30,
              ),
              SizedBox(
                width: 120,
                child: ElevatedButton(
                  onPressed: () async{
                    if(file == null) return;
                    final fileName= basename(file!.path);
                    final destination="files/$fileName";
                    task= FirebaseApi.uploadFiles(destination, file!);
                    if(task == null) return;
                    final snapshot = await task!.whenComplete(() {});
                    final urlDownload = await snapshot.ref.getDownloadURL();

                    setState(() {
                        fileURL=urlDownload;
                    });
                  },
                  style: ElevatedButton.styleFrom(shape: const StadiumBorder()),
                  child: const Text("Upload File"),
                ),
              ),
              const SizedBox(height: 100,),
               task != null ? buildUploadStatus(task!) : Container(),
            ],
          )),
        ),
      ),
    );

  }


  Widget buildUploadStatus(UploadTask task) => StreamBuilder<TaskSnapshot>(
    stream: task.snapshotEvents,
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        final snap = snapshot.data!;
        final progress = snap.bytesTransferred / snap.totalBytes;
        final percentage = (progress * 100).toStringAsFixed(2);

        return Text(
          '$percentage %',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        );
      } else {
        return Container();
      }
    },
  );
}
class FirebaseApi{
  static UploadTask? uploadFiles(String destination, File file){
    try{
      final ref=FirebaseStorage.instance.ref(destination);
      return ref.putFile(file);

    }on FirebaseException catch(e) {
      return null;
    }
  }

}





