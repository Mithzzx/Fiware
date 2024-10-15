import 'package:finance_apk/Pages/addpage.dart';
import 'package:finance_apk/Pages/morepage.dart';
import 'package:flutter/material.dart';
import 'Components/AppBar/bottom_nav_bar.dart';
import 'Pages/budgets.dart';
import 'Pages/homepage.dart';
import 'Pages/statspage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.blue,
        brightness: Brightness.dark,
      ),
      home: MainPage(), // MainPage is the home screen with navigation
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
    BudgetsPage(),
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
            // Navigate to Add Transaction Page
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddTransactionPage()),  // Navigate to the new page
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
