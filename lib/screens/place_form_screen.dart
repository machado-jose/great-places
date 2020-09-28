import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:great_places/provider/great_place.dart';
import 'package:great_places/widgets/image_input.dart';
import 'package:great_places/widgets/location_input.dart';
import 'package:provider/provider.dart';

class PlaceFormScreen extends StatefulWidget {
  @override
  _PlaceFormScreenState createState() => _PlaceFormScreenState();
}

class _PlaceFormScreenState extends State<PlaceFormScreen> {
  final _titleController = TextEditingController();

  File _imageSelected;
  LatLng _pickedPosition;

  void _selectImage(File imageSelected) {
    setState(() {
      this._imageSelected = imageSelected;
    });
  }

  void _selectLocation(LatLng position) {
    setState(() {
      this._pickedPosition = position;
    });
  }

  bool _isValidForm() {
    return this._titleController.text.isNotEmpty &&
        this._imageSelected.path.isNotEmpty &&
        this._pickedPosition != null;
  }

  void _submitForm() {
    if (!this._isValidForm()) return;

    Provider.of<GreatPlace>(context, listen: false).addPlace(
      this._titleController.text,
      this._imageSelected,
      this._pickedPosition,
    );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Novo Lugar'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // Start Form
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: <Widget>[
                    TextField(
                      controller: this._titleController,
                      decoration: InputDecoration(labelText: 'Título'),
                    ),
                    SizedBox(height: 10),
                    ImageInput(onSelectImage: this._selectImage),
                    SizedBox(height: 10),
                    LocationInput(onSelectedPosition: this._selectLocation),
                  ],
                ),
              ),
            ),
          ),
          // End Form
          RaisedButton.icon(
            icon: Icon(Icons.add),
            label: Text('Adicionar'),
            color: Theme.of(context).accentColor,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            elevation: 0,
            onPressed: this._isValidForm() ? _submitForm : null,
          ),
        ],
      ),
    );
  }
}
