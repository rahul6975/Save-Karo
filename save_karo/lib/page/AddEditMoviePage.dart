import 'package:flutter/material.dart';
import 'package:save_karo/db/MoviesDatabase.dart';
import 'package:save_karo/model/Movies.dart';
import 'package:save_karo/widget/MovieFormWidget.dart';

class AddEditNotePage extends StatefulWidget {
  final Movies? movies;

  const AddEditNotePage({
    Key? key,
    this.movies,
  }) : super(key: key);

  @override
  _AddEditNotePageState createState() => _AddEditNotePageState();
}

class _AddEditNotePageState extends State<AddEditNotePage> {
  final _formKey = GlobalKey<FormState>();
  late String name;
  late String director;
  late String image;

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
            onChangedImage: (image) => setState(() => this.image = image),
          ),
        ),
      );

  Widget buildButton() {
    final isFormValid =
        name.isNotEmpty && director.isNotEmpty && image.isNotEmpty;

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
        await updateNote();
      } else {
        await addMovie();
      }

      Navigator.of(context).pop();
    }
  }

  Future updateMovie() async {
    final movie = widget.movies!.copy(
      name: name,
      image: image,
      director: director,
    );

    await MoviesDatabase.instance.update(movie);
  }

  Future addMovie() async {
    final movie = Movies(
      name: name,
      image: image,
      director: director,
    );

    await MoviesDatabase.instance.create(movie);
  }
}
