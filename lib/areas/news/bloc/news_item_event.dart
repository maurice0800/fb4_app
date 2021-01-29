part of 'news_item_bloc.dart';

abstract class NewsItemEvent extends Equatable {
  const NewsItemEvent();

  @override
  List<Object> get props => [];
}

class FetchNewsItemsEvent extends NewsItemEvent {}
