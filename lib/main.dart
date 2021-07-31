import 'package:flutter/material.dart';
// import 'package:google_maps_in_flutter/screen/google_map_screen.dart';
import 'home_page.dart';

void main() {
  runApp(MyApp());
}

// panggil package" yang digunakan
// buat ui dlu
// sisanya di masing" page..
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Google maps in flutter',
        home: HomePage());
  }
}
