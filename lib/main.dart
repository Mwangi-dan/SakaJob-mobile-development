import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'auth_service.dart';
import 'job_service.dart';
import 'dashboard_page.dart';
import 'login_page.dart';
import 'browse_page.dart';
import 'profile_page.dart';
import 'settings_page.dart';
import 'job_details_page.dart';
import 'search_service.dart';
import 'coming_soon.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(SakaJobApp());
}

class SakaJobApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthService()),
        ChangeNotifierProvider(create: (context) => JobService()),
        ChangeNotifierProvider(create: (context) => SearchService()),
      ],
      child: MaterialApp(
        title: 'SakaJob',
        initialRoute: '/',
        routes: {
          '/': (context) => Consumer<AuthService>(
                builder: (context, auth, _) {
                  if (auth.isAuth) {
                    return DashboardPage();
                  } else {
                    return LoginPage();
                  }
                },
              ),
          '/signup': (context) => SignUpPage(),
          '/dashboard': (context) => DashboardPage(),
          '/browse': (context) => BrowsePage(),
          '/profile': (context) => ProfilePage(),
          '/settings': (context) => SettingsPage(),
          '/job-details': (context) => JobDetailsPage(),
          '/coming-soon': (context) => ComingSoonPage(),
        },
      ),
    );
  }
}
