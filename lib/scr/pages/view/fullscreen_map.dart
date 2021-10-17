import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class FullScreenMap extends StatefulWidget {
  const FullScreenMap({Key? key}) : super(key: key);

  @override
  _FullScreenMapState createState() => _FullScreenMapState();
}

double _zoom = 13.0;
final myPos = LatLng(-37.327154, -59.119667);
MapController _mapController = MapController();
const lightStyle = "light-v10";
const darkStyle = "dark-v10";
String selectedStyle =  "light-v10";

class _FullScreenMapState extends State<FullScreenMap> {
  @override
  Widget build(BuildContext context) {
    final myToken =
        'pk.eyJ1IjoibGVhbmQ5NjYiLCJhIjoiY2t1cmpreDdtMG5hazJvcGp5YzNxa3VubyJ9.laphl_yeaw_9SUbcebw9Rg';

    final pointIcon = 'lib/assets/custom-icon.png';

    return Scaffold(
      body: _mapBox(
          zoom: _zoom,
          myPos: myPos,
          myToken: myToken,
          pointIcon: pointIcon),
      floatingActionButton: _FAB(darkStyle, lightStyle),
    );
  }

  Column _FAB(String darkStyle, String lightStyle) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FloatingActionButton(
            child: Icon(Icons.zoom_in),
            onPressed: () {
              setState(() {
                _zoom = _zoom + 1;
                _mapController.move(myPos, _zoom);
              });
            }),
        const SizedBox(height: 10.0),
        FloatingActionButton(
            child: Icon(Icons.zoom_out),
            onPressed: () {
              _zoom = _zoom - 1;
              if (_zoom < 10.0) {
                _zoom = 10.0;
              }
              _mapController.move(myPos, _zoom);
            }),
        const SizedBox(height: 10.0),
        FloatingActionButton(
            child: Icon(Icons.add_to_home_screen),
            onPressed: () {
              if (selectedStyle == darkStyle) {
                selectedStyle = lightStyle;
              } else {
                selectedStyle = darkStyle;
              }
              print(selectedStyle);
              setState(() {});
            }),
      ],
    );
  }
}

class _mapBox extends StatelessWidget {
  const _mapBox({
    Key? key,
    required this.myPos,
    required this.myToken,
    required this.pointIcon,
    required this.zoom,
  }) : super(key: key);

  final LatLng myPos;
  final String myToken;
  final String pointIcon;
  final double zoom;

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        center: myPos,
        zoom: zoom,
      ),
      nonRotatedLayers: [
        TileLayerOptions(
          //TileLayerOptions(urlTemplate: selectedStyle);
          urlTemplate:
              'https://api.mapbox.com/styles/v1/mapbox/$selectedStyle/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoibGVhbmQ5NjYiLCJhIjoiY2t1cmpreDdtMG5hazJvcGp5YzNxa3VubyJ9.laphl_yeaw_9SUbcebw9Rg',
          additionalOptions: {
            'accessToken': myToken,
            'id': 'mapbox/$selectedStyle',
          },
        ),
        MarkerLayerOptions(
          markers: [
            Marker(
              width: 50.0,
              height: 50.0,
              point: myPos,
              builder: (ctx) => Container(
                child: Image.asset(pointIcon),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
