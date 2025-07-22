import 'package:bookify/pages/admin_orders_page.dart';
import 'package:bookify/pages/admin_page.dart';
import 'package:bookify/pages/homePage.dart';
import 'package:bookify/pages/loginPage.dart';
import 'package:bookify/pages/search_page.dart';
import 'package:bookify/pages/user_profile_page.dart';
import 'package:go_router/go_router.dart';

final GoRouter router = GoRouter(
  initialLocation: "/login",
  routes: [
    GoRoute(path: "/login", builder: (context, state) => const LoginPage()),
    GoRoute(path: "/home", builder: (context, state) => const HomePage()),
    GoRoute(path: '/admin', builder: (context, state) => const AdminPage()),
    GoRoute(path: '/search', builder: (context, state) => const SearchPage()),
    GoRoute(path: '/admin/orders', builder: (context, state) => const AdminOrdersPage()),
    GoRoute(
      path: '/profile',
      builder: (context, state) {
        final email = state.extra as String; // expect a String
        return UserProfilePage(userEmail: email);
      },
    ),

  ]
);