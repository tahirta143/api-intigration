import 'package:api_practice/providers/pro.dart';
import 'package:api_practice/providers/product_provider.dart';
import 'package:api_practice/screens/usersscreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/user_provider.dart';
import 'providers/employee_provider.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => EmployeeProvider()),
        ChangeNotifierProvider(create: (_) => ProProvider()),
    ChangeNotifierProvider(create: (_) => ProductProvider()..fetchProducts()),

      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: UsersScreen(),
      ),
    );
  }
}
