import 'dart:async';
import 'package:dunno/constants/constants.dart';
import 'package:dunno/constants/themes.dart';
import 'package:dunno/cubits/app_user_profile/app_user_profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:sp_utilities/utilities.dart';

enum TypeSearch { friends, collections }

class DunnoSearchField extends StatefulWidget {
  final String? hintText;
  final String? initialValue;
  final Color? color;
  final TypeSearch typeSearch;
  final TextEditingController controller;
  final Function(String)? onChanged;
  final bool isPinkVersion;

  const DunnoSearchField({super.key, this.hintText, this.color, this.initialValue, required this.typeSearch, required this.controller, this.onChanged, this.isPinkVersion = false});

  @override
  State<DunnoSearchField> createState() => DunnoSearchFieldState();
}

class DunnoSearchFieldState extends State<DunnoSearchField> {
  final AppUserProfileCubit _appUserProfileCubit = sl<AppUserProfileCubit>();
  Timer? _debounce;

  void _onSearchChanged(String text) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      _handleSearch(text);
    });
    setState(() {});
  }

  void _handleSearch(String query) {
    switch (widget.typeSearch) {
      case TypeSearch.friends:
        _appUserProfileCubit.searchUsers(query);
      case TypeSearch.collections:
        // handle collections search later
        break;
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
    final bool isPink = widget.isPinkVersion;
    final Color primaryColor = isPink ? AppColors.cerise : AppColors.black;
    final Color iconColor = isPink ? AppColors.offWhite : AppColors.offWhite;
    final Color clearIconColor = isPink ? AppColors.cerise : AppColors.cerise;
    final Color fillColor = isPink ? AppColors.pinkLavender.withValues(alpha: 0.4) : AppColors.black.withValues(alpha: 0.1);
    final Color hintColor = isPink ? AppColors.cerise.withValues(alpha: 0.7) : AppColors.black.withValues(alpha: 0.4);

    return SizedBox(
      child: TextField(
        autocorrect: false,
        controller: widget.controller,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(color: isPink ? AppColors.black : AppColors.black),
        decoration: InputDecoration(
          hintText: widget.hintText ?? 'Search',
          suffixIcon: StringHelpers.isNullOrEmpty(widget.controller.text)
              ? Container(
                  margin: const EdgeInsets.all(6),
                  decoration: BoxDecoration(color: primaryColor, borderRadius: BorderRadius.circular(30)),
                  child: Icon(Icons.search, color: iconColor),
                )
              : IconButton(
                  icon: Icon(Icons.close, color: clearIconColor),
                  onPressed: () {
                    widget.controller.clear();
                    _onSearchChanged('');
                  },
                ),
          contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          hintStyle: Theme.of(context).textTheme.labelLarge?.copyWith(color: hintColor),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
          fillColor: widget.color ?? fillColor,
          filled: true,
        ),
        onChanged: (value) {
          _onSearchChanged(value);
          widget.onChanged?.call(value);
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
