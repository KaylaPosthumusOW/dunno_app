import 'dart:async';

import 'package:dunno/constants/constants.dart';
import 'package:dunno/constants/themes.dart';
import 'package:dunno/cubits/app_user_profile/app_user_profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:sp_utilities/utilities.dart';

enum TypeSearch { friends }

class DunnoSearchField extends StatefulWidget {
  final String? hintText;
  final String? initialValue;
  final Color? color;
  final TypeSearch typeSearch;
  final TextEditingController controller;
  final Function(String)? onChanged;

  const DunnoSearchField({super.key, this.hintText, this.color, this.initialValue, required this.typeSearch, required this.controller, this.onChanged});

  @override
  State<DunnoSearchField> createState() => DunnoSearchFieldState();
}

class DunnoSearchFieldState extends State<DunnoSearchField> {
  final AppUserProfileCubit _appUserProfileCubit = sl<AppUserProfileCubit>();

  Timer? _debounce;

  void _onSearchChanged(String text) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      if (!StringHelpers.isNullOrEmpty(text) && text.length > 2) {
        _handleSearch(text);
      } else {
        _handleSearch(text);
      }
    });
    setState(() {});
  }

  void _handleSearch(String query) {
    switch (widget.typeSearch) {
      case TypeSearch.friends:
        _appUserProfileCubit.searchUsers(query);
    }
  }

  @override
  void didUpdateWidget(covariant DunnoSearchField oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.initialValue != oldWidget.initialValue && widget.initialValue != widget.controller.text) {
      widget.controller.text = widget.initialValue ?? '';
      _handleSearch(widget.initialValue ?? '');
    }
  }

  @override
  void initState() {
    super.initState();
    if (!StringHelpers.isNullOrEmpty(widget.initialValue)) {
      widget.controller.text = widget.initialValue!;
      _handleSearch(widget.initialValue!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: TextField(
        autocorrect: false,
        controller: widget.controller,
        style: Theme.of(context).textTheme.labelLarge,
        decoration: InputDecoration(
          hintText: widget.hintText ?? 'Search',
          suffixIcon: StringHelpers.isNullOrEmpty(widget.controller.text)
              ? Container(
                  margin: const EdgeInsets.only(right: 5, top: 3, bottom: 3),
                  decoration: BoxDecoration(color: AppColors.cerise, borderRadius: BorderRadius.circular(10),),
                  child: Icon(Icons.search, color: AppColors.offWhite),
                )
              : IconButton(
                  icon: Icon(Icons.close, color: AppColors.cerise),
                  onPressed: () {
                    widget.controller.clear();
                    _onSearchChanged('');
                  },
                ),
          contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          hintStyle: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.cerise),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          fillColor: widget.color ?? AppColors.pinkLavender.withValues(alpha: 0.6),
          filled: true,
        ),
        onChanged: (value) {
          _onSearchChanged(value);
          if (widget.onChanged != null) {
            widget.onChanged!(value);
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
