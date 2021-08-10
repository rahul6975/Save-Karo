import 'package:flutter/material.dart';
import 'package:save_karo/db/MoviesDatabase.dart';
import 'package:save_karo/model/Movies.dart';

import 'AddEditMoviePage.dart';

class MovieDetailPage extends StatefulWidget {
  final int movieId;

  const MovieDetailPage({
    Key? key,
    required this.movieId,
  }) : super(key: key);

  @override
  _MovieDetailPageState createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  late Movies movies;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    refreshMovies();
  }

  Future refreshMovies() async {
    setState(() => isLoading = true);

    this.movies = await MoviesDatabase.instance.readMovie(widget.movieId);

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          actions: [editButton(), deleteButton()],
        ),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : Padding(
                padding: EdgeInsets.all(12),
                child: ListView(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  children: [
                    Text(
                      movies.name,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      movies.director,
                      style: TextStyle(color: Colors.white38, fontSize: 25),
                    ),
                    SizedBox(height: 8),
                    Container(
                      width: 70,
                      height: 600,
                      child: Utility.imageFromBase64String(
                        movies.image,
                      ),
                    ),
                  ],
                ),
              ),
      );

  Widget editButton() => IconButton(
        icon: Icon(Icons.edit_outlined),
        onPressed: () async {
          if (isLoading) return;
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AddEditMoviePage(
                movies: movies,
              ),
            ),
          );

          refreshMovies();
        },
      );

  Widget deleteButton() => IconButton(
        icon: Icon(Icons.delete),
        onPressed: () async {
          await MoviesDatabase.instance.delete(widget.movieId);

          Navigator.of(context).pop();
        },
      );
}
