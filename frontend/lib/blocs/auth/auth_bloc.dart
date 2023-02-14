import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:frontend/blocs/blocs.dart';
import 'package:frontend/configs/configs.dart';
import 'package:http/http.dart';

import '../../constants/constants.dart';
import '../../models/models.dart';
import '../../repositories/repositories.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  final SigninBloc _signinBloc;
  final SignoutBloc _signoutBloc;
  late StreamSubscription _signinSubscription;
  late StreamSubscription _signoutSubscription;

  AuthBloc({
    required AuthRepository authRepository,
    required SigninBloc signinBloc,
    required SignoutBloc signoutBloc,
  })  : _authRepository = authRepository,
        _signinBloc = signinBloc,
        _signoutBloc = signoutBloc,
        super(AuthState.unknown()) {
    on<AuthStarted>(_onAuthStarted);
    on<AuthChanged>(_onAuthChanged);

    _signinSubscription = _signinBloc.stream.listen((state) {
      if (state is SigninLoaded) {
        // Store token
        AppCache.setString(key: TOKEN_KEY, value: state.token);
        // Change status
        add(AuthChanged(user: state.user));
      }
    });

    _signoutSubscription = _signoutBloc.stream.listen((state) async {
      if (state is SignoutLoaded) {
        // Remove token
        await AppCache.removeString(TOKEN_KEY);
        // Change status
        add(AuthChanged());
      }
    });
  }

  FutureOr<void> _onAuthStarted(
    AuthStarted event,
    Emitter<AuthState> emit,
  ) async {
    final token = AppCache.getString(TOKEN_KEY);

    if (token != "") {
      try {
        Response res = await _authRepository.verifyToken(token);
        final json = jsonDecode(res.body);

        if (res.statusCode == 200) {
          emit(
            AuthState.authenticated(
              user: User.fromJson(jsonEncode(json['user'])),
            ),
          );
        } else {
          emit(AuthState.unauthenticated());
        }
      } catch (e) {
        emit(AuthState.unauthenticated());
      }
    } else {
      emit(AuthState.unauthenticated());
    }
  }

  FutureOr<void> _onAuthChanged(
    AuthChanged event,
    Emitter<AuthState> emit,
  ) {
    event.user == null
        ? emit(AuthState.unauthenticated())
        : emit(AuthState.authenticated(user: event.user!));
  }

  @override
  Future<void> close() {
    _signinSubscription.cancel();
    _signoutSubscription.cancel();
    return super.close();
  }
}
