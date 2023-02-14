import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart';

import '../repositories.dart';

class LocationRepository extends BaseLocationRepository {
  @override
  Future<Position?> getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      throw 'Location Not Available';
    } else {
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    }
  }

  @override
  Future<Response> getAutocomplete(String searchInput) async {
    Response res = await get(
      Uri.parse(
        'https://nominatim.openstreetmap.org/search/$searchInput?format=jsonv2&addressdetails=1',
      ),
    );

    /**
     * place_id
     * lat
     * lon
     * display_name
     */

    return res;
  }
}
