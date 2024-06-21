// ignore_for_file: prefer_const_constructors

import 'package:get/get.dart';

import '../../screens/auth/login_screen.dart';
import '../../screens/auth/pin_login_screen.dart';
import '../../screens/bottom_nav_bar/bottom_nav_bar_screen.dart';
import '../../screens/history/history_screen.dart';
import '../../screens/home/comment_screen.dart';
import '../../screens/home/home_screen.dart';
import '../../screens/profile/profile_screen.dart';
import '../../screens/splash/splash_screen.dart';

final appRoute = [
  GetPage(name: '/splash', page: () => const SplashScreen()),
  GetPage(name: '/pinLogin', page: () => const PINLoginScreen()),
  GetPage(name: '/bottomNavBar', page: () => const BottomNavBarScreen()),
  GetPage(name: '/login', page: () => LoginScreen()),
  GetPage(name: '/home', page: () => HomeScreen()),
  GetPage(name: '/comment', page: () => CommentScreen()),
  GetPage(name: '/history', page: () => HistoryScreen()),
  GetPage(name: '/profile', page: () => ProfileScreen()),
];
