part of 'sources_bloc.dart';

abstract class SourcesEvent extends Equatable {
  const SourcesEvent();
}

class FetchSources extends SourcesEvent {
  @override
  List<Object?> get props => [];
}
