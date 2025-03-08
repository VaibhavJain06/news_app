part of 'home_bloc.dart';

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {}
abstract class HomeActionState extends HomeState{}
class BottomNavState extends HomeState{
  final int selectedIndex;

  BottomNavState({required this.selectedIndex});
  
}
class BookmarkState extends HomeState{
  final List<Bookmark> bookmarks;

  BookmarkState({required this.bookmarks});
  
}

class SearchDataState extends HomeState {
  final List<dynamic> searchResults;
  SearchDataState({required this.searchResults});
}

class NewsDataState extends HomeState{
  final List<dynamic> newData;

  NewsDataState({required this.newData});
  
}

class BookNavState extends HomeActionState{}

class HomeErrorState extends HomeState{
  final String message;

  HomeErrorState({required this.message});
  
}
