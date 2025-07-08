class Movie {
  final String imdbID;
  final String title;
  final String? poster;


  Movie({
    required this.imdbID,
    required this.title,
    this.poster,
    });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      imdbID: json['imdbID'],
      title: json['Title'] ?? 'Unknown Title',
      poster: json['Poster'] != 'N/A' ? json['Poster'] : null,
     );
  }
}
