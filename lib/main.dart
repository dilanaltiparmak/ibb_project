import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ibb_project/googlemaps/googlemaps_view.dart';
import "locations.dart" as locations;


void main() => runApp(MyApp());
class MyApp1 extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return MaterialApp(title:'Material App', home:GoogleMapsView());
  }
}
class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  final Map<String, Marker> _markers = {};


  Future<void> _onMapCreated(GoogleMapController controller) async {

    final fetchPharmacies = await locations.fetchPharmacies();


    final googleOffices = await locations.getPharmacyOffices();
    setState(() {
      _markers.clear();
      for (final pharmacy in googleOffices.pharmacies) {
        final marker = Marker(
          markerId: MarkerId(pharmacy.Adi),
          position: LatLng(pharmacy.LokasyonX, pharmacy.LokasyonY),
          infoWindow: InfoWindow(
            title: pharmacy.Adi,
            snippet: pharmacy.Adres,
          ),
        );
        _markers[pharmacy.Adi] = marker;
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Google Maps App'),
          backgroundColor: Colors.green[700],
        ),
        body: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: LatLng(38.417675,27.079717),
            zoom: 6,
          ),
          markers: _markers.values.toSet(),
        ),
      ),
    );
  }
}
