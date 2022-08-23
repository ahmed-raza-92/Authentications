import 'package:authentications/screens/authentication%20page.dart';
import 'package:authentications/screens/success_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthentication extends StatelessWidget {
  const GoogleAuthentication({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Google Sign in"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AuthenticationUI()));
            },
            icon: const Icon(Icons.home),
          )
        ],
      ),
      body: (Center(
        child: Container(
          height: 200,
          child: Column(
            children: [
              ElevatedButton(
                  onPressed: () async{
                    try {
                      GoogleSignInAccount? user =
                      await GoogleSignIn(scopes: <String>['email']).signIn();
                      GoogleSignInAuthentication auth = await user!.authentication;
                      final credential = GoogleAuthProvider.credential(
                          accessToken: auth.accessToken, idToken: auth.idToken);
                      FirebaseAuth.instance.signInWithCredential(credential).then((value){
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> const HomePage()));
                      });

                    } on FirebaseException catch (e) {
                      print(e.message);
                    }
                  },
                  child: const Text("Sign In")),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () {
                    // googleSignOut();
                  },
                  child: const Text("Sign Out")),
            ],
          ),
        ),
      )),
    );
  }

  googleSignOut() async {
    await FirebaseAuth.instance.signOut();
  }

}
