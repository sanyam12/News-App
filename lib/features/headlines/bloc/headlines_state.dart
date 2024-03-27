part of 'headlines_bloc.dart';

abstract class HeadlinesState extends Equatable {
  const HeadlinesState();
}

class HeadlinesInitial extends HeadlinesState {
  @override
  List<Object> get props => [];
}
