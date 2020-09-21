import 'package:learning_ui/api/movie_api_provider.dart';
import 'package:learning_ui/model/model_movie.dart';

class MovieRepository{
  MovieApiProvider _movieApiProvider = MovieApiProvider();

  Future<MovieData> get getMovie => _movieApiProvider.getDataMovieGetFromApi();
}