part of 'news_bloc.dart';

abstract class NewsEvent extends Equatable {
  const NewsEvent();
}

class FetchNewsOfSource extends NewsEvent {
  final String sourceName;
  final int pageIndex;
  final ArticleList oldArticleList;

  const FetchNewsOfSource({
    required this.sourceName,
    required this.pageIndex,
    required this.oldArticleList,
  });

  @override
  List<Object?> get props => [sourceName, pageIndex, oldArticleList,];
}

class SearchTriggered extends NewsEvent {
  final String query;
  final ArticleList articleList;

  const SearchTriggered(this.query, this.articleList);

  @override
  List<Object?> get props => [query, articleList];

}
