import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:save_karo/db/MoviesDatabase.dart';
import 'package:save_karo/model/Movies.dart';
import 'package:save_karo/widget/MovieFormWidget.dart';

class Utility {
  static Image imageFromBase64String(String base64String) {
    return Image.memory(
      base64Decode(base64String),
      fit: BoxFit.fill,
    );
  }

  static Uint8List dataFromBase64String(String base64String) {
    return base64Decode(base64String);
  }

  static String base64String(Uint8List data) {
    return base64Encode(data);
  }
}

class AddEditMoviePage extends StatefulWidget {
  final Movies? movies;

  const AddEditMoviePage({
    Key? key,
    this.movies,
  }) : super(key: key);

  @override
  _AddEditMoviePageState createState() => _AddEditMoviePageState();
}

class _AddEditMoviePageState extends State<AddEditMoviePage> {
  final _formKey = GlobalKey<FormState>();
  late String name;
  late String director;
  late String image;
  String imageUrl = "";
  late Future<File> imageFile;
  late Image imageString;

  void pickImageFromGallery() {
    ImagePicker.pickImage(source: ImageSource.gallery).then((imageFile) {
      imageUrl = Utility.base64String(imageFile.readAsBytesSync());
    });
  }

  @override
  void initState() {
    super.initState();

    name = widget.movies?.name ?? '';
    director = widget.movies?.director ?? '';
    image = widget.movies?.image ?? '';
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          actions: [buildButton()],
        ),
        body: Form(
          key: _formKey,
          child: MovieFormWidget(
            name: name,
            director: director,
            image: image,
            onChangedName: (name) => setState(() => this.name = name),
            onChangedDirector: (director) =>
                setState(() => this.director = director),
            onChangedImage: (image) => setState(() => pickImageFromGallery()),
          ),
        ),
      );

  Widget buildButton() {
    final isFormValid =
        name.isNotEmpty && director.isNotEmpty && imageUrl.isNotEmpty;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          onPrimary: Colors.white,
          primary: isFormValid ? null : Colors.grey.shade700,
        ),
        onPressed: addOrUpdateNote,
        child: Text('Save'),
      ),
    );
  }

  void addOrUpdateNote() async {
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      final isUpdating = widget.movies != null;
      if (isUpdating) {
        await updateMovie();
      } else {
        await addMovie();
      }
      Navigator.of(context).pop();
    }
  }

  Future updateMovie() async {
    final movie = widget.movies!.copy(
      name: name,
      image: imageUrl,
      director: director,
    );
    await MoviesDatabase.instance.update(movie);
  }

  Future addMovie() async {
    final movie = Movies(
      name: name,
      image: imageUrl,
      director: director,
    );
    await MoviesDatabase.instance.create(movie);
  }
}
