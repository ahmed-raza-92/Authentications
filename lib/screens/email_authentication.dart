import 'package:authentications/screens/authentication%20page.dart';
import 'package:authentications/screens/success_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EmailAuthentication extends StatelessWidget {
  EmailAuthentication({Key? key}) : super(key: key);
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Email Authentication"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AuthenticationUI()));
              },
              icon: const Icon(Icons.navigate_before))
        ],
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 100, left: 20, right: 20),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(
                    borderSide:
                        const BorderSide(width: 0, style: BorderStyle.none),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  hintText: "Enter your email address",
                  filled: true),
            ),
            SizedBox(
              height: 40,
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(
                    borderSide:
                        const BorderSide(width: 0, style: BorderStyle.none),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  hintText: "Enter your password",
                  filled: true),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    try {
                      UserCredential credential = await FirebaseAuth.instance
                          .signInWithEmailAndPassword(
                              email: emailController.text,
                              password: passwordController.text);
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomePage()));
                    } on FirebaseException catch (e) {
                      if (e.code == "user-not-found") {
                        dialogBox(context, "There is no user with this Email",
                            "Error");
                      } else if (e.code == "wrong-password") {
                        dialogBox(context, "Wrong Password Provided for user",
                            "Error");
                      }
                    }
                  },
                  child: const Text("Sign in"),
                ),
                const SizedBox(
                  width: 20,
                ),
                ElevatedButton(
                    onPressed: () async {
                      bool? check = checkFields(context);
                      if (check!) {
                        try {
                          await FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                                  email: emailController.text,
                                  password: passwordController.text);
                          dialogBox(context, "Successfully Registered User",
                              "Success!");
                        } on FirebaseAuthException catch (e) {
                          dialogBox(context, e.message.toString(), "Error");
                        }
                      }
                    },
                    child: const Text("Register"))
              ],
            )
          ],
        ),
      ),
    );
  }

  Future dialogBox(context, String message, String header) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(header),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Ok'),
            child: const Text('Ok'),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  bool? checkFields(context) {
    if (emailController.text.isEmpty | passwordController.text.isEmpty) {
      dialogBox(context, "Email or Password cant be empty", "Error!");
      return false;
    } else {
      return true;
    }
  }
}
