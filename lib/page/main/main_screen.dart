import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:meet_ceylon/page/sub/filters_screen.dart';
import 'package:meet_ceylon/page/sub/message_screen.dart';
import 'package:meet_ceylon/page/sub/settings_screen.dart';
import 'package:meet_ceylon/page/main/chat.dart';
import 'package:meet_ceylon/page/main/flame.dart';
import 'package:meet_ceylon/page/main/home.dart';
import 'package:meet_ceylon/page/user_profile/profile.dart';
import 'package:meet_ceylon/widget/page_routes/scale_page_route.dart';
import 'package:meet_ceylon/widget/page_routes/slide_right_page_route.dart';

import '../test.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with WidgetsBindingObserver {
  int _selectedIndex = 0;

  ///Ref to Firebase DB
  final DatabaseReference _ref = FirebaseDatabase(
          databaseURL:
              "https://meet-ceylon-5ec4a.europe-west1.firebasedatabase.app/")
      .reference();

  ///Current user id
  final String currentUserId = FirebaseAuth.instance.currentUser.uid;

  ///For Extracting time from DateTime
  final DateTime now = DateTime.now();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>()
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final isFirstRouteInCurrentTab =
            !await _navigatorKeys[_selectedIndex].currentState.maybePop();

        print(
            'isFirstRouteInCurrentTab: ' + isFirstRouteInCurrentTab.toString());

        // let system handle back button if we're on the first route
        return isFirstRouteInCurrentTab;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
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
                Icons.person,
                size: 30.0,
              ),
              label: 'Profile',
              backgroundColor: Colors.white,
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.amber[800],
          unselectedItemColor: Color(0xFFF434A50),
          onTap: _onItemTapped,
        ),
        body: Stack(
          children: [
            _buildOffstageNavigator(0),
            _buildOffstageNavigator(1),
            _buildOffstageNavigator(2),
            _buildOffstageNavigator(3),
          ],
        ),
      ),
    );
  }

  void _next() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => Screen2()));
  }

  void _nav() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => SettingsScreen()));
  }

  ///Filter screen
  void _nav1() {
    Navigator.push(context, SlideRightRoute(page: FilterScreen()));
    //Navigator.push(context, MaterialPageRoute(builder: (context) => FilterScreen()));
  }

  ///Chat Screen
  void _nav2(String id, String user2id, String thumbUri, String name,
      bool isActive, String lastOnline) {
    Navigator.push(
        context,
        ScaleRoute(
            page: MessagesScreen(
          chatID: id,
          user2id: user2id,
          thumbUri: thumbUri,
          name: name,
          isActive: isActive,
          lastOnline: lastOnline,
        )));
  }

  Map<String, WidgetBuilder> _routeBuilders(BuildContext context, int index) {
    return {
      '/': (context) {
        return [
          Home(
            onNav: _next,
          ),
          Chats(
            onNav: _nav2,
          ),
          Flames(),
          UserProfile(
            onNav: _nav,
            onFilterNav: _nav1,
          ),
        ].elementAt(index);
      },
    };
  }

  Widget _buildOffstageNavigator(int index) {
    var routeBuilders = _routeBuilders(context, index);

    return Offstage(
      offstage: _selectedIndex != index,
      child: Navigator(
        key: _navigatorKeys[index],
        onGenerateRoute: (routeSettings) {
          return MaterialPageRoute(
            builder: (context) => routeBuilders[routeSettings.name](context),
          );
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed){
      _ref.child("Users/$currentUserId").update({"isActive": "1"});}
    else{
      _ref.child("Users/$currentUserId").update({"isActive": "0",});
      _ref.child("Users/$currentUserId").update({"lastOnline": now.toString(),});
    }
  }
}
