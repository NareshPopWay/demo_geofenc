

// ignore_for_file: must_be_immutable

import 'package:demo_geofenc/Controller/home_controller.dart';
import 'package:demo_geofenc/change_lanuage.dart';
import 'package:demo_geofenc/Model/lat_long_model.dart';
import 'package:demo_geofenc/localization/language_constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends GetView<HomeController> {
   HomeScreen({super.key});

  HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
      appBar: AppBar(
        title:  Text(getTranslated(context, 'appTitle_text')!,
          style:  const TextStyle(
              color: Colors.blueGrey,
              fontSize: 25,
              fontWeight: FontWeight.w500
          ),
        ),
        actions:  [
          GestureDetector(
            onTap: (){
              Get.to(() => ChangeLanguageScreen());
            },
            child:  const Padding(
              padding: EdgeInsets.all(8.0),
              child:  Icon(
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: !controller.isInPremiseCheck.value ? TextButton(
                onPressed: (){
                  controller.checkPremisesEntry(context);
                },
                child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blueAccent ,
                      borderRadius: BorderRadius.circular(05),
                    ),
                    child:  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(getTranslated(context, 'btn_text')!,
                        style: const TextStyle(
                            color: Colors.white
                        ),
                      ),
                    ))): Column(
                      children: [
                        const CircularProgressIndicator(color: Colors.blueAccent,),
                        Text(getTranslated(context, 'loader_text')!,
                          style: const TextStyle(
                              color: Colors.blueAccent,
                              fontSize: 20,
                            fontWeight: FontWeight.w500
                          ),
                        ),
                      ],
                    ),
          )
        ],
      ),
    ));

  }
}
