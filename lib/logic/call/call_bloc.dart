import 'package:contact_list/data/models/call_model.dart';
import 'package:contact_list/data/repositories/user_repository.dart';
import 'package:contact_list/logic/call/call_event.dart';
import 'package:contact_list/logic/call/call_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CallBloc extends Bloc<CallEvent, CallState> {
  final UserRepository userRepository;

  CallBloc(this.userRepository) : super(CallInitial()) {
    on<LoadCalls>((event, emit) async {
      emit(CallLoading());
      try {
        final calls = await userRepository.fetchCalls();
        emit(CallLoaded(calls));
      } catch (e) {
        emit(CallError('Failed to load calls: $e'));
      }
    });

    on<DeleteCall>((event, emit) async {
      if (state is CallLoaded) {
        final currentCalls = List<Call>.from((state as CallLoaded).calls);
        currentCalls.remove(event.call);
        emit(CallLoaded(currentCalls));
      }
    });
  }
}
