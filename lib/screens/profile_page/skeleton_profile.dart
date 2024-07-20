import 'package:flutter/material.dart';
import 'package:my_todo_app/screens/theme/theme.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTheme = Theme.of(context);
    final skeletonColors = appTheme.extension<SkeletonColors>();

    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        Shimmer.fromColors(
          baseColor: skeletonColors!.baseColor,
          highlightColor: skeletonColors.highlightColor,
          child: Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Container(
                    width: 120,
                    height: 20,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Container(
                    width: 180,
                    height: 20,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Container(
                    width: 200,
                    height: 20,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Container(
                    width: 120,
                    height: 40,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 16),
        Shimmer.fromColors(
          baseColor: skeletonColors!.baseColor,
          highlightColor: skeletonColors.highlightColor,
          child: Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 150,
                    height: 20,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  ...List.generate(4, (index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            color: Colors.grey,
                          ),
                          SizedBox(width: 16),
                          Container(
                            width: 200,
                            height: 20,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}