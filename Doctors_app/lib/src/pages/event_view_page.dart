import 'package:flutter/material.dart';
import 'package:calendar_view/calendar_view.dart';
import 'package:flutter_healthcare_app/src/config/utils.dart';
import 'package:intl/intl.dart';

import '../theme/light_color.dart';

class EventViewPage extends StatefulWidget {
  const EventViewPage({Key? key}) : super(key: key);

  @override
  State<EventViewPage> createState() => _EventViewPageState();
}

class _EventViewPageState extends State<EventViewPage> {
  @override
  Widget build(BuildContext context) {
    return CalendarControllerProvider<Event>(
      controller: EventController<Event>()..addAll(_events),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: LightColor.purple,
          title: Text('Day - Events'),
        ),
        body: DayViewWidget(),
      ),
    );
  }
}

class DayViewWidget extends StatelessWidget {
  final GlobalKey<DayViewState>? state;
  final double? width;

  const DayViewWidget({
    Key? key,
    this.state,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 10),
      child: DayView<Event>(
        headerStyle: HeaderStyle(
          headerTextStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          headerMargin: EdgeInsets.all(10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: LightColor.extraLightBlue),
        ),
        dateStringBuilder: (date, {secondaryDate}) {
          return "${date.day} ${DateFormat("MMM").format(date)} ${date.year}";
        },
        key: state,
        width: width,
        startDuration: Duration(hours: 8),
        showHalfHours: true,
        heightPerMinute: 1,
        timeLineBuilder: _timeLineBuilder,
        hourIndicatorSettings: HourIndicatorSettings(
          color: Theme.of(context).dividerColor,
        ),
        halfHourIndicatorSettings: HourIndicatorSettings(
          color: Theme.of(context).dividerColor,
          lineStyle: LineStyle.dashed,
        ),
        eventTileBuilder: _customEventTileBuilder,
      ),
    );
  }

  Widget _customEventTileBuilder(
    DateTime date,
    List<CalendarEventData<Event>> events,
    Rect boundary,
    DateTime startDuration,
    DateTime endDuration,
  ) {
    if (events.isNotEmpty) {
      return RoundedEventTile(
        borderRadius: BorderRadius.circular(10.0),
        title: events[0].title,
        totalEvents: events.length - 1,
        description: events[0].description,
        padding: EdgeInsets.all(10.0),
        backgroundColor: LightColor.purpleLight,
        margin: EdgeInsets.all(2.0),
        titleStyle: TextStyle(color: Colors.white, fontSize: 15),
        descriptionStyle: TextStyle(color: Colors.white, fontSize: 13),
      );
    } else
      return SizedBox.shrink();
  }

  Widget _timeLineBuilder(DateTime date) {
    if (date.minute != 0) {
      return Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            top: -8,
            right: 8,
            child: Text(
              "${date.hour}:${date.minute}",
              textAlign: TextAlign.right,
              style: TextStyle(
                color: Colors.black.withAlpha(50),
                fontStyle: FontStyle.italic,
                fontSize: 12,
              ),
            ),
          ),
        ],
      );
    }

    final hour = ((date.hour - 1) % 12) + 1;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned.fill(
          top: -8,
          right: 8,
          child: Text(
            "$hour ${date.hour ~/ 12 == 0 ? "am" : "pm"}",
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}

DateTime get _now => DateTime.now();

List<CalendarEventData<Event>> _events = [
  CalendarEventData(
    date: _now,
    event: Event("Check-up Camp", "11AM - 3PM", false, true),
    title: "Check-up Camp",
    description: "General Checkup camp at Hospital assembly.",
    startTime: DateTime(_now.year, _now.month, _now.day, 18, 30),
    endTime: DateTime(_now.year, _now.month, _now.day, 22),
  ),
  CalendarEventData(
    date: _now.add(Duration(days: 1)),
    startTime: DateTime(_now.year, _now.month, _now.day, 18),
    endTime: DateTime(_now.year, _now.month, _now.day, 19),
    event: Event("Monthly Meeting", "11AM - 3PM", false, true),
    title: "Monthly meeting",
    description: "General Monthly meeting with Directors",
  ),
  CalendarEventData(
    date: _now,
    startTime: DateTime(_now.year, _now.month, _now.day, 14),
    endTime: DateTime(_now.year, _now.month, _now.day, 17),
    event: Event("Joe's assistance", "4PM - 5PM", false, true),
    title: "Dr. Joe's assistance",
    description: " Dr. Joe's assistance for Raya's case study",
  ),
  CalendarEventData(
    date: _now,
    startTime: DateTime(_now.year, _now.month, _now.day, 15),
    endTime: DateTime(_now.year, _now.month, _now.day, 17),
    event: Event("Meetup", "4PM - 5PM", false, true),
    title: "General meetup",
    description: "Go to meetup",
  ),
  CalendarEventData(
    date: _now.add(Duration(days: 3)),
    startTime: DateTime(_now.add(Duration(days: 3)).year,
        _now.add(Duration(days: 3)).month, _now.add(Duration(days: 3)).day, 10),
    endTime: DateTime(_now.add(Duration(days: 3)).year,
        _now.add(Duration(days: 3)).month, _now.add(Duration(days: 3)).day, 14),
    event: Event("Sprint Meeting.", "10AM - 10:30AM", false, true),
    title: "Sprint Meeting.",
    description: "Last day of project submission for last year.",
  ),
  CalendarEventData(
    date: _now.subtract(Duration(days: 2)),
    startTime: DateTime(
        _now.subtract(Duration(days: 2)).year,
        _now.subtract(Duration(days: 2)).month,
        _now.subtract(Duration(days: 2)).day,
        14),
    endTime: DateTime(
        _now.subtract(Duration(days: 2)).year,
        _now.subtract(Duration(days: 2)).month,
        _now.subtract(Duration(days: 2)).day,
        16),
    event: Event("Team Meeting", "1PM - 3PM", false, true),
    title: "Team Meeting",
    description: "Team Meeting",
  ),
  CalendarEventData(
    date: _now.subtract(Duration(days: 2)),
    startTime: DateTime(
        _now.subtract(Duration(days: 2)).year,
        _now.subtract(Duration(days: 2)).month,
        _now.subtract(Duration(days: 2)).day,
        10),
    endTime: DateTime(
        _now.subtract(Duration(days: 2)).year,
        _now.subtract(Duration(days: 2)).month,
        _now.subtract(Duration(days: 2)).day,
        12),
    event: Event("Raya's Blood work", "11AM - 12PM", false, true),
    title: "Raya's Blood work",
    description: "Raya's Blood work",
  ),
];
