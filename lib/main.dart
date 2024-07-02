import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:kulinerjogja/presentation/views/auth_pages/login_admin_page/login_page.dart';
import 'package:kulinerjogja/presentation/views/auth_pages/login_user_page/login_page.dart';
import 'package:kulinerjogja/presentation/views/auth_pages/login_user_page/token_page.dart';
import 'package:kulinerjogja/presentation/views/auth_pages/register_page/email_verified_page.dart';
import 'package:kulinerjogja/presentation/views/auth_pages/register_page/register_page.dart';
import 'package:kulinerjogja/presentation/views/auth_pages/register_page/token_page.dart';
import 'package:kulinerjogja/presentation/views/auth_pages/welcome_page/welcome_page.dart';
import 'package:kulinerjogja/presentation/views/home_page/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Panggil initializeDateFormatting untuk menginisialisasi data lokal
  await initializeDateFormatting('id_ID');

  SharedPreferences prefs = await SharedPreferences.getInstance();
  runApp(MyApp(prefs: prefs));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, required this.prefs}) : super(key: key);

  final SharedPreferences prefs;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Color.fromARGB(255, 255, 234, 255),
          ),
          useMaterial3: true,
        ),
        home: EmailVerifiedPage());
  }
}
