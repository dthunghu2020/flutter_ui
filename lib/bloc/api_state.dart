import 'package:learning_ui/model/model_movie.dart';

class ApiState {
}

class ApiInitial extends ApiState{}
class ApiLoading extends ApiState{}
class ApiLoadFinish extends ApiState{
  MovieData movieData;

  ApiLoadFinish(this.movieData);
}