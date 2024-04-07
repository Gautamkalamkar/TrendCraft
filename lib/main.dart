import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:trendcraft/services/auth/auth_gate.dart';
import 'package:trendcraft/services/auth/auth_service.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if(defaultTargetPlatform == TargetPlatform.android){
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  }
  else{
    await Firebase.initializeApp(options: const FirebaseOptions(apiKey: "AIzaSyCTWTPMVWIWppeSPEifkKT0p08wQnWxbCE", appId: "1:577284010119:web:7bd253b20790153b62c822", messagingSenderId: "577284010119", projectId: "trendcraft-c44e4"));
  }
  runApp(
    ChangeNotifierProvider(create: (context) => AuthService(),child: const MyApp(),
    )
  );
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.blueGrey[200],
        textTheme: GoogleFonts.poppinsTextTheme(),

        //appbar theme
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.green[400],
          titleTextStyle:  GoogleFonts.mukta(
            fontSize: 23,
            color: Colors.black87,
          ),
        )
      ),
      debugShowCheckedModeBanner: false,
      home: const AuthGate(),
    );
  }
}

