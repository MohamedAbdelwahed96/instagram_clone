import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SkeletonProfileHeader extends StatelessWidget {
  const SkeletonProfileHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use the theme's inversePrimary color for all placeholder elements.
    final placeholderColor = Theme.of(context).colorScheme.inversePrimary;

    return Shimmer.fromColors(
      baseColor: placeholderColor,
      highlightColor: placeholderColor.withOpacity(0.7),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Row: Avatar and Stats
              Row(
                children: [
                  // Circular avatar placeholder
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: placeholderColor,
                    ),
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.15),
                  // Stats placeholders for Posts, Followers, Following
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatPlaceholder(placeholderColor),
                        _buildStatPlaceholder(placeholderColor),
                        _buildStatPlaceholder(placeholderColor),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              // Username placeholder
              Container(width: 150, height: 16, color: placeholderColor),
              SizedBox(height: 6),
              // Category/Genre placeholder
              Container(width: 100, height: 14, color: placeholderColor),
              SizedBox(height: 6),
              // Bio placeholder (two lines)
              Container(width: double.infinity, height: 14, color: placeholderColor),
              SizedBox(height: 4),
              Container(width: double.infinity, height: 14, color: placeholderColor),
              SizedBox(height: 6),
              // Link placeholder
              Container(width: 120, height: 14, color: placeholderColor),
              SizedBox(height: 10),
              // Buttons row placeholder (for Follow/Message or Edit Profile/Sign Out)
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 45,
                      decoration: BoxDecoration(
                        color: placeholderColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  /// A helper widget to build a stat placeholder (e.g., for Posts, Followers, Following).
  Widget _buildStatPlaceholder(Color color) {
    return Column(
      children: [
        Container(width: 40, height: 16, color: color),
        SizedBox(height: 4),
        Container(width: 30, height: 12, color: color),
      ],
    );
  }
}
