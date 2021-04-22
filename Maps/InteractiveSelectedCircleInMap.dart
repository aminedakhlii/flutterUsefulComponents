// This widget is a map in which a circle of a given center and radius is selected
// This Widget requires the GeoLocatorService.dart from this directory

import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'geolocator.dart';
import 'dart:async';

class MapWithSelectedCircle extends StatefulWidget {
  @override
  MapWithSelectedCircleState createState() => MapWithSelectedCircleState() ;
}

class MapWithSelectedCircleState extends State<MapWithSelectedCircle> {

  final geoService = GeoLocatorService();
  Completer<GoogleMapController> controller = Completer();
  Set<Circle> circles = HashSet<Circle>();
  double radius = 300; //You might want to set the initial radius
  LatLng _point;

  Future<void> centerScreen (position) async {
    final GoogleMapController c = await controller.future ;
    c.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(position.latitude , position.longitude),
    zoom: 20)));
  }

  void setCircle (center) {
    setState(() {
      circles.add(Circle(
        circleId: CircleId('1'),
        center: center,
        radius: radius,
        fillColor: Colors.red.withOpacity(0.5),
        strokeWidth: 3,
        strokeColor: Colors.red
      ));
    });
  }

  Widget build(BuildContext context) {
      return Scaffold(
          body:  FutureBuilder(
            future: geoService.getLocation(),
            builder : (context , snap) => (snap.data != null) ? Column(
              children: <Widget>[
                Container(
                    height: MediaQuery.of(context).size.height * 0.75,
                    width: MediaQuery.of(context).size.width ,
                    child : GoogleMap(
                              initialCameraPosition: CameraPosition(target: LatLng(snap.data.latitude,snap.data.longitude),
                                zoom: 16.0,),
                              mapType: MapType.satellite,
                              circles: circles,
                              myLocationEnabled: true,
                              zoomGesturesEnabled: true,
                              onMapCreated: (GoogleMapController c) {
                                controller.complete(c) ;
                              },
                              onTap: (point) {
                                _point = point ;
                                circles.clear();
                                setCircle(point);
                              },
                    )
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.03,),
                Slider.adaptive(
                    value: radius,
                    onChanged: (newValue) {
                      setState(() {
                        radius = newValue ;
                        circles.clear() ;
                        setCircle(_point);
                      });
                    },
                  label: radius.toString(),
                  min: 50,
                  max: 3000,// You might want to set the min and max radius
                )
                SizedBox(height: MediaQuery.of(context).size.height * 0.03,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    FloatingActionButton.extended(
                      heroTag: 'backlocationlost',
                      label: Text('back'),
                      icon: Icon(Icons.arrow_back_ios),
                      onPressed: () => Navigator.of(context).pop(),
                    ),

                    FloatingActionButton.extended(
                      heroTag: 'approvelocationlost',
                      label: Text('Approve'),
                      icon: Icon(Icons.approval),
                      onPressed: () => Navigator.of(context).pop({
                        'radius' : radius,
                        'lat' : _point.latitude,
                        'long' : _point.longitude,
                      }),
                    ),
                  ],
                )
              ],
            ) : Center(
                  child: CircularProgressIndicator(),
                )
          )
      );
  }


}
