import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/features/news/data/models/article_list.dart';
import 'package:news_app/features/news/presentation/news_page.dart';
import 'bloc/headlines_country_bloc.dart';

class HeadlinesCountryPage extends StatefulWidget {
  const HeadlinesCountryPage({
    super.key,
    required this.name,
    required this.id,
  });

  final String name;
  final String id;

  @override
  State<HeadlinesCountryPage> createState() => _HeadlinesCountryPageState();
}

class _HeadlinesCountryPageState extends State<HeadlinesCountryPage> {
  final ScrollController _scrollController = ScrollController();
  int pageIndex = 1;
  bool _isLoading = false;
  ArticleList articleList = ArticleList(0, []);
  ArticleList filteredArticleList = ArticleList(0, []);
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<HeadlinesCountryBloc>().add(
          FetchCountryHeadlines(
            id: widget.id,
            pageIndex: 1,
            oldArticleList: articleList,
          ),
        );
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent &&
        !_isLoading) {
      pageIndex++;
      _isLoading = true;
      context.read<HeadlinesCountryBloc>().add(
        FetchCountryHeadlines(
          id: widget.id,
          pageIndex: pageIndex,
          oldArticleList: articleList,
        ),
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.name} (${widget.id})"),
      ),
      body: BlocConsumer<HeadlinesCountryBloc, HeadlinesCountryState>(
        listener: (context, state) {
          if (state is HeadlinesCountryFetched) {
            _isLoading = false;
            articleList.totalSize = state.articleList.totalSize;
            articleList.list.addAll(state.articleList.list);
            filteredArticleList = articleList;
            controller.text = "";
          }
          if (state is ShowSnackBar) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          }
          if (state is ArticleListFiltered) {
            filteredArticleList = state.articleList;
          }
        },
        builder: (context, state) {
          if(state is HeadlinesCountryInitial || state is HeadlinesCountryLoading){
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                        hintText: "Search News..."
                    ),
                    onChanged: (q){
                      context.read<HeadlinesCountryBloc>().add(SearchTriggered(q, articleList));
                    },
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: filteredArticleList.list.length + 1,
                    itemBuilder: (context, index) {
                      if (index < filteredArticleList.list.length) {
                        return ArticleTile(article: filteredArticleList.list[index]);
                      } else if (filteredArticleList.totalSize > filteredArticleList.list.length) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    },
                  ),
                ),
              ]
          );
        },
      ),
    );
  }
}
