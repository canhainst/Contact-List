import 'package:contact_list/core/config/languages.dart';
import 'package:contact_list/core/theme/app_text_styles.dart';
import 'package:contact_list/core/utils/format_datetime.dart';
import 'package:contact_list/core/utils/url_launcher.dart';
import 'package:contact_list/logic/call/call_bloc.dart';
import 'package:contact_list/logic/call/call_event.dart';
import 'package:contact_list/logic/call/call_state.dart';
import 'package:contact_list/presentation/screens/calls/new_call_bottom_sheet.dart';
import 'package:contact_list/presentation/screens/contact/contact_detail_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CallsScreen extends StatefulWidget {
  const CallsScreen({super.key});

  @override
  State<CallsScreen> createState() => _CallsScreenState();
}

class _CallsScreenState extends State<CallsScreen> {
  int _selectedIndex = 0;
  bool editState = false;

  final Set<int> _selectedCalls = {};

  @override
  void initState() {
    super.initState();
    context.read<CallBloc>().add(LoadCalls());
  }

  @override
  Widget build(BuildContext context) {
    var localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        centerTitle: true,
        title: CupertinoSegmentedControl<int>(
          groupValue: _selectedIndex,
          selectedColor: Colors.blueGrey,
          unselectedColor: Colors.white,
          borderColor: Colors.blueGrey,
          pressedColor: Colors.blueGrey.withOpacity(0.2),
          children: {
            0: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                localizations.translate('calls_screen.all'),
                style: AppTextStyles.body.copyWith(
                  color: _selectedIndex == 0 ? Colors.white : Colors.black,
                ),
              ),
            ),
            1: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                localizations.translate('calls_screen.missed'),
                style: AppTextStyles.body.copyWith(
                  color: _selectedIndex == 1 ? Colors.white : Colors.black,
                ),
              ),
            ),
          },
          onValueChanged: (int value) {
            setState(() {
              _selectedIndex = value;
            });
          },
        ),
        leading: IconButton(
          onPressed: () {
            showNewCallBottomSheet(context);
          },
          icon: Icon(Icons.add_call, size: 24, color: theme.iconTheme.color),
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                editState = !editState;
                if (!editState) _selectedCalls.clear();
              });
            },
            child: Text(
              localizations.translate(
                'calls_screen.${editState ? 'cancel' : 'edit'}',
              ),
              style: TextStyle(
                color: theme.primaryColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: BlocBuilder<CallBloc, CallState>(
        builder: (context, state) {
          if (state is CallLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CallError) {
            return Center(child: Text(state.message));
          } else if (state is CallLoaded) {
            final filteredCalls = state.calls.where((c) {
              if (_selectedIndex == 0) return true;
              return c.isMissed;
            }).toList();

            if (filteredCalls.isEmpty) {
              return Center(
                child: Text(localizations.translate('calls_screen.no_calls')),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                context.read<CallBloc>().add(LoadCalls());
              },
              child: ListView.separated(
                itemCount: filteredCalls.length,
                separatorBuilder: (_, __) => Divider(height: 1),
                itemBuilder: (context, index) {
                  final call = filteredCalls[index];
                  return ListTile(
                    leading: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        editState
                            ? Padding(
                                padding: EdgeInsetsGeometry.only(right: 8),
                                child: Checkbox(
                                  shape: CircleBorder(),
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  value: _selectedCalls.contains(index),
                                  onChanged: (val) {
                                    setState(() {
                                      if (val == true) {
                                        _selectedCalls.add(index);
                                      } else {
                                        _selectedCalls.remove(index);
                                      }
                                    });
                                  },
                                ),
                              )
                            : SizedBox(),
                        CircleAvatar(
                          backgroundColor: Colors.blueGrey,
                          backgroundImage: call.contact.avatarUrl != null
                              ? NetworkImage(call.contact.avatarUrl!)
                              : null,
                          child: call.contact.avatarUrl == null
                              ? Text(
                                  call.contact.name[0].toUpperCase(),
                                  style: const TextStyle(color: Colors.white),
                                )
                              : null,
                        ),
                      ],
                    ),
                    title: Text(
                      call.contact.name,
                      style: AppTextStyles.body.copyWith(
                        fontWeight: FontWeight.bold,
                        color: call.isMissed
                            ? Colors.redAccent
                            : theme.textTheme.bodyLarge!.color,
                      ),
                    ),
                    subtitle: Text(
                      call.isMissed
                          ? localizations.translate('calls_screen.missed')
                          : formatDuration(call.duration),
                      style: TextStyle(
                        color: call.isMissed ? Colors.red : Colors.grey,
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(formatDateTime(call.startTime)),
                        SizedBox(width: 8),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ContactDetailScreen(contact: call.contact),
                              ),
                            );
                          },
                          child: Icon(Icons.info, color: Colors.blueGrey),
                        ),
                      ],
                    ),
                    onTap: () {
                      if (!editState) {
                        callPhone(call.contact.phone);
                      } else {
                        setState(() {
                          if (_selectedCalls.contains(index)) {
                            _selectedCalls.remove(index);
                          } else {
                            _selectedCalls.add(index);
                          }
                        });
                      }
                    },
                  );
                },
              ),
            );
          }
          return const SizedBox.shrink();
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
                  final bloc = context.read<CallBloc>();

                  for (var index in _selectedCalls) {
                    final callToDelete =
                        (bloc.state as CallLoaded).calls[index];
                    bloc.add(DeleteCall(callToDelete));
                  }

                  setState(() {
                    editState = false;
                    _selectedCalls.clear();
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
