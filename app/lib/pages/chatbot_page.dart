import 'package:dpg_app/components/chatbot/chat_app_bar.dart';
import 'package:dpg_app/components/chatbot/chat_bubble.dart';
import 'package:dpg_app/components/chatbot/chat_controller.dart';
import 'package:dpg_app/components/chatbot/typing_indicator.dart';
import 'package:dpg_app/services/rasa_chat_services.dart';
import 'package:flutter/material.dart';

class ChatbotPage extends StatefulWidget {
  const ChatbotPage({super.key});

  @override
  State<ChatbotPage> createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage> {
  final RasaChatService _rasaService = RasaChatService();
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<Map<String, dynamic>> _messages = [];
  bool _isTyping = false;

  // Dropdown State
  List<String> dropdownItems = [];
  String? selectedDropdownValue;

  @override
  void initState() {
    super.initState();

    // Add welcome message
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _messages.add({
          "text": "Hello! How can I help you today? 😊",
          "isUser": false,
          "buttons": [],
          "dropdownItems": [],
          "selectedDropdownValue": null
        });
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _sendMessage(String input) async {
    if (input.trim().isEmpty) return;

    setState(() {
      _messages.add({
        "text": input,
        "isUser": true,
        "buttons": [],
        "dropdownItems": [],
        "selectedDropdownValue": null
      });
      _isTyping = true;
    });
    _controller.clear();

    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

    try {
      await Future.delayed(Duration(milliseconds: 500));

      final responses = await _rasaService.sendMessage(input);

      setState(() {
        _isTyping = false;
      });

      for (var res in responses) {
        print("Bot response text: ${res['text']}");
        print("Dropdown data: ${res['dropdown']}");

        await Future.delayed(Duration(milliseconds: 300));

        List<String> dropdownList = [];
        String? dropdownValue;

        // Extract dropdown from Rasa response
        if (res['dropdown'] != null) {
          if (res['dropdown'] is List) {
            dropdownList = List<String>.from(res['dropdown']);
          } else if (res['dropdown'] is Map &&
              res['dropdown'].containsKey('dropdown')) {
            dropdownList = List<String>.from(res['dropdown']['dropdown']);
          }
        }

        String botText = res['text']?.trim() ?? '';
        List<dynamic> botButtons = res['buttons'] ?? [];

        setState(() {
          // If text is empty but dropdown/buttons exist → merge into last bot message
          if (botText.isEmpty && (dropdownList.isNotEmpty || botButtons.isNotEmpty)) {
            if (_messages.isNotEmpty && !_messages.last['isUser']) {
              if (dropdownList.isNotEmpty) {
                _messages.last['dropdownItems'] = dropdownList;
                _messages.last['selectedDropdownValue'] = dropdownValue;
              }
              if (botButtons.isNotEmpty) {
                _messages.last['buttons'] = botButtons;
              }
            }
          } else {
            // Normal case: create a new bot message
            _messages.add({
              "text": botText,
              "isUser": false,
              "buttons": botButtons,
              "dropdownItems": dropdownList,
              "selectedDropdownValue": dropdownValue
            });
          }
        });

        WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
      }
    } catch (e) {
      setState(() {
        _isTyping = false;
        _messages.add({
          "text": "Sorry, I'm having trouble connecting right now. Please try again! 🔄",
          "isUser": false,
          "buttons": [],
          "dropdownItems": [],
          "selectedDropdownValue": null
        });
      });

      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    }
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Color(0xFF000000) : Color(0xFFFAFAFA),
      appBar: ChatAppBar(
        isTyping: _isTyping,
        onBack: () => Navigator.of(context).pop(),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.symmetric(vertical: 16),
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (_isTyping && index == _messages.length) {
                  return const TypingIndicator();
                }

                final message = _messages[index];
                return ChatBubble(
                  text: message['text'] ?? '',
                  isUser: message['isUser'] ?? false,
                  buttons: message['buttons'] ?? [],
                  dropdownItems:
                      List<String>.from(message['dropdownItems'] ?? []),
                  selectedValue: message['selectedDropdownValue'],
                  onButtonPressed: _sendMessage,
                );
              },
            ),
          ),

          // Chat input controller
          ChatController(onSend: _sendMessage),
        ],
      ),
    );
  }
}
