// ignore_for_file: must_be_immutable, unrelated_type_equality_checks

import 'package:demo_geofenc/Controller/change_language_controller.dart';
import 'package:demo_geofenc/Controller/home_controller.dart';
import 'package:demo_geofenc/Model/language_model.dart';
import 'package:demo_geofenc/Model/lat_long_model.dart';
import 'package:demo_geofenc/localization/language_constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChangeLanguageScreen extends GetView<ChangeLanguageController> {
  ChangeLanguageScreen({super.key});

  ChangeLanguageController controller = Get.put(ChangeLanguageController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(controller.selected.value == "en"
                ? "App Language"
                : controller.selected.value == "gu"
                    ? "એપ ની ભાષા"
                    : controller.selected.value == "hi"
                        ? "ऐप की भाषा"
                        : controller.selected.value == "mr"
                            ? "ॲप ची भाषा"
                            : "App Language"),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 15,
                        mainAxisSpacing: 15,
                        childAspectRatio: 1,
                      ),
                      itemCount: controller.languageList.length,
                      itemBuilder: (context, index) => Obx(() =>
                          GestureDetector(
                            onTap: () {
                              controller.selected.value =
                                  controller.languageList[index].languageCode;
                              controller.languageCode.value =
                                  controller.languageList[index].languageCode;
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                  color: controller.selected.value ==
                                          controller
                                              .languageList[index].languageCode
                                              .toString()
                                      ? Colors.green.shade50
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(25),
                                  border: Border.all(
                                      color: controller.selected.value ==
                                              controller.languageList[index]
                                                  .languageCode
                                                  .toString()
                                          ? Colors.green
                                          : Colors.grey),
                                ),
                                // margin: const EdgeInsets.all(20.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                        controller.selected.value ==
                                                controller.languageList[index]
                                                    .languageCode
                                                    .toString()
                                            ? Icons.check
                                            : Icons.language,
                                        size: 40.0,
                                        color: controller.selected.value ==
                                                controller.languageList[index]
                                                    .languageCode
                                                    .toString()
                                            ? Colors.green
                                            : Colors.blueGrey),
                                    const SizedBox(height: 10),
                                    Text(
                                      controller.languageList[index].name,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: controller.selected.value ==
                                                  controller.languageList[index]
                                                      .languageCode
                                                      .toString()
                                              ? Colors.green
                                              : Colors.blueGrey,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                )),
                          ))),
                ),
              ),
              GestureDetector(
                onTap: () {
                  controller.changeLanguage(context);
                },
                child: Container(
                  height: Get.height * 0.06,
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFFD30B42), Color(0xFFEE2F5A)])),
                  child: Center(
                    child: Text(
                      controller.selected.value == "en"
                          ? "Continue in English"
                          : controller.selected.value == "gu"
                              ? "ગુજરાતી મા શરૂ રખો"
                              : controller.selected.value == "hi"
                                  ? "हिंदी में जारी रखें"
                                  : controller.selected.value == "mr"
                                      ? "मराठीत सुरू ठेवा"
                                      : "Continue in English",
                      style: Get.textTheme.displayLarge!.copyWith(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ));
  }
}
