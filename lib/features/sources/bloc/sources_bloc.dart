import 'dart:async';
import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:news_app/constants.dart';

part 'sources_event.dart';
part 'sources_state.dart';

class SourcesBloc extends Bloc<SourcesEvent, SourcesState> {
  SourcesBloc() : super(SourcesInitial()) {
    on<FetchSources>((event, emit)async {
      emit(SourcesLoading());
      try {
        final response = await fetchSources();
        emit(SourcesFetched(response));
      } on Exception catch (e) {
        emit(ShowSnackbar(e.toString()));
      }
    });
  }

  Future<List<Map<String, dynamic>>> fetchSources() async {
    const String apiUrl = 'https://newsapi.org/v2/top-headlines/sources';

    final response = await get(
      Uri.parse(apiUrl),
      headers: {'x-api-key': API_KEY},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['status'] == 'ok') {
        return List<Map<String, dynamic>>.from(data['sources']);
      } else {
        throw Exception('Error: ${data['message']}');
      }
    } else {
      throw Exception('HTTP Error: ${response.statusCode}');
    }
  }

}
