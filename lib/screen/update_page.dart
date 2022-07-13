import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';

class UpdatePage extends StatefulWidget {
  const UpdatePage({Key? key}) : super(key: key);

  @override
  State<UpdatePage> createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: showAlertDialog(context),
    );
  }
}

AlertDialog showAlertDialog(BuildContext context) {
  Widget update = TextButton(
      onPressed: () {
        launchUrl(Uri.parse(
            "https://play.google.com/store/apps/details?id=co.vstextile"));
      },
      child: const Text("Update"));

  return AlertDialog(
    title: Text("Update Avialable"),
    content: Text("Please update your app to continue using the app."),
    actions: <Widget>[update],
  );
}
