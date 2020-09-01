import 'dart:typed_data';

import 'package:flutter/services.dart' show rootBundle;
import 'package:here_sdk/core.dart';
import 'package:here_sdk/gestures.dart';
import 'package:here_sdk/mapview.dart';

class MapMaker {
  HereMapController _hereMapController;
  MapImage _poiMapImage;
  double _initialLatitude;
  double _initialLongitude;
  bool _isSelecting;
  Function _setLatLong;
  MapMarker _mapMarker = null;
  //Constructor
  MapMaker(HereMapController hereMapController, double latitude,
      double longitude, bool isSelecting, Function setLatLong) {
    _hereMapController = hereMapController;
    _initialLatitude = latitude;
    _initialLongitude = longitude;
    _isSelecting = isSelecting;
    _setLatLong = setLatLong;
    double distanceToEarthInMeters = 8000;
    _hereMapController.camera.lookAtPointWithDistance(
        GeoCoordinates(_initialLatitude, _initialLongitude),
        distanceToEarthInMeters);
    _addPOIMapMarker(GeoCoordinates(latitude, longitude), 1);
    if (_isSelecting) {
      _setTapGestureHandler();
    }
  }
  //Adding Poi image
  Future<void> _addPOIMapMarker(
      GeoCoordinates geoCoordinates, int drawOrder) async {
    // Reuse existing MapImage for new map markers.
    if (_poiMapImage == null) {
      Uint8List imagePixelData = await _loadFileAsUint8List('poi.png');
      _poiMapImage =
          MapImage.withPixelDataAndImageFormat(imagePixelData, ImageFormat.png);
    }

    // By default, the anchor point is set to 0.5, 0.5 (= centered).
    // Here the bottom, middle position should point to the location.
    Anchor2D anchor2D = Anchor2D.withHorizontalAndVertical(0.5, 1);

    MapMarker mapMarker =
        MapMarker.withAnchor(geoCoordinates, _poiMapImage, anchor2D);
    mapMarker.drawOrder = drawOrder;

    Metadata metadata = new Metadata();
    metadata.setString("key_poi", "Metadata: This is a POI.");
    mapMarker.metadata = metadata;
    if (_mapMarker != null) {
      _hereMapController.mapScene.removeMapMarker(_mapMarker);
    }
    _hereMapController.mapScene.addMapMarker(mapMarker);
    _mapMarker = mapMarker;
  }

  Future<Uint8List> _loadFileAsUint8List(String fileName) async {
    // The path refers to the assets directory as specified in pubspec.yaml.
    ByteData fileData = await rootBundle.load('assets/' + fileName);
    return Uint8List.view(fileData.buffer);
  }

  //Adding Poi marker
  void _setTapGestureHandler() {
    _hereMapController.gestures.tapListener =
        TapListener.fromLambdas(lambda_onTap: (Point2D touchPoint) {
      var point = _hereMapController.viewToGeoCoordinates(touchPoint);
      var geoCoordinates = _toString(point);
      print('Point on $geoCoordinates');

      _addPOIMapMarker(point, 1);
      _setLatLong(point.latitude, point.longitude);
    });
  }

  String _toString(GeoCoordinates geoCoordinates) {
    return geoCoordinates.latitude.toString() +
        ", " +
        geoCoordinates.longitude.toString();
  }
}
