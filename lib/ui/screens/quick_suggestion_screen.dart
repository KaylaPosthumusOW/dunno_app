import 'package:dunno/constants/routes.dart';
import 'package:dunno/ui/widgets/dunno_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class QuickSuggestionScreen extends StatefulWidget {
  const QuickSuggestionScreen({super.key});

  @override
  State<QuickSuggestionScreen> createState() => _QuickSuggestionScreenState();
}

class _QuickSuggestionScreenState extends State<QuickSuggestionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height),
          child: IntrinsicHeight(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Spacer(),
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.end, children: [SvgPicture.asset('assets/svg/quick_suggestion.svg', width: 260, height: 260)]),
                    Positioned(
                      left: 0,
                      top: 170,
                      child: Text('Quick \nSuggestions', style: TextStyle(fontSize: 48, fontWeight: FontWeight.w600, height: 1.2)),
                    ),
                  ],
                ),
                SizedBox(height: 60),
                Text('No profile? No problem. Get instant gift ideas', style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w700)),
                SizedBox(height: 10),
                DunnoButton(
                  type: ButtonType.secondary,
                  label: 'Get Quick Suggestions',
                  onPressed: () {
                    context.pushNamed(GIFT_SUGGESTION_MANAGEMENT);
                  },
                ),
                SizedBox(height: 130),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
