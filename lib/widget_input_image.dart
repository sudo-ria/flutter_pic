import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class InputImage extends StatefulWidget {
  @override
  _InputImageState createState() => _InputImageState();
}

class _InputImageState extends State<InputImage> {
  List<DataImageModel> _dataImages = [];
  List<Widget> _selectedImages = [];

  Widget getImageWidget(File _selectedFile) {
    return Image.file(
      _selectedFile,
      width: 150,
      height: 150,
      fit: BoxFit.cover,
    );
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Ошибка'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Нельзя прикрепить больше 5 фотографий'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Закрыть'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showImage(String _base64, int _index) async {
    return showDialog(
        context: context,
        builder: (_) => new AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              content: Builder(
                builder: (context) {
                  return Container(
                    height: 350,
                    // width: 550,
                    child: Column(
                      children: <Widget>[
                        Flexible(
                          fit: FlexFit.tight,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                child: Image.memory(base64Decode(_base64)),
                                height: 250,
                                width: 350,
                              ),
                            ],
                            mainAxisAlignment: MainAxisAlignment.center,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              // padding: const EdgeInsets.all(8.0),
                              padding: const EdgeInsets.only(top: 8.0),
                              child: FloatingActionButton(
                                  backgroundColor: Colors.orange,
                                  foregroundColor: Colors.black,
                                  child: Icon(Icons.restore_from_trash),
                                  onPressed: () {
                                    _dataImages.removeAt(_index);
                                    _selectedImages.removeAt(_index);
                                    Navigator.of(context).pop();
                                    setState(() {});
                                  }),
                            ),
                            Padding(
                              // padding: const EdgeInsets.all(8.0),
                              padding: const EdgeInsets.only(top: 8.0),
                              child: FloatingActionButton(
                                  backgroundColor: Colors.orange,
                                  foregroundColor: Colors.black,
                                  child: Icon(Icons.close),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    setState(() {});
                                  }),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ));
  }

  getImage(ImageSource source) async {
    print(_selectedImages.length);
    if (_selectedImages.length < 5) {
      final pickedFile = await ImagePicker().getImage(source: source);
      if (pickedFile != null) {
        // File cropped = await ImageCropper.cropImage(
        //     sourcePath: pickedFile.path,
        //     aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
        //     compressQuality: 100,
        //     maxWidth: 150,
        //     maxHeight: 100,
        //     compressFormat: ImageCompressFormat.jpg,
        //     androidUiSettings: AndroidUiSettings(
        //       toolbarColor: Colors.orange,
        //       toolbarTitle: "RPS Cropper",
        //       statusBarColor: Colors.orangeAccent,
        //       backgroundColor: Colors.white,
        //     ));
        //
        // if (cropped != null) {

        //Заполнить данные отправки

        DataImageModel _dataImage = DataImageModel();
        File imageFile = new File(pickedFile.path);
        final imageBytes = imageFile.readAsBytesSync();
        _dataImage.name = '1';
        _dataImage.type = '1';
        _dataImage.value = base64.encode(imageBytes);

        //КонецЗаполнения

        _dataImages.add(_dataImage);
        // _selectedImages.add(getImageWidget(cropped));
        _selectedImages.add(getImageWidget(File(pickedFile.path)));

        // }

        setState(() {});
      }
    } else {
      _showMyDialog();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: SizedBox(
                height: 150,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _selectedImages.length,
                  itemBuilder: (context, i) => Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(2),
                        child: GestureDetector(
                          child: _selectedImages[i],
                          onTap: () async {
                            await _showImage(_dataImages[i].value, i);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              decoration:
                  BoxDecoration(border: Border.all(color: Colors.black)),
            ),
          ),
        ),
        Container(
          height: 150,
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FloatingActionButton(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.black,
                      child: Icon(Icons.add),
                      onPressed: () {
                        getImage(ImageSource.gallery);
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FloatingActionButton(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.black,
                      child: Icon(Icons.camera_alt),
                      onPressed: () {
                        getImage(ImageSource.camera);
                      }),
                ),
            ],
          ),
        )
      ],
    );
  }
}

class DataImageModel {
  String name;
  String type;
  String value;

  DataImageModel({
    this.name,
    this.type,
    this.value,
  });
}
