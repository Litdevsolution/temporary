import 'package:get/get.dart';
import '../pages/login/login_page.dart';
import '../pages/home/home_page.dart';

class RouteApp {
  static String login = "/";
  static String home = "/home";
//   static String scan = "/scan";
//   static String profile = "/profile";
//   static String contact = "/contact";

  static List<GetPage> routes = [
    GetPage(
      name: login,
      page: () => LoginPage(),
      transition: Transition.leftToRight,
    ),
    GetPage(
      name: home,
      page: () {
        final role = Get.arguments?['role'] ?? 'USER'; // default fallback
        return HomePage(role: role);
      },
      transition: Transition.leftToRight,
    ),
    // GetPage(
    //   name: scan,
    //   page: () => ScanScreen(),
    //   transition: Transition.leftToRight,
    // ),
    // GetPage(
    //   name: profile,
    //   page: () => ProfileScreen(),
    //   transition: Transition.leftToRight,
    // ),
    // GetPage(
    //   name: contact,
    //   page: () => ContactScreen(),
    //   transition: Transition.leftToRight,
    // ),
  ];
}
