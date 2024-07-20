import 'package:flutter/material.dart';
import 'package:my_todo_app/screens/theme/theme.dart';
import 'package:shimmer/shimmer.dart';

class CalendarShimmerLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTheme = Theme.of(context);
    final skeletonColors = appTheme.extension<SkeletonColors>();
    final mediaQuery = MediaQuery.of(context);
    final width = mediaQuery.size.width;
    final height = mediaQuery.size.height;

    final padding = width * 0.03; // Adjust padding based on screen width
    final containerWidth = width * 0.8; // Adjust container width based on screen width
    final containerHeight = height * 0.02; // Adjust container height based on screen height
    final itemSize = width * 0.1; // Adjust item size based on screen width

    return Shimmer.fromColors(
      baseColor: skeletonColors!.baseColor,
      highlightColor: skeletonColors.highlightColor,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: padding),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: height * 0.03, bottom: height * 0.02),
              height: containerHeight,
              width: containerWidth,
              decoration: BoxDecoration(
                color: appTheme.colorScheme.secondary,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(7, (index) {
                return Container(
                  width: itemSize,
                  height: itemSize,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(itemSize / 2),
                  ),
                );
              }),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(7, (index) {
                return Container(
                  width: itemSize,
                  height: itemSize,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(itemSize / 2),
                  ),
                );
              }),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(7, (index) {
                return Container(
                  width: itemSize,
                  height: itemSize,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(itemSize / 2),
                  ),
                );
              }),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(7, (index) {
                return Container(
                  width: itemSize,
                  height: itemSize,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(itemSize / 2),
                  ),
                );
              }),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(7, (index) {
                return Container(
                  width: itemSize,
                  height: itemSize,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(itemSize / 2),
                  ),
                );
              }),
            ),
            SizedBox(height: height * 0.07), // Adjust bottom margin based on screen height
          ],
        ),
      ),
    );
  }
}

class TaskListShimmerLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTheme = Theme.of(context);
    final skeletonColors = appTheme.extension<SkeletonColors>();
    final mediaQuery = MediaQuery.of(context);
    final width = mediaQuery.size.width;

    final padding = width * 0.04; // Adjust padding based on screen width
    final itemWidth = width * 0.1; // Adjust item width based on screen width
    final textWidth = width * 0.8; // Adjust text width based on screen width
    final itemHeight = width * 0.1; // Adjust item height based on screen width

    return Shimmer.fromColors(
      baseColor: skeletonColors!.baseColor,
      highlightColor: skeletonColors.highlightColor,
      child: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: padding, horizontal: padding),
            child: Row(
              children: [
                Container(
                  width: itemWidth,
                  height: itemHeight,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(itemWidth / 4),
                  ),
                ),
                SizedBox(width: padding),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: padding / 2),
                      Container(
                        width: textWidth,
                        height: itemHeight * 0.3, // Adjust height based on item height
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      SizedBox(height: padding),
                      Container(
                        width: textWidth,
                        height: itemHeight * 0.3, // Adjust height based on item height
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
