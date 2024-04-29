// ignore_for_file: must_be_immutable, unrelated_type_equality_checks

// import 'package:calendar_view/calendar_view.dart';
import 'package:demo_geofenc/Controller/week_view_Controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

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
      // body: Column(
      //   children: [
      //     Expanded(
      //       child: WeekView(
      //           controller: EventController(),
      //           eventTileBuilder: (date, events, boundry, start, end) {
      //             // Return your widget to display as event tile.
      //             return Container();
      //           },
      //           fullDayEventBuilder: (events,
      //               date) {
      //             // Return your widget to display full day event view.
      //             return Container();
      //           },
      //           showLiveTimeLineInAllDays: true, // To display live time line in all pages in week view.
      //           width: 350, // width of week view.
      //           minDay: DateTime(1990),
      //           maxDay: DateTime(2050),
      //           initialDay: DateTime.now(),
      //           heightPerMinute: 1, // height occupied by 1 minute time span.
      //           liveTimeIndicatorSettings: const LiveTimeIndicatorSettings(color: Colors.blue),
      //           eventArranger: const SideEventArranger(), // To define how simultaneous events will be arranged.
      //           onEventTap: (events, date) => print(events),
      //           onDateLongPress: (date) => print(date),
      //           startDay: WeekDays.monday, // To change the first day of the week.
      //           startHour: 8, // To set the first hour displayed (ex: 05:00)
      //           showVerticalLines: true, // Show the vertical line between days.
      //
      //           // hourLinePainter: (lineColor, lineHeight, offset, minuteHeight, showVerticalLine, verticalLineOffset) {
      //           //   return //Your custom painter.
      //           // },
      //           weekPageHeaderBuilder: WeekHeader.hidden // To hide week header
      //
      //       ),
      //     ),
      //   ],
      // ),
      body: SfCalendar(
        view: CalendarView.month,
        dataSource: MeetingDataSource(_getDataSource()),
        monthViewSettings: MonthViewSettings(
            appointmentDisplayMode: MonthAppointmentDisplayMode.appointment),
      ),
    );
  }
  List<Meeting> _getDataSource() {
    final List<Meeting> meetings = <Meeting>[];
    final DateTime today = DateTime.now();
    final DateTime startTime =
    DateTime(today.year, today.month, today.day, 9, 0, 0);
    final DateTime endTime = startTime.add(const Duration(hours: 2));
    meetings.add(
        Meeting('Conference', startTime, endTime, const Color(0xFF0F8644), false));
    return meetings;
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> source){
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].to;
  }

  @override
  String getSubject(int index) {
    return appointments![index].eventName;
  }

  @override
  Color getColor(int index) {
    return appointments![index].background;
  }

  @override
  bool isAllDay(int index) {
    return appointments![index].isAllDay;
  }
}

class Meeting {
  Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay);

  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
}

