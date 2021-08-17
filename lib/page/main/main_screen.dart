import 'package:flutter/material.dart';
import 'package:meet_ceylon/page/main/flame.dart';
import 'package:meet_ceylon/provider/position_feedback_provider.dart';
import 'package:provider/provider.dart';

import 'home.dart';
import 'chat.dart';
import 'crush.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      print(index);
      _selectedIndex = index;
    });
  }

  List<Widget> ScreensList = <Widget>[
    Home(),
    Chat(),
    Flames(),
    Crush(),
  ];

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext context) => ChangeNotifierProvider(
        create: (context) => FeedbackPositionProvider(),
        child: MaterialApp(
          title: 'Meet Ceylon',
          theme: ThemeData(
            // scaffoldBackgroundColor: const Color(0x1F000000),
            bottomSheetTheme: BottomSheetThemeData(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0)),
                ),
                backgroundColor: Colors.black.withOpacity(0.5)),
            primarySwatch: Colors.deepOrange,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: Scaffold(
            body: ScreensList.elementAt(_selectedIndex),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.shifting,
              elevation: 0,
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.home,
                    size: 30.0,
                  ),
                  label: 'Home',
                  backgroundColor: Colors.white,
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.question_answer_rounded,
                    size: 30.0,
                  ),
                  label: 'Chat',
                  backgroundColor: Colors.white,
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.local_fire_department,
                    size: 30.0,
                  ),
                  label: 'Flames',
                  backgroundColor: Colors.white,
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.star,
                    size: 30.0,
                  ),
                  label: 'Crush',
                  backgroundColor: Colors.white,
                ),
              ],
              currentIndex: _selectedIndex,
              selectedItemColor: Colors.amber[800],
              unselectedItemColor: Color(0xFFF434A50),
              onTap: _onItemTapped,
            ),
          ),
        ),
      ),
    );
  }
}
