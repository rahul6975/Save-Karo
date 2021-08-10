import 'package:flutter/material.dart';

class MovieFormWidget extends StatelessWidget {
  final String? name;
  final String? director;
  final String? image;
  final ValueChanged<String> onChangedName;
  final ValueChanged<String> onChangedDirector;
  final ValueChanged<String> onChangedImage;

  const MovieFormWidget({
    Key? key,
    this.name = '',
    this.director = '',
    this.image = '',
    required this.onChangedName,
    required this.onChangedDirector,
    required this.onChangedImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Row(
              //   children: [
              //     Expanded(
              //       child: Slider(
              //         value: (number ?? 0).toDouble(),
              //         min: 0,
              //         max: 5,
              //         divisions: 5,
              //         onChanged: (number) => onChangedNumber(number.toInt()),
              //       ),
              //     )
              //   ],
              // ),
              buildName(),
              SizedBox(height: 8),
              buildDirector(),
              SizedBox(height: 16),
              buildImage(),
            ],
          ),
        ),
      );

  Widget buildName() => TextFormField(
        maxLines: 1,
        initialValue: name,
        style: TextStyle(
          color: Colors.white70,
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Movie name',
          hintStyle: TextStyle(color: Colors.white70),
        ),
        validator: (name) => name != null && name.isEmpty
            ? 'The movie name cannot be empty'
            : null,
        onChanged: onChangedName,
      );

  Widget buildDirector() => TextFormField(
        maxLines: 5,
        initialValue: director,
        style: TextStyle(color: Colors.white60, fontSize: 18),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Director name',
          hintStyle: TextStyle(color: Colors.white60),
        ),
        validator: (director) => director != null && director.isEmpty
            ? 'The director name cannot be empty'
            : null,
        onChanged: onChangedDirector,
      );

  Widget buildImage() => TextFormField(
        maxLines: 5,
        initialValue: director,
        style: TextStyle(color: Colors.white60, fontSize: 18),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Add image',
          hintStyle: TextStyle(color: Colors.white60),
        ),
        validator: (image) =>
            image != null && image.isEmpty ? 'Image cannot be empty' : null,
        onChanged: onChangedImage,
      );
}
