import 'package:flutter/material.dart';
import 'package:rootally/constants/app_colors.dart';
import 'package:rootally/constants/app_text.dart';
import 'package:rootally/locator.dart';
import 'package:rootally/services/navigation_service.dart';
import 'package:rootally/utils/helper.dart';
import 'package:rootally/view/widgets/app_widgets.dart';

class PainScoreBottomSheet extends StatefulWidget {
  final String btnText;
  final Icon? btnIcon;
  const PainScoreBottomSheet({Key? key, required this.btnText, this.btnIcon})
      : super(key: key);

  @override
  _PainScoreBottomSheetState createState() => _PainScoreBottomSheetState();
}

class _PainScoreBottomSheetState extends State<PainScoreBottomSheet> {
  int _currentIndex = 0;

  final NavigationService _navigationService = locator<NavigationService>();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return WillPopScope(
      onWillPop: () async => false,
      child: StatefulBuilder(
        builder: (context, setState) {
          return Container(
            height: isPortrait ? height * 0.57 : height * 0.80,
            padding: const EdgeInsets.all(25),
            decoration: const BoxDecoration(
              color: AppColors.whiteColor,
              boxShadow: [
                BoxShadow(
                  color: AppColors.greyColor,
                  spreadRadius: 1,
                  blurRadius: 7,
                ),
              ],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
              ),
            ),
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    AppText.painScoreText,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: AppColors.secondaryColor,
                    ),
                  ),
                  const Text(
                    AppText.howDoesFeelText,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.secondaryColor,
                    ),
                  ),
                  emptyVerticalBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.info_outline_rounded,
                        size: 22,
                        color: AppColors.redColor,
                      ),
                      emptyHorizontalBox(width: 5),
                      const Text(
                        AppText.notifyMsgText,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.greyTextColor,
                        ),
                      ),
                    ],
                  ),
                  emptyVerticalBox(),
                  Center(
                    child: Image.asset(
                      "assets/emoji/" + getImgName(),
                      height: 50,
                      width: 50,
                    ),
                  ),
                  SizedBox(
                    height: isPortrait ? height * 0.15 : height * 0.34,
                    child: PageView.builder(
                      controller: PageController(
                        viewportFraction: 0.1,
                      ),
                      onPageChanged: (value) {
                        setState(() {
                          _currentIndex = value;
                        });
                      },
                      itemCount: 11,
                      itemBuilder: (context, index) {
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            // color: AppColors.secondaryColor,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                index.toString(),
                                style: TextStyle(
                                  fontSize: _currentIndex == index ? 31 : 15,
                                  fontWeight: _currentIndex == index
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                                  color: _currentIndex == index
                                      ? AppColors.secondaryColor
                                      : AppColors.sliderGray,
                                ),
                              ),
                              emptyVerticalBox(height: 10),
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                width: 2,
                                height: _currentIndex == index ? 60 : 30,
                                color: _currentIndex == index
                                    ? AppColors.secondaryColor
                                    : AppColors.sliderGray,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  emptyVerticalBox(height: 10),
                  const Center(
                    child: Text(
                      AppText.discomfortingText,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: AppColors.greenAccentColor,
                      ),
                    ),
                  ),
                  emptyVerticalBox(height: 25),
                  AppWidgets.getAppBtn(
                    onTap: () {
                      _navigationService.goBack(argumates: _currentIndex);
                    },
                    width: width,
                    height: 50,
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          widget.btnIcon ?? Container(),
                          // emptyHorizontalBox(width: 10),
                          Text(
                            widget.btnText,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                              color: AppColors.secondaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String getImgName() {
    if (_currentIndex == 0) {
      return "0 - No pain.png";
    } else if (_currentIndex >= 1 && _currentIndex <= 2) {
      return "1-2 Mild .png";
    } else if (_currentIndex >= 3 && _currentIndex <= 4) {
      return "3-4 mild.png";
    } else if (_currentIndex >= 5 && _currentIndex <= 6) {
      return "5-6 Moderate.png";
    } else if (_currentIndex >= 7 && _currentIndex <= 8) {
      return "7-8 Moderate.png";
    } else {
      return "9-10 Severe Pain.png";
    }
  }
}
