import 'package:flutter/material.dart';
import 'dart:async';

class CurvedSlider extends StatefulWidget {
  const CurvedSlider({super.key});

  @override
  State<CurvedSlider> createState() => _CurvedSliderState();
}

class _CurvedSliderState extends State<CurvedSlider> {

  int currentSlide = 0;

  final List<Map<String, String>> slides = [
    {
      'title': 'Welcome to Your App',
      'content': 'Track your progress and achieve your goals',
    },
    {
      'title': 'Insights & Analytics',
      'content': 'Get detailed insights about your activities',
    },
    {
      'title': 'Smart Reports',
      'content': 'Generate comprehensive reports automatically',
    },
  ];

  late Timer _timer;

  void nextSlide() {
    setState(() {
      currentSlide = (currentSlide + 1) % slides.length;
    });
  }

  void prevSlide() {
    setState(() {
      currentSlide = (currentSlide - 1 + slides.length) % slides.length;
    });
  }
  @override
  void initState() {
    
    super.initState();

    // 🔁 Auto-rotate slide every 3 seconds
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      nextSlide();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.all(Radius.circular(40)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: prevSlide, 
                  icon: Icon(Icons.chevron_left),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        slides[currentSlide]['title']!,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8,),

                      Text(
                        slides[currentSlide]['content']!,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: nextSlide,
                  icon: Icon(Icons.chevron_right),
                ),
              ],
            ),

            const SizedBox(height: 95,),

            //Dots indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                slides.length,
                (index) => GestureDetector(
                  onTap: () {
                    setState(() {
                      currentSlide = index;
                    });
                  },
                  child:AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: currentSlide == index
                        ? Theme.of(context).colorScheme.primary
                        : Colors.grey.shade400,
                  ),
                ),
                )
             ),
            ),
          ],
        )
      ),
    );
  }
}