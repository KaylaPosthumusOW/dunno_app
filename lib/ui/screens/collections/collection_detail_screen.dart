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
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: AppColors.offWhite,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: AppColors.yellow, offset: const Offset(3, 4))],
        border: Border.all(width: 1.5, color: AppColors.yellow),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: AppColors.black),
          ),
          const SizedBox(height: 5),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: items
                .map(
                  (item) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(color: AppColors.yellow.withValues(alpha: 0.6), borderRadius: BorderRadius.circular(20)),
                    child: Text(
                      item,
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.black),
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
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        final collection = state.mainCollectionState.selectedCollection;
        if (collection == null) {
          return const Scaffold(body: Center(child: Text('No collection selected')));
        }

        final likes = collection.likes;
        final eventDate = collection.eventCollectionDate;

        return Scaffold(
          backgroundColor: AppColors.offWhite,
          body: Column(
            children: [
              CustomHeaderBar(
                onBack: () => Navigator.pop(context),
                backButtonColor: AppColors.yellow,
                iconColor: AppColors.offWhite,
                title: state.mainCollectionState.selectedCollection?.title ?? 'Collection',
                subtitle: 'This is your collection details, you can edit it here.',
                actions: [
                  DunnoButton(
                    icon: const Icon(Icons.edit, color: Colors.white),
                    type: ButtonType.saffron,
                    label: 'Edit Collection',
                    onPressed: () {
                      _collectionCubit.setSelectedCollection(collection);
                      context.push(CREATE_COLLECTION_SCREEN);
                    },
                  ),
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _StatPill(icon: Icons.star_rounded, label: 'Visibility', value: (collection.isDateVisible ?? true) ? 'Public' : 'Private'),
                            if (collection.isDateVisible == true && eventDate != null)
                              _StatPill(
                                icon: Icons.event_available_rounded,
                                label: 'Event',
                                value: StringHelpers.printFirebaseTimeStamp(eventDate, format: 'dd MMM yyyy'),
                              ),
                          ],
                        ),
                      ),

                      SizedBox(height: 30),

                      if (likes != null) ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            'Your Preferences',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppColors.black, fontWeight: FontWeight.w600),
                          ),
                        ),
                        SizedBox(height: 5),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _buildChipsSection('Hobbies', likes.hobbies),
                              _buildChipsSection('Interests', likes.interests),
                              _buildChipsSection('Likes', likes.likes),
                              _buildChipsSection('Aesthetic Preferences', likes.aestheticPreferences),
                            ],
                          ),
                        ),
                      ],
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

class _StatPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatPill({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(color: AppColors.black, borderRadius: BorderRadius.circular(35)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.offWhite),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: TextStyle(color: AppColors.offWhite, fontWeight: FontWeight.w600),
          ),
          Text(
            value,
            style: TextStyle(color: AppColors.offWhite, fontWeight: FontWeight.w900),
          ),
        ],
      ),
    );
  }
}
