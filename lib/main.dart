import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:news_aggregator_app/Auth/auth.dart';
import 'package:news_aggregator_app/Auth/bloc/auth_bloc.dart';
import 'package:news_aggregator_app/home/bloc/home_bloc.dart';
import 'package:news_aggregator_app/home/homeScreen.dart';
import 'package:news_aggregator_app/firebase_options.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';

void main() async{
  await dotenv.load();
  WidgetsFlutterBinding.ensureInitialized();
   WebViewPlatform.instance = AndroidWebViewPlatform();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(),
        ),
        BlocProvider(
          create: (context) => HomeBloc(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(), 
          builder: (context,snapshot){
               if(snapshot.connectionState == ConnectionState.waiting){
                 return const CircularProgressIndicator();
               }
               if(snapshot.hasData){
                return const Homescreen();
               }
                return const AuthScreen();
               
          }
          ),
      ),
    );
  }
}