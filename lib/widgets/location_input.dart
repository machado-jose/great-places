import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:great_places/model/place.dart';
import 'package:great_places/screens/map_screen.dart';
import 'package:great_places/utils/location_util.dart';
import 'package:location/location.dart';

class LocationInput extends StatefulWidget {
  final Function onSelectedPosition;

  LocationInput({@required this.onSelectedPosition});

  @override
  _LocationInputState createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  String _previewImageUrl;

  void _showPreview(double latitude, double longitude) {
    final staticMapImageUrl = LocationUtil.generateLocationPreviewImage(
      latitude: latitude,
      longitude: longitude,
    );

    setState(() {
      this._previewImageUrl = staticMapImageUrl;
    });
  }

  Future<void> _getCurrentUserLocation() async {
    try {
      final locData = await Location().getLocation();

      this._showPreview(locData.latitude, locData.longitude);

      widget.onSelectedPosition(
        LatLng(
          locData.latitude,
          locData.longitude,
        ),
      );
    } catch (error) {
      print("[_getCurrentUserLocation()]: $error");
      return;
    }
  }

  Future<void> _selectOnMap() async {
    final locData = await Location().getLocation();

    final LatLng selectedLocation = await Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (ctx) => MapScreen(
          initialLocation: PlaceLocation(
            latitude: locData.latitude,
            longitude: locData.longitude,
          ),
        ),
      ),
    );

    if (selectedLocation == null) return;

    this._showPreview(selectedLocation.latitude, selectedLocation.longitude);

    widget.onSelectedPosition(selectedLocation);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Colors.grey,
            ),
          ),
          height: 170,
          width: double.infinity,
          alignment: Alignment.center,
          child: this._previewImageUrl == null
              ? Text("Localização não informada!")
              : Image.network(
                  this._previewImageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FlatButton.icon(
              onPressed: _getCurrentUserLocation,
              icon: Icon(Icons.location_on),
              label: Text(
                "Localização Atual",
                style: TextStyle(
                  fontSize: 11,
                ),
              ),
              textColor: Theme.of(context).primaryColor,
            ),
            FlatButton.icon(
              onPressed: _selectOnMap,
              icon: Icon(Icons.map),
              label: Text(
                "Selecione no Mapa",
                style: TextStyle(
                  fontSize: 11,
                ),
              ),
              textColor: Theme.of(context).primaryColor,
            ),
          ],
        )
      ],
    );
  }
}
