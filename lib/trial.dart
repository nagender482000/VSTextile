

      // analytics.logEvent('OTP', eventProperties: {'submit_otp': "failure"});






// import 'package:amplitude_flutter/amplitude.dart';
// import 'package:amplitude_flutter/identify.dart';

// class YourClass {
//   Future<void> exampleForAmplitude() async {
//     print("Starting");
//     // Create the instance
//     final Amplitude analytics =
//         Amplitude.getInstance(instanceName: "Vs Textiles Dev");

//     // Initialize SDK
//     analytics.init('d8d3905a1724ce55d7be787729ff7ddf');

//     // Enable COPPA privacy guard. This is useful when you choose not to report sensitive user information.
//     analytics.enableCoppaControl();

//     // Set user Id
//     analytics.setUserId("Nagender Singh");

//     // Turn on automatic session events
//     analytics.trackingSessionEvents(true);

//     // Log an event
//     analytics.logEvent('MyApp startup', eventProperties: {
//       'friend_num': {"user": "2", "user3": "1"},
//       'is_heavy_user': true
//     });

//     // Identify
//     final Identify identify1 = Identify()
//       ..set('identify_test',
//           'identify sent at ${DateTime.now().millisecondsSinceEpoch}')
//       ..add('identify_count', 1);
//     analytics.identify(identify1);

//     // Set group
//     analytics.setGroup('Eventid', 15);

//     // Group identify
//     final Identify identify2 = Identify()..set('identify_count', 1);
//     analytics.groupIdentify('Eventid', '15', identify2);
//     print("Done");
//   }
// }
