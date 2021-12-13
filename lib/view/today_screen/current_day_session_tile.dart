import 'dart:math';

import 'package:flutter/material.dart';
import 'package:rootally/constants/app_colors.dart';
import 'package:rootally/constants/app_text.dart';
import 'package:rootally/utils/helper.dart';
import 'package:timeline_tile/timeline_tile.dart';

class CurrentDaySessionTileUI extends StatelessWidget {
  final int index, totalSessionCount;
  final Map<String, dynamic> data;

  const CurrentDaySessionTileUI(
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
      afterLineStyle: index != totalSessionCount - 1
          ? index < data["sessionDone"] - 1
              ? const LineStyle(
                  color: AppColors.primaryColor,
                  thickness: 2,
                )
              : const LineStyle(
                  color: AppColors.tileSideLineColor,
                  thickness: 2,
                )
          : const LineStyle(color: AppColors.primaryColor),
      beforeLineStyle: index < data["sessionDone"]
          ? const LineStyle(
              color: AppColors.primaryColor,
              thickness: 2,
            )
          : const LineStyle(color: AppColors.tileSideLineColor, thickness: 2),
      indicatorStyle: index < data["sessionDone"]
          ? IndicatorStyle(
              color: AppColors.primaryColor,
              height: 20,
              width: 20,
              iconStyle: IconStyle(
                iconData: Icons.check,
                color: AppColors.whiteColor,
                fontSize: 14,
              ),
            )
          : IndicatorStyle(
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
                index < data["sessionDone"]
                    ? Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: AppColors.primaryColor,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                        ),
                        height: 25,
                        child: const Center(
                          child: Text(
                            "Completed",
                            style: TextStyle(
                                color: AppColors.whiteColor, fontSize: 12),
                          ),
                        ),
                      )
                    : index != data["sessionDone"]
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.play_arrow_outlined,
                                color: AppColors.greyTextColor,
                              ),
                              Text(
                                "${AppText.finishSessionText}\n$index ${AppText.toStartText}",
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: AppColors.greyTextColor,
                                  height: 1.1,
                                ),
                              ),
                            ],
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: const [
                              Text(
                                AppText.startText,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: AppColors.greyTextColor,
                                  fontWeight: FontWeight.w500,
                                  height: 1.3,
                                ),
                              ),
                              Icon(
                                Icons.play_arrow_rounded,
                                color: AppColors.greenAccentColor,
                                size: 32,
                              ),
                            ],
                          ),
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
