import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rootally/constants/app_colors.dart';
import 'package:rootally/constants/app_text.dart';
import 'package:rootally/utils/helper.dart';
import 'package:rootally/view/demo_screen/demo_exercise_list_tile.dart';
import 'package:rootally/viewmodel/today_screen_view_model.dart';

class DemoScreen extends StatelessWidget {
  const DemoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return GetBuilder<TodayScreenViewModel>(
      builder: (controller) {
        return Scaffold(
          backgroundColor: AppColors.greenBackgroudColor,
          body: CustomScrollView(
            physics: const ClampingScrollPhysics(),
            slivers: [
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Container(
                      height: MediaQuery.of(context).orientation ==
                              Orientation.portrait
                          ? height * 0.26
                          : height * 0.55,
                      padding: const EdgeInsets.all(20.0),
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image:
                              AssetImage("assets/background/green_bubbles.png"),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              const Text(
                                AppText.exerciseDemoText,
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.secondaryColor,
                                ),
                              ),
                              emptyVerticalBox(height: 5),
                              Container(
                                height: 25,
                                width: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: AppColors.secondaryColor,
                                ),
                                child: const Center(
                                  child: Text(
                                    AppText.leftShoulderText,
                                    style: TextStyle(
                                      color: AppColors.greenBackgroudColor,
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              emptyVerticalBox(),
                              SizedBox(
                                width: 250,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const Icon(
                                      Icons.info_outline,
                                      color: AppColors.redColor,
                                      size: 20,
                                    ),
                                    emptyHorizontalBox(width: 5),
                                    const Flexible(
                                      child: Text(
                                        AppText.demoNotReviewdByText,
                                        style: TextStyle(
                                          color: AppColors.greyTextColor,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12,
                                        ),
                                        softWrap: true,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Image.asset(
                            "assets/exercise/demo_screen_exercise_logo.png",
                            height: 120,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              getExerciseList(controller, context),
            ],
          ),
        );
      },
    );
  }

  Widget getExerciseList(TodayScreenViewModel controller, context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) => Container(
          height: MediaQuery.of(context).size.height * 0.623,
          padding: const EdgeInsets.only(top: 15),
          decoration: const BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: ListView.builder(
            physics: const ClampingScrollPhysics(),
            itemBuilder: (context, index) => DemoExerciseListTile(
                exercise: controller.exerciseProgramModel!.exercises[index]),
            itemCount: controller.exerciseProgramModel!.exercises.length,
          ),
        ),
        childCount: 1,
      ),
    );
  }
}
