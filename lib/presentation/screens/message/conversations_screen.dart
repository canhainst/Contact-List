import 'package:contact_list/core/config/languages.dart';
import 'package:contact_list/data/models/contact_model.dart';
import 'package:contact_list/data/models/message_model.dart';
import 'package:contact_list/logic/message/message_bloc.dart';
import 'package:contact_list/logic/message/message_event.dart';
import 'package:contact_list/logic/message/message_state.dart';
import 'package:contact_list/main.dart';
import 'package:contact_list/presentation/screens/message/chat_screen.dart';
import 'package:contact_list/presentation/screens/message/new_chat_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConversationsScreen extends StatefulWidget {
  const ConversationsScreen({super.key});

  @override
  State<ConversationsScreen> createState() => _ConversationsScreenState();
}

class _ConversationsScreenState extends State<ConversationsScreen>
    with RouteAware {
  bool editState = false;

  final Set<int> _selectedConversations = {};
  final _searchBarController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<MessageBloc>().add(LoadConversations());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route is PageRoute) {
      routeObserver.subscribe(this, route);
    }
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    context.read<MessageBloc>().add(LoadConversations());
  }

  @override
  Widget build(BuildContext context) {
    var localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        title: Column(
          children: [
            Row(
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      editState = !editState;
                      if (!editState) _selectedConversations.clear();
                    });
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(40, 40),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    localizations.translate(
                      'messages_screen.${editState ? 'cancel' : 'edit'}',
                    ),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                Expanded(
                  child: Text(
                    localizations.translate('nav_bar.chats'),
                    style:
                        (theme.textTheme.titleLarge ??
                                theme.textTheme.headlineSmall)
                            ?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                    textAlign: TextAlign.center,
                  ),
                ),

                GestureDetector(
                  onTap: () {
                    showChatBottomSheet(context);
                  },
                  child: SizedBox(
                    width: 40,
                    child: Icon(
                      Icons.border_color,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 10),

            Container(
              height: 42,
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: BlocBuilder<MessageBloc, MessageState>(
                builder: (context, state) {
                  return TextField(
                    controller: _searchBarController,
                    style: TextStyle(color: theme.textTheme.bodyLarge!.color),

                    onChanged: (value) {
                      context.read<MessageBloc>().add(
                        SearchConversations(value),
                      );
                    },
                    decoration: InputDecoration(
                      hintText: localizations.translate(
                        'messages_screen.search',
                      ),
                      hintStyle: TextStyle(color: theme.hintColor),
                      prefixIcon: Icon(
                        Icons.search,
                        color: theme.iconTheme.color,
                      ),
                      border: InputBorder.none,
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
        elevation: 1,
        toolbarHeight: 100,
      ),
      body: BlocBuilder<MessageBloc, MessageState>(
        builder: (context, state) {
          if (state is MessageLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ConversationsLoaded) {
            final conversations = state.filtered;

            return ListView.builder(
              itemCount: conversations.length,
              itemBuilder: (context, index) {
                final entry = conversations.entries.elementAt(index);
                final Contact contact = entry.key;
                final List<Message> convo = entry.value;
                final Message lastMsg = convo.isNotEmpty
                    ? convo.last
                    : Message(content: '', time: DateTime(0), contact: null);

                return ListTile(
                  leading: editState
                      ? Checkbox(
                          shape: CircleBorder(),
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          value: _selectedConversations.contains(index),
                          onChanged: (val) {
                            setState(() {
                              if (val == true) {
                                _selectedConversations.add(index);
                              } else {
                                _selectedConversations.remove(index);
                              }
                            });
                          },
                        )
                      : CircleAvatar(
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
                  title: Text(
                    contact.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    lastMsg.content,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Text(
                    "${lastMsg.time.hour}:${lastMsg.time.minute.toString().padLeft(2, '0')}",
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  onTap: () {
                    if (editState) {
                      setState(() {
                        if (_selectedConversations.contains(index)) {
                          _selectedConversations.remove(index);
                        } else {
                          _selectedConversations.add(index);
                        }
                      });
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BlocProvider.value(
                            value: context.read<MessageBloc>(),
                            child: ChatScreen(contact: contact),
                          ),
                        ),
                      );
                    }
                  },
                );
              },
            );
          } else if (state is MessageError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox();
        },
      ),
      floatingActionButton: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation) {
          return ScaleTransition(scale: animation, child: child);
        },
        child: editState
            ? ElevatedButton(
                onPressed: () {
                  final bloc = context.read<MessageBloc>();

                  for (final index in _selectedConversations) {
                    final contact =
                        (context.read<MessageBloc>().state
                                as ConversationsLoaded)
                            .conversations
                            .keys
                            .elementAt(index);

                    bloc.add(DeleteConversation(contact));
                  }

                  setState(() {
                    editState = false;
                    _selectedConversations.clear();
                  });
                },
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(16),
                  backgroundColor: Colors.redAccent,
                ),
                child: const Icon(Icons.delete, color: Colors.white, size: 24),
              )
            : const SizedBox(),
      ),
    );
  }
}
