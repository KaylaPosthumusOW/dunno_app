import 'package:dunno/constants/constants.dart';
import 'package:dunno/cubits/ai_gift_suggestion/ai_gift_suggestion_cubit.dart';
import 'package:dunno/cubits/friend_gift_suggestion/friend_gift_suggestion_cubit.dart';
import 'package:dunno/cubits/app_user_profile/app_user_profile_cubit.dart';
import 'package:dunno/cubits/calender_event_cubit/calender_event_cubit.dart';
import 'package:dunno/cubits/collections/collection_cubit.dart';
import 'package:dunno/cubits/connections/connection_cubit.dart';
import 'package:dunno/cubits/general/general_cubit.dart';
import 'package:dunno/cubits/gift_board/gift_board_cubit.dart';
import 'package:dunno/firebase_options.dart';
import 'package:dunno/repositories/ai_text_generation_repository.dart';
import 'package:dunno/stores/firebase/app_user_profile_firebase_repository.dart';
import 'package:dunno/stores/firebase/calender_event_firebase_repository.dart';
import 'package:dunno/stores/firebase/collection_firebase_repository.dart';
import 'package:dunno/stores/firebase/connection_firebase_repository.dart';
import 'package:dunno/stores/firebase/gift_board_firebase_repository.dart';
import 'package:dunno/stores/firebase/main_firebase_repository.dart';
import 'package:sp_firebase/sp_firebase.dart';
import 'package:sp_user_repository/sp_user_repository.dart';
import 'package:sp_utilities/utilities.dart';

class DependencyInjection {
  static init() async {
    await _packages();
    await _repos();
    await _cubits();
    await _main();
  }

  static _main() async {}

  static _repos() async {
    sl.registerLazySingleton<MainFirebaseRepository>(() => MainFirebaseRepository());
    sl.registerLazySingleton<AppUserProfileFirebaseRepository>(() => AppUserProfileFirebaseRepository());
    sl.registerLazySingleton<CalenderEventFirebaseRepository>(() => CalenderEventFirebaseRepository());
    sl.registerLazySingleton<CollectionFirebaseRepository>(() => CollectionFirebaseRepository());
    sl.registerLazySingleton<ConnectionFirebaseRepository>(() => ConnectionFirebaseRepository());
    sl.registerLazySingleton<GiftBoardFirebaseRepository>(() => GiftBoardFirebaseRepository());
    
    // AI Repository
    sl.registerLazySingleton<AiTextGenerationRepository>(() => AiTextGenerationRepository());
  }

  static _cubits() async {
    sl.registerSingleton<AppUserProfileCubit>(AppUserProfileCubit());
    sl.registerLazySingleton<GeneralCubit>(() => GeneralCubit()..checkIfLatestAppVersion());
    sl.registerSingleton<CalenderEventCubit>(CalenderEventCubit());
    sl.registerSingleton<CollectionCubit>(CollectionCubit());
    sl.registerSingleton<ConnectionCubit>(ConnectionCubit());
    sl.registerSingleton<GiftBoardCubit>(GiftBoardCubit());

    sl.registerFactory<AiGiftSuggestionCubit>(() => AiGiftSuggestionCubit(sl<AiTextGenerationRepository>()));
    sl.registerFactory<FriendGiftSuggestionCubit>(() => FriendGiftSuggestionCubit(sl<AiTextGenerationRepository>()));
  }


  static _packages() async {
    await SPFirebaseInitialiser.initialiseDI(name: '[DEFAULT]', options: DefaultFirebaseOptions.currentPlatform);
    await UserRepoInitialiser.initialiseDI();
    await SPUtilitiesInitialiser.initialiseDI();
  }
}
