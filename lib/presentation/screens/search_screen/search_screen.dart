import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:instagram_clone/core/controllers.dart';
import 'package:instagram_clone/data/user_model.dart';
import 'package:instagram_clone/logic/user_provider.dart';
import 'package:instagram_clone/presentation/screens/search_screen/posts_results.dart';
import 'package:instagram_clone/presentation/screens/search_screen/users_results.dart';
import 'package:instagram_clone/presentation/widgets/icons_widget.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final formControllers = FormControllers();
  List<UserModel>? users;

  @override
  void initState() {
    super.initState();
    Provider.of<UserProvider>(context, listen: false).getAllPosts();
  }

  @override
  void dispose() {
    formControllers.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return Consumer<UserProvider>(builder: (context, provider, _){
      return SafeArea(
        child: Scaffold(
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                child: TextFormField(
                  controller: formControllers.search,
                  style: TextStyle(color: theme.primary),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: theme.inversePrimary,
                    prefixIcon: Padding(padding: const EdgeInsets.all(16), child: IconsWidget(icon: "search")),
                    suffixIcon: formControllers.search.text.isEmpty?null:IconButton(
                      onPressed: ()=> setState(() => formControllers.search.clear()),
                      icon: Icon(Icons.clear),),
                    hintText: "Search",
                    hintStyle: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: theme.secondary),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  onFieldSubmitted: (v) async =>
                  users = await provider.searchUsers(context, formControllers.search.text),
                ),
              ),
              if (formControllers.search.text.isEmpty)
                Expanded(
                    child: MasonryGridView.builder(
                      itemCount: provider.posts.length,
                      gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                      mainAxisSpacing: 2,
                      crossAxisSpacing: 2,
                      itemBuilder: (context, index){
                        final reversedIndex = provider.posts.length - 1 - index;
                        final post = provider.posts[reversedIndex];
                        return PostsResults(model: post);
                      },
                    ))
              else if (users!.isEmpty)
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: Text("No results found for ${formControllers.search.text}"),)
              else
                Expanded(
                  child: ListView.builder(
                      itemCount: users!.length,
                      itemBuilder: (context, index){
                        return UsersResults(user: users![index]);
                      })
              )
            ],
          ),
        ),
      );
    });
  }
}
