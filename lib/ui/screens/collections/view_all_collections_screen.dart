import 'package:dunno/constants/constants.dart';
import 'package:dunno/constants/routes.dart';
import 'package:dunno/constants/themes.dart';
import 'package:dunno/cubits/app_user_profile/app_user_profile_cubit.dart';
import 'package:dunno/cubits/collections/collection_cubit.dart';
import 'package:dunno/ui/widgets/collection_card.dart';
import 'package:dunno/ui/widgets/custom_header_bar.dart';
import 'package:dunno/ui/widgets/dunno_button.dart';
import 'package:dunno/ui/widgets/dunno_search_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ViewAllCollectionsScreen extends StatefulWidget {
  const ViewAllCollectionsScreen({super.key});

  @override
  State<ViewAllCollectionsScreen> createState() => _ViewAllCollectionsScreenState();
}

class _ViewAllCollectionsScreenState extends State<ViewAllCollectionsScreen> {
  final AppUserProfileCubit _appUserProfileCubit = sl<AppUserProfileCubit>();
  final CollectionCubit _collectionCubit = sl<CollectionCubit>();

  final TextEditingController _searchCollection = TextEditingController();

  @override
  void initState() {
    super.initState();
    _collectionCubit.loadAllCollectionsForUser(userUid: _appUserProfileCubit.state.mainAppUserProfileState.selectedProfile?.uid ?? '');
  }

  _displayCollections() {
    return BlocBuilder<CollectionCubit, CollectionState>(
      bloc: _collectionCubit,
      builder: (context, state) {
        if (state is LoadingAllCollections) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is CollectionError) {
          return Center(child: Text('Error: ${state.mainCollectionState.errorMessage}'));
        }

        final collections = state.mainCollectionState.allUserCollections ?? [];

        if (collections.isEmpty) {
          return const Center(child: Text('No collections found.'));
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          clipBehavior: Clip.none,
          itemCount: collections.length,
          itemBuilder: (context, index) {
            final collection = collections[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 16.0),
              child: CollectionCard(collection: collection, colorType: CollectionColorType.yellow)
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppUserProfileCubit, AppUserProfileState>(
      bloc: _appUserProfileCubit,
      builder: (context, state) {
        return Scaffold(
          body: Column(
            children: [
              CustomHeaderBar(
                backgroundColor: AppColors.offWhite,
                title: 'Your Collections',
                subtitle: 'Manage and explore your collections',
                onBack: () => Navigator.pop(context),
                backButtonColor: AppColors.yellow,
                actions: [
                  Offstage(
                    offstage: state.mainAppUserProfileState.appUserProfile?.uid != state.mainAppUserProfileState.selectedProfile?.uid,
                    child: Expanded(
                      flex: 1,
                      child: DunnoButton(
                        label: 'Create',
                        type: ButtonType.saffron,
                        textColor: AppColors.offWhite,
                        icon: Icon(Icons.add, color: Colors.white),
                        onPressed: () {
                          context.pushNamed(CREATE_COLLECTION_SCREEN);
                        },
                      ),
                    ),
                  )
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        DunnoSearchField(hintText: 'Search Collections', typeSearch: TypeSearch.collections, controller: _searchCollection),
                        _displayCollections(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}
