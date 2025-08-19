import 'package:dpg_app/components/home/bottom_nav_bar.dart';
import 'package:dpg_app/components/home/curved_slider.dart';
import 'package:dpg_app/components/home/my_count_button.dart';
import 'package:dpg_app/pages/chatbot_page.dart';
import 'package:dpg_app/components/home/my_button.dart'; 
import 'package:flutter/material.dart';

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
      // Add navigation logic here based on index
    });
  }

  void Chatbot(BuildContext context) async {
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
        title: Text(
          "Home", 
          style: TextStyle(
            color: Colors.grey,
          ),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.grey),

        actions: [
          Container(
            margin: EdgeInsets.only(right: 30),
            child: IconButton(
              icon: Icon(
                Icons.notifications_on_rounded,
              ),
              onPressed: () {},
            ),
          ),
        ],

      ),
      body: Column(
        children: [
          //Spacer pushes buttons at bottom

          //Curved Slider
          const CurvedSlider(),

          // 3 buttons in a row

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: MyCountButton(
                    count: 12, 
                    label: 'Total Grievance', 
                    color: Color.fromARGB(255, 248, 174, 13),
                    onTap: () {},
                  ),
                ),

                const SizedBox(width: 10),
            
                Expanded(
                  child: MyCountButton(
                    count: 5, 
                    label: 'Closed Grievance',
                    color: Color.fromARGB(255, 40, 133, 43), 
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

          //Two buttons in a line at the bottom
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: MyButton(
                    text: "Button", 
                    onTap: () {}
                  ),
                ),
            
                SizedBox(width: 16,),
            
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
      // 👇 Bottom Navigation Bar here
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex, 
        onItemTapped: onItemTapped,
      ),
    );
  }
}
