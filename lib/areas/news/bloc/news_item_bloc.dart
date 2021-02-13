import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fb4_app/areas/news/models/news_item.dart';
import 'package:fb4_app/areas/news/repositories/news_repository.dart';

part 'news_item_event.dart';
part 'news_item_state.dart';

class NewsItemBloc extends Bloc<NewsItemEvent, NewsItemState> {
  final NewsRepository newsRepository;

  NewsItemBloc({this.newsRepository}) : super(NewsItemInitial());

  @override
  Stream<NewsItemState> mapEventToState(
    NewsItemEvent event,
  ) async* {
    if (event is FetchNewsItemsEvent) {
      yield NewsItemLoading();
      var items = await newsRepository.getNewsItems();
      yield NewsItemLoaded(newsItems: items);
    }
  }
}
