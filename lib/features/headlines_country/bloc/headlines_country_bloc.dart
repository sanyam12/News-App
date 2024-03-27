import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart';
import 'package:news_app/constants.dart';

import '../../news/data/models/article.dart';
import '../../news/data/models/article_list.dart';

part 'headlines_country_event.dart';

part 'headlines_country_state.dart';

class HeadlinesCountryBloc
    extends Bloc<HeadlinesCountryEvent, HeadlinesCountryState> {
  HeadlinesCountryBloc() : super(HeadlinesCountryInitial()) {
    on<FetchCountryHeadlines>((event, emit) async {
      if(event.oldArticleList.list.isEmpty){
        emit(HeadlinesCountryLoading());
      }
      try {
        final response = await _fetchHeadlines(event.id);
        emit(HeadlinesCountryFetched(response));
      } on Exception catch (e) {
        emit(ShowSnackBar(e.toString()));
      }
    });
    on<SearchTriggered>((event, emit)async{
      emit(
        ArticleListFiltered(
          ArticleList(
            event.articleList.totalSize,
            event.articleList.list
                .where((element) => element.title.toLowerCase().contains(event.query.toLowerCase()))
                .toList(),
          ),
        ),
      );
    });
  }

  Future<ArticleList> _fetchHeadlines(String id) async {
    const base = "https://newsapi.org/v2/top-headlines";
    final url = "$base?country=$id&apiKey=$API_KEY";
    final response = await get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['status'] == 'ok') {
        final List<dynamic> articlesJson = data['articles'];
        return ArticleList(
          data["totalResults"],
          articlesJson.map((json) => Article.fromJson(json)).toList(),
        );
      } else {
        throw Exception('Failed to load articles');
      }
    } else {
      throw Exception('Failed to load articles');
    }
  }
}
