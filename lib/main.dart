import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:temporary/routes/route_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const Main());
}

class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: RouteApp.login, // 👈 Use your first page route here
      getPages: RouteApp.routes,
    );
  }
}
// 11:00