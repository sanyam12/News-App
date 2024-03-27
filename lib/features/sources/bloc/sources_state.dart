part of 'sources_bloc.dart';

abstract class SourcesState extends Equatable {
  const SourcesState();
}

class SourcesInitial extends SourcesState {
  @override
  List<Object> get props => [];
}

class SourcesLoading extends SourcesState {
  @override
  List<Object?> get props => [];
}

class SourcesFetched extends SourcesState {
  final List<Map<String, dynamic>> response;

  const SourcesFetched(this.response);

  @override
  List<Object?> get props => [response];

}

class ShowSnackbar extends SourcesState {
  final String message;

  const ShowSnackbar(this.message);

  @override
  List<Object?> get props => [message];

}
