import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/features/news/bloc/news_bloc.dart';
import 'package:news_app/features/news/data/models/article.dart';
import 'package:news_app/features/news/data/models/article_list.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key, required this.id});

  final String id;

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  final ScrollController _scrollController = ScrollController();
  int pageIndex = 1;
  bool _isLoading = false;
  ArticleList articleList = ArticleList(0, []);
  ArticleList filteredArticleList = ArticleList(0, []);
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<NewsBloc>().add(
          FetchNewsOfSource(
            sourceName: widget.id,
            pageIndex: pageIndex,
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
      context.read<NewsBloc>().add(
            FetchNewsOfSource(
              sourceName: widget.id,
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
    context.read<NewsBloc>();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.id),
      ),
      body: BlocConsumer<NewsBloc, NewsState>(
        listener: (context, state) {
          if (state is NewsFetched) {
            _isLoading = false;
            articleList.totalSize = state.articleList.totalSize;
            articleList.list.addAll(state.articleList.list);
            filteredArticleList = articleList;
            controller.text = "";
          }
          if (state is ShowSnackbar) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          }
          if (state is ArticleListFiltered) {
            filteredArticleList = state.articleList;
          }
        },
        builder: (context, state) {
          if (state is NewsLoading || state is NewsInitial) {
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
                    context.read<NewsBloc>().add(SearchTriggered(q, articleList));
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

class ArticleTile extends StatelessWidget {
  final Article article;

  const ArticleTile({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(article.title),
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Author: ${article.author}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text('Published At: ${article.publishedAt}'),
              const SizedBox(height: 8),
              Text(article.content),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FullArticleScreen(article: article),
                    ),
                  );
                },
                child: const Text(
                  'Read Full Article',
                  style: TextStyle(
                      color: Colors.blue, decoration: TextDecoration.underline),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class FullArticleScreen extends StatelessWidget {
  final Article article;

  const FullArticleScreen({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(article.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Author: ${article.author}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Published At: ${article.publishedAt}'),
            const SizedBox(height: 16),
            Text(article.content),
          ],
        ),
      ),
    );
  }
}
