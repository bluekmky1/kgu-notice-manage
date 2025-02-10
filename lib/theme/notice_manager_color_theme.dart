import 'package:flutter/material.dart';

import 'notice_manager_colors.dart';

@immutable
class NoticeManagerColorTheme extends ThemeExtension<NoticeManagerColorTheme> {
  const NoticeManagerColorTheme({
    required this.background,
    required this.main,
    required this.editing,
    required this.error,
    required this.white,
    required this.gray40,
    required this.black,
  });

  static const NoticeManagerColorTheme light = NoticeManagerColorTheme(
    background: NoticeManagerColors.background,
    main: NoticeManagerColors.main,
    editing: NoticeManagerColors.editing,
    error: NoticeManagerColors.error,
    white: NoticeManagerColors.white,
    gray40: NoticeManagerColors.gray40,
    black: NoticeManagerColors.black,
  );

  static const NoticeManagerColorTheme dark = light;

  final Color background;
  final Color main;
  final Color editing;
  final Color black;
  final Color gray40;
  final Color white;
  final Color error;

  @override
  NoticeManagerColorTheme lerp(NoticeManagerColorTheme? other, double t) {
    if (other is! NoticeManagerColorTheme) {
      return this;
    }
    return NoticeManagerColorTheme(
      background: Color.lerp(background, other.background, t)!,
      main: Color.lerp(main, other.main, t)!,
      editing: Color.lerp(editing, other.editing, t)!,
      error: Color.lerp(error, other.error, t)!,
      white: Color.lerp(white, other.white, t)!,
      black: Color.lerp(black, other.black, t)!,
      gray40: Color.lerp(gray40, other.gray40, t)!,
    );
  }

  @override
  NoticeManagerColorTheme copyWith({
    Color? background,
    Color? main,
    Color? editing,
    Color? error,
    Color? white,
    Color? black,
    Color? gray40,
  }) =>
      NoticeManagerColorTheme(
        background: background ?? this.background,
        main: main ?? this.main,
        editing: editing ?? this.editing,
        error: error ?? this.error,
        white: white ?? this.white,
        black: black ?? this.black,
        gray40: gray40 ?? this.gray40,
      );
}
