import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:frontend/configs/configs.dart';
import 'package:latlong2/latlong.dart';

class MapScreen extends StatefulWidget {
  static const String routeName = "/maps";
  static Route route() => MaterialPageRoute(
        settings: RouteSettings(name: routeName),
        builder: (_) => MapScreen(),
      );

  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: AppSize.screenHeight,
            child: FlutterMap(
              options: MapOptions(
                center: LatLng(21.028511, 105.804817),
                zoom: 15,
              ),
              nonRotatedChildren: [
                AttributionWidget.defaultWidget(
                  source: 'OpenStreetMap contributors',
                  onSourceTapped: () {},
                ),
              ],
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'dev.fleaflet.flutter_map.example',
                ),
                // MarkerLayer(markers: markers),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
