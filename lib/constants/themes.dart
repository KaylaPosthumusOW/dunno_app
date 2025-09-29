import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sp_utilities/utilities.dart';

const kDefaultThemeMode = ThemeMode.light;

class FrameTheme {
  static TextTheme get textTheme {
    return GoogleFonts.robotoTextTheme().copyWith(
      displayLarge: GoogleFonts.lexend(fontSize: 32, fontWeight: FontWeight.w600, color: Colors.black),
      displayMedium: GoogleFonts.lexend(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.black),
      displaySmall: GoogleFonts.lexend(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.black),
      headlineLarge: GoogleFonts.lexend(fontSize: 24, fontWeight: FontWeight.w700, color: Colors.black),
      headlineMedium: GoogleFonts.lexend(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black),
      headlineSmall: GoogleFonts.lexend(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black),
      titleLarge: GoogleFonts.lexend(fontSize: 24, fontWeight: FontWeight.w400, color: Colors.black),
      titleMedium: GoogleFonts.lexend(fontSize: 20, fontWeight: FontWeight.w400, color: Colors.black),
      titleSmall: GoogleFonts.lexend(fontSize: 12, fontWeight: FontWeight.w400, color: Colors.black),
      labelLarge: GoogleFonts.lexend(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black),
      labelMedium: GoogleFonts.lexend(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.black),
      labelSmall: GoogleFonts.lexend(fontSize: 12, fontWeight: FontWeight.w400, color: Colors.black),
      bodyLarge: GoogleFonts.lexend(fontSize: 16, fontWeight: FontWeight.w300, color: Colors.black),
      bodyMedium: GoogleFonts.lexend(fontSize: 14, fontWeight: FontWeight.w300, color: Colors.black),
      bodySmall: GoogleFonts.lexend(fontSize: 10, fontWeight: FontWeight.w300, color: Colors.black),
    );
  }

  static ThemeData lightTheme(bool useMaterial3) {
    return ThemeData(
      textTheme: textTheme,
      useMaterial3: useMaterial3,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.white,
      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        foregroundColor: Colors.black,
        actionsPadding: EdgeInsets.symmetric(horizontal: 16),
        titleTextStyle: GoogleFonts.lexend(fontSize: 28, fontWeight: FontWeight.w700, color: Colors.white),
        iconTheme: IconThemeData(color: Colors.white, size: 33),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      iconTheme: IconThemeData(color: Colors.black, size: 33),
      colorScheme: ColorScheme.light(
        primary: AppColors.framePurple,
        secondary: AppColors.limeGreen,
        surface: AppColors.white,
        error: AppColors.errorRed.withValues(alpha: 0.5),
        onPrimary: AppColors.white,
        onSecondary: AppColors.white,
        onSurface: AppColors.white,
        onError: AppColors.errorRed.withValues(alpha: 0.5),
      ),
      tabBarTheme: TabBarThemeData(
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(color: AppColors.framePurple, width: 2),
        ),
        labelColor: AppColors.framePurple,
        unselectedLabelColor: AppColors.white,
        labelStyle: textTheme.labelMedium,
        unselectedLabelStyle: textTheme.labelMedium,
      ),
      toggleButtonsTheme: ToggleButtonsThemeData(
        color: AppColors.black,
        selectedColor: AppColors.framePurple,
        fillColor: AppColors.black,
        borderRadius: BorderRadius.circular(8),
        constraints: const BoxConstraints(minHeight: 40, minWidth: 40),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.all(AppColors.black),
        trackColor: WidgetStateProperty.all(AppColors.slateGrey),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.black,
        indicatorColor: Colors.transparent,
        labelTextStyle: WidgetStateProperty.all(
          textTheme.displayLarge,
        ),
      ),
      listTileTheme: ListTileThemeData(
        iconColor: AppColors.framePurple,
        textColor: Colors.black,
        titleTextStyle: textTheme.displaySmall,
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.all(AppColors.white),
        checkColor: WidgetStateProperty.all(AppColors.framePurple),
      ),
      dividerTheme: DividerThemeData(color: AppColors.slateGrey),
      splashColor: Colors.transparent,
      cardTheme: CardThemeData(
        color: AppColors.white,
      ),
      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      badgeTheme: BadgeThemeData(
        backgroundColor: AppColors.framePurple,
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
        primary: AppColors.framePurple,
        secondary: AppColors.limeGreen,
        surface: AppColors.lightPink,
        error: AppColors.framePurple.withValues(alpha: 0.5),
        onPrimary: AppColors.white,
        onSecondary: AppColors.white,
        onSurface: AppColors.white,
        onError: AppColors.framePurple.withValues(alpha: 0.5),
      ),
      tabBarTheme: TabBarThemeData(
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(color: AppColors.framePurple, width: 2),
        ),
        labelColor: AppColors.framePurple,
        unselectedLabelColor: AppColors.white,
        labelStyle: textTheme.labelMedium,
        unselectedLabelStyle: textTheme.labelMedium,
      ),
      toggleButtonsTheme: ToggleButtonsThemeData(
        color: AppColors.slateGrey,
        selectedColor: AppColors.framePurple,
        fillColor: AppColors.slateGrey,
        borderRadius: BorderRadius.circular(8),
        constraints: const BoxConstraints(minHeight: 40, minWidth: 40),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.all(AppColors.black),
        trackColor: WidgetStateProperty.all(AppColors.slateGrey),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.black,
        indicatorColor: Colors.transparent,
        labelTextStyle: WidgetStateProperty.all(
          textTheme.displayLarge,
        ),
      ),
      listTileTheme: ListTileThemeData(
        iconColor: AppColors.limeGreen,
        textColor: Colors.black,
        titleTextStyle: textTheme.displaySmall,
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.all(AppColors.white),
        checkColor: WidgetStateProperty.all(AppColors.framePurple),
      ),
      dividerTheme: DividerThemeData(color: AppColors.slateGrey),
      splashColor: Colors.transparent,
      cardTheme: CardThemeData(
        color: AppColors.white,
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
  static Color white = HexColor('#FFFFFF');
  static Color limeGreen = HexColor('#D5ED8B');
  static Color framePurple = HexColor('#AC77FF');
  static Color lightPink = HexColor('#FCC2FB');
  static Color slateGrey = HexColor('#333333');
  static Color errorRed = HexColor('#FF4C4C');
  static Color grey = HexColor('#F3EEE6');
}

List<BoxShadow> getBoxShadow(BuildContext context) {
  return [
    BoxShadow(color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.16), blurStyle: BlurStyle.normal, offset: const Offset(0, 1), blurRadius: 3),
  ];
}
