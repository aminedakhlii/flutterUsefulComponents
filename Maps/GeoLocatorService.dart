import 'package:geolocator/geolocator.dart';

class GeoLocatorService {

  Future<Position> getLocation() async {
    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
  }

  Future<double> getDistance (startLat , startLong , endLat , endLong) async {
    return Geolocator.distanceBetween(startLat, startLong, endLat, endLong) ;
  }

  Stream<Position> getLiveLocation () {
    return Geolocator.getPositionStream(desiredAccuracy: LocationAccuracy.bestForNavigation , distanceFilter: 2) ;
  }
}
