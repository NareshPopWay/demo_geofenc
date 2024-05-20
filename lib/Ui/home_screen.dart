// ignore_for_file: must_be_immutable

import 'package:demo_geofenc/Controller/home_controller.dart';
import 'package:demo_geofenc/Ui/calander/week_view.dart';
import 'package:demo_geofenc/Ui/qr_scanner.dart';
import 'package:demo_geofenc/common/localization/language_constant.dart';
import 'package:demo_geofenc/ui/change_lanuage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simple_speed_dial/simple_speed_dial.dart';

class HomeScreen extends GetView<HomeController> {
  HomeScreen({super.key});

  HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          appBar: AppBar(
            title: Text(
              getTranslated(context, 'appTitle_text')!,
              style: const TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 25,
                  fontWeight: FontWeight.w500),
            ),
            actions: [
              GestureDetector(
                onTap: () {
                  Get.to(() => ChangeLanguageScreen());
                },
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.g_translate,
                    color: Colors.blueGrey,
                    size: 40,
                  ),
                  // Row(
                  //   children: [
                  //     Text(getTranslated(context, 'action_text')!,
                  //       style:  const TextStyle(
                  //           color: Colors.blueGrey,
                  //           fontSize: 20,
                  //           fontWeight: FontWeight.w500
                  //       ),
                  //     ),
                  //     const SizedBox(width: 05),
                  //     const Icon(
                  //       Icons.g_translate,
                  //       color: Colors.blueGrey,
                  //     ),
                  //   ],
                  // ),
                ),
              ),
            ],
          ),
      floatingActionButton: SpeedDial(
        child: const Icon(Icons.add),
        closedForegroundColor: Colors.white,
        closedBackgroundColor: Colors.blueGrey,
        openForegroundColor: Colors.blueGrey,
        openBackgroundColor: Colors.white,
        // labelsStyle: /* Your label TextStyle goes here */,
        labelsBackgroundColor: Colors.white,
        // controller: /* Your custom animation controller goes here */,
        speedDialChildren: <SpeedDialChild>[
          SpeedDialChild(
            child: const Icon(Icons.qr_code_scanner_outlined),
            foregroundColor: Colors.white,
            backgroundColor: Colors.blueGrey,
            label: 'Qr Scanner',
            onPressed: () {
               // Get.back();
              Get.to(() => ScannerScreen());
            },
          ),
          SpeedDialChild(
            child: const Icon(Icons.calendar_view_week),
            foregroundColor: Colors.white,
            backgroundColor: Colors.blueGrey,
            label: 'Weekly Calendar',
            onPressed: () {
              Get.to(() => WeekViewScreen());

            },
          ),
          SpeedDialChild(
            child: const Icon(Icons.calendar_view_day),
            foregroundColor: Colors.white,
            backgroundColor: Colors.blueGrey,
            label: 'Daily Calendar ',
            onPressed: () {

            },
          ),
          //  Your other SpeedDialChildren go here.
        ],
      ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: !controller.isInPremiseCheck.value
                    ? TextButton(
                        onPressed: () {
                          controller.checkPremisesEntry(context);
                        },
                        child: Container(
                            decoration: BoxDecoration(
                              color: Colors.blueAccent,
                              borderRadius: BorderRadius.circular(05),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                getTranslated(context, 'btn_text')!,
                                style: const TextStyle(color: Colors.white),
                              ),
                            )))
                    : Column(
                        children: [
                          const CircularProgressIndicator(
                            color: Colors.blueAccent,
                          ),
                          Text(
                            getTranslated(context, 'loader_text')!,
                            style: const TextStyle(
                                color: Colors.blueAccent,
                                fontSize: 20,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
              )
            ],
          ),
        ));
  }
}
