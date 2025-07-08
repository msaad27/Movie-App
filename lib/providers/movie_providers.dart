import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/movie.dart';
import '../models/movie_detail.dart';
import '../services/movie_service.dart';


final movieServiceProvider = Provider<MovieService>((ref) => MovieService());


final searchQueryProvider = StateProvider<String>((ref) => '');


final movieListProvider = StateNotifierProvider.family<MovieListNotifier, AsyncValue<List<Movie>>, String>((ref, query) {
  return MovieListNotifier(ref, query);
});


final movieDetailProvider = FutureProvider.family<MovieDetail, String>((ref, movieId) {
  return ref.read(movieServiceProvider).fetchMovieDetail(movieId);
});

class MovieListNotifier extends StateNotifier<AsyncValue<List<Movie>>> {
  final Ref ref;
  final String query;

  int _page = 1;
  bool _isLoading = false;
  bool _hasMore = true;
  final List<Movie> _movies = [];

  MovieListNotifier(this.ref, this.query) : super(const AsyncValue.loading()) {
    fetchMovies();
  }

  bool get hasMore => _hasMore;

  Future<void> fetchMovies() async {
    if (_isLoading || !_hasMore) return;

    _isLoading = true;
    try {
      final newMovies = await ref.read(movieServiceProvider).fetchMovies(query, _page);

      if (newMovies.isEmpty) {
        _hasMore = false;
      } else {
        _movies.addAll(newMovies);
        _page++;
      }

      state = AsyncValue.data(List.unmodifiable(_movies));
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    } finally {
      _isLoading = false;
    }
  }

  void loadMore() => fetchMovies();

  void reset() {
    _page = 1;
    _hasMore = true;
    _movies.clear();
    state = const AsyncValue.loading();
    fetchMovies();
  }
}
