import 'package:app/page/LoginPage.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:local_auth/local_auth.dart';

import '../Global/GlobalVar.dart';

class RegisterationPage extends StatefulWidget{
  const RegisterationPage({super.key});

  @override
  State<RegisterationPage> createState() => _RegisterationPageState();
}

class _RegisterationPageState extends State<RegisterationPage> {

  final NameTextEditingControler = TextEditingController();
  final EmailTextEditingControler = TextEditingController();
  final PhoneTextEditingControler = TextEditingController();
  final AddressTextEditingControler = TextEditingController();
  final PasswordTextEditingControler = TextEditingController();
  final CnfPasswordTextEditingControler = TextEditingController();
  bool passwordvisible = false;
  bool cnfpassword = false;

  final _formkey = GlobalKey<FormState>();


//Biometric Auth
  Future<void> _enrollBiometric() async {
    try {
      bool isBiometricAvailable = await localAuth.canCheckBiometrics;
      if (isBiometricAvailable) {
        bool isAuthenticated = await localAuth.authenticate(
          localizedReason: 'Please authenticate to enroll biometric',
          options: const AuthenticationOptions(biometricOnly: true),
        );

        if (isAuthenticated) {
          await storage.write(key: 'uid', value: currentUser!.uid);
          await storage.write(key: 'email', value: EmailTextEditingControler.text.trim());
          await storage.write(key: 'password', value: PasswordTextEditingControler.text.trim());
          Fluttertoast.showToast(msg: 'Biometric enrolled successfully');
        } else {
          Fluttertoast.showToast(msg: 'Biometric authentication failed');
        }
      } else {
        Fluttertoast.showToast(msg: 'Biometric not available on this device');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error enrolling biometric: $e');
      print("error biomatric ${e}");
    }
  }


  void _submit() async {
    if (_formkey.currentState!.validate()) {

      await firebaseAuth.createUserWithEmailAndPassword(
        email: EmailTextEditingControler.text.trim(),

        password: PasswordTextEditingControler.text.trim(),

      ).then((auth) async {
        currentUser = auth.user;
        if (currentUser != null) {
          await _enrollBiometric();
          Map userMap = {
            "id": currentUser!.uid,
            "name": NameTextEditingControler.text.trim(),
            "email": EmailTextEditingControler.text.trim(),
            "phone": PhoneTextEditingControler.text.trim(),
          };

          DatabaseReference userRef = FirebaseDatabase.instance.ref().child("users");
          await userRef.child(currentUser!.uid).set(userMap);
          await storage.write(key: 'email', value: EmailTextEditingControler.text.trim());
          await storage.write(key: 'password', value: PasswordTextEditingControler.text.trim());

          Fluttertoast.showToast(msg: "Successfully Registered, Login now");
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => const LoginPage()));
        }
      }).catchError((errorMessage) {
        Fluttertoast.showToast(msg: "User already registered \n Please login");
      });
    } else {
      Fluttertoast.showToast(msg: "Not all Fields are valid!");
    }
  }

  @override
  Widget build(BuildContext context) {
    bool darktheme = MediaQuery
        .of(context)
        .platformBrightness == Brightness.dark;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: darktheme ? Colors.black:Colors.white,
        body: ListView(
          padding: const EdgeInsets.all(0),
          children: [
            const SizedBox(height: 40,),
            Image.asset(darktheme ? 'images/user.png' : 'images/user_blue.png',height: 50,),
            const SizedBox(height: 30,),
            Text(
              'Register',
              textAlign: TextAlign.center,
              style: GoogleFonts.niconne(
                color: darktheme ? Colors.amber.shade400 : Colors.red,
                fontSize: 50,
                fontWeight: FontWeight.w600,
                fontStyle: FontStyle.italic,
              ),

            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 10, 15, 50),
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
                              hintText: "Name",
                              hintStyle: GoogleFonts.lato(
                                color: darktheme?Colors.white:Colors.black,
                              ),
                              filled: true,
                              fillColor: darktheme ? Colors.black : Colors
                                  .white,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(80),
                                  borderSide: const BorderSide(
                                    width: 0,
                                    style: BorderStyle.none,
                                  )
                              ),
                              prefixIcon: Icon(Icons.person,
                                color: darktheme ? Colors.yellow : Colors.red,)

                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (text) {
                            if (text == null || text.isEmpty) {
                              return "name can`t be Empty";
                            }
                            if (text.length < 2 || text.length > 25) {
                              return "Please Enter Valid Name";
                            }
                            return null;
                          },
                          onChanged: (Text) =>
                              setState(() {
                                NameTextEditingControler.text = Text;
                              }),
                          style: TextStyle(
                            color: darktheme? Colors.white:Colors.black,
                          ),
                        ),
                        //EMail Box
                        const SizedBox(height: 10,),
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(50)
                          ],
                          decoration: InputDecoration(
                              hintText: "Email",

                              hintStyle: GoogleFonts.lato(
                                color: darktheme?Colors.white:Colors.black,

                              ),
                              filled: true,
                              fillColor: darktheme ? Colors.black : Colors
                                  .white,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(80),
                                  borderSide: const BorderSide(
                                    width: 0,
                                    style: BorderStyle.none,
                                  )
                              ),
                              prefixIcon: Icon(Icons.email,
                                color: darktheme ? Colors.yellow : Colors.red,)

                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,

                          validator: (email) {
                            if (email == null || email.isEmpty) {
                              return "Email can`t be Empty";
                            }
                            if (EmailValidator.validate(email) == true) {
                              return null;
                            }
                            return null;

                          },
                          onChanged: (text) =>
                              setState(() {
                                EmailTextEditingControler.text = text;
                              }),
                          style: TextStyle(
                            color: darktheme? Colors.white:Colors.black,
                          ),
                        ),
                        const SizedBox(height: 10,),
                        //PhoneBox For enter phone number
                        IntlPhoneField(
                          showCountryFlag: true,
                          languageCode:"en",
                          dropdownTextStyle:TextStyle(
                            color: darktheme ? Colors.white:Colors.black,
                          ),
                          dropdownIcon: Icon(
                            Icons.arrow_drop_down_rounded,
                            color: darktheme ? Colors.yellow : Colors.red,
                          ),
                          decoration: InputDecoration(
                            hintText: "Phone Number",
                            hintStyle: GoogleFonts.lato(
                              color: darktheme?Colors.white:Colors.black,
                            ),
                            filled: true,


                            fillColor: darktheme ? Colors.black : Colors.white,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50),
                                borderSide: const BorderSide(
                                  width: 0,
                                  style: BorderStyle.none,
                                )
                            ),
                          ),
                          initialCountryCode: 'IN' ,
                          onChanged: (text) =>
                              setState(() {
                                PhoneTextEditingControler.text = text.completeNumber;

                              }),
                          style: TextStyle(
                            color: darktheme? Colors.white:Colors.black,
                          ),

                        ),

                        const SizedBox(height: 0,),
                        //Password Fields
                        //password
                        TextFormField(
                          obscureText: !passwordvisible,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(50)
                          ],
                          decoration: InputDecoration(
                            hintText: "Enter Password",

                            hintStyle: GoogleFonts.lato(
                              color: darktheme?Colors.white:Colors.black,
                            ),
                            filled: true,
                            fillColor: darktheme ? Colors.black : Colors.white,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(80),
                                borderSide: const BorderSide(
                                  width: 0,
                                  style: BorderStyle.none,
                                )
                            ),
                            prefixIcon: Icon(Icons.password,
                              color: darktheme ? Colors.yellow : Colors.red,),
                            suffixIcon: IconButton(
                              icon: Icon(
                                passwordvisible ? Icons.visibility : Icons
                                    .visibility_off,
                                color: darktheme ? Colors.green : Colors.red,
                              ),
                              onPressed: () {
                                //Update the state of password visible variable
                                setState(() {
                                  passwordvisible = !passwordvisible;
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
                                PasswordTextEditingControler.text = text;
                              }),
                          style: TextStyle(
                            color: darktheme? Colors.white:Colors.black,
                          ),
                        ),
                        const SizedBox(height: 10,),
                        //cnf password
                        TextFormField(
                          obscureText: !cnfpassword,
                          inputFormatters: [LengthLimitingTextInputFormatter(50)],
                          decoration: InputDecoration(
                            hintText: "Confirm Password",
                            hintStyle: GoogleFonts.lato(
                              color: darktheme?Colors.white:Colors.black,
                            ),
                            filled: true,
                            fillColor: darktheme ? Colors.black : Colors.white,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(80),
                                borderSide: const BorderSide(
                                  width: 0,
                                  style: BorderStyle.none,
                                )
                            ),
                            prefixIcon: Icon(Icons.password,
                              color: darktheme ? Colors.yellow : Colors.red,),
                            suffixIcon: IconButton(
                              icon: Icon(
                                cnfpassword ? Icons.visibility : Icons
                                    .visibility_off,
                                color: darktheme ? Colors.green : Colors.red,
                              ),

                              onPressed: () {
                                //Update the state of password visible variable
                                setState(() {
                                  cnfpassword = !cnfpassword;
                                });
                              },

                            ),

                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,

                          validator: (text) {
                            if (text == null || text.isEmpty) {
                              return "Confirm Password";
                            }
                            if (text != PasswordTextEditingControler.text) {
                              return "Password Don`t match";
                            }
                            return null;
                          },
                          onChanged: (text) =>
                              setState(() {
                                CnfPasswordTextEditingControler.text = text;
                              }),
                          style: TextStyle(
                            color: darktheme? Colors.white:Colors.black,
                          ),
                        ),
                        const SizedBox(height: 20,),

                        ElevatedButton.icon(

                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                            darktheme ? Colors.black : Colors.white,
                            elevation: 0,
                            minimumSize: const Size(40, 40),
                          ),
                          onPressed: () {
                            _enrollBiometric();
                          },
                          icon: Icon(Icons.fingerprint ,size: 100, color: darktheme ? Colors.green[800]: Colors.purple[800],),
                          label:Text("") ,
                        ),
                        SizedBox(height: 30,),

                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: darktheme
                                ? Colors.yellowAccent
                                : Colors.red,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            minimumSize: const Size(120, 30),

                          ),
                          onPressed: () {
                            _submit();

                          }, child: Text(
                          'Register',
                          style: GoogleFonts.niconne(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.purple,
                          ),

                        ),
                        ),
                        const SizedBox(height: 20,),
                        GestureDetector(
                          onTap: () {
                            // Navigator.pushReplacement(context,
                            //     MaterialPageRoute(
                            //         builder: (c) => const forgetScreen()));
                          },
                          child: Text(
                            'Forget Password',
                            style: GoogleFonts.niconne(
                              color: darktheme ? Colors.yellowAccent : Colors
                                  .red,
                              fontSize: 25,
                            ),
                          ),

                        ),
                        const SizedBox(height: 10,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Have an account?",
                              style: GoogleFonts.niconne(
                                color: darktheme? Colors.white: Colors.black,
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),),
                            const SizedBox(width: 10,),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushReplacement(context,
                                    MaterialPageRoute(
                                        builder: (c) => const LoginPage()));
                              },
                              child: Text(
                                "Sign in",
                                style: GoogleFonts.niconne(
                                  fontSize: 25,
                                  color: darktheme ? Colors.white : Colors.black,
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}