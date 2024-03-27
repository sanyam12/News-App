import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/constants.dart';
import 'package:news_app/features/headlines/bloc/headlines_bloc.dart';
import 'package:news_app/features/headlines_country/headlines_country_page.dart';

class HeadlinesPage extends StatelessWidget {
  const HeadlinesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Headlines"),
      ),
      body: BlocConsumer<HeadlinesBloc, HeadlinesState>(
        listener: (context, state) {},
        builder: (context, state) {
          List<Widget> list = [];
          codes.forEach((key, value) {
            list.add(
              ListTile(
                title: Text("$value ($key)"),
                trailing: const Icon(Icons.arrow_forward),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HeadlinesCountryPage(name:value,id:key),
                    ),
                  );
                },
              ),
            );
          });
          return ListView(
            children: list,
          );
        },
      ),
    );
  }
}
