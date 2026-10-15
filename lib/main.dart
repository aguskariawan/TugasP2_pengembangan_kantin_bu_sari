import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'pages/menu_list_page.dart';
import 'pages/menu_detail_page.dart';
import 'pages/order_page.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const KantinBuSariApp());
}

class KantinBuSariApp extends StatelessWidget {
  const KantinBuSariApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kantin Bu Sari',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => const MenuListPage(),
        '/detail': (context) => const MenuDetailPage(),
        '/pesan': (context) => const OrderPage(),
      },
    );
  }
}
