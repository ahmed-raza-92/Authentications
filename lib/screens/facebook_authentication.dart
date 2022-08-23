import 'package:authentications/screens/success_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class FaceBookLogin extends StatelessWidget {
  const FaceBookLogin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("FaceBook Login"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const HomePage()));
              },
              icon: const Icon(Icons.home))
        ],
      ),
      body: (Center(
        child: SizedBox(
          height: 200,
          child: Column(
            children: [
              SizedBox(
                width: 200,
                height: 45,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(shape: StadiumBorder()),
                  child: const Text("Login FaceBook"),
                  onPressed: () async {
                    facebookSignin();
                    try {
                      final firebaseAuth= FirebaseAuth.instance;
                      final instance=FacebookAuth.instance;
                      final result = await instance
                          .login(permissions: ['email']);
                      if (result.status == LoginStatus.success) {
                        final OAuthCredential credential =
                            FacebookAuthProvider.credential(
                                result.accessToken!.token);
                        await instance.getUserData().then((userData) async {
                          await firebaseAuth.currentUser!.updateEmail(userData['email']);
                        });
                        await firebaseAuth
                            .signInWithCredential(credential)
                            .then((value) {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const HomePage()));
                        });
                      } else if (result.status == LoginStatus.cancelled) {
                        print("Login Cancelled");
                      }
                    } on FirebaseException catch (e) {
                      print(e.message);
                    }
                  },
                ),
              ),
              SizedBox(
                height: 40,
              ),
              SizedBox(
                width: 200,
                height: 45,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(shape: StadiumBorder()),
                  child: const Text("Logout FaceBook"),
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    await FacebookAuth.instance.logOut();
                  },
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }

  Future<String?> facebookSignin() async {

  }
}
