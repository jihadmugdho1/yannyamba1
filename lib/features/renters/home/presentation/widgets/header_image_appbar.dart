import 'package:flutter/material.dart';
import 'dart:io';

import '../../../../../core/utils/constants/colors.dart';
import 'package:yannyamba/core/models/property/property_models.dart';
import '../../../../../core/core.dart';

class HeaderImageAppBar extends StatefulWidget {
  final Apartment apartment;

  const HeaderImageAppBar({super.key, required this.apartment});

  @override
  State<HeaderImageAppBar> createState() => _HeaderImageAppBarState();
}

class _HeaderImageAppBarState extends State<HeaderImageAppBar> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _pageController.addListener(() {
      int next = _pageController.page!.round();
      if (_currentPage != next) {
        setState(() {
          _currentPage = next;
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 250,
      pinned: true,
      backgroundColor: Colors.white,
      leading: _circleButton(
        context,
        icon: Icons.arrow_back,
        onTap: () => Navigator.pop(context),
      ),
      // actions: [_circleButton(context, icon: Icons.share, onTap: () {})],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
              child: PageView.builder(
                controller: _pageController,
                itemCount: widget.apartment.images.length,
                itemBuilder: (context, index) {
                  return _buildPropertyImage(widget.apartment.images[index]);
                },
              ),
            ),
            // Page indicator
            if (widget.apartment.images.length > 1)
              Positioned(
                bottom: 16,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    widget.apartment.images.length,
                    (index) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _currentPage == index
                            ? Colors.white
                            : Colors.white.withValues(alpha: 0.5),
                      ),
                    ),
                  ),
                ),
              ),
            // Image counter
            if (widget.apartment.images.length > 1)
              Positioned(
                top: 80,
                right: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${_currentPage + 1}/${widget.apartment.images.length}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _circleButton(
    BuildContext context, {
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.textWhite,
        borderRadius: BorderRadius.circular(12),
      ),
      child: SizedBox(
        width: 28,
        height: 28,
        child: IconButton(
          iconSize: 20,
          padding: EdgeInsets.zero,
          icon: Icon(icon, color: Colors.black),
          onPressed: onTap,
        ),
      ),
    );
  }

  Widget _buildPropertyImage(String imageUrl) {
    // Check if it's a file path (uploaded image)
    if (imageUrl.startsWith('/') || imageUrl.contains('file://')) {
      return Image.file(
        File(imageUrl.replaceAll('file://', '')),
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (context, error, stackTrace) {
          // Fallback to default image if file doesn't exist
          return Image.asset(
            ImagePath.homeImage,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          );
        },
      );
    }

    // Check if it's a network URL
    if (imageUrl.startsWith('http://') || imageUrl.startsWith('https://')) {
      return Image.network(
        imageUrl,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                  : null,
              color: Colors.white,
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          // Fallback to default image if network image fails
          return Image.asset(
            ImagePath.homeImage,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          );
        },
      );
    }

    // Otherwise, treat it as an asset
    return Image.asset(
      imageUrl,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      errorBuilder: (context, error, stackTrace) {
        // Fallback to default image if asset doesn't exist
        return Image.asset(
          ImagePath.homeImage,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        );
      },
    );
  }
}
