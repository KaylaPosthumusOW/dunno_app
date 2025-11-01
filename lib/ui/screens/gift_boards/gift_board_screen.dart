import 'package:dunno/ui/screens/gift_boards/create_board_dialog.dart';
import 'package:dunno/ui/widgets/dunno_button.dart';
import 'package:dunno/ui/widgets/dunno_search_field.dart';
import 'package:flutter/material.dart';

class GiftBoardScreen extends StatefulWidget {
  const GiftBoardScreen({super.key});

  @override
  State<GiftBoardScreen> createState() => _GiftBoardScreenState();
}

class _GiftBoardScreenState extends State<GiftBoardScreen> {
  final TextEditingController _searchCollection = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gift Board'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 2,
                    child: DunnoSearchField(hintText: 'Search Your Boards', typeSearch: TypeSearch.collections, controller: _searchCollection),
                  ),
                  SizedBox(width: 10),
                  DunnoButton(
                    label: 'Create',
                    type: ButtonType.primary,
                    icon: Icon(Icons.add, color: Colors.white),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return const CreateBoardDialog();
                        },
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      )
    );
  }
}
