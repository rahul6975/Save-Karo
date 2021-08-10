final String tableMovies = 'movies';

class MovieFields {
  static final List<String> values = [
    /// Add all fields
    id, name, director, image
  ];

  static final String id = '_id';
  static final String name = 'name';
  static final String director = 'director';
  static final String image = 'description';
}

class Movies {
  final int? id;
  final String name;
  final String director;
  final String image;

  const Movies({
    this.id,
    required this.image,
    required this.name,
    required this.director,
  });

  Movies copy({
    int? id,
    String? name,
    String? director,
    String? image,
  }) =>
      Movies(
        id: id ?? this.id,
        name: name ?? this.name,
        director: director ?? this.director,
        image: image ?? this.image,
      );

  static Movies fromJson(Map<String, Object?> json) => Movies(
        id: json[MovieFields.id] as int?,
        name: json[MovieFields.name] as String,
        director: json[MovieFields.director] as String,
        image: json[MovieFields.image] as String,
      );

  Map<String, Object?> toJson() => {
        MovieFields.id: id,
        MovieFields.name: name,
        MovieFields.director: director,
        MovieFields.image: image,
      };
}
