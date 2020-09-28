import 'package:flutter/material.dart';
import 'package:great_places/model/place.dart';
import 'package:great_places/screens/map_screen.dart';

class PlaceDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Place place = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text(place.title),
      ),
      body: Column(
        children: <Widget>[
          Container(
            height: 250,
            width: double.infinity,
            child: Image.file(
              place.image,
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
          SizedBox(height: 10),
          Text(
            place.location.address,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey,
              fontSize: 20,
            ),
          ),
          SizedBox(height: 10),
          FlatButton.icon(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                fullscreenDialog: true,
                builder: (_) => MapScreen(
                  isReadOnly: true,
                  initialLocation: place.location,
                ),
              ),
            ),
            icon: Icon(Icons.map),
            label: Text('Ver o mapa'),
            textColor: Theme.of(context).primaryColor,
          ),
        ],
      ),
    );
  }
}
