import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:news_aggregator_app/home/bloc/home_bloc.dart';
import 'package:news_aggregator_app/home/screens/webView.dart';

class NewsScreen extends StatefulWidget {
   final int index;
  const NewsScreen({super.key, required this.index});
 

  @override
  State<NewsScreen> createState() => _NewScreenState();
}

class _NewScreenState extends State<NewsScreen> {
  final ScrollController _scrollController = ScrollController();
 

  @override
  void initState(){
    super.initState();
    
    _scrollController.addListener(_onScroll); 
  }

  void _onScroll(){
    if(_scrollController.position.pixels == _scrollController.position.maxScrollExtent){
    
      context.read<HomeBloc>().add(GetDataEvent(index: widget.index));
    }
  }
  
  @override
  void dispose(){
    _scrollController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc,HomeState>(
      builder: (BuildContext context,state){
        if(state is NewsDataState){
      return Scaffold(
        body: ListView.builder(
          controller: _scrollController,
          itemCount: state.newData.length,
        itemBuilder: (context,index){
          final news = state.newData[index];
          final formattedDate =DateFormat('yyyy-MM-dd').format(DateTime.parse(news['publishedAt']));
           return Container(
            padding: EdgeInsets.all(20.0),
            height: 500.0,
            width: 50.0,
             child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 5.0,
               children: [
                SizedBox(
                  height: 210.0,
                  width: MediaQuery.of(context).size.width,
                  child: Image(image:NetworkImage(state.newData[index]['urlToImage']),fit: BoxFit.fill,)),
                 Text(formattedDate.toString(),style: TextStyle(fontWeight:FontWeight.w500),),
                 Text(state.newData[index]['title'],style: TextStyle(fontWeight: FontWeight.bold),),
                 Text(state.newData[index]['description']),
                 Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                     TextButton.icon(
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>Webview(url: state.newData[index]['url'],)));
                      }, 
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9.0)),
                        ),
                        iconAlignment: IconAlignment.end,
                      label: Text('Read More',style: TextStyle(color: Colors.white),),
                      icon: Icon(Icons.arrow_outward_outlined,color: Colors.white,),
                      ),
                      IconButton(onPressed: (){
                        context.read<HomeBloc>().add(AddToBookMarkEvent(news: state.newData[index]));
                      }, icon: Icon(Icons.bookmark_add_sharp,color: Colors.black,size: 33.0,)),
                   ],
                 )
                  
               ],
             ),
           );
        }
        
      ),
      );
        }
        return const Center(child:CircularProgressIndicator());
      },
    );
  }
}