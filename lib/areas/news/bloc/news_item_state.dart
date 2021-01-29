part of 'news_item_bloc.dart';

abstract class NewsItemState extends Equatable {
  const NewsItemState();

  @override
  List<Object> get props => [];
}

class NewsItemInitial extends NewsItemState {}

class NewsItemLoading extends NewsItemState {}

class NewsItemLoaded extends NewsItemState {
  final List<NewsItem> newsItems;

  NewsItemLoaded({this.newsItems});
}

class NewsItemError extends NewsItemState {
  final String message;

  NewsItemError({this.message});
}
