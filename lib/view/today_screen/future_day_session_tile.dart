import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rootally/constants/app_colors.dart';
import 'package:rootally/utils/helper.dart';
import 'package:timeline_tile/timeline_tile.dart';

class FutureDaySessionTileUI extends StatelessWidget {
  final int index, totalSessionCount;
  final Map<String, dynamic> data;

  const FutureDaySessionTileUI(
      {Key? key,
      required this.index,
      required this.totalSessionCount,
      required this.data})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TimelineTile(
      isFirst: index == 0,
      isLast: index == totalSessionCount - 1,
      afterLineStyle: const LineStyle(
        color: AppColors.tileSideLineColor,
        thickness: 2,
      ),
      beforeLineStyle: const LineStyle(
        color: AppColors.tileSideLineColor,
        thickness: 2,
      ),
      indicatorStyle: IndicatorStyle(
        color: AppColors.tileSideLineColor,
        drawGap: true,
        indicator: Container(
          decoration: const BoxDecoration(
            border: Border.fromBorderSide(
              BorderSide(
                color: AppColors.tileSideLineColor,
                width: 2,
              ),
            ),
            shape: BoxShape.circle,
          ),
        ),
      ),
      endChild: sessionTile(
        index: index,
        sessionName: data["sessionName"],
      ),
    );
  }

  Widget sessionTile({required int index, required String sessionName}) {
    String nextSessionDate =
        DateFormat("dd/MM/yyyy").format(data["nextSessionDate"]);
    int logoIndex = Random().nextInt(3);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppColors.tileBoxBorderColor,
          width: 2,
        ),
      ),
      height: 140,
      margin: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 10,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  sessionName,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold),
                ),
                emptyVerticalBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // const Icon(
                    //   Icons.play_arrow_outlined,
                    //   color: AppColors.greyColor,
                    // ),
                    RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          const TextSpan(
                            text: "Available on\n",
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.tileSideLineColor,
                              fontWeight: FontWeight.w500,
                              height: 1.1,
                            ),
                          ),
                          TextSpan(
                            text: nextSessionDate,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.greyTextColor,
                              fontWeight: FontWeight.w500,
                              height: 1.1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          emptyHorizontalBox(width: 30),
          Expanded(
            child: Image.asset(
              "assets/session_logo_${logoIndex + 1}.png",
            ),
          ),
        ],
      ),
    );
  }
}
