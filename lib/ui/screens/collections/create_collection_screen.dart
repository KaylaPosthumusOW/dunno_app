import 'package:dunno/constants/constants.dart';
import 'package:dunno/constants/themes.dart';
import 'package:dunno/cubits/app_user_profile/app_user_profile_cubit.dart';
import 'package:dunno/cubits/collections/collection_cubit.dart';
import 'package:dunno/models/collection_likes.dart';
import 'package:dunno/models/collections.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dunno/ui/widgets/dunno_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateCollectionScreen extends StatefulWidget {
  final bool isFirstTimeUser;

  const CreateCollectionScreen({
    super.key,
    this.isFirstTimeUser = false,
  });

  @override
  State<CreateCollectionScreen> createState() => _CreateCollectionScreenState();
}

class _CreateCollectionScreenState extends State<CreateCollectionScreen> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _hobbiesController = TextEditingController();
  final _interestsController = TextEditingController();
  final _likesController = TextEditingController();
  final _aestheticController = TextEditingController();

  DateTime? _selectedDate;
  bool _isDateVisible = true;
  bool _isLoading = false;

  final AppUserProfileCubit _appUserProfileCubit = sl<AppUserProfileCubit>();
  final CollectionCubit _collectionCubit = sl<CollectionCubit>();

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _createCollection() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    final collectionLikes = CollectionLikes(
      hobbies: _hobbiesController.text.split(',').map((e) => e.trim()).toList(),
      interests: _interestsController.text.split(',').map((e) => e.trim()).toList(),
      likes: _likesController.text.split(',').map((e) => e.trim()).toList(),
      aestheticPreferences: _aestheticController.text.split(',').map((e) => e.trim()).toList(),
      createdAt: Timestamp.now(),
    );

    try {
      final userProfile = _appUserProfileCubit.state.mainAppUserProfileState.appUserProfile;
      if (userProfile == null) {
        throw Exception('User profile not found');
      }

      final newCollection = Collections(
        title: _titleController.text.trim(),
        owner: userProfile,
        eventCollectionDate: _selectedDate != null ? Timestamp.fromDate(_selectedDate!) : null,
        isDateVisible: _isDateVisible,
        createdAt: Timestamp.now(),
        updatedAt: Timestamp.now(),
        likes: collectionLikes,
      );

      await _collectionCubit.createNewCollection(newCollection);

      if (widget.isFirstTimeUser || !userProfile.hasCreatedFirstCollection) {
        await _appUserProfileCubit.updateProfile(
          userProfile.copyWith(hasCreatedFirstCollection: true),
        );
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Collection created successfully!'),
            backgroundColor: Colors.green,
          ),
        );

        if (widget.isFirstTimeUser) {
          Navigator.of(context).popUntil((route) => route.isFirst);
        } else {
          Navigator.of(context).pop();
        }
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error creating collection: $error'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isFirstTimeUser ? 'Create Your First Collection' : 'Create Collection'),
        centerTitle: false,
        automaticallyImplyLeading: !widget.isFirstTimeUser,
      ),
      body: BlocListener<CollectionCubit, CollectionState>(
        bloc: _collectionCubit,
        listener: (context, state) {
          if (state is CollectionError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.mainCollectionState.errorMessage ?? 'An error occurred'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              if (widget.isFirstTimeUser) ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Theme.of(context).primaryColor.withOpacity(0.3),
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.celebration,
                        size: 48,
                        color: Theme.of(context).primaryColor,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Welcome to Collections!',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Create your first collection to organize gift ideas for special occasions.',
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],
              DunnoTextField(
                controller: _titleController,
                label: 'Collection Title',
                supportingText: 'Enter a title for your collection',
                onChanged: (value) { setState(() {}); },
                onCleared: () { setState(() {}); },
                isLight: true,
              ),
              const SizedBox(height: 12),
              DunnoTextField(
                controller: _hobbiesController,
                label: 'Hobbies',
                supportingText: 'e.g. Reading, Hiking, Cooking',
                onChanged: (value) { setState(() {}); },
                onCleared: () { setState(() {}); },
                isLight: true,
              ),
              const SizedBox(height: 12),
              DunnoTextField(
                controller: _interestsController,
                label: 'Interests',
                supportingText: 'e.g. Technology, Art, Travel',
                onChanged: (value) { setState(() {}); },
                onCleared: () { setState(() {}); },
                isLight: true,
              ),
              const SizedBox(height: 12),
              DunnoTextField(
                controller: _likesController,
                label: 'Likes',
                supportingText: 'e.g. Coffee, Music, Sports',
                onChanged: (value) { setState(() {}); },
                onCleared: () { setState(() {}); },
                isLight: true,
              ),
              const SizedBox(height: 12),
              DunnoTextField(
                controller: _aestheticController,
                label: 'Aesthetic Preferences',
                supportingText: 'e.g. Minimalist, Vintage, Modern',
                onChanged: (value) { setState(() {}); },
                onCleared: () { setState(() {}); },
                isLight: true,
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(bottom: 4, left: 15),
                child: Text(
                  'Event Date (Optional)',
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ),
              Container(
                height: 55,
                decoration: BoxDecoration(
                  color: AppColors.pinkLavender.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: AppColors.pinkLavender.withValues(alpha: 0.6)),
                ),
                child: Row(
                  children: [
                    SizedBox(width: 10),
                    Expanded(
                      child: TextButton.icon(
                        onPressed: _selectDate,
                        icon: Icon(Icons.calendar_today, color: Colors.black87),
                        label: Text(
                          _selectedDate != null
                              ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                              : 'Select Date',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.black87),
                        ),
                        style: TextButton.styleFrom(alignment: Alignment.centerLeft),
                      ),
                    ),
                    if (_selectedDate != null)
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _selectedDate = null;
                          });
                        },
                        icon: const Icon(Icons.clear_rounded, color: Colors.black54, size: 25),
                      ),
                  ],
                ),
              ),
              if (_selectedDate != null) ...[
                const SizedBox(height: 12),
                SwitchListTile(
                  title: const Text('Make date visible to others'),
                  value: _isDateVisible,
                  onChanged: (value) {
                    setState(() {
                      _isDateVisible = value;
                    });
                  },
                  contentPadding: EdgeInsets.zero,
                ),
              ],
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: _isLoading ? null : _createCollection,
                  icon: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.add),
                  label: Text(
                    _isLoading
                        ? 'Creating Collection...'
                        : widget.isFirstTimeUser
                            ? 'Create My First Collection'
                            : 'Create Collection',
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),

              if (widget.isFirstTimeUser) ...[
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    final userProfile = _appUserProfileCubit.state.mainAppUserProfileState.appUserProfile;
                    if (userProfile != null) {
                      _appUserProfileCubit.updateProfile(
                        userProfile.copyWith(hasCreatedFirstCollection: true),
                      );
                    }
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  child: const Text('Skip for now'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
