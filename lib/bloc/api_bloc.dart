import 'package:bloc/bloc.dart';
import 'package:learning_ui/api/movie_api_provider.dart';
import 'package:learning_ui/bloc/api_event.dart';
import 'package:learning_ui/bloc/api_state.dart';
import 'package:learning_ui/bloc/shop_event.dart';
import 'package:learning_ui/model/model_movie.dart';

class ApiBloc extends Bloc<ApiEvent, ApiState> {
  ApiBloc(ApiState initialState) : super(ApiInitial());
  MovieApiProvider apiProvider = MovieApiProvider();
  MovieData data ;

  @override
  Stream<ApiState> mapEventToState(ApiEvent event) async*{
    if(event is ApiLoadDataEvent){
      yield ApiLoading();
      data = await apiProvider.getDataMovieGetFromApi();
      yield ApiLoadFinish(data);
    }
  }
}
