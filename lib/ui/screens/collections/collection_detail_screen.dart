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
                    decoration: BoxDecoration(
                      color: AppColors.yellow.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(20),
                    ),
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
        final owner = collection.owner;
        final eventDate = collection.eventCollectionDate;

        return Scaffold(
          backgroundColor: AppColors.offWhite,
          body: Column(
            children: [
              CustomHeaderBar(
                onBack: () => Navigator.pop(context),
                backButtonColor: AppColors.yellow,
                iconColor: AppColors.offWhite,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 20),
                      
                      // Collection info card
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.offWhite,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.tangerine.withValues(alpha: 0.15),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                          border: Border.all(
                            color: AppColors.tangerine.withValues(alpha: 0.2),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 35,
                              backgroundColor: AppColors.tangerine.withValues(alpha: 0.1),
                              backgroundImage: ((owner?.profilePicture ?? '').isNotEmpty)
                                  ? NetworkImage(owner!.profilePicture!)
                                  : null,
                              child: ((owner?.profilePicture ?? '').isEmpty)
                                  ? Icon(
                                      Icons.person,
                                      color: AppColors.tangerine,
                                      size: 35,
                                    )
                                  : null,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    collection.title ?? 'Untitled Collection',
                                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                      color: AppColors.black,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    'By ${owner?.name ?? "Unknown"}',
                                    style: TextStyle(
                                      color: AppColors.black.withValues(alpha: 0.6),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  if (collection.isDateVisible == true && eventDate != null) ...[
                                    const SizedBox(height: 12),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: AppColors.tangerine.withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: AppColors.tangerine.withValues(alpha: 0.3),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.calendar_today,
                                            size: 16,
                                            color: AppColors.tangerine,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            StringHelpers.printFirebaseTimeStamp(
                                              eventDate,
                                              format: 'dd MMM yyyy',
                                            ),
                                            style: TextStyle(
                                              color: AppColors.tangerine,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
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

                      if (likes != null) ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            'Likes & Interests',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppColors.black, fontWeight: FontWeight.w600),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(color: AppColors.antiqueWhite, borderRadius: BorderRadius.circular(20)),
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [_buildChipsSection('Hobbies', likes.hobbies), _buildChipsSection('Interests', likes.interests), _buildChipsSection('Likes', likes.likes), _buildChipsSection('Aesthetic Preferences', likes.aestheticPreferences)]),
                          ),
                        ),
                      ],

                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
                        child: DunnoButton(
                          icon: const Icon(Icons.edit, color: Colors.white),
                          type: ButtonType.saffron,
                          label: 'Edit Collection',
                          onPressed: () {
                            _collectionCubit.setSelectedCollection(collection);
                            context.push(CREATE_COLLECTION_SCREEN);
                          },
                        ),
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

class _StatPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatPill({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.yellow,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.tangerine.withValues(alpha: 0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.cinnabar),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: TextStyle(color: AppColors.black.withValues(alpha: 0.7), fontWeight: FontWeight.w600),
          ),
          Text(
            value,
            style: TextStyle(color: AppColors.cinnabar, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
