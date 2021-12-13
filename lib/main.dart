import 'package:cupertino_will_pop_scope/cupertino_will_pop_scope.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rootally/constants/local_storage_key.dart';
import 'package:rootally/locator.dart';
import 'package:rootally/services/navigation_service.dart';
import 'package:rootally/constants/route_path.dart' as routes;
import 'package:rootally/router.dart' as router;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  setupLocator();
  await FirebaseDatabase.instance.setPersistenceEnabled(true);
  await FirebaseDatabase.instance.setPersistenceCacheSizeBytes(10000000);

  SharedPreferences preferences = await SharedPreferences.getInstance();
  String userId = preferences.getString(LocalStorageKey.userId) ?? "";
  if (kDebugMode) {
    // Force disable Crashlytics collection while doing every day development.
    // Temporarily toggle this to true if you want to test crash reporting in your app.
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
  } else {
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  }

  runApp(
    MyApp(
      isLoggedIn: userId != "",
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  const MyApp({Key? key, required this.isLoggedIn}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Ally Care App',
      navigatorKey: locator<NavigationService>().navigatorKey,
      theme: ThemeData(
        fontFamily: GoogleFonts.poppins().fontFamily,
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: ZoomPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoWillPopScopePageTransionsBuilder(),
          },
        ),
      ),
      initialRoute: !isLoggedIn ? routes.loginRoute : routes.homeRoute,
      // initialRoute: routes.loginRoute,
      onGenerateRoute: router.generateRoutes,
    );
  }
}
