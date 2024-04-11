// ignore_for_file: must_be_immutable, unrelated_type_equality_checks

import 'package:calendar_view/calendar_view.dart';
import 'package:demo_geofenc/Controller/week_view_Controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WeekViewScreen extends GetView<WeekViewController> {
  WeekViewScreen({super.key});

  WeekViewController controller = Get.put(WeekViewController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Week View"),
      ),
      body: Column(
        children: [
          Expanded(
            child: WeekView(
                controller: EventController(),
            
                eventTileBuilder: (date, events, boundry, start, end) {
                  // Return your widget to display as event tile.
                  return Container();
                },
                fullDayEventBuilder: (events, date) {
                  // Return your widget to display full day event view.
                  return Container();
                },
                showLiveTimeLineInAllDays: true, // To display live time line in all pages in week view.
                width: 350, // width of week view.
                minDay: DateTime(1990),
                maxDay: DateTime(2050),
                initialDay: DateTime(2024),
                heightPerMinute: 1, // height occupied by 1 minute time span.
                liveTimeIndicatorSettings: LiveTimeIndicatorSettings(color: Colors.blue),
                eventArranger: SideEventArranger(), // To define how simultaneous events will be arranged.
                onEventTap: (events, date) => print(events),
                onDateLongPress: (date) => print(date),
                startDay: WeekDays.monday,
                // To change the first day of the week.
                startHour: 5, // To set the first hour displayed (ex: 05:00)
                showVerticalLines: true, // Show the vertical line between days.
                // hourLinePainter: (lineColor, lineHeight, offset, minuteHeight, showVerticalLine, verticalLineOffset) {
                //   return //Your custom painter.
                // },
                weekPageHeaderBuilder: WeekHeader.hidden // To hide week header

            ),
          ),
        ],
      ),
    );
  }
}
