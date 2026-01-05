import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'cots/design_system/styles.dart';
import 'cots/controllers/task_controller.dart';
import 'cots/presentation/pages/dashboard_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TaskController(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'COTS App',
        theme: ThemeData(
          primaryColor: AppColors.primary,
          scaffoldBackgroundColor: AppColors.background,
          useMaterial3: true,
        ),
        home: const DashboardPage(),
      ),
    );
  }
}
