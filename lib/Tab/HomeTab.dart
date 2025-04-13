import 'package:app/page/DrawerScreen.dart';
import 'package:flutter/material.dart';

class HomeTab extends StatefulWidget{
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final  GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    bool darkTheme = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Scaffold(
      key: _scaffoldState,
      drawer: const DrawerScreen(),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blue,
        title: GestureDetector(
          onTap: _scaffoldState.currentState?.openDrawer,
          child: Text("Hello", style: TextStyle(
              color: Colors.red,
          ),),
        ),

          ),
      body: Stack(
        children: [
          // Add your widgets here
        ],
      ),
    );


  }
}