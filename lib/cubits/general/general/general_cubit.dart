import 'dart:developer';
import 'dart:io';

import 'package:dunno/stores/firebase/main_firebase_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get_it/get_it.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sp_user_repository/sp_user_repository.dart';
import 'package:sp_utilities/utilities.dart';
import 'package:url_launcher/url_launcher.dart';

part 'general_state.dart';

class GeneralCubit extends Cubit<GeneralState> {
  final MainFirebaseRepository _mainFirebaseRepository = GetIt.instance<MainFirebaseRepository>();
  final AuthenticationCubit _authenticationCubit = GetIt.instance<AuthenticationCubit>();

  GeneralCubit() : super(const GeneralInitial());

  Future<void> openWebsite({required String url}) async {
    if (!url.toLowerCase().startsWith('https://') && !url.toLowerCase().startsWith('http://') && !url.toLowerCase().startsWith('mailto:')) {
      if (!url.toLowerCase().startsWith('www.')) {
        url = "http://$url";
      } else {
        url = url.toLowerCase().replaceAll("www.", 'http://');
      }
    }
    try {
      Uri value = Uri.parse(url);
      if (await canLaunchUrl(value)) {
        await launchUrl(value, mode: LaunchMode.externalApplication);
      } else {
        emit(GeneralError(state.mainGeneralState.copyWith(errorMessage: 'Could not launch $url'), stackTrace: 'Could not launch $url'));
      }
    } catch (error, stackTrace) {
      emit(GeneralError(state.mainGeneralState.copyWith(errorMessage: '$error', message: ''), stackTrace: stackTrace.toString()));
    }
  }

  Future<void> recommendThisApp(String url, BuildContext context) async {
    String text = url;
    final RenderBox box = context.findRenderObject() as RenderBox;

    final params = ShareParams(
      text: text,
      sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size,
    );

    await SharePlus.instance.share(params);
  }

  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries.map((MapEntry<String, String> e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}').join('&');
  }

  Future<void> emailSupport(String emailAddress, String subject) async {
    try {
      Uri emailLaunchUri = Uri(
        scheme: 'mailto',
        path: emailAddress,
        query: encodeQueryParameters(<String, String>{
          'subject': subject,
        }),
      );

      if (await canLaunchUrl(emailLaunchUri)) {
        await launchUrl(emailLaunchUri);
      }
    } catch (error, stackTrace) {
      emit(GeneralError(state.mainGeneralState.copyWith(errorMessage: '$error', message: ''), stackTrace: stackTrace.toString()));
    }
  }

  Future<void> dialNumber({required String number}) async {
    try {
      var url = 'tel:$number';
      Uri value = Uri.parse(url);
      if (await canLaunchUrl(value)) {
        await launchUrl(value);
      } else {
        emit(GeneralError(state.mainGeneralState.copyWith(errorMessage: 'Could not launch $url'), stackTrace: 'Could not launch $url'));
      }
    } catch (error, stackTrace) {
      emit(GeneralError(state.mainGeneralState.copyWith(errorMessage: '$error', message: ''), stackTrace: stackTrace.toString()));
    }
  }

  Future<void> checkIfLatestAppVersion() async {
    emit(GeneralLoading(state.mainGeneralState.copyWith(message: 'Checking App version', errorMessage: '')));
    try {
      PackageInfo packageInfo = PackageInfo(appName: 'Unknown', packageName: 'Unknown', version: 'Unknown', buildNumber: 'Unknown');
      packageInfo = await PackageInfo.fromPlatform();

      emit(GeneralLoading(state.mainGeneralState.copyWith(message: 'Checking App version', errorMessage: '')));
      num buildNumberStoredInFirebase = await _mainFirebaseRepository.latestAppVersion();
      if (buildNumberStoredInFirebase > (int.tryParse(packageInfo.buildNumber) ?? 0)) {
        emit(GeneralLoaded(state.mainGeneralState.copyWith(latestVersionOfApp: false, packageInfo: packageInfo, message: 'Latest version of the app', errorMessage: '')));
      } else {
        emit(GeneralLoaded(state.mainGeneralState.copyWith(latestVersionOfApp: true, packageInfo: packageInfo, message: 'Not latest version of the app', errorMessage: '')));
      }

      if (_authenticationCubit.state.mainAuthenticationState.user != null) {
        _authenticationCubit.updateAuthUser(_authenticationCubit.state.mainAuthenticationState.user!.copyWith(packageInfo: StringHelpers.packageInfoToMap(packageInfo)));
      }
    } catch (e, stackTrace) {
      emit(GeneralError(state.mainGeneralState.copyWith(errorMessage: e.toString(), message: ''), stackTrace: stackTrace.toString()));
    }
  }

