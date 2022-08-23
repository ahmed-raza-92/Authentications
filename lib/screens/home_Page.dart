import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[900],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "TODO APPLICATION",
          style: TextStyle(fontSize: 18),
        ),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {},
        ),


      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: (){},
      ),

      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(left: 0),
            child: (Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:[
                const SizedBox(
                  height: 20,
                ),
              StreamBuilder(
                  stream: Stream.periodic(const Duration(seconds: 60)),
                  builder: (context, snapshot) {
                    return Text(
                      DateFormat('hh:mm a').format(DateTime.now(),), style: const TextStyle(
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
              child: ListView.builder(
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.only(bottom: 8, left: 16, right: 16),
                      child: const ListTile(
                        contentPadding: EdgeInsets.only(left: 32, right: 32, top: 8, bottom: 8),
                        title: Text("Dummy", style : TextStyle(color: Colors.black87,
                            fontWeight: FontWeight.bold),),
                        subtitle: Text("Dummy", style: TextStyle(color: Colors.black45,
                            fontWeight: FontWeight.bold),),

                        trailing: Icon(Icons.check_circle, color: Colors.greenAccent,),
                      ),
                    );

                  }),
            ),
          )
        ],
      ),
    );
  }
}
