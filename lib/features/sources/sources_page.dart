import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:news_app/features/news/presentation/news_page.dart';
import 'package:news_app/features/sources/bloc/sources_bloc.dart';

class SourcesPage extends StatefulWidget {
  const SourcesPage({super.key});

  @override
  State<SourcesPage> createState() => _SourcesPageState();
}

class _SourcesPageState extends State<SourcesPage> {
  List<Map<String, dynamic>> sources = [];

  @override
  void initState() {
    super.initState();
    context.read<SourcesBloc>().add(FetchSources());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('News Sources'),
      ),
      body: BlocConsumer<SourcesBloc, SourcesState>(
        listener: (context, state) {
          if (state is ShowSnackbar) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          }
          if (state is SourcesFetched) {
            sources = state.response;
          }
        },
        builder: (context, state) {
          if (state is SourcesInitial || state is SourcesLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Column(
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed("/headlines");
                },
                child: const Text("Top Headlines"),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: sources.length,
                  itemBuilder: (context, index) {
                    final source = sources[index];
                    return Card(
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        title: Text(
                          "${source['name']} (${source['country']})",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(source['description']),
                            const SizedBox(height: 8),
                            Text(
                              'Country Code: ${source['country'].toUpperCase()}',
                              style: TextStyle(
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                        trailing: const Icon(Icons.arrow_forward),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NewsPage(id: source["id"]),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
