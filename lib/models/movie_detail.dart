class MovieDetail {
  final String imdbID;
  final String title;
  final String plot;
  final String? poster;
  final String? released;

  MovieDetail({
    required this.imdbID,
    required this.title,
    required this.plot,
    this.poster,
    this.released,
  });

  factory MovieDetail.fromJson(Map<String, dynamic> json) {
    return MovieDetail(
      imdbID: json['imdbID'],
      title: json['Title'] ?? 'Unknown Title',
      plot: json['Plot'] ?? 'No plot available',
      poster: json['Poster'] != 'N/A' ? json['Poster'] : null,
      released: json['Released'],
    );
  }
}
