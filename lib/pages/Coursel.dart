import 'dart:ui';
import 'package:final_project/pages/fullimages.dart';
import 'package:flutter/material.dart';

class CursorNetworkSlider extends StatefulWidget {
  final List<String> imageUrls;
  final int initialPage;

   const CursorNetworkSlider({
    super.key,
    required this.imageUrls,
    required this.initialPage,
  });

  @override
  State<CursorNetworkSlider> createState() => _CursorNetworkSliderState();
}

class _CursorNetworkSliderState extends State<CursorNetworkSlider> {
  late PageController _pageController;
  late int _currentPage;

  @override
  void initState() {
    super.initState();
    _currentPage = widget.initialPage;
    _pageController = PageController(
      viewportFraction: 0.8,
      initialPage: widget.initialPage,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 600),
          child: Image.network(
            widget.imageUrls[_currentPage],
            key: ValueKey(widget.imageUrls[_currentPage]),
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
        ),
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
            child: Container(color: Colors.black.withOpacity(0.3)),
          ),
        ),
        Center(
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            width: MediaQuery.of(context).size.width, 
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.imageUrls.length,
              onPageChanged: (index) => setState(() => _currentPage = index),
              itemBuilder: (context, index) {
                double value = 1.0;
                if (_pageController.position.haveDimensions) {
                  value = _pageController.page! - index;
                  value = (1 - (value.abs() * 0.3)).clamp(0.7, 1.0);
                }

                return Transform.scale(
                  scale: value,
                  child: Opacity(
                    opacity: value,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => FullScreenImage(
                              imagePath: widget.imageUrls[index],
                            ),
                          ),
                        );
                      },
                      child: Hero(
                        tag: widget.imageUrls[index],
                        child: Container(
                          
                          margin: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            image: DecorationImage(
                              image: NetworkImage(widget.imageUrls[index]),
                              fit: BoxFit.cover, 
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.pink.withOpacity(0.5),
                                blurRadius: 3,
                                spreadRadius: 3,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
