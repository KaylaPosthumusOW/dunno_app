import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sp_utilities/utilities.dart';

const kDefaultThemeMode = ThemeMode.light;

class FrameTheme {
  static TextTheme get textTheme {
    return GoogleFonts.mulishTextTheme().copyWith(
      displayLarge: GoogleFonts.mulish(fontSize: 32, fontWeight: FontWeight.w600, color: Colors.black),
      displayMedium: GoogleFonts.mulish(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.black),
      displaySmall: GoogleFonts.mulish(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.black),
      headlineLarge: GoogleFonts.mulish(fontSize: 24, fontWeight: FontWeight.w700, color: Colors.black),
      headlineMedium: GoogleFonts.mulish(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black),
      headlineSmall: GoogleFonts.mulish(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black),
      titleLarge: GoogleFonts.mulish(fontSize: 24, fontWeight: FontWeight.w400, color: Colors.black),
      titleMedium: GoogleFonts.mulish(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.black),
      titleSmall: GoogleFonts.mulish(fontSize: 12, fontWeight: FontWeight.w400, color: Colors.black),
      labelLarge: GoogleFonts.mulish(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black),
      labelMedium: GoogleFonts.mulish(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.black),
      labelSmall: GoogleFonts.mulish(fontSize: 12, fontWeight: FontWeight.w400, color: Colors.black),
      bodyLarge: GoogleFonts.mulish(fontSize: 16, fontWeight: FontWeight.w300, color: Colors.black),
      bodyMedium: GoogleFonts.mulish(fontSize: 14, fontWeight: FontWeight.w300, color: Colors.black),
      bodySmall: GoogleFonts.mulish(fontSize: 10, fontWeight: FontWeight.w300, color: Colors.black),
    );
  }

  static ThemeData lightTheme(bool useMaterial3) {
    return ThemeData(
      textTheme: textTheme,
      useMaterial3: useMaterial3,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.offWhite,
      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        foregroundColor: Colors.black,
        actionsPadding: EdgeInsets.symmetric(horizontal: 16),
        titleTextStyle: GoogleFonts.lexend(fontSize: 28, fontWeight: FontWeight.w500, color: AppColors.black),
        iconTheme: IconThemeData(color: AppColors.black, size: 33),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      iconTheme: IconThemeData(color: Colors.black, size: 33),
      colorScheme: ColorScheme.light(
        primary: AppColors.cerise,
        secondary: AppColors.cinnabar,
        surface: AppColors.offWhite,
        error: AppColors.cinnabar.withValues(alpha: 0.5),
        onPrimary: AppColors.cerise,
        onSecondary: AppColors.tangerine,
        onSurface: AppColors.black,
        onError: AppColors.cinnabar.withValues(alpha: 0.5),
      ),
      tabBarTheme: TabBarThemeData(
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(color: AppColors.cerise, width: 2),
        ),
        labelColor: AppColors.cerise,
        unselectedLabelColor: AppColors.pinkLavender,
        labelStyle: textTheme.labelMedium,
        unselectedLabelStyle: textTheme.labelMedium,
      ),
      toggleButtonsTheme: ToggleButtonsThemeData(
        color: AppColors.offWhite,
        selectedColor: AppColors.cerise,
        fillColor: AppColors.black,
        borderRadius: BorderRadius.circular(8),
        constraints: const BoxConstraints(minHeight: 40, minWidth: 40),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.all(AppColors.black),
        trackColor: WidgetStateProperty.all(AppColors.tangerine),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.black,
        indicatorColor: Colors.transparent,
        labelTextStyle: WidgetStateProperty.all(
          textTheme.displayLarge,
        ),
      ),
      listTileTheme: ListTileThemeData(
        iconColor: AppColors.cerise,
        textColor: Colors.black,
        titleTextStyle: textTheme.displaySmall,
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.all(AppColors.offWhite),
        checkColor: WidgetStateProperty.all(AppColors.offWhite),
      ),
      dividerTheme: DividerThemeData(color: AppColors.black),
      splashColor: Colors.transparent,
      cardTheme: CardThemeData(
        color: AppColors.offWhite,
      ),
      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      badgeTheme: BadgeThemeData(
        backgroundColor: AppColors.cerise,
        textStyle: textTheme.labelMedium?.copyWith(color: Colors.white),
        textColor: Colors.white,
      ),
    );
  }

  static ThemeData darkTheme(bool useMaterial3) {
    return ThemeData(
      textTheme: textTheme,
      useMaterial3: useMaterial3,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.black,
      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.black, size: 33),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      iconTheme: IconThemeData(color: Colors.black, size: 33),
      colorScheme: ColorScheme.dark(
        primary: AppColors.cerise,
        secondary: AppColors.tangerine,
        surface: AppColors.black,
        error: AppColors.cinnabar.withValues(alpha: 0.5),
        onPrimary: AppColors.offWhite,
        onSecondary: AppColors.offWhite,
        onSurface: AppColors.offWhite,
        onError: AppColors.offWhite,
      ),
      tabBarTheme: TabBarThemeData(
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(color: AppColors.cerise, width: 2),
        ),
        labelColor: AppColors.cerise,
        unselectedLabelColor: AppColors.offWhite,
        labelStyle: textTheme.labelMedium,
        unselectedLabelStyle: textTheme.labelMedium,
      ),
      toggleButtonsTheme: ToggleButtonsThemeData(
        color: AppColors.offWhite,
        selectedColor: AppColors.cerise,
        fillColor: AppColors.offWhite,
        borderRadius: BorderRadius.circular(8),
        constraints: const BoxConstraints(minHeight: 40, minWidth: 40),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.all(AppColors.black),
        trackColor: WidgetStateProperty.all(AppColors.offWhite),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.black,
        indicatorColor: Colors.transparent,
        labelTextStyle: WidgetStateProperty.all(
          textTheme.displayLarge,
        ),
      ),
      listTileTheme: ListTileThemeData(
        iconColor: AppColors.offWhite,
        textColor: Colors.black,
        titleTextStyle: textTheme.displaySmall,
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.all(AppColors.offWhite),
        checkColor: WidgetStateProperty.all(AppColors.offWhite),
      ),
      dividerTheme: DividerThemeData(color: AppColors.offWhite),
      splashColor: Colors.transparent,
      cardTheme: CardThemeData(
        color: AppColors.offWhite,
      ),
      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}

class AppColors {
  static Color black = HexColor('#151515');
  static Color offWhite = HexColor('#F5F5F5');
  static Color pinkLavender = HexColor('#F3C8F3');
  static Color cerise = HexColor('#E22897');
  static Color tangerine = HexColor('#FD9651');
  static Color cinnabar = HexColor('#EF512C');
  static Color antiqueWhite = HexColor('#FBE9D1');
  static Color errorRed = HexColor('#FF4C4C');
  static Color yellow = HexColor('#FFB700');
  static Color brightPink = HexColor('#FB66B1');
}

List<BoxShadow> getBoxShadow(BuildContext context) {
  return [
    BoxShadow(color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.16), blurStyle: BlurStyle.normal, offset: const Offset(0, 1), blurRadius: 3),
  ];
}
