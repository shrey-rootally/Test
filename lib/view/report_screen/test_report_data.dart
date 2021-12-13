import 'package:rootally/model/report_model/exercise_data.dart';
import 'package:rootally/model/report_model/knee_range.dart';
import 'package:rootally/model/report_model/report_data.dart';
import 'package:rootally/model/report_model/set_data.dart';

class TestReportData {
  static ReportData reportData = ReportData(
    initialPainScore: 0,
    laterPainScore: 0,
    timeElapsed: 300,

    ///NOTE: Change The Format
    timeStemp: DateTime.now(),
    exercises: [
      ExerciseData(
        name: "Leg Raise",
        assignReps: 10,
        setList: [
          SetData(
            correctReps: 10,
            incorrectReps: 4,
            isSkipped: false,
            maxHoldTime: 20,
            time: 50,
            kneeRange: KneeRange(
              avg: 45,
              max: 60,
              min: 30,
            ),
          ),
          SetData(
            correctReps: 10,
            incorrectReps: 5,
            isSkipped: false,
            maxHoldTime: 20,
            time: 50,
            kneeRange: KneeRange(
              avg: 45,
              max: 60,
              min: 30,
            ),
          ),
          SetData(
            correctReps: 8,
            incorrectReps: 5,
            isSkipped: false,
            maxHoldTime: 20,
            time: 50,
            kneeRange: KneeRange(
              avg: 45,
              max: 60,
              min: 30,
            ),
          ),
        ],
      ),
      ExerciseData(
        name: "Leg Down",
        assignReps: 10,
        setList: [
          SetData(
            correctReps: 10,
            incorrectReps: 3,
            isSkipped: false,
            maxHoldTime: 20,
            time: 50,
            kneeRange: KneeRange(
              avg: 45,
              max: 60,
              min: 30,
            ),
          ),
          SetData(
            correctReps: 5,
            incorrectReps: 8,
            isSkipped: false,
            maxHoldTime: 20,
            time: 50,
            kneeRange: KneeRange(
              avg: 45,
              max: 60,
              min: 30,
            ),
          ),
          SetData(
            correctReps: 7,
            incorrectReps: 5,
            isSkipped: false,
            maxHoldTime: 20,
            time: 50,
            kneeRange: KneeRange(
              avg: 45,
              max: 60,
              min: 30,
            ),
          ),
        ],
      ),
    ],
  );
}
