import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CallsScreen extends StatefulWidget {
  const CallsScreen({super.key});

  @override
  State<CallsScreen> createState() => _CallsScreenState();
}

class _CallsScreenState extends State<CallsScreen> {
  int _selectedIndex = 0;
  bool editState = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        elevation: 0,
        centerTitle: true,
        title: CupertinoSegmentedControl<int>(
          groupValue: _selectedIndex,
          selectedColor: Colors.blueGrey,
          unselectedColor: Colors.white,
          borderColor: Colors.blueGrey,
          pressedColor: Colors.blueGrey.withOpacity(0.2),
          children: const {
            0: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text("All", style: TextStyle(fontWeight: FontWeight.w600)),
            ),
            1: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Missed",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          },
          onValueChanged: (int value) {
            setState(() {
              _selectedIndex = value;
            });
          },
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: Text(
              "Edit",
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: Text(
          "Selected Tab: ${_selectedIndex + 1}",
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
