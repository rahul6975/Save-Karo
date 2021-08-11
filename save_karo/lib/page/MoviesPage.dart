import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:save_karo/db/MoviesDatabase.dart';
import 'package:save_karo/model/Movies.dart';
import 'package:save_karo/provider/GoogleSignInProvider.dart';
import 'package:save_karo/widget/MovieCardWidget.dart';
import 'AddEditMoviePage.dart';
import 'MovieDetailPage.dart';

class MoviesPage extends StatefulWidget {
  @override
  _MoviesPageState createState() => _MoviesPageState();
}

class _MoviesPageState extends State<MoviesPage> {
  late List<Movies> movies;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    refreshMovies();
  }

  @override
  void dispose() {
    MoviesDatabase.instance.close();

    super.dispose();
  }

  Future refreshMovies() async {
    setState(() => isLoading = true);

    this.movies = await MoviesDatabase.instance.readAllMovies();

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(
            'Movies',
            style: TextStyle(fontSize: 24),
          ),
          actions: [

            ElevatedButton(
              onPressed: () {
                final provider =
                Provider.of<GoogleSignInProvider>(context, listen: false);
                provider.logout();
              },
              child: Text('Logout'),
            ),
          ],
        ),
        body: Center(
          child: isLoading
              ? CircularProgressIndicator()
              : movies.isEmpty
                  ? Text(
                      'No Movies',
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    )
                  : buildNotes(),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black,
          child: Icon(Icons.add),
          onPressed: () async {
            await Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => AddEditMoviePage()),
            );
            refreshMovies();
          },
        ),
      );

  Widget buildNotes() => StaggeredGridView.countBuilder(
        padding: EdgeInsets.all(8),
        itemCount: movies.length,
        staggeredTileBuilder: (index) => StaggeredTile.fit(2),
        crossAxisCount: 4,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        itemBuilder: (context, index) {
          final movie = movies[index];

          return GestureDetector(
            onTap: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => MovieDetailPage(movieId: movie.id!),
                ),
              );
              refreshMovies();
            },
            child: MovieCardWidget(movies: movie, index: index),
          );
        },
      );
}
