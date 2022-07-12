import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:vstextile/screen/home_screen.dart';
import 'package:vstextile/screen/login_screen.dart';
import 'package:vstextile/screen/splash_screen.dart';

import 'Screen.dart';

const FIRST_SCREEN = 0;
const SECOND_SCREEN = 1;
const THIRD_SCREEN = 2;

class NavigationProvider extends ChangeNotifier {
  /// Shortcut method for getting [NavigationProvider].
  static NavigationProvider of(BuildContext context) =>
      Provider.of<NavigationProvider>(context, listen: false);

  int _currentScreenIndex = FIRST_SCREEN;

  int get currentTabIndex => _currentScreenIndex;

  Route<dynamic> onGenerateRoute(RouteSettings settings) {
    print('Generating route: ${settings.name}');
    switch (settings.name) {
      default:
        return MaterialPageRoute(builder: (_) => SplashScreen());
    }
  }

  final Map<int, Screen> _screens = {
    FIRST_SCREEN: Screen(
      title: 'First',
      child: HomeScreen(),
      initialRoute: HomeScreen.route,
      navigatorState: GlobalKey<NavigatorState>(),
      onGenerateRoute: (settings) {
        print('Generating route: ${settings.name}');
        switch (settings.name) {
          default:
            return MaterialPageRoute(builder: (_) => HomeScreen());
        }
      },
    ),
    SECOND_SCREEN: Screen(
      title: 'Second',
      child: HomeScreen(),
      initialRoute: HomeScreen.route,
      navigatorState: GlobalKey<NavigatorState>(),
      onGenerateRoute: (settings) {
        print('Generating route: ${settings.name}');
        switch (settings.name) {
          default:
            return MaterialPageRoute(builder: (_) => HomeScreen());
        }
      },
    ),
    THIRD_SCREEN: Screen(
      title: 'Third',
      child: HomeScreen(),
      initialRoute: HomeScreen.route,
      navigatorState: GlobalKey<NavigatorState>(),
      onGenerateRoute: (settings) {
        print('Generating route: ${settings.name}');
        switch (settings.name) {
          default:
            return MaterialPageRoute(builder: (_) => HomeScreen());
        }
      },
    ),
  };

  List<Screen> get screens => _screens.values.toList();

  Screen? get currentScreen => _screens[_currentScreenIndex];

  /// Set currently visible tab.
  void setTab(int tab) {
    if (tab == currentTabIndex) {
      _scrollToStart();
    } else {
      _currentScreenIndex = tab;
      notifyListeners();
    }
  }

  /// If currently displayed screen has given [ScrollController] animate it
  /// to the start of scroll view.
  void _scrollToStart() {
    // if (currentScreen.scrollController != null &&
    //     currentScreen.scrollController.hasClients) {
    //   currentScreen.scrollController.animateTo(
    //     0,
    //     duration: const Duration(seconds: 1),
    //     curve: Curves.easeInOut,
    //   );
    // }
  }

  /// Provide this to [WillPopScope] callback.
  Future<bool> onWillPop(BuildContext context) async {
    final currentNavigatorState = currentScreen!.navigatorState.currentState;

    if (currentNavigatorState!.canPop()) {
      currentNavigatorState.pop();
      return false;
    } else {
      if (currentTabIndex != FIRST_SCREEN) {
        setTab(FIRST_SCREEN);
        notifyListeners();
        return false;
      } else {
        return await showDialog(
          context: context,
          builder: (context) => LoginScreen(),
        );
      }
    }
  }
}
