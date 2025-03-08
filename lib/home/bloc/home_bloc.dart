import 'dart:convert';


import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart'as http;
import 'package:news_aggregator_app/Models/bookmark.dart';
part 'home_event.dart';
part 'home_state.dart';

final apiKey = dotenv.env['API_KEY'];

class HomeBloc extends Bloc<HomeEvent, HomeState> {
   
  HomeBloc() : super(HomeInitial()) {

    on<BottomNavBarEvent>((event, emit) {
      emit(BottomNavState(selectedIndex: event.index));
      add(GetDataEvent(index: event.index));
    });

     on<SearchEvent>((event, emit) async {

      List<dynamic> searchResults = [];
      try {
        final response = await http.get(
          Uri.parse('https://newsapi.org/v2/everything?q=${event.query}&apiKey=$apiKey'),
          headers: {
            'Api-Key': apiKey!,
          },
        );
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          searchResults.addAll(data['articles']); 
          emit(SearchDataState(searchResults: searchResults));
        }
      } catch (e) {
        emit(HomeErrorState(message: e.toString()));
      } 
    });


    on<GetDataEvent>((event, emit) async{
      List<dynamic> allData = [];

      if (state is NewsDataState) {
        final current = (state as NewsDataState).newData;
        if(current.isNotEmpty){
          emit(NewsDataState(newData: current));
          return;
        }
      }
      try {
        String apiUrl = getApiUrl(event.index);
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Api-Key': apiKey!,
        }
        );
        if(response.statusCode == 200){
          final data = jsonDecode(response.body);
          allData = data['articles'];
          emit(NewsDataState(newData: allData));
          event.index;
        }
      }catch(e){
        emit(HomeErrorState(message: e.toString()));
      }

    });
    

    on<AddToBookMarkEvent>((event, emit) async{
      final user = FirebaseAuth.instance.currentUser;
      await FirebaseFirestore.instance.collection('users').doc(user!.uid).collection('bookmarks').add(
        {
          'title':event.news['title'],
          'description':event.news['description'],
          'url':event.news['url'],
          'date':event.news['publishedAt'],
          'imageUrl':event.news['urlToImage'],
        }
      );
      
    });


    on<GetStoredBookMarkEvent>((event, emit)async {
      List<Bookmark> savedBookmarks = [];
      try{
      final user = FirebaseAuth.instance.currentUser;
      QuerySnapshot bookmarkData = await FirebaseFirestore.instance.collection('users').doc(user!.uid).collection('bookmarks').get();
      
      for(var saved in bookmarkData.docs){
        Bookmark bookmark = Bookmark(
          title: saved['title'], 
          description: saved['description'], 
          url: saved['url'], 
          date: saved['date'],
          imageUrl: saved['imageUrl'],
          );
          savedBookmarks.add(bookmark);
    }
      emit(BookmarkState(bookmarks: savedBookmarks));
    }catch(e){
      emit(HomeErrorState(message: e.toString()));
  }
    }
    );

    on<BookNavEvent>((event, emit) {
      emit(BookNavState());
    });
  
  }
}


 dynamic getApiUrl(int index) { 
    switch (index) {
      case 0:
        return "https://newsapi.org/v2/top-headlines?sources=techcrunch&apiKey=$apiKey";
      case 1:
          return "https://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=$apiKey";
      case 2:
        return "https://newsapi.org/v2/top-headlines?country=us&category=health&apiKey=$apiKey";
      case 3:
        return "https://newsapi.org/v2/top-headlines?country=us&category=sports&apiKey=$apiKey";
      
    }
  }