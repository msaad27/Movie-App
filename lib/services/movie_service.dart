// lib/services/movie_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie.dart';
import '../models/movie_detail.dart';
import '../core/api_constants.dart';

class MovieService {

  Future<List<Movie>> fetchMovies(String query, int page) async {
    final url = Uri.parse(
      '${ApiConstants.omdbBaseUrl}/?s=$query&page=$page&apikey=${ApiConstants.omdbApiKey}',
    );

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['Response'] == 'True') {
        final List moviesJson = data['Search'] as List;
        return moviesJson.map((json) => Movie.fromJson(json)).toList();
      } else {

        return [];
      }
    } else {
      throw Exception('Failed to fetch movies');
    }
  }


  Future<MovieDetail> fetchMovieDetail(String imdbId) async {
    final url = Uri.parse(
      '${ApiConstants.omdbBaseUrl}/?apikey=${ApiConstants.omdbApiKey}&i=$imdbId',
    );

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['Response'] == 'True') {
        return MovieDetail.fromJson(data);
      } else {
        throw Exception(data['Error'] ?? 'Movie not found');
      }
    } else {
      throw Exception('Failed to fetch movie detail');
    }
  }
}
