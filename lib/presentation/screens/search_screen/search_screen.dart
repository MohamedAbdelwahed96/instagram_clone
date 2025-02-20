import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:instagram_clone/data/user_model.dart';
import 'package:instagram_clone/logic/user_provider.dart';
import 'package:instagram_clone/presentation/screens/search_screen/posts_widget.dart';
import 'package:instagram_clone/presentation/screens/search_screen/users_results.dart';
import 'package:instagram_clone/presentation/widgets/icons_widget.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _controller = TextEditingController();
  List<UserModel>? users;

  @override
  void initState() {
    super.initState();
    Provider.of<UserProvider>(context, listen: false).getAllPosts();
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
                  controller: _controller,
                  style: TextStyle(color: theme.primary),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: theme.inversePrimary,
                    prefixIcon: Padding(padding: const EdgeInsets.all(16), child: IconsWidget(icon: "search")),
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
                  users = await provider.searchUsers(context, _controller.text),
                ),
              ),
              _controller.text.isEmpty?
                  Expanded(
                    child: StaggeredGrid.count(
                      crossAxisCount: 4,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      children: List.generate(10, (index) {
                        return StaggeredGridTile.count(
                          crossAxisCellCount: index.isEven ? 2 : 1,
                          mainAxisCellCount: index.isEven ? 2 : 1,
                          child: Container(
                            color: Colors.blueAccent,
                            child: Center(
                              child: Text(
                                'Tile $index',
                                style: TextStyle(color: Colors.white, fontSize: 18),
                              ),
                            ),
                          ),
                        );
                      }),
                    ))
                  // :users==null?Center(child: CircularProgressIndicator())
                  :users!.isEmpty?Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: Text("No results found for ${_controller.text}"),
                  ):
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
