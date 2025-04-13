import 'package:app/page/LoginPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DrawerScreen extends StatefulWidget{
  const DrawerScreen({super.key});

  @override
  State<DrawerScreen> createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  @override
  Widget build(BuildContext context) {
    bool darkTheme = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 90, 0, 0),
      child: SizedBox(
        width: 170,
        child: Drawer(
          backgroundColor: darkTheme ? Colors.black:Colors.white,

          child: Padding(
            padding: const EdgeInsets.fromLTRB(20,150, 10, 20),
            child: Column(

              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [

                    GestureDetector(
                      onTap: () {

                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Flexible(
                            fit: FlexFit.loose,
                            child: Text("Hello",
                              style:
                               GoogleFonts.niconne(
                                fontWeight: FontWeight.bold,
                                fontSize: 35,
                                color: darkTheme ? Colors.grey : Colors.blue,
                              ),
                              overflow: TextOverflow
                                  .ellipsis, // Handle text overflow
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40,),

                    GestureDetector(
                      onTap: () {

                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.question_mark_rounded,
                            size: 35,
                            color: darkTheme ? Colors.yellow : Colors.blue,
                          ),
                          const Padding(padding: EdgeInsets.all(6)),
                          Text(
                            "About",
                            style: GoogleFonts.niconne(
                              fontSize: 35,
                              color: darkTheme ? Colors.white : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 35,),
                    //Sign out

                    GestureDetector(
                      onTap: () {
                        FirebaseAuth.instance.signOut();
                        Navigator.pushReplacement(context, MaterialPageRoute(
                            builder: (c) => const LoginPage()));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.login_outlined,
                            size: 35,
                            color: Colors.red,
                          ),
                          const Padding(padding: EdgeInsets.all(5)),
                          Text(
                            "log out",
                            style: GoogleFonts.niconne(
                              fontSize: 35,
                              fontWeight: FontWeight.bold,
                              color: darkTheme ? Colors.red[800] : Colors
                                  .red[800],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}