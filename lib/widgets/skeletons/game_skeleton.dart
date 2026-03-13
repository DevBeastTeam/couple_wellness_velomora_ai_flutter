import 'package:flutter/material.dart';
import 'shimmer_widget.dart';


class GameScreenSkeleton extends StatelessWidget {
  const GameScreenSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final width = mq.size.width;
    final height = mq.size.height;

    return ShimmerWrap(
      Scaffold(
        body: Column(
          children: [
            // Progress strip at top
            Container(height: height * 0.01, color: Colors.grey.shade300),
            // Main content
            SizedBox(
              height: height * 0.65,
              child: ListView(
                padding: EdgeInsets.all(width * 0.067),
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  // Center icon
                  Center(
                    child: ShimmerBox(
                      height: height * 0.1,
                      width: height * 0.1,
                      radius: width * 0.222,
                      color: Colors.grey.shade300,
                    ),
                  ),
                  SizedBox(height: height * 0.04),
                  // Question card
                  Container(
                    padding: EdgeInsets.all(width * 0.056),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(width * 0.056),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        ShimmerLine(
                          height: height * 0.025,
                          width: width * 0.7,
                          color: Colors.grey.shade300,
                        ),
                        SizedBox(height: height * 0.015),
                        ShimmerLine(
                          height: height * 0.02,
                          width: width * 0.85,
                          color: Colors.grey.shade300,
                        ),
                        SizedBox(height: height * 0.015),
                        ShimmerLine(
                          height: height * 0.02,
                          width: width * 0.6,
                          color: Colors.grey.shade300,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: height * 0.04),
                  // Option cards
                  _optionCard(width, height),
                  SizedBox(height: height * 0.02),
                  _optionCard(width, height),
                ],
              ),
            ),
            // Bottom button
            Container(
              padding: EdgeInsets.all(width * 0.067),
              child: ShimmerBox(
                height: height * 0.0625,
                width: height * 0.0625,
                radius: width,
                color: Colors.grey.shade300,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _optionCard(double width, double height) {
    return Container(
      padding: EdgeInsets.all(width * 0.044),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(width * 0.044),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          ShimmerBox(
            height: height * 0.025,
            width: height * 0.025,
            radius: width * 0.056,
            color: Colors.grey.shade300,
          ),
          SizedBox(width: width * 0.044),
          SizedBox(
            width: width * 0.55,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerLine(
                  height: height * 0.02,
                  width: width * 0.5,
                  color: Colors.grey.shade300,
                ),
                SizedBox(height: height * 0.008),
                ShimmerLine(
                  height: height * 0.015,
                  width: width * 0.7,
                  color: Colors.grey.shade300,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
