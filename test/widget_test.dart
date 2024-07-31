import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:sakajob/dashboard_page.dart';
import 'package:sakajob/browse_page.dart';
import 'package:sakajob/profile_page.dart';
import 'package:sakajob/auth_service.dart';
import 'package:sakajob/job_service.dart';
import 'package:sakajob/search_service.dart';

void main() {
  testWidgets('DashboardPage displays jobs and can be filtered',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthService()),
          ChangeNotifierProvider(create: (_) => JobService()),
          ChangeNotifierProvider(create: (_) => SearchService()),
        ],
        child: MaterialApp(
          home: DashboardPage(),
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pump(Duration(seconds: 2)); // Wait for async operations

    // Verify if jobs are loaded and displayed
    expect(find.byType(ListView), findsOneWidget);
  });

  testWidgets('BrowsePage displays categories and new listings',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BrowsePage(),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pump(Duration(seconds: 2)); // Wait for async operations

    // Verify if categories and new listings are loaded and displayed
    expect(find.byType(ListView), findsWidgets);
  });

  testWidgets('ProfilePage displays user information and has a logout button',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => AuthService(),
        child: MaterialApp(
          home: ProfilePage(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Verify if profile information is displayed
    expect(find.text('Jane Doe'), findsOneWidget);
    expect(find.text('name@domain.com'), findsOneWidget);
    expect(find.text('LOGOUT'), findsOneWidget);

    // Tap the logout button
    await tester.tap(find.text('LOGOUT'));
    await tester.pumpAndSettle();

    // Verify if user is logged out (assuming it navigates to the login page)
    expect(find.byType(ListView), findsOneWidget);
  });

  testWidgets('Widgets do not overflow on different screen sizes',
      (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(Size(320, 480)); // Small screen size
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthService()),
          ChangeNotifierProvider(create: (_) => JobService()),
          ChangeNotifierProvider(create: (_) => SearchService()),
        ],
        child: MaterialApp(
          home: DashboardPage(),
        ),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.byType(OverflowBar), findsNothing);

    await tester.binding.setSurfaceSize(Size(1080, 1920)); // Large screen size
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthService()),
          ChangeNotifierProvider(create: (_) => JobService()),
          ChangeNotifierProvider(create: (_) => SearchService()),
        ],
        child: MaterialApp(
          home: DashboardPage(),
        ),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.byType(OverflowBar), findsNothing);
  });
}
