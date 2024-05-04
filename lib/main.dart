import 'package:flutter/material.dart';
import 'sign_in_screen.dart';
import 'api/google_sign_in_service.dart';

void main() {
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  final String webClientId = '264994690136-4t5u4r9bbu0s680gscbr8r1dsbj0mlku.apps.googleusercontent.com';
final String backendUrl = "http://192.168.1.7:5000/auth/google";
  @override
  Widget build(BuildContext context) {
final GoogleSignInService _googleSignInService = GoogleSignInService(webClientId, backendUrl);

    return MaterialApp(
      title: 'Google Sign-In Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SignInScreen(googleSignInService: _googleSignInService),
    );
  }
}

//NOTE:
//  CLICK ON BUTTON CURRENT LOCATION ON MAP AND TAP ON  MAP OTHER LOCATION THAT LONGITUDE AND LATITUDE PRINT IN CONSOLE COMMENT ABOVE CODE AND UNCOMMENT BELOW CODE


// import 'package:flutter/material.dart';
// import 'package:location/location.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Location Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: MyHomePage(),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   late Location location;
//   LocationData? currentLocation;
//   GoogleMapController? mapController;
//   Set<Marker> markers = {};

//   @override
//   void initState() {
//     super.initState();
//     location = Location();
//   }

//   void getCurrentLocation() async {
//     try {
//       currentLocation = await location.getLocation();
//       setState(() {
//         markers.add(
//           Marker(
//             markerId: MarkerId("current_location"),
//             position: LatLng(
//               currentLocation!.latitude!,
//               currentLocation!.longitude!,
//             ),
//             icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
//             infoWindow: InfoWindow(title: "Current Location"),
//           ),
//         );
//       });
//       print(currentLocation);
//     } catch (e) {
//       print('Failed to get location: $e');
//     }
//   }

//   void onTapLocation(LatLng tappedPoint) {
//     setState(() {
//       // Remove the previous blue marker
//       markers.removeWhere((marker) => marker.markerId.value != "current_location");
//       // Add the new blue marker
//       markers.add(
//         Marker(
//           markerId: MarkerId(tappedPoint.toString()),
//           position: tappedPoint,
//           icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
//           infoWindow: InfoWindow(title: "Tapped Location"),
//         ),
//       );
//     });
//     // Print latitude and longitude to the console
//     print('Tapped Location: ${tappedPoint.latitude}, ${tappedPoint.longitude}');
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Location Demo'),
//       ),
//       body: currentLocation == null
//           ? Center(
//               child: ElevatedButton(
//                 onPressed: getCurrentLocation,
//                 child: Text('Get Current Location'),
//               ),
//             )
//           : Column(
//               children: [
//                 Expanded(
//                   child: GoogleMap(
//                     initialCameraPosition: CameraPosition(
//                       target: LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
//                       zoom: 15.0,
//                     ),
//                     onMapCreated: (GoogleMapController controller) {
//                       mapController = controller;
//                     },
//                     onTap: onTapLocation,
//                     markers: markers,
//                   ),
//                 ),
//                 ElevatedButton(
//                   onPressed: getCurrentLocation,
//                   child: Text('Get Current Location'),
//                 ),
//               ],
//             ),
//     );
//   }
// }
