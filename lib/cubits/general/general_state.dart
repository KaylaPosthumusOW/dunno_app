part of 'general_cubit.dart';

class MainGeneralState extends Equatable {
  final String? message;
  final String? errorMessage;
  final bool? forcedLogout;
  final bool? showUpdateScreen;
  final PackageInfo? packageInfo;
  final bool latestVersionOfApp;
  final String? downloadUrl;
  final String? ogUrl;
  final bool showSplashScreen;
  final String? bannerImageUrl;

  const MainGeneralState({this.message, this.errorMessage, this.forcedLogout, this.showUpdateScreen, this.packageInfo, this.latestVersionOfApp = true, this.downloadUrl, this.ogUrl, this.showSplashScreen = true, this.bannerImageUrl});

  @override
  List<Object?> get props => [message, errorMessage, forcedLogout, showUpdateScreen, packageInfo, latestVersionOfApp, downloadUrl, ogUrl, showSplashScreen, bannerImageUrl];

  MainGeneralState copyWith({
    String? message,
    String? errorMessage,
    bool? forcedLogout,
    bool? showUpdateScreen,
    PackageInfo? packageInfo,
    bool? latestVersionOfApp,
    String? downloadUrl,
    String? ogUrl,
    bool? showSplashScreen,
    String? bannerImageUrl,
  }) {
    return MainGeneralState(
      message: message ?? this.message,
      errorMessage: errorMessage ?? this.errorMessage,
      forcedLogout: forcedLogout ?? this.forcedLogout,
      showUpdateScreen: showUpdateScreen ?? this.showUpdateScreen,
      packageInfo: packageInfo ?? this.packageInfo,
      latestVersionOfApp: latestVersionOfApp ?? this.latestVersionOfApp,
      downloadUrl: downloadUrl ?? this.downloadUrl,
      ogUrl: ogUrl ?? this.ogUrl,
      showSplashScreen: showSplashScreen ?? this.showSplashScreen,
      bannerImageUrl: bannerImageUrl ?? this.bannerImageUrl,
    );
  }
}

abstract class GeneralState extends Equatable {
  final MainGeneralState mainGeneralState;

  const GeneralState(this.mainGeneralState);

  @override
  List<Object> get props => [mainGeneralState];
}

class GeneralInitial extends GeneralState {
  const GeneralInitial() : super(const MainGeneralState(forcedLogout: false));
}

class GeneralLoading extends GeneralState {
  const GeneralLoading(super.mainGeneralState);
}

class GeneralLoaded extends GeneralState {
  const GeneralLoaded(super.mainGeneralState);
}

class GeneralImagesCleared extends GeneralState {
  const GeneralImagesCleared(super.mainGeneralState);
}

class GeneralCacheCleared extends GeneralState {
  const GeneralCacheCleared(super.mainGeneralState);
}

class GeneralError extends GeneralState {
  final String? stackTrace;

  GeneralError(MainGeneralState mainGeneralState, {this.stackTrace}) : super(mainGeneralState) {
    if (kDebugMode) {
      log('ERROR: ${mainGeneralState.errorMessage!}');
      log('ERROR: $stackTrace');
    }
  }
}
