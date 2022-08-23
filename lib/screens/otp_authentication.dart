import 'package:authentications/screens/authentication%20page.dart';
import 'package:authentications/screens/success_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class PhoneNumberVerification extends StatefulWidget {
  const PhoneNumberVerification({Key? key}) : super(key: key);

  @override
  State<PhoneNumberVerification> createState() =>
      _PhoneNumberVerificationState();
}

class _PhoneNumberVerificationState extends State<PhoneNumberVerification> {
  bool visibleCheck = false;
  late String verificationCode;
  TextEditingController numberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Phone Number Verification"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AuthenticationUI()));
              },
              icon: const Icon(Icons.home))
        ],
      ),
      body: (Center(
        child: Container(
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 40),
                child: Text("Enter Phone Number"),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: numberController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    filled: true,
                    labelText: "Enter Number",
                    isDense: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(style: BorderStyle.none))),
              ),
              const SizedBox(
                height: 20,
              ),
              Visibility(
                visible: visibleCheck,
                child: Pinput(
                  length: 6,
                  onCompleted: (String pin) async {
                    try {
                      await FirebaseAuth.instance
                          .signInWithCredential(PhoneAuthProvider.credential(
                              verificationId: verificationCode, smsCode: pin))
                          .then((value) {
                        if (value.user != null) {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const HomePage()));
                        } else {
                         return DialogBox(header: "Error",message: "Incorrect Pin Entered",);

                        }
                      });
                    } on FirebaseException catch (e) {
                      DialogBox(header: "Error",message: e.message.toString(),);
                    }
                  },
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: 100,
                child: ElevatedButton(
                    onPressed: () {
                      _verifyPhone();
                      setState(() {
                        visibleCheck = true;
                      });
                    },
                    style: ElevatedButton.styleFrom(shape: StadiumBorder()),
                    child: const Text("Verify")),
              )
            ],
          ),
        ),
      )),
    );
  }

  _verifyPhone() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: numberController.text,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await FirebaseAuth.instance
            .signInWithCredential(credential)
            .then((value) async {
          if (value.user != null) {
            print("User Logged in");
          }
        });
      },
      verificationFailed: (FirebaseAuthException e) {
        print(e.message);
      },
      codeAutoRetrievalTimeout: (String verificationID) {
        verificationCode = verificationID;
      },
      codeSent: (String verificationId, int? resendToken) {
        verificationCode = verificationId;
      },
      timeout: const Duration(seconds: 120),
    );
  }
}

class DialogBox extends StatelessWidget {
  String header;
  String message;

  DialogBox({Key? key, required this.header, required this.message})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(header),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, 'Ok'),
          child: const Text('Ok'),
        ),
      ],
    );
  }
}
