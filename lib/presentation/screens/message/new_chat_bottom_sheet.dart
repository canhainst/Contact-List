import 'package:contact_list/core/utils/format_string.dart';
import 'package:contact_list/data/models/contact_model.dart';
import 'package:contact_list/logic/message/message_bloc.dart';
import 'package:contact_list/logic/message/message_event.dart';
import 'package:contact_list/presentation/screens/message/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:contact_list/core/config/languages.dart';
import 'package:contact_list/logic/contact/contact_bloc.dart';
import 'package:contact_list/logic/contact/contact_event.dart';
import 'package:contact_list/logic/contact/contact_state.dart';

void showChatBottomSheet(BuildContext context) {
  final searchBarController = TextEditingController();
  var localizations = AppLocalizations.of(context)!;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) {
      final height = MediaQuery.of(context).size.height * 0.9;
      return SizedBox(
        height: height,
        child: _NewCallContent(
          searchBarController: searchBarController,
          localizations: localizations,
        ),
      );
    },
  ).whenComplete(() {
    context.read<ContactBloc>().add(LoadContacts());
    context.read<MessageBloc>().add(LoadConversations());
  });
}

class _NewCallContent extends StatefulWidget {
  final TextEditingController searchBarController;
  final AppLocalizations localizations;

  const _NewCallContent({
    required this.searchBarController,
    required this.localizations,
  });

  @override
  State<_NewCallContent> createState() => _NewCallContentState();
}

class _NewCallContentState extends State<_NewCallContent> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Text(
                  widget.localizations.translate("calls_screen.new_call.close"),
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                widget.localizations.translate(
                  "messages_screen.new_chat.title",
                ),

                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const Spacer(),
              const SizedBox(width: 50),
            ],
          ),
        ),

        // Search bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            height: 42,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(20),
            ),
            child: BlocBuilder<ContactBloc, ContactState>(
              builder: (context, state) {
                return TextField(
                  controller: widget.searchBarController,
                  onChanged: (value) {
                    final currentSort = state is ContactLoaded
                        ? state.sortState
                        : 'lastSeen';

                    context.read<ContactBloc>().add(
                      SortContactsWithQuery(sortBy: currentSort, query: value),
                    );
                  },
                  decoration: InputDecoration(
                    hintText: widget.localizations.translate(
                      'contact_screen.search',
                    ),
                    prefixIcon: const Icon(Icons.search),
                    border: InputBorder.none,
                  ),
                );
              },
            ),
          ),
        ),

        const SizedBox(height: 16),

        const Divider(height: 1),

        Expanded(
          child: BlocBuilder<ContactBloc, ContactState>(
            builder: (context, state) {
              if (state is ContactLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is ContactError) {
                return Center(child: Text(state.message));
              } else if (state is ContactLoaded) {
                final contacts = state.contacts;
                return ListView.builder(
                  itemCount: contacts.length,
                  itemBuilder: (context, index) {
                    final contact = contacts[index];

                    return ContactTile(contact: contact, onChanged: (val) {});
                  },
                );
              }
              return const SizedBox();
            },
          ),
        ),
      ],
    );
  }
}

class ContactTile extends StatelessWidget {
  final Contact contact;
  final ValueChanged<bool> onChanged;
  const ContactTile({
    super.key,
    required this.contact,
    required this.onChanged,
  });
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.blueGrey,
        backgroundImage: contact.avatarUrl != null
            ? NetworkImage(contact.avatarUrl!)
            : null,
        child: contact.avatarUrl == null
            ? Text(
                contact.name[0].toUpperCase(),
                style: const TextStyle(color: Colors.white),
              )
            : null,
      ),
      title: Text(contact.name),
      subtitle: Text(
        formatLastSeen(context, contact.lastSeen),
        style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BlocProvider.value(
              value: context.read<MessageBloc>(),
              child: ChatScreen(contact: contact),
            ),
          ),
        );
      },
    );
  }
}
