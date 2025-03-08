import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_aggregator_app/Auth/bloc/auth_bloc.dart';
import 'package:news_aggregator_app/home/bloc/home_bloc.dart';
import 'package:news_aggregator_app/home/screens/bookMark.dart';
import 'package:news_aggregator_app/home/screens/newsScreen.dart';
import 'package:news_aggregator_app/home/screens/search.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    context.read<HomeBloc>().add(GetDataEvent(index: 0));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      listenWhen: (previous, current) => current is HomeActionState,
      buildWhen: (previous, current) => current is! HomeActionState,
      listener: (context, state) {
        if (state is BookNavState) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => BookMarkScreen()),
          );
        }
        if(state is HomeErrorState){
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
        }
       
      },
      builder: (context, state) {
        if (state is BottomNavState) {
          selectedIndex = state.selectedIndex;
        }
        return Scaffold(
          drawer: Drawer(
            child: Column(
              children: [
                DrawerHeader(
                  child: Column(
                    children: [
                      Icon(
                        Icons.article_rounded,
                        size: 80,
                        color: Colors.black,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Daily News',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    context.read<AuthBloc>().add(LogOutEvent());
                  },
                  label: Text('Logout'),
                  icon: Icon(Icons.login_rounded),
                ),
              ],
            ),
          ),
          appBar: AppBar(
            title: Row(
              children: [
                Icon(
                  Icons.article_rounded,
                  color: Colors.black,
                ),
                const SizedBox(width: 8),
                Text(
                  'Daily News',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.bookmark),
                onPressed: () {
                  context.read<HomeBloc>().add(BookNavEvent());
                },
              ),
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () async {
                  final query = await showSearch(
                    context: context,
                    delegate: NewsSearchDelegate(),
                  );
                  if (query != null && query.isNotEmpty) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SearchScreen(query: query),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
          body:NewsScreen(index: selectedIndex),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: selectedIndex,
            onTap: (index) {
             
              context.read<HomeBloc>().add(BottomNavBarEvent(index: index));
            },
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Theme.of(context).colorScheme.primary,
            unselectedItemColor: Colors.grey,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.computer),
                label: 'Technology',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.business_rounded),
                label: 'Business',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.health_and_safety),
                label: 'Health',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.sports_tennis_outlined),
                label: 'Sports',
              ),
            ],
          ),
        );
      },
    );
  }
}

class NewsSearchDelegate extends SearchDelegate<String> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return SearchScreen(query: query);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}
