import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:frontend/configs/configs.dart';
import 'package:frontend/models/models.dart';

import '../../constants/constants.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(ThemeState(themeData: darkThemeData())) {
    on<LoadTheme>(_onLoadTheme);
    on<UpdateTheme>(_onUpdateTheme);
  }

  Future<FutureOr<void>> _onUpdateTheme(
    UpdateTheme event,
    Emitter<ThemeState> emit,
  ) async {
    if (event.appTheme == AppTheme.lightTheme) {
      AppCache.setString(key: THEME_KEY, value: "light");
      emit(ThemeState(themeData: lightThemeData()));
    } else {
      AppCache.setString(key: THEME_KEY, value: "dark");
      emit(ThemeState(themeData: darkThemeData()));
    }
  }

  FutureOr<void> _onLoadTheme(
    LoadTheme event,
    Emitter<ThemeState> emit,
  ) async {
    String currTheme = AppCache.getString(THEME_KEY);

    print('Theme: $currTheme');

    if (currTheme != '') {
      if (currTheme == 'light') {
        emit(ThemeState(themeData: lightThemeData()));
      } else {
        emit(ThemeState(themeData: darkThemeData()));
      }
    }
  }
}
