// ignore_for_file: unused_import

import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vstextile/providers/NavigationProvider.dart';
import 'package:vstextile/screen/ProfileScreen.dart';
import 'package:vstextile/screen/address_screen.dart';
import 'package:vstextile/screen/cart_screen.dart';
import 'package:vstextile/screen/filter_screen.dart';
import 'package:vstextile/screen/login_screen.dart';
import 'package:device_preview/device_preview.dart';
import 'package:vstextile/screen/onboarding_screen.dart';
import 'package:vstextile/screen/order_details_screen.dart';
import 'package:vstextile/screen/orders_screen.dart';
import 'package:vstextile/screen/product_details_screen.dart';
import 'package:vstextile/screen/product_listing_screen.dart';
import 'package:vstextile/screen/splash_screen.dart';
import 'package:vstextile/utils/amplitude.dart';
import 'package:vstextile/utils/constant.dart';
import 'package:vstextile/viewmodels/address_viewmodel.dart';
import 'package:vstextile/viewmodels/cart_viewmodel.dart';
import 'package:vstextile/viewmodels/categories_viewmodel.dart';
import 'package:vstextile/viewmodels/home_viewmodel.dart';
import 'package:vstextile/viewmodels/login_viewmodel.dart';
import 'package:vstextile/viewmodels/orders_viewmodel.dart';
import 'package:vstextile/viewmodels/product_details_viewmodel.dart';
import 'package:vstextile/viewmodels/product_listing_viewmodel.dart';
import 'package:vstextile/viewmodels/profile_viewmodel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  analytics.init('d8d3905a1724ce55d7be787729ff7ddf');
  analytics.enableCoppaControl();

  if (Platform.isIOS) {
    await Firebase.initializeApp();
  } else {
    await Firebase.initializeApp();
  }
  runApp(
    // DevicePreview(
    //   enabled: true,tools: [
    //   ...DevicePreview.defaultTools,
    // ],
    //  builder: (context) =>
    const MyApp(), // Wrap your app
    // )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
        ChangeNotifierProvider(create: (_) => ProfileViewModel()),
        ChangeNotifierProvider(create: (_) => HomeViewModel()),
        ChangeNotifierProvider(create: (_) => CategoriesViewModel()),
        ChangeNotifierProvider(create: (_) => ProductListingViewModel()),
        ChangeNotifierProvider(create: (_) => ProductDetailsViewModel()),
        ChangeNotifierProvider(create: (_) => CartViewModel()),
        ChangeNotifierProvider(create: (_) => AddressViewModel()),
        ChangeNotifierProvider(create: (_) => OrdersViewModel()),
      ],
      child: Builder(
        builder: (context) {
          return MaterialApp(
            onGenerateRoute: NavigationProvider.of(context).onGenerateRoute,
          );
        },
      ),
    );

    //   MaterialApp(
    //
    //   useInheritedMediaQuery: true,
    //   locale: DevicePreview.locale(context),
    //   builder: DevicePreview.appBuilder,
    //   title: 'VS Textile',
    //   debugShowCheckedModeBanner: false,
    //   theme: ThemeData(
    //     primarySwatch: colorCustom,
    //   ),
    //   home: SplashScreen(),
    // );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

MaterialColor colorCustom = MaterialColor(0xFF000000, color);
Map<int, Color> color = {
  50: const Color.fromRGBO(136, 14, 79, .1),
  100: const Color.fromRGBO(136, 14, 79, .2),
  200: const Color.fromRGBO(136, 14, 79, .3),
  300: const Color.fromRGBO(136, 14, 79, .4),
  400: const Color.fromRGBO(136, 14, 79, .5),
  500: const Color.fromRGBO(136, 14, 79, .6),
  600: const Color.fromRGBO(136, 14, 79, .7),
  700: const Color.fromRGBO(136, 14, 79, .8),
  800: const Color.fromRGBO(136, 14, 79, .9),
  900: const Color.fromRGBO(136, 14, 79, 1),
};

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
