import 'package:dpg_app/components/chatbot/custom_dropdown.dart';
import 'package:dpg_app/components/chatbot/custom_attachment.dart'; 
import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String text;
  final bool isUser;
  final List<dynamic> buttons;
  final Function(String) onButtonPressed;
  final List<String> dropdownItems;
  final String? selectedValue;
  final ValueChanged<String?>? onDropdownChanged;

  const ChatBubble({
    super.key,
    required this.text,
    required this.isUser,
    this.buttons = const [],
    required this.onButtonPressed,
    this.dropdownItems = const [],
    this.selectedValue,
    this.onDropdownChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      child: Column(
        crossAxisAlignment:
            isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          // Chat bubble
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.75,
            ),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              gradient: isUser
                  ? LinearGradient(
                      colors: [
                        Color(0xFF667eea),
                        Color(0xFF764ba2),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : null,
              color: isUser
                  ? null
                  : isDark
                      ? Color(0xFF2C2C2E)
                      : Color(0xFFF2F2F7),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
                bottomLeft: isUser ? Radius.circular(20) : Radius.circular(4),
                bottomRight: isUser ? Radius.circular(4) : Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 10,
                  offset: Offset(0, 2),
                )
              ],
            ),
            child: Text(
              text,
              style: TextStyle(
                fontSize: 16,
                height: 1.4,
                color: isUser
                    ? Colors.white
                    : isDark
                        ? Colors.white
                        : Color(0xFF1C1C1E),
                fontWeight: FontWeight.w400,
              ),
            ),
          ),

          // Message timestamp
          if (isUser)
            Padding(
              padding: EdgeInsets.only(top: 4, right: 4),
              child: Text(
                '${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade500,
                ),
              ),
            ),

          // Buttons section
          if (buttons.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(top: 12),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: isUser ? WrapAlignment.end : WrapAlignment.start,
                children: List.generate(buttons.length, (index) {
                  final button = buttons[index];
                  return Material(
                    elevation: 2,
                    borderRadius: BorderRadius.circular(25),
                    child: InkWell(
                      onTap: () => onButtonPressed(button['payload']),
                      borderRadius: BorderRadius.circular(25),
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(
                            color: Color(0xFF667eea).withOpacity(0.3),
                            width: 1,
                          ),
                          color: isDark
                              ? Color(0xFF1C1C1E)
                              : Colors.white,
                        ),
                        child: Text(
                          button['title'],
                          style: TextStyle(
                            color: Color(0xFF667eea),
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),

          // Dropdown section
          if (dropdownItems.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(top: 12),
              child: CustomDropdown(
                items: dropdownItems,
                selectedValue: selectedValue,
                hintText: "Select the department",
                onChanged: onDropdownChanged ??
                    (value) {
                      if (value != null) {
                        onButtonPressed(value);
                      }
                    },
              ),
            ),

          // 📎 Custom attachment section
          if (text.toLowerCase().contains("supporting documents") ||
              text.toLowerCase().contains("photos"))
            Padding(
              padding: EdgeInsets.only(top: 12),
              child: CustomAttachment(
                onFileSelected: (file) {
                  // Here you can send file path/message back to bot
                  onButtonPressed("Uploaded: ${file.path.split('/').last}");
                },
              ),
            ),
        ],
      ),
    );
  }
}
