import 'package:dpg_app/components/home/bottom_nav_bar.dart';
import 'package:dpg_app/components/home/curved_slider.dart';
import 'package:dpg_app/components/home/my_count_button.dart';
import 'package:dpg_app/pages/chatbot_page.dart';
import 'package:dpg_app/components/home/my_button.dart'; 
import 'package:flutter/material.dart';
import 'settings.dart'; // 👈 import your SettingsPage

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 3) { // 👈 index of Settings in BottomNavBar
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SettingsPage()),
      );
    }
  }

  void Chatbot(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatbotPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          "Home", 
          style: TextStyle(color: Colors.grey),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.grey),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 30),
            child: IconButton(
              icon: const Icon(Icons.notifications_on_rounded),
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          const CurvedSlider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: MyCountButton(
                    count: 12, 
                    label: 'Total Grievance', 
                    color: const Color.fromARGB(255, 248, 174, 13),
                    onTap: () {},
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: MyCountButton(
                    count: 5, 
                    label: 'Closed Grievance',
                    color: const Color.fromARGB(255, 40, 133, 43), 
                    onTap: () {},
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: MyCountButton(
                    count: 7, 
                    label: 'Active Grievance', 
                    color: const Color.fromARGB(255, 186, 55, 46),
                    onTap: () {},
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: MyButton(
                    text: "Button", 
                    onTap: () {},
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: MyButton(
                    text: "Chatbot", 
                    onTap: () => Chatbot(context),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex, 
        onItemTapped: onItemTapped,
      ),
    );
  }
}
