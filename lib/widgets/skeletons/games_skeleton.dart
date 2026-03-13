import 'package:flutter/material.dart';
import 'shimmer_widget.dart';


class GamesScreenSkeleton extends StatelessWidget {
  const GamesScreenSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final width = mq.size.width;
    final height = mq.size.height;

    return ShimmerWrap(
      Column(
        children: [
          // Game cards
          SizedBox(
            height: height * 0.65,
            child: ListView(
              padding: EdgeInsets.all(width * 0.067),
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _gameCard(width, height),
                SizedBox(height: height * 0.02),
                _gameCard(width, height),
                SizedBox(height: height * 0.02),
                _gameCard(width, height),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _gameCard(double width, double height) {
    return Container(
      height: height * 0.25,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(width * 0.056),
      ),
      child: Column(
        children: [
          // Image area
          Container(
            height: height * 0.10,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(width * 0.056),
                topRight: Radius.circular(width * 0.056),
              ),
            ),
          ),
          // Content
          Padding(
            padding: EdgeInsets.all(width * 0.044),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerLine(
                  height: height * 0.022,
                  width: width * 0.6,
                  color: Colors.grey.shade300,
                ),
                SizedBox(height: height * 0.01),
                ShimmerLine(
                  height: height * 0.015,
                  width: width * 0.85,
                  color: Colors.grey.shade300,
                ),
                SizedBox(height: height * 0.015),
                Row(
                  children: [
                    ShimmerBox(
                      height: height * 0.02,
                      width: height * 0.02,
                      radius: width * 0.08,
                      color: Colors.grey.shade300,
                    ),
                    SizedBox(width: width * 0.028),
                    ShimmerBox(
                      height: height * 0.02,
                      width: height * 0.02,
                      radius: width * 0.08,
                      color: Colors.grey.shade300,
                    ),
                    const Spacer(),
                    ShimmerBox(
                      height: height * 0.045,
                      width: height * 0.045,
                      radius: width * 0.2,
                      color: Colors.grey.shade300,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
