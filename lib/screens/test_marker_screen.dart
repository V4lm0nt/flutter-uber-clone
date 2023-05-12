import 'package:flutter/material.dart';
import 'package:mapas_app/markers/markers.dart';


class TestMarkerScreen extends StatelessWidget {
  const TestMarkerScreen({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 350,
          height: 150,
          //color: Colors.red,
          child: CustomPaint(
            painter: EndMarkerPainter(
              destination: 'Roosters Rest & Snack Bar Google Maps asfldjdmsagkssdjgnjds',
              kilometers: 30
            ),
          ),
        ),
      )
   );
  }
}