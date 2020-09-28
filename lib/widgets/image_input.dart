import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:path/path.dart' as path;

class ImageInput extends StatefulWidget {
  final Function onSelectImage;

  ImageInput({@required this.onSelectImage});

  @override
  _ImageInputState createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File _storedImage;

  _takePicture() async {
    final _picker = ImagePicker();
    PickedFile _image = await _picker.getImage(
      source: ImageSource.camera,
      maxWidth: 600,
    );

    if (_image == null) return;

    setState(() {
      _storedImage = File(_image.path);
    });

    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final filename = path.basename(this._storedImage.path);
    final savedImage = await this._storedImage.copy(
          "${appDir.path}/$filename",
        );
    widget.onSelectImage(savedImage);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: 180,
          height: 100,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey,
              width: 1,
            ),
          ),
          alignment: Alignment.center,
          child: this._storedImage != null
              ? Image.file(
                  this._storedImage,
                  width: double.infinity,
                  fit: BoxFit.cover,
                )
              : Text('Nenhuma Image!'),
        ),
        SizedBox(width: 10),
        Expanded(
          child: FlatButton.icon(
            icon: Icon(Icons.camera),
            label: Text('Tirar foto'),
            textColor: Theme.of(context).primaryColor,
            onPressed: _takePicture,
          ),
        ),
      ],
    );
  }
}
