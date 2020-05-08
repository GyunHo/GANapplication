import 'dart:async';
import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:slider_button/slider_button.dart';

void main() {
  runApp(MaterialApp(
    home: ImageInputPage(),
  ));
}

class ImageInputPage extends StatefulWidget {
  @override
  _ImageInputPageState createState() => _ImageInputPageState();
}

class _ImageInputPageState extends State<ImageInputPage> {
  File _originImage;
  File _makeUpImage;
  StorageReference _storageReference = FirebaseStorage.instance.ref();

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xfffedbc0),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: _size.height * 0.1,
            ),
            Text(
              'Makeup',
              style: TextStyle(fontSize: 50.0),
            ),
            Text(
              'Transfer',
              style: TextStyle(fontSize: 50.0),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                InkWell(
                  child: DottedBorder(
                    strokeWidth: 3.0,
                    dashPattern: [5.0],
                    borderType: BorderType.RRect,
                    radius: Radius.circular(12),
                    padding: EdgeInsets.all(6),
                    child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        child: Container(
                          child: _originImage != null
                              ? Image(
                                  fit: BoxFit.cover,
                                  image: FileImage(File(_originImage.path)),
                                )
                              : Center(child: Text('add Makeup Image')),
                          width: _size.width * 0.4,
                          height: _size.height * 0.3,
                        )),
                  ),
                  onTap: () async {
                    await imageDialog().then((res) {
                      if (res is File) {
                        setState(() {
                          _originImage = res;
                        });
                      }
                    });
                  },
                ),
                InkWell(
                  child: DottedBorder(
                    strokeWidth: 3.0,
                    dashPattern: [5.0],
                    borderType: BorderType.RRect,
                    radius: Radius.circular(12),
                    padding: EdgeInsets.all(6),
                    child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        child: Container(
                          child: _makeUpImage != null
                              ? Image(
                                  fit: BoxFit.cover,
                                  image: FileImage(File(_makeUpImage.path)),
                                )
                              : Center(child: Text('add Makeup Image')),
                          width: _size.width * 0.4,
                          height: _size.height * 0.3,
                        )),
                  ),
                  onTap: () async {
                    await imageDialog().then((res) {
                      if (res is File) {
                        setState(() {
                          _makeUpImage = res;
                        });
                      }
                    });
                  },
                ),
              ],
            ),
            SizedBox(
              height: _size.height * 0.1,
            ),
            Center(
              child: SliderButton(
                label: Text(
                  'Slide to makeup',
                  style: TextStyle(fontSize: 20.0),
                ),
                buttonColor: Colors.black,
                backgroundColor: Colors.white,
                icon: Icon(
                  Icons.brush,
                  color: Colors.white,
                ),
                dismissible: false,
                vibrationFlag: false,
                action: () {
                  upload();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<File> pickImage(ImageSource source) async {
    File image = await ImagePicker.pickImage(source: source);
    return image;
  }

  Future imageDialog() {
    return showDialog(
      context: context,
      builder: (context) => Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        child: Container(
          height: 120,
          width: 180,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.camera_alt,
                      size: 30.0,
                    ),
                    onPressed: () {
                      pickImage(ImageSource.camera).then((File img) {
                        Navigator.pop(context, img);
                      });
                    },
                  ),
                  Text('Camera'),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.photo_album,
                      size: 30.0,
                    ),
                    onPressed: () {},
                  ),
                  Text('Album')
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  upload() async {
    StorageReference _reference =  FirebaseStorage.instance
        .ref().child('img').child('${DateTime.now().millisecondsSinceEpoch.toString()}.jpg');
    StorageUploadTask task = _reference.putFile(_originImage);
    await task.onComplete.then((StorageTaskSnapshot snapshot)  async {
      print( await snapshot.ref.getBucket());
      print( await snapshot.ref.getName());

    });

    }


}
