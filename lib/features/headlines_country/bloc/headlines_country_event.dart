part of 'headlines_country_bloc.dart';

abstract class HeadlinesCountryEvent extends Equatable {
  const HeadlinesCountryEvent();
}

class FetchCountryHeadlines extends HeadlinesCountryEvent {
  final String id;
  final int pageIndex;
  final ArticleList oldArticleList;

  const FetchCountryHeadlines({
    required this.id,
    required this.pageIndex,
    required this.oldArticleList,
  });

  @override
  List<Object?> get props => [id];
}

class SearchTriggered extends HeadlinesCountryEvent {
  final String query;
  final ArticleList articleList;

  const SearchTriggered(this.query, this.articleList);

  @override
  List<Object?> get props => [query, articleList];
}
