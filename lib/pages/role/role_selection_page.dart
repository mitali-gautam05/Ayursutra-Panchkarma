// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'utils/routes.dart';
// // import 'firebase_options.dart';

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
  
//   await Firebase.initializeApp(
//     options: const FirebaseOptions(
//       apiKey: "firebase-key.json",
//       authDomain: "panchkarma.firebaseapp.com",
//       projectId: "panchkarma-732a2",
//       storageBucket: "panchkarma.appspot.com",
//       messagingSenderId: "YOUR_MESSAGING_ID",
//       appId: "YOUR_APP_ID",
//       // measurementId: "G-XXXXXXX",
//     ),
//   );
//   runApp(const AyurSutraApp());
// }

// class AyurSutraApp extends StatelessWidget {
//   const AyurSutraApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'AyurSutra',
//       debugShowCheckedModeBanner: false,
//       initialRoute: AppRoutes.login,
//       onGenerateRoute: AppRoutes.generateRoute,
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // ✅ Use this instead of manual config
import 'utils/routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // ✅ Auto-selects config
  );

  runApp(const AyurSutraApp());
}

class AyurSutraApp extends StatelessWidget {
  const AyurSutraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AyurSutra',
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.login,
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}