import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mycookcoach/Entry_point.dart';
import 'package:mycookcoach/core/errors/error_screen.dart';
import 'package:mycookcoach/features/Catalogue%20des%20prestations/presentation/pages/Cours/recipe_screen.dart';
import 'package:mycookcoach/features/Catalogue%20des%20prestations/presentation/pages/formation_screen/formation_screen.dart';
import 'package:mycookcoach/features/Notifications%20et%20alertes/presentation/pages/notifications_page.dart';
import 'package:mycookcoach/features/authentication/presentation/blocs/auth_blocs/auth_bloc.dart';
import 'package:mycookcoach/features/authentication/presentation/blocs/auth_blocs/auth_state.dart';
import 'package:mycookcoach/features/authentication/presentation/pages/welcome_screen.dart';
import 'package:mycookcoach/features/location_espace/presentation/pages/location_screen.dart';
import 'package:mycookcoach/features/shop/presentation/pages/orders_screen.dart';
import 'package:mycookcoach/features/shop/presentation/pages/shop_screen.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    var authBloc = BlocProvider.of<AuthenticationBloc>(context, listen: true);

    final GoRouter router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const WelcomeScreen(),
        ),
        GoRoute(
          path: '/home',
          builder: (context, state) =>
              const /*EntryPoint(), ShopScreen(),  FormationScreen(), HomeRecipeScreen(),*/ LocationScreen(),
        ),
        GoRoute(
          path: '/notification',
          builder: (context, state) => NotificationsPage(),
        ),
      ],
      errorBuilder: (context, state) => const ErrorScreen(
        errorMessage: " error goRouter builder ! ",
      ),
      redirect: (context, state) {
        var authState = authBloc.state;

        if (authState.status == AuthenticationStatus.unknown) {
          return null;
        }

        var isLoggedIn = authState.status == AuthenticationStatus.authenticated;
        final loggingIn = state.uri.toString() == '/';

        if (!isLoggedIn && !loggingIn) {
          return '/';
        } else if (isLoggedIn && loggingIn) {
          return '/home';
        }
        return null;
      },
    );

    return MaterialApp.router(
      routeInformationProvider: router.routeInformationProvider,
      routeInformationParser: router.routeInformationParser,
      routerDelegate: router.routerDelegate,
      title: 'MyCookCoach',
      theme: ThemeData(
        colorScheme: ColorScheme.light(
          background: Colors.white,
          onBackground: Colors.black,
          primary: Color(0xFF37B6E9),
          onPrimary: Colors.black,
          secondary: Color(0xFF4B4CED),
          onSecondary: Colors.white,
          tertiary: Color.fromRGBO(255, 204, 128, 1),
          error: Colors.red,
          outline: Color(0xFF424242),
        ),
      ),
    );
  }
}
