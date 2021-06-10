import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lab2/foods/food.dart';
import 'package:lab2/foods/validator.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:image_cropper/image_cropper.dart';

class NewFood extends StatefulWidget {
  @override
  _NewFoodState createState() => _NewFoodState();
}

class _NewFoodState extends State<NewFood> with Validator {
  double screenHeight, screenWidth;

  File _image;

  bool _isLoading = false;

  final _formKey = GlobalKey<FormState>();
  String _foodName;
  double _price;
  int _quantity;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add New Food',
        ),
      ),
      body: SafeArea(
        child: ModalProgressHUD(
          inAsyncCall: _isLoading,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(child: _imageSelector(context)),
                Flexible(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 18),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              labelText: 'Food Name',
                              labelStyle: TextStyle(
                                fontSize: 20,
                              ),
                              hintText: 'Food Name',
                              prefixIcon: Icon(Icons.note),
                            ),
                            validator: validateString,
                            onSaved: (newValue) => _foodName = newValue,
                          ),
                          SizedBox(
                            height: 18,
                          ),
                          SizedBox(
                            height: 18,
                          ),
                          TextFormField(
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                labelText: 'Price',
                                labelStyle: TextStyle(
                                  fontSize: 20,
                                ),
                                hintText: 'Price',
                                prefixIcon: Icon(Icons.money),
                                suffix: Text('RM')),
                            validator: validatePrice,
                            onSaved: (newValue) =>
                                _price = double.tryParse(newValue),
                          ),
                          SizedBox(
                            height: 18,
                          ),
                          TextFormField(
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              labelText: 'Quantity',
                              labelStyle: TextStyle(
                                fontSize: 20,
                              ),
                              hintText: 'Quantity',
                              prefixIcon: Icon(Icons.format_list_numbered),
                            ),
                            validator: validateQuantity,
                            onSaved: (newValue) =>
                                _quantity = int.tryParse(newValue),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(18),
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      _submit(context);
                    },
                    child: Text(
                      'Submit',
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container _imageSelector(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.only(top: 16, bottom: 16, left: 40, right: 40),
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(16)),
            child: Stack(
              alignment: Alignment.center,
              children: [
                _image == null
                    ? Image.asset('images/noimage.png')
                    : Image.file(_image),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(20)),
                    child: IconButton(
                        color: Colors.white,
                        icon: Icon(_image == null ? Icons.add : Icons.repeat),
                        onPressed: () {
                          _showModalImagePicker(context);
                        }),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Future _showModalImagePicker(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: screenHeight / 5,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                    alignment: Alignment.center,
                    child: Text(
                      "Take picture from:",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    )),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                        height: 50,
                        child: Text('Camera',
                            style: TextStyle(
                              color: Colors.white,
                            )),
                        color: Theme.of(context).accentColor,
                        elevation: 10,
                        onPressed: () => {
                          Navigator.pop(context, _chooseCamera()),
                        },
                      ),
                    ),
                    SizedBox(width: 10),
                    Flexible(
                        child: MaterialButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      height: 50,
                      child: Text('Gallery',
                          style: TextStyle(
                            color: Colors.white,
                          )),
                      color: Theme.of(context).accentColor,
                      elevation: 10,
                      onPressed: () => {
                        Navigator.pop(context, _chooseGallery()),
                      },
                    )),
                  ],
                ),
              ],
            ),
          );
        });
  }

  _chooseGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(
      source: ImageSource.gallery,
      maxHeight: 800,
      maxWidth: 800,
    );

    if (pickedFile != null) {
      _image = File(pickedFile.path);
    } else {
      print('No image selected.');
    }
    _cropImage();
  }

  _chooseCamera() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(
      source: ImageSource.camera,
      maxHeight: 800,
      maxWidth: 800,
    );

    if (pickedFile != null) {
      _image = File(pickedFile.path);
    } else {
      print('No image selected.');
    }
    _cropImage();
  }

  _cropImage() async {
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: _image.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Crop your image',
            toolbarColor: Colors.orange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: true),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        ));

    if (croppedFile != null) {
      setState(() {
        _image = croppedFile;
      });
    }
  }

  bool _isImageEmpty() {
    if (_image != null) {
      return true;
    }
    Fluttertoast.showToast(
        msg: "Please add a food image",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        fontSize: 16.0);
    return false;
  }

  void _submit(BuildContext context) async {
    if (_formKey.currentState.validate() || !_isImageEmpty()) {
      _formKey.currentState.save();
      Food food = Food(foodName: _foodName, price: _price, quantity: _quantity);

      setState(() {
        _isLoading = true;
      });
      bool isCreated = await Provider.of<FoodProvider>(context, listen: false)
          .addFood(food, _image);
      setState(() {
        _isLoading = false;
      });
      if (!isCreated) {
        Fluttertoast.showToast(
            msg: "Adding Food failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            textColor: Colors.white,
            fontSize: 16.0);
      }
      Navigator.of(context).pop();
    }
  }
}
