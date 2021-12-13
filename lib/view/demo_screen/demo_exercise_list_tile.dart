import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:rootally/constants/app_colors.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:rootally/constants/app_text.dart';
import 'package:rootally/model/data/exercises.dart';
import 'package:rootally/utils/cached_image_url.dart';
import 'package:rootally/utils/helper.dart';
import 'package:rootally/view/widgets/app_widgets.dart';

class DemoExerciseListTile extends StatefulWidget {
  final Exercise exercise;
  const DemoExerciseListTile({Key? key, required this.exercise})
      : super(key: key);

  @override
  State<DemoExerciseListTile> createState() => _DemoExerciseListTileState();
}

class _DemoExerciseListTileState extends State<DemoExerciseListTile> {
  String url = "";

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getImageUrl(),
      builder: (context, snapshot) {
        return InkWell(
          onTap: () {
            openBottomSheet(context);
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            decoration: BoxDecoration(
              color: AppColors.demoTileColor,
              borderRadius: BorderRadius.circular(10),
            ),
            height: 90,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  snapshot.connectionState == ConnectionState.done
                      ? CachedNetworkImage(
                          imageUrl: url,
                          width: 50,
                        )
                      : AppWidgets.circularProgressIndicator,
                  emptyHorizontalBox(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.exercise.exerciseName,
                        style: const TextStyle(
                          fontSize: 19,
                          color: AppColors.greyTextColor,
                        ),
                      ),
                      // emptyVerticalBox(height: 5),
                      Row(
                        children: [
                          const Text(
                            AppText.practiceText,
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                          emptyHorizontalBox(width: 5),
                          const Icon(
                            Icons.arrow_forward,
                            size: 16,
                          ),
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  getImageUrl() async {
    final firebase_storage.Reference ref = firebase_storage
        .FirebaseStorage.instance
        .ref('exercise_images/${widget.exercise.exerciseName}.png');

    url = await CachedImageUrl.instance.getUrl(ref);
  }

  void openBottomSheet(context) {
    List<int> repsCount = [3, 5, 7, 10];
    int _selectedIndex = 0;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Container(
          decoration: const BoxDecoration(
            color: AppColors.whiteColor,
            boxShadow: [
              BoxShadow(
                color: AppColors.greyTextColor,
                spreadRadius: 1,
                blurRadius: 7,
              ),
            ],
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40),
              topRight: Radius.circular(40),
            ),
          ),
          height: MediaQuery.of(context).size.height * 0.67,
          padding: const EdgeInsets.all(30),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  AppText.howManyText,
                  style:
                      TextStyle(fontSize: 20, color: AppColors.greyTextColor),
                ),
                emptyVerticalBox(height: 5),
                const Text(
                  AppText.howManyRepText,
                  style: TextStyle(
                      fontSize: 12, color: AppColors.bottomSheetSubtitle),
                ),
                emptyVerticalBox(),
                SizedBox(
                  height: 220,
                  child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) => InkWell(
                      onTap: () {
                        setState(() {
                          _selectedIndex = index;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: _selectedIndex == index
                              ? AppColors.primaryColor
                              : AppColors.whiteColor,
                          border: Border.all(
                            color: _selectedIndex == index
                                ? AppColors.secondaryColor
                                : AppColors.tileSideLineColor,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                        ),
                        margin: const EdgeInsets.symmetric(
                          vertical: 5,
                        ),
                        child: Center(
                          child: Text(
                            repsCount[index].toString(),
                            style: TextStyle(
                              color: _selectedIndex == index
                                  ? AppColors.whiteColor
                                  : AppColors.secondaryColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                    itemCount: repsCount.length,
                  ),
                ),
                emptyVerticalBox(height: 30),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    border:
                        Border.all(color: AppColors.secondaryColor, width: 3),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.play_arrow_rounded,
                        color: AppColors.greenAccentColor,
                        size: 30,
                      ),
                      Text(AppText.startPracticeText),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
