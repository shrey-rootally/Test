import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:rootally/constants/app_colors.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:rootally/model/data/exercises.dart';
import 'package:rootally/utils/cached_image_url.dart';
import 'package:rootally/utils/helper.dart';
import 'package:rootally/view/widgets/app_widgets.dart';

class StartExerciseListTile extends StatefulWidget {
  final Exercise exercise;
  const StartExerciseListTile({Key? key, required this.exercise})
      : super(key: key);

  @override
  State<StartExerciseListTile> createState() => _StartExerciseListTileState();
}

class _StartExerciseListTileState extends State<StartExerciseListTile> {
  String url = "";

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getImageUrl(),
      builder: (context, snapshot) {
        return Container(
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
                    emptyVerticalBox(height: 3),
                    Row(
                      children: [
                        getSmallBoxWithInnerText(
                          color: AppColors.setsBoxColor,
                          text: widget.exercise.sets.toString(),
                        ),
                        emptyHorizontalBox(width: 10),
                        getSmallBoxWithInnerText(
                          color: AppColors.repsBoxColor,
                          text: widget.exercise.repititions.toString(),
                        ),
                        emptyHorizontalBox(width: 10),
                        widget.exercise.holdTime == null
                            ? Container()
                            : getSmallBoxWithInnerText(
                                color: AppColors.holdTimeBoxColor,
                                text: widget.exercise.holdTime.toString(),
                              ),
                      ],
                    ),
                  ],
                )
              ],
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

  Widget getSmallBoxWithInnerText(
      {required Color color, required String text}) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(5),
      ),
      width: 18,
      height: 18,
      child: Center(
        child: Text(
          text,
          style: const TextStyle(fontSize: 10, color: AppColors.whiteColor),
        ),
      ),
    );
  }
}
