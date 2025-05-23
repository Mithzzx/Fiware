import 'package:finance_apk/Pages/addpage.dart';
import 'package:finance_apk/Pages/morepage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Components/AppBar/bottom_nav_bar.dart';
import 'Pages/plannings_page.dart';
import 'Pages/homepage.dart';
import 'Pages/statspage.dart';
import 'Pages/theme_provider.dart';
import 'backend/database_helper.dart';


void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(ThemeProvider.currentTheme.themeData), // Default theme
      child: MyApp(),
    ),
  );
}


class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {a
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return ChangeNotifierProvider(
            create: (_) => FinanceState(),
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: themeProvider.themeData, // Use the theme from the provider
              home: MainPage(),
            )
        );
      },
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  // Define your pages as separate widgets
  final List<Widget> _pages = [
    HomePage(),  // From home_page.dart
    PlanningPage(),
    StatsPage(),
    StatsPage(),// From budgets_page.dart
    MorePage()// From settings_page.dart
  ];


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages, // Use the separate pages here
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
        theme: Theme.of(context),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(top: 22), // Move the button down
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) => AddTransactionPage(),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  const begin = Offset(0.0, 1.0);
                  const end = Offset.zero;
                  const curve = Curves.ease;

                  var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                  var offsetAnimation = animation.drive(tween);

                  return SlideTransition(
                    position: offsetAnimation,
                    child: child,
                  );
                },
              ),
            );
          },
          elevation: 0,
          backgroundColor: Colors.green,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          child: const Icon(Icons.add,color: Colors.white,),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
