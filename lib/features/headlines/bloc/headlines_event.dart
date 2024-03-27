part of 'headlines_bloc.dart';

abstract class HeadlinesEvent extends Equatable {
  const HeadlinesEvent();
}

class FetchCountriesList extends HeadlinesEvent {
  @override
  List<Object?> get props => [];

}
