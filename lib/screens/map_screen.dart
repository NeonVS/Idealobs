import 'package:flutter/material.dart';
import 'package:here_sdk/mapview.dart';

import '../widget/map_maker.dart';
import '../models/place.dart';

class MapScreen extends StatefulWidget {
  final PlaceLocation initialLocation;
  final bool isSelecting;
  MapScreen({
    this.initialLocation = const PlaceLocation(
        latitude: 26.449,
        longitude: 80.3319,
        address1: null,
        address2: null,
        pincode: null,
        city: null,
        state: null),
    this.isSelecting = false,
  });
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  var _selectedLatitude;
  var _selectedLongitude;
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _selectedLatitude = widget.initialLocation.latitude;
    _selectedLongitude = widget.initialLocation.longitude;
  }

  void _setLatLong(double latitude, double longitude) {
    _selectedLatitude = latitude;
    _selectedLongitude = longitude;
    // print(latitude);
    // print(longitude);
  }

  void _onMapCreated(HereMapController hereMapController) {
    hereMapController.mapScene.loadSceneForMapScheme(MapScheme.normalDay,
        (MapError error) {
      if (error == null) {
        MapMaker(hereMapController, widget.initialLocation.latitude,
            widget.initialLocation.longitude, widget.isSelecting, _setLatLong);
      } else {
        print("Map scene not loaded. MapError: " + error.toString());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Your Map'),
      //   backgroundColor: Colors.transparent,
      //   actions: <Widget>[
      //     IconButton(
      //       icon: Icon(Icons.check),
      //       onPressed: () {
      //         Navigator.of(context)
      //             .pop([_selectedLatitude, _selectedLongitude]);
      //       },
      //       color: Colors.white,
      //     ),
      //   ],
      // ),
      body: Stack(
        children: [
          HereMap(
            onMapCreated: _onMapCreated,
          ),
          Positioned(
            child: IconButton(
              icon: Icon(Icons.done, size: 33, color: Colors.black54),
              onPressed: () {
                Navigator.of(context)
                    .pop([_selectedLatitude, _selectedLongitude]);
              },
            ),
            top: 30,
            right: 20,
          ),
          Positioned(
            child: ButtonTheme(
              height: 100,
              child: CloseButton(
                onPressed: () {
                  Navigator.of(context)
                      .pop([_selectedLatitude, _selectedLongitude]);
                },
              ),
            ),
            top: 30,
            left: 20,
          ),
        ],
      ),
    );
  }
}
