import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/features/headlines/bloc/headlines_bloc.dart';
import 'package:news_app/features/headlines/headlines_page.dart';
import 'package:news_app/features/headlines_country/bloc/headlines_country_bloc.dart';
import 'package:news_app/features/headlines_country/headlines_country_page.dart';
import 'package:news_app/features/news/presentation/news_page.dart';
import 'package:news_app/features/sources/bloc/sources_bloc.dart';
import 'package:news_app/features/sources/sources_page.dart';

import 'features/news/bloc/news_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context)=>NewsBloc()),
        BlocProvider(create: (context)=>SourcesBloc()),
        BlocProvider(create: (context)=>HeadlinesBloc()),
        BlocProvider(create: (context)=>HeadlinesCountryBloc()),
      ],
      child: MaterialApp(
        title: 'News API',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        initialRoute: "/sources",
        routes: {
          "/sources": (context) => const SourcesPage(),
          "/headlines": (context) => const HeadlinesPage(),
        },
      ),
    );
  }
}