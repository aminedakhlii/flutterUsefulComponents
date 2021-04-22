import 'dart:async';
import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

StatefulWidget MarkedMap(latitude,longitude) {

  Completer<GoogleMapController> controller = Completer() ;
  Marker marker = Marker(
      markerId: MarkerId('1'),
      draggable: false,
      position: LatLng(latitude , longitude)
  );
  Set<Marker> markers = HashSet<Marker>() ;

  markers.add(marker) ;

  return GoogleMap(
    initialCameraPosition: CameraPosition(
      target: LatLng(latitude, longitude),
      zoom: 16.0,
    ),
    gestureRecognizers: Set()
      ..add(Factory<PanGestureRecognizer>(() => PanGestureRecognizer()))
      ..add(Factory<ScaleGestureRecognizer>(() => ScaleGestureRecognizer()))
      ..add(Factory<TapGestureRecognizer>(() => TapGestureRecognizer()))
      ..add(Factory<VerticalDragGestureRecognizer>(
              () => VerticalDragGestureRecognizer())),
    mapType: MapType.satellite,
    markers: markers,
    myLocationEnabled: true,
    zoomGesturesEnabled: true,
    onMapCreated: (GoogleMapController c) {
      controller.complete(c);
    },
  );
}