  Future<void> shouldClearAppCache({bool forceClear = false, bool clearPreferences = false, bool clearImages = false, required String clearSharedPrefsVersion}) async {
    emit(GeneralLoading(state.mainGeneralState.copyWith(message: 'Checking cache clear', errorMessage: '')));
    if (clearPreferences) {
      try {
        SharedPreferences preferences = GetIt.instance<SharedPreferences>();
        String? clearStorage = preferences.getString(clearSharedPrefsVersion);
        if (clearStorage == null || forceClear) {
          await preferences.clear();
          await preferences.setString(clearSharedPrefsVersion, clearSharedPrefsVersion);
          emit(GeneralCacheCleared(state.mainGeneralState.copyWith(message: 'Cache cleared', errorMessage: '')));

          if (clearImages) {
            try {
              DefaultCacheManager().emptyCache();
              emit(GeneralImagesCleared(state.mainGeneralState.copyWith(message: 'Image cache cleared', errorMessage: '')));
            } catch (error, stackTrace) {
              emit(GeneralError(state.mainGeneralState.copyWith(errorMessage: error.toString(), message: ''), stackTrace: stackTrace.toString()));
            }
          } else {
            emit(GeneralLoaded(state.mainGeneralState.copyWith(message: 'Skipping images clear', errorMessage: '')));
          }
        } else {
          emit(GeneralLoaded(state.mainGeneralState.copyWith(message: 'Skipping cache clear', errorMessage: '')));
        }
      } catch (error, stackTrace) {
        emit(GeneralError(state.mainGeneralState.copyWith(errorMessage: error.toString(), message: ''), stackTrace: stackTrace.toString()));
      }
    }
  }

  Future<void> openAppStore() async {
    try {
      if (Platform.isAndroid) {
        await launchUrl(Uri.parse('https://play.google.com/store/apps/details?id=za.co.ubleisure.ubleisureapp'));
      } else {
        openWebsite(url: 'https://apps.apple.com/us/app/ub-leisure/id6746235263');
      }
    } on PlatformException catch (error, stackTrace) {
      emit(GeneralError(state.mainGeneralState.copyWith(errorMessage: '$error', message: ''), stackTrace: stackTrace.toString()));
    }
  }

  Future<void> openWhatsapp(String number) async {
    String formattedNumber = StringHelpers.formatPhoneNumber(number);

    var whatsappAndroidUrl = "whatsapp://send?phone=$formattedNumber&text=hello";
    var whatsappIOSUrl = "https://wa.me/$formattedNumber?text=${Uri.parse("hello")}";
    try {
      if (Platform.isIOS) {
        // for iOS phone only
        Uri value = Uri.parse(whatsappIOSUrl);
        if (await canLaunchUrl(value)) {
          await launchUrl(value);
        } else {
          emit(GeneralError(state.mainGeneralState.copyWith(errorMessage: "whatsapp not installed"), stackTrace: 'whatsapp not installed'));
        }
      } else {
        // android , web
        Uri value = Uri.parse(whatsappAndroidUrl);
        if (await canLaunchUrl(value)) {
          await launchUrl(value);
        } else {
          emit(GeneralError(state.mainGeneralState.copyWith(errorMessage: "whatsapp not installed"), stackTrace: 'whatsapp not installed'));
        }
      }
    } catch (error, stackTrace) {
      emit(GeneralError(state.mainGeneralState.copyWith(errorMessage: '$error', message: ''), stackTrace: stackTrace.toString()));
    }
  }
}
