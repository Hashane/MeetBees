import 'package:flutter/material.dart';

// Import the firebase_core plugin
import 'package:firebase_core/firebase_core.dart';
import 'package:meet_ceylon/page/wrapper.dart';
import 'package:meet_ceylon/widget/loading_widget.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(App());
}

class App extends StatelessWidget {
  // Create the initialization Future outside of `build`:
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return const MaterialApp(
           home : Scaffold(body: Center(child: Text("Error"),),),
        );
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return Wrapper();
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return loading();

      },
    );
  }
}