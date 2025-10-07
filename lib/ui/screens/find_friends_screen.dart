import 'package:dunno/ui/widgets/dunno_search_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FindFriendsScreen extends StatefulWidget {
  const FindFriendsScreen({super.key});

  @override
  State<FindFriendsScreen> createState() => _FindFriendsScreenState();
}

class _FindFriendsScreenState extends State<FindFriendsScreen> {
  final TextEditingController _searchFriendController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height),
          child: IntrinsicHeight(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Spacer(),
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.end, children: [SvgPicture.asset('assets/svg/find_friends.svg', width: 230, height: 230)]),
                    Positioned(
                      left: 0,
                      top: 170,
                      child: Text('Find \nFriends', style: TextStyle(fontSize: 48, fontWeight: FontWeight.w600, height: 1.2)),
                    ),
                  ],
                ),
                SizedBox(height: 80),
                Text('Search Friends, Family & Colleagues', style: Theme.of(context).textTheme.titleMedium),
                SizedBox(height: 10),
                DunnoSearchField(typeSearch: TypeSearch.friends, controller: _searchFriendController),
                SizedBox(height: 130),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
