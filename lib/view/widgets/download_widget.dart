import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_getx_widget.dart';
import 'package:rootally/constants/app_colors.dart';
import 'package:rootally/constants/app_text.dart';
import 'package:rootally/utils/helper.dart';
import 'package:rootally/viewmodel/video_download_view_model.dart';

class DownloadDialog extends StatefulWidget {
  const DownloadDialog({Key? key, required this.list}) : super(key: key);

  final List<String> list;

  @override
  State<DownloadDialog> createState() => _DownloadDialogState();
}

class _DownloadDialogState extends State<DownloadDialog> {
  final VideoDownloadViewModel _videoDownloadViewModel =
      Get.put(VideoDownloadViewModel());

  @override
  void initState() {
    _videoDownloadViewModel.fetchVideos(videoList: widget.list);

    _videoDownloadViewModel.downloadComplete.listen((p0) {
      if (p0) {
        Navigator.pop(context);
      }
    });

    super.initState();
  }

  dialogContent(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
      height: 135,
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.sessionTrackBoxColor,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: GetX<VideoDownloadViewModel>(
        builder: (controller) => Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.asset(AppText.assets + AppText.downloadIcon, width: 30),
                emptyHorizontalBox(width: 10),
                const Text(
                  AppText.downloadPopupTitle,
                  style: TextStyle(
                      fontSize: 14, color: AppColors.downloadTitleColor),
                )
              ],
            ),
            emptyVerticalBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 7,
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                child: LinearProgressIndicator(
                  value: controller.progress,
                ),
              ),
            ),
            emptyVerticalBox(height: 5),
            Row(
              children: [
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      AppText.downloadPopupSubtitle,
                      style: TextStyle(
                          fontSize: 10, color: AppColors.downloadTitleColor),
                    )
                  ],
                )),
                Text(
                  controller.percent.toString() + "%",
                  textAlign: TextAlign.end,
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppColors.downloadPercentColor,
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 0.0,
      backgroundColor: Colors.white,
      child: dialogContent(context),
    );
  }
}
