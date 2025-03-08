part of 'home_bloc.dart';

@immutable
abstract class HomeEvent {}


class BottomNavBarEvent extends HomeEvent{
  final int index;

  BottomNavBarEvent({required this.index});
  
}

class GetDataEvent extends HomeEvent{
  final int index;

  GetDataEvent({required this.index});
}

class GetStoredBookMarkEvent extends HomeEvent{}

class AddToBookMarkEvent extends HomeEvent{
  final Map<String,dynamic> news;

  AddToBookMarkEvent({required this.news});
}

class LoadMoreDataEvent extends HomeEvent{
  final int page;

  LoadMoreDataEvent({required this.page});
  
}

class BookNavEvent extends HomeEvent{}

class SearchEvent extends HomeEvent{
  final String query;

  SearchEvent({required this.query});
}