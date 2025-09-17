import 'package:contact_list/data/models/contact_model.dart';

abstract class ContactState {}

class ContactInitial extends ContactState {}

class ContactLoading extends ContactState {}

class ContactLoaded extends ContactState {
  final List<Contact> contacts; // danh sách hiển thị (đã filter)
  final List<Contact> allContacts; // danh sách gốc (full)
  final String sortState;

  ContactLoaded(
    this.contacts, {
    required this.allContacts,
    this.sortState = 'lastSeen',
  });
}

class ContactError extends ContactState {
  final String message;
  ContactError(this.message);
}
