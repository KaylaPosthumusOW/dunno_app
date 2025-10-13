import 'package:dunno/constants/constants.dart';
import 'package:dunno/constants/themes.dart';
import 'package:dunno/cubits/app_user_profile/app_user_profile_cubit.dart';
import 'package:dunno/cubits/collections/collection_cubit.dart';
import 'package:dunno/models/collection_likes.dart';
import 'package:dunno/models/collections.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dunno/ui/widgets/dunno_button.dart';
import 'package:dunno/ui/widgets/dunno_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateCollectionScreen extends StatefulWidget {
  final bool isFirstTimeUser;

  const CreateCollectionScreen({super.key, this.isFirstTimeUser = false});

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

  bool get _isEditing => _collectionCubit.state.mainCollectionState.selectedCollection != null;

  @override
  void initState() {
    super.initState();

    // Prefill form if editing
    final selected = _collectionCubit.state.mainCollectionState.selectedCollection;
    if (selected != null) {
      _titleController.text = selected.title ?? '';
      _selectedDate = selected.eventCollectionDate?.toDate();
      _isDateVisible = selected.isDateVisible ?? true;

      final likes = selected.likes;
      if (likes != null) {
        _hobbiesController.text = likes.hobbies?.join(', ') ?? '';
        _interestsController.text = likes.interests?.join(', ') ?? '';
        _likesController.text = likes.likes?.join(', ') ?? '';
        _aestheticController.text = likes.aestheticPreferences?.join(', ') ?? '';
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _hobbiesController.dispose();
    _interestsController.dispose();
    _likesController.dispose();
    _aestheticController.dispose();
    super.dispose();
  }

  Future<void> _saveCollection() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final userProfile = _appUserProfileCubit.state.mainAppUserProfileState.appUserProfile;
      if (userProfile == null) {
        throw Exception('User profile not found');
      }

      final collectionLikes = CollectionLikes(hobbies: _hobbiesController.text.isNotEmpty ? _hobbiesController.text.split(',').map((e) => e.trim()).toList() : [], interests: _interestsController.text.isNotEmpty ? _interestsController.text.split(',').map((e) => e.trim()).toList() : [], likes: _likesController.text.isNotEmpty ? _likesController.text.split(',').map((e) => e.trim()).toList() : [], aestheticPreferences: _aestheticController.text.isNotEmpty ? _aestheticController.text.split(',').map((e) => e.trim()).toList() : [], createdAt: Timestamp.now());

      final existing = _collectionCubit.state.mainCollectionState.selectedCollection;

      if (_isEditing && existing != null) {
        final updated = existing.copyWith(title: _titleController.text.trim(), eventCollectionDate: _selectedDate != null ? Timestamp.fromDate(_selectedDate!) : null, isDateVisible: _isDateVisible, likes: collectionLikes, updatedAt: Timestamp.now());

        await _collectionCubit.updateCollection(updated);

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Collection updated successfully!'), backgroundColor: Colors.green));
      } else {
        final newCollection = Collections(title: _titleController.text.trim(), owner: userProfile, eventCollectionDate: _selectedDate != null ? Timestamp.fromDate(_selectedDate!) : null, isDateVisible: _isDateVisible, createdAt: Timestamp.now(), updatedAt: Timestamp.now(), likes: collectionLikes);

        await _collectionCubit.createNewCollection(newCollection);

        if (widget.isFirstTimeUser || !userProfile.hasCreatedFirstCollection) {
          await _appUserProfileCubit.updateProfile(userProfile.copyWith(hasCreatedFirstCollection: true));
        }

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Collection created successfully!'), backgroundColor: Colors.green));
      }

      if (mounted) Navigator.of(context).pop();
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error saving collection: $error'), backgroundColor: Colors.red));
    } finally {
      if (mounted) setState(() => _isLoading = false);
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
      setState(() => _selectedDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = _isEditing
        ? 'Edit Collection'
        : widget.isFirstTimeUser
        ? 'Create Your First Collection'
        : 'Create Collection';

    return Scaffold(
      appBar: AppBar(title: Text(title), centerTitle: false, automaticallyImplyLeading: !widget.isFirstTimeUser),
      body: BlocListener<CollectionCubit, CollectionState>(
        bloc: _collectionCubit,
        listener: (context, state) {
          if (state is CollectionError) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.mainCollectionState.errorMessage ?? 'An error occurred'), backgroundColor: Colors.red));
          }
        },
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              DunnoTextField(controller: _titleController, label: 'Collection Title', supportingText: 'Enter a title for your collection', isLight: true),
              const SizedBox(height: 12),
              DunnoTextField(controller: _hobbiesController, label: 'Hobbies', supportingText: 'e.g. Reading, Hiking, Cooking', isLight: true),
              const SizedBox(height: 12),
              DunnoTextField(controller: _interestsController, label: 'Interests', supportingText: 'e.g. Technology, Art, Travel', isLight: true),
              const SizedBox(height: 12),
              DunnoTextField(controller: _likesController, label: 'Likes', supportingText: 'e.g. Coffee, Music, Sports', isLight: true),
              const SizedBox(height: 12),
              DunnoTextField(controller: _aestheticController, label: 'Aesthetic Preferences', supportingText: 'e.g. Minimalist, Vintage, Modern', isLight: true),
              const SizedBox(height: 10),

              // --- Date Selection ---
              Padding(
                padding: const EdgeInsets.only(bottom: 4, left: 15),
                child: Text('Event Date (Optional)', style: Theme.of(context).textTheme.labelMedium),
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
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextButton.icon(
                        onPressed: _selectDate,
                        icon: const Icon(Icons.calendar_today, color: Colors.black87),
                        label: Text(_selectedDate != null ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}' : 'Select Date', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.black87)),
                        style: TextButton.styleFrom(alignment: Alignment.centerLeft),
                      ),
                    ),
                    if (_selectedDate != null)
                      IconButton(
                        onPressed: () => setState(() => _selectedDate = null),
                        icon: const Icon(Icons.clear_rounded, color: Colors.black54, size: 25),
                      ),
                  ],
                ),
              ),
              if (_selectedDate != null) ...[
                const SizedBox(height: 12),
                SwitchListTile(
                  activeThumbColor: AppColors.cerise,
                    activeTrackColor: AppColors.pinkLavender,
                    inactiveThumbColor: AppColors.pinkLavender,
                    inactiveTrackColor: AppColors.pinkLavender.withValues(alpha: 0.4),
                    trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
                    title: const Text('Make date visible to others'),
                    value: _isDateVisible, onChanged: (v) => setState(() => _isDateVisible = v),
                    contentPadding: EdgeInsets.zero,
                ),
              ],

              const SizedBox(height: 32),

              DunnoButton(
                onPressed: _isLoading ? null : _saveCollection,
                icon: Icon(_isEditing ? Icons.update : Icons.add, color: Colors.white),
                label: (_isLoading ? (_isEditing ? 'Updating...' : 'Creating...') : (_isEditing ? 'Update Collection' : 'Create Collection')),
                type: ButtonType.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
