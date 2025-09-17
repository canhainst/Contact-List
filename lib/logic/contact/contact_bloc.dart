import 'package:contact_list/data/repositories/user_repository.dart';
import 'package:contact_list/logic/contact/contact_event.dart';
import 'package:contact_list/logic/contact/contact_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContactBloc extends Bloc<ContactEvent, ContactState> {
  final UserRepository userRepository;

  ContactBloc(this.userRepository) : super(ContactInitial()) {
    on<LoadContacts>((event, emit) async {
      emit(ContactLoading());
      try {
        final contacts = await userRepository.fetchContacts();
        emit(ContactLoaded(contacts, allContacts: contacts));
      } catch (_) {
        emit(ContactError("Failed to load contacts"));
      }
    });

    on<SortContactsWithQuery>((event, emit) async {
      emit(ContactLoading());
      try {
        final contacts = await userRepository.fetchContacts(
          sortBy: event.sortBy,
          query: event.query,
        );

        emit(ContactLoaded(contacts, allContacts: contacts));
      } catch (_) {
        emit(ContactError("Failed to load contacts"));
      }
    });
  }
}
