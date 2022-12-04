import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:bejaii_grocery/src/controllers/delivery_addresses_controller.dart';
import 'package:bejaii_grocery/src/repository/map_address_repository.dart';
import 'package:bejaii_grocery/src/repository/map_places_repository.dart';
import 'generated/l10n.dart';
import 'map_cubit.dart/map_cubit.dart';
import 'route_generator.dart';
import 'src/helpers/app_config.dart' as config;
import 'src/helpers/custom_trace.dart';
import 'src/models/setting.dart';
import 'src/repository/settings_repository.dart' as settingRepo;
import 'src/repository/user_repository.dart' as userRepo;
import 'package:flutter_screenutil/flutter_screenutil.dart';
class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}
Future<void> main() async {
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await Firebase.initializeApp(

  );
  await GlobalConfiguration().loadFromAsset("configurations");

  print(CustomTrace(StackTrace.current,
      message: "base_url: ${GlobalConfiguration().getValue('base_url')}"));
  print(CustomTrace(StackTrace.current,
      message:
          "api_base_url: ${GlobalConfiguration().getValue('api_base_url')}"));
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    settingRepo.initSettings();
    settingRepo.getCurrentLocation();
    userRepo.getCurrentUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (BuildContext context, Widget child) {
        return ValueListenableBuilder(
              valueListenable: settingRepo.setting,
              builder: (context, Setting _setting, _) {
                return BlocProvider(
                  create: (BuildContext context) =>  MapsCubit(MapsRepository(PlacesWebServices())),        
              
      
        child: MaterialApp(
                        navigatorKey: settingRepo.navigatorKey,
                        title: _setting.appName,
                        initialRoute: '/Splash',
                        onGenerateRoute: RouteGenerator.generateRoute,
                        debugShowCheckedModeBanner: false,
                        locale: _setting.mobileLanguage.value,
                        localizationsDelegates: [
                          S.delegate,
                          GlobalMaterialLocalizations.delegate,
                          GlobalWidgetsLocalizations.delegate,
                        ],
                        supportedLocales: S.delegate.supportedLocales,
                        theme: _setting.brightness.value == Brightness.light
                            ? ThemeData(
                                fontFamily: 'ProductSans',
                                primaryColor: Colors.white,
                                floatingActionButtonTheme: FloatingActionButtonThemeData(
                                    elevation: 0, foregroundColor: Colors.white),
                                brightness: Brightness.light,
                                accentColor: config.Colors().mainColor(1),
                                dividerColor: config.Colors().accentColor(0.1),
                                focusColor: config.Colors().accentColor(1),
                                hintColor: config.Colors().secondColor(1),
                                textTheme: TextTheme(
                                  headline5: TextStyle(
                                      fontSize: 22.0,
                                      color: config.Colors().secondColor(1),
                                      height: 1.3),
                                  headline4: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w700,
                                      color: config.Colors().secondColor(1),
                                      height: 1.3),
                                  headline3: TextStyle(
                                      fontSize: 22.0,
                                      fontWeight: FontWeight.w700,
                                      color: config.Colors().secondColor(1),
                                      height: 1.3),
                                  headline2: TextStyle(
                                      fontSize: 24.0,
                                      fontWeight: FontWeight.w700,
                                      color: config.Colors().mainColor(1),
                                      height: 1.4),
                                  headline1: TextStyle(
                                      fontSize: 26.0,
                                      fontWeight: FontWeight.w300,
                                      color: config.Colors().secondColor(1),
                                      height: 1.4),
                                  subtitle1: TextStyle(
                                      fontSize: 17.0,
                                      fontWeight: FontWeight.w500,
                                      color: config.Colors().secondColor(1),
                                      height: 1.2),
                                  headline6: TextStyle(
                                      fontSize: 17.0,
                                      fontWeight: FontWeight.w700,
                                      color: config.Colors().mainColor(1),
                                      height: 1.3),
                                  bodyText2: TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w400,
                                      color: config.Colors().secondColor(1),
                                      height: 1.2),
                                  bodyText1: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w400,
                                      color: config.Colors().secondColor(1),
                                      height: 1.3),
                                  caption: TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w300,
                                      color: config.Colors().accentColor(1),
                                      height: 1.2),
                                ),
                              )
                            : ThemeData(
                                fontFamily: 'ProductSans',
                                primaryColor: Color(0xFF252525),
                                brightness: Brightness.dark,
                                scaffoldBackgroundColor: Color(0xFF2C2C2C),
                                accentColor: config.Colors().mainDarkColor(1),
                                dividerColor: config.Colors().accentColor(0.1),
                                hintColor: config.Colors().secondDarkColor(1),
                                focusColor: config.Colors().accentDarkColor(1),
                                textTheme: TextTheme(
                                  headline5: TextStyle(
                                      fontSize: 22.0,
                                      color: config.Colors().secondDarkColor(1),
                                      height: 1.3),
                                  headline4: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w700,
                                      color: config.Colors().secondDarkColor(1),
                                      height: 1.3),
                                  headline3: TextStyle(
                                      fontSize: 22.0,
                                      fontWeight: FontWeight.w700,
                                      color: config.Colors().secondDarkColor(1),
                                      height: 1.3),
                                  headline2: TextStyle(
                                      fontSize: 24.0,
                                      fontWeight: FontWeight.w700,
                                      color: config.Colors().mainDarkColor(1),
                                      height: 1.4),
                                  headline1: TextStyle(
                                      fontSize: 26.0,
                                      fontWeight: FontWeight.w300,
                                      color: config.Colors().secondDarkColor(1),
                                      height: 1.4),
                                  subtitle1: TextStyle(
                                      fontSize: 17.0,
                                      fontWeight: FontWeight.w500,
                                      color: config.Colors().secondDarkColor(1),
                                      height: 1.2),
                                  headline6: TextStyle(
                                      fontSize: 17.0,
                                      fontWeight: FontWeight.w700,
                                      color: config.Colors().mainDarkColor(1),
                                      height: 1.3),
                                  bodyText2: TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w400,
                                      color: config.Colors().secondDarkColor(1),
                                      height: 1.2),
                                  bodyText1: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w400,
                                      color: config.Colors().secondDarkColor(1),
                                      height: 1.3),
                                  caption: TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w300,
                                      color: config.Colors().secondDarkColor(0.6),
                                      height: 1.2),
                                ),
                              ))
                    
                  );
              });
      }
    )
    ;
  }
}
