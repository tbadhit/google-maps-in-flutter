import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

import 'model/map_type_google.dart';

class Map2 extends StatefulWidget {
  @override
  _Map2State createState() => _Map2State();
}

class _Map2State extends State<Map2> {
  Set<Marker> marker = {};
  MapType mapType = MapType.normal;
  GoogleMapController controller;
  double latitude = -6.1952988;
  double longitude = 106.7926625;
  Position userLocation;
  LatLng lastMapPosition;
  String address;

  List<MapTypeGoogle> googleMapsTypes = <MapTypeGoogle>[
    MapTypeGoogle(title: 'Normal'),
    MapTypeGoogle(title: 'Hybrid'),
    MapTypeGoogle(title: 'Terrain'),
    MapTypeGoogle(title: 'Satellite'),
  ];

  selectedStyleMap(MapTypeGoogle type) {
    setState(() {
      if (type.title == "Normal") {
        mapType = MapType.normal;
      } else if (type.title == "Hybrid") {
        mapType = MapType.hybrid;
      } else if (type.title == "Terrain") {
        mapType = MapType.terrain;
      } else if (type.title == "Satellite") {
        mapType = MapType.satellite;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Google Maps v2',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        actions: [
          PopupMenuButton(
            onSelected: selectedStyleMap,
            icon: Icon(
              Icons.more_vert,
              color: Colors.black,
            ),
            itemBuilder: (BuildContext context) {
              return googleMapsTypes.map((tipeMap) {
                return PopupMenuItem(
                  child: Text(tipeMap.title),
                  value: tipeMap,
                );
              }).toList();
            },
          )
        ],
      ),
      body: Stack(
        children: <Widget>[
          GoogleMap(
              markers: marker,
              mapType: mapType,
              onMapCreated: createMap,
              myLocationButtonEnabled: true,
              myLocationEnabled: true,
              initialCameraPosition: CameraPosition(
                  target: LatLng(latitude, longitude), zoom: 17)),

          // Create card
          Positioned(
            top: 30,
            left: 15,
            right: 15,
            child: Material(
              elevation: 8,
              borderRadius: BorderRadius.circular(10),
              child: Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 20, right: 20, top: 8),
                      child: TextField(
                        decoration: InputDecoration(
                            hintText: 'Masukkan alamat..',
                            contentPadding: EdgeInsets.only(top: 15, left: 15),
                            suffixIcon: IconButton(
                              icon: Icon(Icons.search),
                              // TODO:
                              onPressed: () {
                                searchAddress();
                              },
                            )),
                        onChanged: (value) {
                          setState(() {
                            address = value;
                          });
                        },
                      ),
                    ),

                    // Create button
                    RaisedButton(
                      onPressed: () {
                        getLocation().then((value) {
                          setState(() {
                            userLocation = value;
                          });
                          controller.animateCamera(
                              CameraUpdate.newCameraPosition(CameraPosition(
                                  target: LatLng(userLocation.latitude,
                                      userLocation.longitude),
                                  zoom: 17)));
                        });
                      },
                      child: Text('Get My Location'),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    userLocation == null
                        ? Text('Lokasi belum terdeteksi')
                        : Text(resultLocation(
                            userLocation.latitude, userLocation.longitude))
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLocation();
    // Permission
    requestPermission();
  }

  // membuat perizinan menyalakan lokasi :
  Future<void> requestPermission() async {
    await Permission.location.request();
  }

  // ngecreate map
  createMap(GoogleMapController controler) {
    setState(() {
      controller = controler;
    });
  }

  // Untuk mendapatkan lokasi device saat ini :
  Future<Position> getLocation() async {
    var currentLocation;
    try {
      currentLocation = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
    } catch (e) {
      currentLocation = null;
    }

    return currentLocation;
  }

  // Membuat hasil lokasi dan mark
  String resultLocation(double latitude, double longitude) {
    setState(() {
      lastMapPosition = LatLng(latitude, longitude);
      marker.add(Marker(
          markerId: MarkerId(lastMapPosition.toString()),
          position: lastMapPosition,
          infoWindow: InfoWindow(title: 'Hi!, im here', snippet: '5 rating'),
          icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueAzure)));
    });

    return 'My Location: ' +
        userLocation.latitude.toString() +
        ',' +
        userLocation.longitude.toString();
  }

  // Untuk mencari alamat :
  void searchAddress() {
    GeocodingPlatform.instance.locationFromAddress(address).then((result) {
      controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: LatLng(result[0].latitude, result[0].longitude), zoom: 16)));
    });
  }
}
