
import 'package:dio/dio.dart';
import 'package:learning_ui/api/movie_repository.dart';
import 'package:learning_ui/model/model_movie.dart';

class MovieApiProvider{
  final String _link = "http://api.themoviedb.org/3/discover/movie";
  final String _key = "api_key=26763d7bf2e94098192e629eb975dab0";

  final Dio _dio = Dio();

  Future<MovieData> getDataMovieGetFromApi() async{
    try{
      Response response = await _dio.get("$_link?$_key");
      print(response.statusCode);
      print(response.statusMessage);
      return MovieData.fromJson(response.data);
    }catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return null;
    }
  }
}