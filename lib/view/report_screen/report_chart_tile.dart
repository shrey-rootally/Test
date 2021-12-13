import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:rootally/constants/app_colors.dart';
import 'package:rootally/constants/app_text.dart';
import 'package:rootally/model/report_model/exercise_data.dart';
import 'package:rootally/model/report_model/set_data.dart';
import 'package:rootally/utils/helper.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ReportChartTile extends StatelessWidget {
  final ExerciseData exerciseData;
  const ReportChartTile({Key? key, required this.exerciseData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: ExpansionTileCard(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              exerciseData.name,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            Row(
              children: [
                const Text(
                  AppText.setsText,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.secondaryColor,
                  ),
                ),
                emptyHorizontalBox(width: 5),
                SizedBox(
                  width: width * 0.2,
                  height: 20,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: exerciseData.setList.length,
                    itemBuilder: (context, setIndex) {
                      int completedReps =
                          exerciseData.setList[setIndex].correctReps;
                      int assignReps = exerciseData.assignReps;
                      return Row(
                        children: [
                          completedReps >= assignReps
                              ? getGreenCheck()
                              : getRedCircle(
                                  completedReps: completedReps,
                                ),
                          emptyHorizontalBox(width: 5),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
        shadowColor: Colors.transparent,
        expandedColor: AppColors.demoTileColor,
        baseColor: AppColors.demoTileColor,
        expandedTextColor: AppColors.secondaryColor,
        children: getChartsWithData(),
      ),
    );
  }

  Widget getGreenCheck() {
    return Container(
      width: 18,
      height: 18,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppColors.reportPrimaryColor,
      ),
      child: const Icon(
        Icons.check,
        color: AppColors.whiteColor,
        size: 12,
      ),
    );
  }

  Widget getRedCircle({required int completedReps}) {
    return Container(
      width: 18,
      height: 18,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppColors.reportSecondaryColor,
      ),
      child: Center(
        child: Text(
          completedReps.toString(),
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: AppColors.whiteColor,
          ),
        ),
      ),
    );
  }

  List<Widget> getChartsWithData() {
    return [
      SizedBox(
        width: double.infinity,
        height: 100,
        child: SfCartesianChart(
          primaryXAxis: NumericAxis(isVisible: false),
          primaryYAxis: NumericAxis(
            minimum: 0,
            maximum: 10,
            interval: 2,
            title: AxisTitle(
              text: AppText.repsText,
              textStyle: const TextStyle(
                fontSize: 12,
              ),
            ),
          ),
          series: <ChartSeries>[
            ColumnSeries<SetData, int>(
              dataSource: exerciseData.setList,
              xValueMapper: (datum, index) => index + 1,
              color: AppColors.reportPrimaryColor,
              dataLabelMapper: (SetData sets, _) => sets.correctReps.toString(),
              dataLabelSettings: const DataLabelSettings(
                color: Colors.transparent,
                isVisible: true,
                labelAlignment: ChartDataLabelAlignment.bottom,
                textStyle: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
              yValueMapper: (SetData sets, _) => sets.correctReps,
            ),
            ColumnSeries<SetData, int>(
              dataSource: exerciseData.setList,
              xValueMapper: (datum, index) => index + 1,
              color: AppColors.reportSecondaryColor,
              dataLabelMapper: (SetData sets, _) =>
                  sets.incorrectReps.toString(),
              dataLabelSettings: const DataLabelSettings(
                color: Colors.transparent,
                isVisible: true,
                labelAlignment: ChartDataLabelAlignment.bottom,
                textStyle: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
              yValueMapper: (SetData sets, _) => sets.incorrectReps,
            ),
          ],
        ),
      ),
    ];
  }
}
