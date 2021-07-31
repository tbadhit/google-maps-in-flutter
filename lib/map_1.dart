import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_in_flutter/model/map_type_google.dart';

class Map1 extends StatefulWidget {
  @override
  _Map1State createState() => _Map1State();
}

class _Map1State extends State<Map1> {
  MapType mapType = MapType.normal;
  double latitude = -6.1952988;
  double longitude = 106.7926625;
  double zoom = 15;
  // Controller
  Completer<GoogleMapController> _controller = Completer();

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
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Google Maps v1',
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
                  child: Text(tipeMap.title!),
                  value: tipeMap,
                );
              }).toList();
            },
          )
        ],
      ),
      body: Stack(
        children: [_buildMap(), _zoomOut(), _zoomIn(), _buildDetailPage()],
      ),
    );
  }

  // 1
  _buildMap() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: GoogleMap(
        mapType: mapType,
        initialCameraPosition:
            CameraPosition(target: LatLng(latitude, longitude), zoom: 17),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        markers: {imaStudio, monas, istana, masjid},
      ),
    );
  }

  // Membuat marker detail (manual) :
  static Marker imaStudio = Marker(
      markerId: MarkerId("imaStudio"),
      position: LatLng(-6.195303, 106.7926562),
      infoWindow: InfoWindow(title: "Training Mobile App"),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure));

  static Marker monas = Marker(
      markerId: MarkerId("monas"),
      position: LatLng(-6.1753871, 106.8249587),
      infoWindow: InfoWindow(title: "Monumen Nasional"),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure));

  static Marker istana = Marker(
      markerId: MarkerId("Istana Merdeka"),
      position: LatLng(-6.1701812, 106.8219803),
      infoWindow: InfoWindow(title: "Istana Merdeka"),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure));

  static Marker masjid = Marker(
      markerId: MarkerId("Masjid Istiqlal"),
      position: LatLng(-6.1699883, 106.8287337),
      infoWindow: InfoWindow(title: "Masjid Istiqlal"),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure));

  // 2
  _zoomOut() {
    return Align(
      alignment: Alignment.topRight,
      child: IconButton(
        icon: Icon(Icons.zoom_out),
        onPressed: () {
          zoom--;
          _zoomAction(zoom, latitude, longitude);
        },
      ),
    );
  }

  // 3
  _zoomIn() {
    return Align(
      alignment: Alignment.topLeft,
      child: IconButton(
        icon: Icon(Icons.zoom_in),
        onPressed: () {
          zoom++;
          _zoomAction(zoom, latitude, longitude);
        },
      ),
    );
  }

  // Membuat aksi ketika icon zoom_in dan zoom_out di klik
  void _zoomAction(double zoom, double latitude, double longitude) async {
    GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(latitude, longitude), zoom: zoom)));
  }

  // Membuat fungsi detail card :
  _buildDetailPage() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 150,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            SizedBox(
              width: 10,
            ),
            _displayPlaceCard(
                "https://idn.sch.id/wp-content/uploads/2016/10/ima-studio.png",
                "ImaStudio",
                -6.1952988,
                106.7926625),
            SizedBox(
              width: 10,
            ),
            _displayPlaceCard(
                "https://2.bp.blogspot.com/-0WirdbkDv4U/WxUkajG0pAI/AAAAAAAADNA/FysRjLMqCrw_XkcU0IQwuqgKwXaPpRLRgCLcBGAs/s1600/1528109954774.jpg",
                "Monas",
                -6.1753871,
                106.8249587),
            SizedBox(
              width: 10,
            ),
            _displayPlaceCard(
                "https://cdn1-production-images-kly.akamaized.net/n8uNqIv9lZ3PJVYw-8rfy8DZotE=/640x360/smart/filters:quality(75):strip_icc():format(jpeg)/kly-media-production/medias/925193/original/054708200_1436525200-6-Masjid-Megah-Istiqlal.jpg",
                "Masjid Istiqlal",
                -6.1702229,
                106.8293614),
            SizedBox(
              width: 10,
            ),
            _displayPlaceCard(
                "https://img-z.okeinfo.net/library/images/2018/08/14/gtesxf7d7xil1zry76xn_14364.jpg",
                "Istana Merdeka",
                -6.1701238,
                106.8219881),
          ],
        ),
      ),
    );
  }

  // Fungsi tampilan tempat card :
  _displayPlaceCard(String image, String name, double lat, double lng) {
    return GestureDetector(
      onTap: () {
        _placeCardClicked(lat, lng);
      },
      child: Container(
        width: 330,
        margin: EdgeInsets.only(bottom: 20),
        child: Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          elevation: 10,
          child: Row(
            children: [
              Container(
                width: 90,
                height: 90,
                margin: EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                        image: NetworkImage(image), fit: BoxFit.cover)),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: Text(
                        name,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      child: Row(
                        children: <Widget>[
                          Container(
                            child: Text(
                              "4.9",
                              style: TextStyle(fontSize: 15),
                            ),
                          ),
                          Container(
                            child: Icon(
                              Icons.star,
                              color: Colors.orange,
                              size: 15,
                            ),
                          ),
                          Container(
                            child: Icon(
                              Icons.star,
                              color: Colors.orange,
                              size: 15,
                            ),
                          ),
                          Container(
                            child: Icon(
                              Icons.star,
                              color: Colors.orange,
                              size: 15,
                            ),
                          ),
                          Container(
                            child: Icon(
                              Icons.star,
                              color: Colors.orange,
                              size: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      child: Text(
                        "Indonesia \u00B7 Jakarta Barat",
                        style: TextStyle(color: Colors.black, fontSize: 15),
                      ),
                    ),
                    Container(
                      child: Text(
                        "Closed \u00B7 Open 09.00 Monday",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // Fungsi ketika card di click :
  _placeCardClicked(double lat, double lng) async {
    setState(() {
      latitude = lat;
      longitude = lng;
    });

    GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(latitude, longitude),
        zoom: 17,
        tilt: 55,
        bearing: 192)));
  }
}
