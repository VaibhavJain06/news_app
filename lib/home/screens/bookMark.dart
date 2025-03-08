import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:news_aggregator_app/home/bloc/home_bloc.dart';
import 'package:news_aggregator_app/home/screens/webView.dart';

class BookMarkScreen extends StatefulWidget {
  const BookMarkScreen({super.key});

  @override
  State<BookMarkScreen> createState() => _BookMarkScreenState();
}

class _BookMarkScreenState extends State<BookMarkScreen> {
  
  @override
  void initState(){
    super.initState();
     context.read<HomeBloc>().add(GetStoredBookMarkEvent());
  }


  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if(state is BookmarkState){
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text('Bookmarks'),
          ),
          body: ListView.builder(
            itemCount: state.bookmarks.length,
          itemBuilder: (context,index){
            final news = state.bookmarks[index];
            final formattedDate =DateFormat('yyyy-MM-dd').format(DateTime.parse(news.date));
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
                    child: Image(image:NetworkImage(state.bookmarks[index].imageUrl),fit: BoxFit.fill,)),
                   Text(formattedDate.toString(),style: TextStyle(fontWeight:FontWeight.w500),),
                   Text(state.bookmarks[index].title,style: TextStyle(fontWeight: FontWeight.bold),),
                   Text(state.bookmarks[index].description,style: TextStyle(fontWeight: FontWeight.w500),),
                   Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: [
                       TextButton.icon(
                        onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>Webview(url: state.bookmarks[index].url,)));
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
                         
                        }, icon: Icon(Icons.bookmark_remove_sharp,color: Colors.black,size: 33.0,)),
                     ],
                   )
                    
                 ],
               ),
             );
          }
          ),
        );
        }
        return Center(child: CircularProgressIndicator(),);
      }
    );
        
  }
}