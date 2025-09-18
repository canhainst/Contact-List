import 'package:contact_list/data/models/contact_model.dart';
import 'package:contact_list/data/models/message_model.dart';
import 'package:contact_list/data/repositories/user_repository.dart';
import 'package:contact_list/logic/message/message_event.dart';
import 'package:contact_list/logic/message/message_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  final UserRepository userRepository;

  MessageBloc(this.userRepository) : super(MessageInitial()) {
    /// Load all
    on<LoadConversations>((event, emit) async {
      emit(MessageLoading());
      try {
        final conversations = await userRepository.fetchAllConversations();
        emit(ConversationsLoaded(conversations));
      } catch (e) {
        emit(MessageError("Failed to load conversations"));
      }
    });

    /// Load 1
    on<LoadMessagesWithContact>((event, emit) async {
      emit(MessageLoading());
      try {
        final messages = await userRepository.fetchMessagesWith(event.contact);
        emit(MessagesLoaded(messages));
      } catch (e) {
        emit(
          MessageError("Failed to load messages with ${event.contact.name}"),
        );
      }
    });

    /// Search
    on<SearchConversations>((event, emit) async {
      if (state is ConversationsLoaded) {
        final current = state as ConversationsLoaded;

        final query = event.query.toLowerCase();

        final filtered = current.conversations.entries
            .where((entry) {
              return entry.key.name.toLowerCase().contains(query);
            })
            .fold<Map<Contact, List<Message>>>({}, (map, entry) {
              map[entry.key] = entry.value;
              return map;
            });

        emit(ConversationsLoaded(current.conversations, filtered: filtered));
      }
    });

    /// Send mess
    on<SendMessage>((event, emit) async {
      if (state is MessagesLoaded) {
        final current = (state as MessagesLoaded).messages;

        final newMessage = Message(
          content: event.content,
          time: DateTime.now(),
          contact: event.contact, // null = mình gửi, có contact = họ gửi
        );

        final updated = List<Message>.from(current)..add(newMessage);

        emit(MessagesLoaded(updated));
      }
    });

    /// Delete conversation
    on<DeleteConversation>((event, emit) async {
      if (state is ConversationsLoaded) {
        final current = Map<Contact, List<Message>>.from(
          (state as ConversationsLoaded).conversations,
        );

        current.remove(event.contact);

        emit(ConversationsLoaded(current));
      }
    });
  }
}
