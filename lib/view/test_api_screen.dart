import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_ui/api/movie_api_provider.dart';
import 'package:learning_ui/bloc/api_bloc.dart';
import 'package:learning_ui/bloc/api_event.dart';
import 'package:learning_ui/bloc/api_state.dart';
import 'package:learning_ui/bloc/shop_event.dart';
import 'package:learning_ui/model/model_movie.dart';

class TestApiScreen extends StatefulWidget {
  @override
  _TestApiScreenState createState() => _TestApiScreenState();
}

class _TestApiScreenState extends State<TestApiScreen>{
  ApiBloc _apiBloc;
  bool _loadingVisible = false;
  List<Results> _resultList;
  double _textSize = 10.0;
  List<String> _imagesLinks = List();
  bool _addData = false;

  @override
  void initState() {
    super.initState();
    _apiBloc = BlocProvider.of<ApiBloc>(context);
    _apiBloc.add(ApiLoadDataEvent());
    if (!_addData) {
      _imagesLinks.add("https://wallpaperaccess.com/full/2350509.jpg");
      _imagesLinks.add("https://cdn.wallpapersafari.com/16/66/lvPSVU.jpg");
      _imagesLinks.add("https://cdn.wallpapersafari.com/73/44/rf3Hkg.jpg");
      _imagesLinks.add("https://wallpaperaccess.com/full/935159.jpg");
      _imagesLinks.add("https://wallpaperaccess.com/full/941359.jpg");
      _imagesLinks.add(
          "https://cdn.suwalls.com/wallpapers/abstract/colorful-perfect-diamond-52721-2560x1440.jpg");
      _imagesLinks.add("https://wallpaperaccess.com/full/102917.jpg");
      _imagesLinks.add("https://cdn.wallpapersafari.com/79/30/3L149K.jpg");
      _imagesLinks.add("https://images7.alphacoders.com/544/544016.jpg");
      _imagesLinks.add(
          "https://a-static.besthdwallpaper.com/flame-like-nebula-wallpaper-2560x1440-3986_51.jpg");
      _imagesLinks.add("https://wallpaperaccess.com/full/2350509.jpg");
      _imagesLinks.add("https://cdn.wallpapersafari.com/16/66/lvPSVU.jpg");
      _imagesLinks.add("https://cdn.wallpapersafari.com/73/44/rf3Hkg.jpg");
      _imagesLinks.add("https://wallpaperaccess.com/full/935159.jpg");
      _imagesLinks.add("https://wallpaperaccess.com/full/941359.jpg");
      _imagesLinks.add(
          "https://cdn.suwalls.com/wallpapers/abstract/colorful-perfect-diamond-52721-2560x1440.jpg");
      _imagesLinks.add("https://wallpaperaccess.com/full/102917.jpg");
      _imagesLinks.add("https://cdn.wallpapersafari.com/79/30/3L149K.jpg");
      _imagesLinks.add("https://images7.alphacoders.com/544/544016.jpg");
      _imagesLinks.add(
          "https://a-static.besthdwallpaper.com/flame-like-nebula-wallpaper-2560x1440-3986_51.jpg");
      _addData = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink[200],
        title: Text("API"),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
      ),
      body: SafeArea(
        child: BlocConsumer(
          cubit: _apiBloc,
          listenWhen: (previous, current) =>
              current is ApiLoading || current is ApiLoadFinish,
          listener: (context, state) {
            if (state is ApiLoading) {
              _loadingVisible = true;
            } else if (state is ApiLoadFinish) {
              _loadingVisible = false;
              _resultList = state.movieData.results;
              print(_resultList.length);
            }
          },
          buildWhen: (previous, current) =>
              current is ApiLoading || current is ApiLoadFinish,
          builder: (context, state) {
            if (_resultList != null) {
              return Stack(
                children: [
                  Container(
                    child: ListView.builder(
                      itemCount: _resultList.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: Container(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              children: [
                                Text(
                                  'popularity: ${_resultList[index].popularity}',
                                  style: TextStyle(
                                      fontSize: _textSize, color: Colors.green),
                                ),
                                Text(
                                  'vote_count: ${_resultList[index].voteCount}',
                                  style: TextStyle(
                                      fontSize: _textSize, color: Colors.green),
                                ),
                                Text(
                                  'video: ${_resultList[index].video}',
                                  style: TextStyle(
                                      fontSize: _textSize,
                                      color: Colors.blueAccent),
                                ),
                                Text(
                                  'id: ${_resultList[index].id}',
                                  style: TextStyle(
                                      fontSize: _textSize, color: Colors.green),
                                ),
                                Text(
                                  'adult: ${_resultList[index].adult}',
                                  style: TextStyle(
                                      fontSize: _textSize,
                                      color: Colors.blueAccent),
                                ),
                                Text(
                                  'original_language: ${_resultList[index].originalLanguage}',
                                  style: TextStyle(
                                      fontSize: _textSize,
                                      color: Colors.blueAccent),
                                ),
                                Text(
                                  'original_title: ${_resultList[index].originalTitle}',
                                  style: TextStyle(
                                      fontSize: _textSize,
                                      color: Colors.blueAccent),
                                ),CachedNetworkImage(
                                  imageUrl: _imagesLinks[index],
                                  placeholder: (context, url) => CircularProgressIndicator(),),
                                Text(
                                  'genre_ids: ${_resultList[index].genreIds}',
                                  style: TextStyle(
                                      fontSize: _textSize, color: Colors.green),
                                ),
                                Text(
                                  'title: ${_resultList[index].title}',
                                  style: TextStyle(
                                      fontSize: _textSize,
                                      color: Colors.blueAccent),
                                ),
                                Text(
                                  'vote_average: ${_resultList[index].voteAverage}',
                                  style: TextStyle(
                                      fontSize: _textSize, color: Colors.green),
                                ),
                                Text(
                                  'release_date: ${_resultList[index].releaseDate}',
                                  style: TextStyle(
                                      fontSize: _textSize,
                                      color: Colors.blueAccent),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Visibility(
                    visible: _loadingVisible,
                    child: Container(
                        alignment: Alignment.center,
                        child: CircularProgressIndicator()),
                  )
                ],
              );
            } else {
              return Container(
                  alignment: Alignment.center,
                  child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _apiBloc.close();
    super.dispose();
  }

}
