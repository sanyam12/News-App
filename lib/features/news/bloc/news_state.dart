part of 'news_bloc.dart';

abstract class NewsState extends Equatable {
  const NewsState();
}

class NewsInitial extends NewsState {
  @override
  List<Object> get props => [];
}

class NewsLoading extends NewsState{
  @override
  List<Object?> get props => [];
}

class NewsFetched extends NewsState{
  final ArticleList articleList;

  const NewsFetched(this.articleList);

  @override
  List<Object?> get props => [articleList];

}

class ShowSnackbar extends NewsState {
  final String message;

  const ShowSnackbar(this.message);

  @override
  List<Object?> get props => [message];

}

class ArticleListFiltered extends NewsState {
  final ArticleList articleList;

  ArticleListFiltered(this.articleList);

  @override
  List<Object?> get props => [articleList];

}
