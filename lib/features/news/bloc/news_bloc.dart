import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart';
import 'package:news_app/constants.dart';
import 'package:news_app/features/news/data/models/article.dart';
import 'package:news_app/features/news/data/models/article_list.dart';

part 'news_event.dart';

part 'news_state.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  NewsBloc() : super(NewsInitial()) {
    on<FetchNewsOfSource>((event, emit) async {
      if (event.oldArticleList.list.isEmpty) {
        emit(NewsLoading());
      }
      try {
        final result =
            await fetchArticles(event.sourceName, 10, event.pageIndex);
        emit(NewsFetched(result));
      } on Exception catch (e) {
        emit(ShowSnackbar(e.toString()));
      }
    });
    on<SearchTriggered>((event, emit) async {
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

  Future<ArticleList> fetchArticles(
      String sourceName, int pageSize, int pageNumber) async {
    const String baseUrl = 'https://newsapi.org/v2/everything';
    final String url =
        '$baseUrl?sources=$sourceName&pageSize=$pageSize&page=$pageNumber&apiKey=$API_KEY';

    final response = await get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['status'] == 'ok') {
        final List<dynamic> articlesJson = data['articles'];
        return ArticleList(data["totalResults"],
            articlesJson.map((json) => Article.fromJson(json)).toList());
      } else {
        throw Exception('Failed to load articles');
      }
    } else {
      throw Exception('Failed to load articles');
    }
  }
}
