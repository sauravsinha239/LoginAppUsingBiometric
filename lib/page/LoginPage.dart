import 'package:app/page/RegistrationPage.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../Global/GlobalVar.dart';
import 'HomePage.dart';


class LoginPage extends StatefulWidget{
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final emailTextEditor = TextEditingController();
  final passwordTextEditor = TextEditingController();
  bool passwordVisible = false;

  final storage = FlutterSecureStorage();

  //GlobalKey

  final _formkey = GlobalKey<FormState>();
  void _loginWithBiometric() async {
    try {
      bool isAuthenticated = await localAuth.authenticate(
        localizedReason: 'Authenticate to login',
        options: const AuthenticationOptions(biometricOnly: true),
      );

      if (isAuthenticated) {
        String? storedUid = await storage.read(key: 'uid');
        String? email = await storage.read(key: 'email');
        String? password = await storage.read(key: 'password');

        if (storedUid != null && email != null && password != null) {

          // await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
          // Fluttertoast.showToast(msg: 'Login Successful via Biometrics');
          UserCredential userCredential = await firebaseAuth.signInWithEmailAndPassword(
              email: email,
              password: password,
          );
          if (userCredential.user?.uid == storedUid) {
            Fluttertoast.showToast(msg: 'Biometric Login Successful');
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => const HomePage()));
          } else {
            Fluttertoast.showToast(msg: 'Biometric login denied: UID mismatch');
          }

        } else {
          Fluttertoast.showToast(msg: 'Biometric data not enrolled');
        }
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Biometric login error: $e');
    }
  }

  // login method started

  void Submit() async {
    if (_formkey.currentState!.validate()) {
      try {
        final UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
          email: emailTextEditor.text.trim(),
          password: passwordTextEditor.text.trim(),
        );

        await storage.write(key: 'uid', value: currentUser?.uid);
        await storage.write(
            key: 'email', value: emailTextEditor.text.trim());
        await storage.write(
            key: 'password', value: passwordTextEditor.text.trim());

        Fluttertoast.showToast(msg: "Login Successful");

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      } catch (e) {
        Fluttertoast.showToast(msg: "Login failed: ${e.toString()}");
      }
    } else {
      Fluttertoast.showToast(msg: "Please enter valid credentials");
    }
  }


  @override
  Widget build(BuildContext context) {
    bool darkTheme = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },

      child: Scaffold(
        backgroundColor: darkTheme ? Colors.black:Colors.white,

        body: ListView(
          padding: const EdgeInsets.all(0),

          children: [
            const SizedBox(height: 50,),
            Image.asset(darkTheme ? 'images/user.png' : 'images/user_blue.png',height: 100,),
            const SizedBox(
              height: 50,
            ),
            Text(
              'Login Now',
              textAlign: TextAlign.center,
              style: GoogleFonts.niconne(
                fontSize: 40,
                color: darkTheme ? Colors.yellowAccent : Colors.red,
                fontStyle: FontStyle.italic,
              ),
            ),
            Padding(

              padding: const EdgeInsets.fromLTRB(15, 20, 15, 50),

              child: Column(

                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Form(
                    key: _formkey,
                    child: Column(
                      children: [
                        TextFormField(
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(50)
                          ],
                          decoration: InputDecoration(
                              hintText: "Enter your email",
                              hintStyle: const TextStyle(
                                color: Colors.grey,
                              ),
                              filled: true,
                              fillColor:
                              darkTheme ? Colors.black : Colors.white,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(40),
                                  borderSide: const BorderSide(
                                    width: 0,
                                    style: BorderStyle.none,
                                  )),
                              prefixIcon: Icon(
                                Icons.email_rounded,
                                color: darkTheme
                                    ? Colors.yellowAccent
                                    : Colors.red,
                              )),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (email) {
                            if (email == null || email.isEmpty) {
                              return "Email is required";
                            }
                            if (email.length < 2 || email.length > 50) {
                              return "Please Enter Valid email address";
                            }
                            if (EmailValidator.validate(email)) {
                              return null;
                            }
                            return null;
                          },
                          onChanged: (Text) =>
                              setState(() {
                                emailTextEditor.text = Text;
                              }),
                        ),
                        //Password Box
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          obscureText: !passwordVisible,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(50)
                          ],
                          decoration: InputDecoration(
                            hintText: "Enter Password",
                            hintStyle: const TextStyle(
                              color: Colors.grey,
                            ),
                            filled: true,
                            fillColor: darkTheme ? Colors.black : Colors.white,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(80),
                                borderSide: const BorderSide(
                                  width: 0,
                                  style: BorderStyle.none,
                                )),
                            prefixIcon: Icon(
                              Icons.password,
                              color: darkTheme ? Colors.yellow : Colors.red,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                passwordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: darkTheme ? Colors.green : Colors.red,
                              ),
                              onPressed: () {
                                //Update the state of password visible variable
                                setState(() {
                                  passwordVisible = !passwordVisible;
                                });
                              },
                            ),
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (text) {
                            if (text == null || text.isEmpty) {
                              return "Enter Password";
                            }
                            if (text.length < 8 || text.length > 30) {
                              return "Please Enter Valid password";
                            }
                            return null;
                          },
                          onChanged: (text) =>
                              setState(() {
                                passwordTextEditor.text = text;
                              }),
                        ),
                        const SizedBox(
                          height: 50,
                        ),

                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                            darkTheme ? Colors.yellowAccent : Colors.red,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            minimumSize: const Size(200, 40),
                          ),
                          onPressed: () {
                            Submit();
                          },
                          child: Text(
                            "Log in",
                            style: GoogleFonts.niconne(
                              fontSize: 32,
                              color: Colors.purple[900],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 70,
                        ),
                        ElevatedButton.icon(

                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                            darkTheme ? Colors.black : Colors.white,
                            elevation: 0,
                            minimumSize: const Size(40, 40),
                          ),
                          onPressed: () {
                            _loginWithBiometric();
                          },
                         icon: Icon(Icons.fingerprint ,size: 100, color: darkTheme ? Colors.green[800]: Colors.purple[800],),
                          label:Text("") ,
                        ),
                        SizedBox(height: 40,),
                        GestureDetector(
                          onTap: () {

                          },
                          child: Text(
                            'Forget Password',
                            style: GoogleFonts.niconne(
                              color:
                              darkTheme ? Colors.yellowAccent : Colors.red,
                              fontSize: 26,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                          width: 10,
                        ),
                        //Create Accounts
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (c)=> const RegisterationPage()));
                          },
                          child: Center(
                            child: Text(
                              "Doesn't have an account?",
                              style: GoogleFonts.niconne(
                                color: Colors.grey,
                                fontSize: 25,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                          height: 10,
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}