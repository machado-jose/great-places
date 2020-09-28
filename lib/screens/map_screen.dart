import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:great_places/model/place.dart';

class MapScreen extends StatefulWidget {
  final PlaceLocation initialLocation;
  final bool isReadOnly;

  MapScreen({
    this.initialLocation =
        const PlaceLocation(latitude: 37.419857, longitude: -122.078827),
    this.isReadOnly = false,
  });

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng _pickedLocation;

  void _selectPosition(LatLng location) {
    setState(() {
      this._pickedLocation = location;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Selecione...'),
        actions: <Widget>[
          if (!widget.isReadOnly)
            IconButton(
              icon: Icon(Icons.check),
              onPressed: () => this._pickedLocation == null
                  ? null
                  : Navigator.of(context).pop(this._pickedLocation),
            ),
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          zoom: 13,
          target: LatLng(widget.initialLocation.latitude,
              widget.initialLocation.longitude),
        ),
        onTap: widget.isReadOnly ? null : _selectPosition,
        markers: (this._pickedLocation == null && !widget.isReadOnly)
            ? null
            : {
                Marker(
                  markerId: MarkerId('p1'),
                  position: this._pickedLocation ?? widget.initialLocation.toLatLng(),
                ),
              },
      ),
    );
  }
}
