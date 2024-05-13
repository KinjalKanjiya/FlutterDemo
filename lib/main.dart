//NOTE:UNCOMMENT THIS CODE FOR SIGNIN WITH GOOGLE FUNCTIONALITY AND COMMENT BELOW CODE

// import 'package:flutter/material.dart';
// import 'sign_in_screen.dart';
// import 'api/google_sign_in_service.dart';

// void main() {
//   runApp(MyApp());
// }


// class MyApp extends StatelessWidget {
//   final String webClientId = '264994690136-4t5u4r9bbu0s680gscbr8r1dsbj0mlku.apps.googleusercontent.com';
// final String backendUrl = "http://192.168.1.7:5000/auth/google";
//   @override
//   Widget build(BuildContext context) {
// final GoogleSignInService _googleSignInService = GoogleSignInService(webClientId, backendUrl);

//     return MaterialApp(
//       title: 'Google Sign-In Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: SignInScreen(googleSignInService: _googleSignInService),
//     );
//   }
// }

//NOTE:
//  CLICK ON BUTTON CURRENT LOCATION ON MAP AND TAP ON  MAP OTHER LOCATION THAT LONGITUDE AND LATITUDE PRINT IN CONSOLE COMMENT ABOVE CODE AND UNCOMMENT BELOW CODE


import 'package:flutter/material.dart';
import 'package:location/location.dart' as location_lib;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Location Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late location_lib.Location location;
  location_lib.LocationData? currentLocation;
  GoogleMapController? mapController;
  Set<Marker> markers = {};
  late LatLng tappedPoint;

  @override
  void initState() {
    super.initState();
    location = location_lib.Location();
  }

  Future<void> getCurrentLocation() async {
    try {
      currentLocation = await location.getLocation();
      setState(() {
        updateMarkers();
      });
      print(currentLocation);
    } catch (e) {
      print('Failed to get location: $e');
    }
  }

  void updateMarkers() {
    markers.clear();
    if (currentLocation != null) {
      markers.add(
        Marker(
          markerId: MarkerId("current_location"),
          position: LatLng(
            currentLocation!.latitude!,
            currentLocation!.longitude!,
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          infoWindow: InfoWindow(title: "Current Location"),
        ),
      );
    }
  }

  void onTapLocation(LatLng point) {
    setState(() {
      markers.clear();
      markers.add(
        Marker(
          markerId: MarkerId("tapped_location"),
          position: point,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          infoWindow: InfoWindow(title: "Tapped Location"),
        ),
      );
      tappedPoint = point;
    });
    print('Tapped Location: ${point.latitude}, ${point.longitude}');
  }

  Future<void> submitLocation() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Loading..."),
          content: CircularProgressIndicator(),
        );
      },
    );
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(tappedPoint.latitude, tappedPoint.longitude);
      Placemark place = placemarks[0];
      Navigator.pop(context); // Dismiss loading dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Location Details"),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Location: ${place.name}'),
                Text('Area: ${place.subLocality}'),
                Text('City: ${place.locality}'),
                Text('State: ${place.administrativeArea}'),
                Text('Country: ${place.country}'),
                Text('Latitude: ${tappedPoint.latitude}'),
                Text('Longitude: ${tappedPoint.longitude}'),
              ],
            ),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Close'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      print("Failed to get address: $e");
      Navigator.pop(context); // Dismiss loading dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text("Failed to get address: $e"),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Close'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Location Demo'),
      ),
      body: currentLocation == null
          ? Center(
              child: ElevatedButton(
                onPressed: getCurrentLocation,
                child: Text('Get Current Location'),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
                      zoom: 15.0,
                    ),
                    onMapCreated: (GoogleMapController controller) {
                      mapController = controller;
                    },
                    onTap: onTapLocation,
                    markers: markers,
                  ),
                ),
                ElevatedButton(
                  onPressed: submitLocation,
                  child: Text('Submit'),
                ),
                ElevatedButton(
                  onPressed: getCurrentLocation,
                  child: Text('Get Current Location'),
                ),
              ],
            ),
    );
  }
}
