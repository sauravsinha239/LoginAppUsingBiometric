import 'package:app/Tab/HomeTab.dart';
import 'package:flutter/material.dart';
import '../Tab/QrCodeReader.dart';

class HomePage extends StatefulWidget{
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  TabController ? tabController;
  int selectIndex = 0;

  onItemClicked(int index) {
    setState(() {
      selectIndex = index;
      tabController!.index = selectIndex;
    });
  }

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    bool darkTheme = MediaQuery
        .of(context)
        .platformBrightness == Brightness.dark;
    return Scaffold(
      body: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: tabController,
        children: const [
          HomeTab(),
          QrCodeReader(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.qr_code), label: "SCAN"),

        ],
        unselectedItemColor: darkTheme ? Colors.black : Colors.white,
        selectedItemColor: darkTheme ? Colors.yellow : Colors.red,
        backgroundColor: darkTheme ? Colors.grey : Colors.brown,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: const TextStyle(fontSize: 14),
        showUnselectedLabels: true,
        currentIndex: selectIndex,
        onTap: onItemClicked,
      ),
    );
  }
}