import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virgil/providers/models_provider.dart';
import 'package:virgil/providers/size_provider.dart';
import 'package:virgil/providers/theme_provider.dart';
import 'package:virgil/providers/tts_provider.dart';
import 'package:virgil/screens/chat_screen.dart';
import 'package:virgil/screens/image_screen.dart';
import 'package:virgil/services/asset_manager.dart';
import 'package:virgil/services/tts_service.dart';
import 'constants/theme_data.dart';
import 'providers/chat_provides.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:page_transition/page_transition.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  TextToSpeech.initTTS();
  runApp( const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_)=> ModelsProvider()),
        ChangeNotifierProvider(create: (_)=> ChatProvider()),
        ChangeNotifierProvider(create: (_)=> ThemeProvider()),
        ChangeNotifierProvider(create: (_)=> TtsProvider()),
        ChangeNotifierProvider(create: (_)=> SizesProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context,ThemeProvider themeProvider, child){
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            //darkTheme: darkTheme,
            // darkTheme: ThemeData(
            //   scaffoldBackgroundColor: myBackgroundColor,
            //   appBarTheme: AppBarTheme(color: cardColor),
            // ),
            theme: themeProvider.darkTheme?darkTheme:lightTheme,
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(AssetManager.openAILogo, width: 250, height: 250),
            const SizedBox(height: 10,),
            Image.asset(AssetManager.appName, height: 50),
            
          ],
        ),
      ),
      backgroundColor: newColor,
      nextScreen: const ImageScreen(),
      splashIconSize: 350,
      duration: 3000,
      splashTransition: SplashTransition.fadeTransition,
      pageTransitionType: PageTransitionType.rightToLeft,
      animationDuration: const Duration(seconds: 2),
    );
  }
}


