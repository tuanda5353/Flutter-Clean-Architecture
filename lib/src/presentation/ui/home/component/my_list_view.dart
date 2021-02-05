import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/res.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:river_movies/src/domain/usecase/movie/fetch_movies_usecase.dart';
import 'package:river_movies/src/presentation/base/async_value_view.dart';
import 'package:river_movies/src/presentation/model/movie_item.dart';
import 'package:river_movies/src/presentation/ui/home/component/movie_view_holder.dart';
import 'package:river_movies/src/presentation/ui/theme/color.dart';

import '../home_view_model.dart';

class MyListView extends HookWidget {
  final Function(MovieItem) actionOpenMovie;
  final Function actionLoadAll;

  const MyListView({Key key, @required this.actionOpenMovie, @required this.actionLoadAll}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AsyncValueView<List<MovieItem>>(
      value: useProvider(fetchMoviesProvider(MovieType.topRated).state),
      errorRetry: () {
        context.refresh(fetchMoviesProvider(MovieType.topRated));
      },
      child: (movies) {
        return _createMyListView(context, movies);
      },
    );
  }

  Widget _createMyListView(BuildContext context, List<MovieItem> movies) {
    final contentHeight = 4.0 * (MediaQuery.of(context).size.width / 2.4) / 3;
    return Container(
      child: Column(
        children: [
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(left: 20.0, right: 16.0),
            height: 48.0,
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Text(
                    Resource.of(context).myList,
                    style: TextStyle(
                      color: groupTitleColor,
                      fontSize: 16.0,
                      fontFamily: 'Muli',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.arrow_forward, color: groupTitleColor),
                  onPressed: () {
                    return actionLoadAll;
                  },
                )
              ],
            ),
          ),
          Container(
            height: contentHeight,
            child: ListView.separated(
              itemBuilder: (BuildContext context, int index) {
                return MovieViewHolder(movies[index], actionOpenMovie);
              },
              padding: EdgeInsets.only(left: 16.0, right: 16.0),
              scrollDirection: Axis.horizontal,
              separatorBuilder: (context, index) => VerticalDivider(
                color: Colors.transparent,
                width: 6.0,
              ),
              itemCount: movies.length,
            ),
          ),
        ],
      ),
    );
  }
}
