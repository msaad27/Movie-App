import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/movie_providers.dart';
import '../widgets/movie_card.dart';

class MovieListScreen extends ConsumerStatefulWidget {
  const MovieListScreen({super.key});

  @override
  ConsumerState<MovieListScreen> createState() => _MovieListScreenState();
}

class _MovieListScreenState extends ConsumerState<MovieListScreen> {
  late final ScrollController _scrollController;
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _searchController = TextEditingController();

    _scrollController.addListener(() {
      final searchQuery = ref.read(searchQueryProvider);
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 100 &&
          searchQuery.isNotEmpty) {
        final notifier = ref.read(movieListProvider(searchQuery).notifier);

        if (notifier.hasMore) {
          notifier.loadMore();
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch() {
    final input = _searchController.text.trim();
    final oldQuery = ref.read(searchQueryProvider);

    if (input != oldQuery) {
      ref.read(searchQueryProvider.notifier).state = input;

      if (input.isNotEmpty) {
        ref.read(movieListProvider(input).notifier).reset();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final searchQuery = ref.watch(searchQueryProvider);
    final movieListAsync = searchQuery.isEmpty
        ? const AsyncValue.data([])
        : ref.watch(movieListProvider(searchQuery));


    _searchController.value = TextEditingValue(
      text: searchQuery,
      selection: TextSelection.collapsed(offset: searchQuery.length),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Movies')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: 'Search movies',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _onSearch(),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _onSearch,
                ),
              ],
            ),
          ),
          Expanded(
            child: movieListAsync.when(
              data: (movies) {
                if (movies.isEmpty) {
                  return const Center(child: Text('Please enter a movie name'));
                }
                return ListView.builder(
                  controller: _scrollController,
                  itemCount: movies.length,
                  itemBuilder: (context, index) {
                    final movie = movies[index];
                    return MovieCard(
                      movie: movie,
                      onTap: () => Navigator.pushNamed(
                        context,
                        '/detail',
                        arguments: movie.imdbID,
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(child: Text('Error: $error')),
            ),
          ),
        ],
      ),
    );
  }
}
