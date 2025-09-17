import 'package:contact_list/data/repositories/user_repository.dart';
import 'package:contact_list/logic/auth/auth_event.dart';
import 'package:contact_list/logic/auth/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserRepository userRepository;

  AuthBloc(this.userRepository) : super(AuthInitial()) {
    on<LoginRequested>((event, emit) async {
      emit(AuthLoading());
      final user = await userRepository.login(event.username, event.password);
      if (user != null) {
        emit(Authenticated(user));
      } else {
        emit(Unauthenticated(message: "Invalid credentials"));
      }
    });

    on<LogoutRequested>((event, emit) {
      emit(Unauthenticated());
    });
  }
}
