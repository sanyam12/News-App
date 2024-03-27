part of 'headlines_country_bloc.dart';

abstract class HeadlinesCountryState extends Equatable {
  const HeadlinesCountryState();
}

class HeadlinesCountryInitial extends HeadlinesCountryState {
  @override
  List<Object> get props => [];
}


class HeadlinesCountryLoading extends HeadlinesCountryState {
  @override
  List<Object?> get props => [];
}

class ShowSnackBar extends HeadlinesCountryState {
  final String message;

  const ShowSnackBar(this.message);

  @override
  List<Object?> get props => [];

}

class HeadlinesCountryFetched extends HeadlinesCountryState {
  final ArticleList articleList;

  const HeadlinesCountryFetched(this.articleList);

  @override
  List<Object?> get props => [articleList];

}

class ArticleListFiltered extends HeadlinesCountryState {
  final ArticleList articleList;

  const ArticleListFiltered(this.articleList);

  @override
  List<Object?> get props => [articleList];

}