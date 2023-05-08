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


