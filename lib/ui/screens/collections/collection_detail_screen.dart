import 'package:dunno/constants/constants.dart';
import 'package:dunno/constants/routes.dart';
import 'package:dunno/constants/themes.dart';
import 'package:dunno/cubits/collections/collection_cubit.dart';
import 'package:dunno/ui/widgets/custom_header_bar.dart';
import 'package:dunno/ui/widgets/dunno_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sp_utilities/utilities.dart';

class CollectionDetailsScreen extends StatefulWidget {
  const CollectionDetailsScreen({super.key});

  @override
  State<CollectionDetailsScreen> createState() => _CollectionDetailsScreenState();
}

class _CollectionDetailsScreenState extends State<CollectionDetailsScreen> {
  final CollectionCubit _collectionCubit = sl<CollectionCubit>();

  Widget _buildChipsSection(String title, List<String>? items) {
    if (items == null || items.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: AppColors.black),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: items
                .map(
                  (item) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(color: AppColors.offWhite, borderRadius: BorderRadius.circular(20)),
                    child: Text(
                      item,
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.cerise),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CollectionCubit, CollectionState>(
      bloc: _collectionCubit,
      builder: (context, state) {
        if (state is LoadingAllCollections) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomHeaderBar(
                    backgroundColor: AppColors.pinkLavender,
                    onBack: () => Navigator.pop(context),
                    backButtonColor: AppColors.cerise,
                  ),
                  CircularProgressIndicator(color: AppColors.cerise, strokeWidth: 3),
                  const SizedBox(height: 16),
                  Text(
                    'Loading collection details...',
                    style: TextStyle(color: AppColors.black.withOpacity(0.7), fontSize: 16, fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ),
          );
        }

        final collection = state.mainCollectionState.selectedCollection;
        if (collection == null) {
          return const Scaffold(body: Center(child: Text('No collection selected')));
        }

        final likes = collection.likes;
        final owner = collection.owner;
        final eventDate = collection.eventCollectionDate;

        return Scaffold(
          body: Column(
            children: [
              CustomHeaderBar(
                title: collection.title ?? 'Collection Details',
                onBack: () => Navigator.pop(context),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(color: AppColors.cerise, borderRadius: BorderRadius.circular(20), boxShadow: getBoxShadow(context)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: AppColors.offWhite,
                            backgroundImage: owner?.profilePicture != null ? NetworkImage(owner!.profilePicture!) : null,
                            child: owner?.profilePicture == null ? Icon(Icons.person, color: AppColors.cerise, size: 30) : null,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  collection.title ?? 'Untitled Collection',
                                  style: Theme.of(context).textTheme.displayMedium?.copyWith(color: AppColors.offWhite, fontWeight: FontWeight.w700),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'By ${owner?.name ?? "Unknown"}',
                                  style: TextStyle(color: AppColors.offWhite.withValues(alpha: 0.8), fontSize: 14, fontWeight: FontWeight.w400),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      if (collection.isDateVisible == true && eventDate != null) ...[
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                          decoration: BoxDecoration(color: AppColors.offWhite.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(30)),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.calendar_today, size: 16, color: AppColors.offWhite),
                              const SizedBox(width: 8),
                              Text(
                                StringHelpers.printFirebaseTimeStamp(eventDate, format: 'dd MMMM, yyyy'),
                                style: TextStyle(fontSize: 14, color: AppColors.offWhite, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                if (likes != null) ...[
                  Text('Likes & Interests', style: Theme.of(context).textTheme.displayMedium?.copyWith(color: AppColors.black)),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(color: AppColors.pinkLavender.withValues(alpha: 0.6), borderRadius: BorderRadius.circular(20)),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [_buildChipsSection('Hobbies', likes.hobbies), _buildChipsSection('Interests', likes.interests), _buildChipsSection('Likes', likes.likes), _buildChipsSection('Aesthetic Preferences', likes.aestheticPreferences)]),
                  ),
                  const SizedBox(height: 24),
                ],
                DunnoButton(
                  icon: Icon(Icons.edit, color: AppColors.offWhite),
                  type: ButtonType.primary,
                  label: 'Edit your Collections',
                  onPressed: () {
                    context.push(CREATE_COLLECTION_SCREEN);
                  },
                ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
