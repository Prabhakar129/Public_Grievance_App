import 'package:flutter/material.dart';

class ChatController extends StatefulWidget {

  final Function(String) onSend;

  const ChatController({
    super.key,
    required this.onSend,
  });

  @override
  State<ChatController> createState() => _ChatControllerState();
}

class _ChatControllerState extends State<ChatController> 
    with SingleTickerProviderStateMixin{
  final TextEditingController _controller = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;  
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController, 
      curve: Curves.easeInOut,
    ));

    _controller.addListener(() {
      setState(() {
        _hasText = _controller.text.trim().isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _handleSend() {
    if (_controller.text.trim().isEmpty) return;

    _animationController.forward().then((_) {
      _animationController.reverse();
    });

    widget.onSend(_controller.text);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Color(0xFF1C1C1E) : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            ///Message input field
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: isDark ? Color(0xFF2C2C2E) : Color(0xFFF2F2F7),
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: _hasText
                      ? Color(0xFF667eea) 
                      : Colors.transparent,
                    width: 1,  
                  ),
                ),
                child: TextField(
                  controller: _controller,
                  maxLines: null,
                  textInputAction: TextInputAction.send,
                  decoration: InputDecoration(
                    hintText: "Type your message...",
                    hintStyle: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 16,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 14,),
                  ),
                  style: TextStyle(
                    fontSize: 16,
                    color: isDark ? Colors.white : Color(0xFF1C1C1E),
                  ),
                  onSubmitted: (_) => _handleSend(),
                ),
              ),
            ),
            
            SizedBox(width: 12,),
            //Send Button
            AnimatedBuilder(
              animation: _scaleAnimation, 
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Container(
                    height: 48,
                    width: 48,
                    decoration: BoxDecoration(
                      gradient: _hasText
                        ? LinearGradient(
                          colors: [
                          Color(0xFF667eea),
                          Color(0xFF764ba2),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ): null,
                      color: _hasText ? null : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: _hasText ? [
                        BoxShadow(
                          color: Color(0xFF667eea).withOpacity(0.3),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ]: null,
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        child: Icon(
                          Icons.send_rounded,
                          color: _hasText
                            ? Colors.white
                            : Colors.grey.shade500,
                          size: 20,  
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}