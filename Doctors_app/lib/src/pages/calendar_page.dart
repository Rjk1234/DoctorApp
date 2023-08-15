import 'package:flutter/material.dart';
import 'package:flutter_healthcare_app/src/theme/light_color.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_healthcare_app/src/config/utils.dart';
import 'event_view_page.dart';

class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late final ValueNotifier<List<Event>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOff; // Can be toggled on/off by longpressing a date
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  List<Event> _getEventsForDay(DateTime day) {
    return kEvents[day] ?? [];
  }

  List<Event> _getEventsForRange(DateTime start, DateTime end) {
    final days = daysInRange(start, end);

    return [
      for (final d in days) ..._getEventsForDay(d),
    ];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeStart = null; // Important to clean those
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });

      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    setState(() {
      _selectedDay = null;
      _focusedDay = focusedDay;
      _rangeStart = start;
      _rangeEnd = end;
      _rangeSelectionMode = RangeSelectionMode.toggledOn;
    });

    // `start` or `end` could be null
    if (start != null && end != null) {
      _selectedEvents.value = _getEventsForRange(start, end);
    } else if (start != null) {
      _selectedEvents.value = _getEventsForDay(start);
    } else if (end != null) {
      _selectedEvents.value = _getEventsForDay(end);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: LightColor.purple,
        title: Text('Calendar - Events'),
      ),
      body: Column(
        children: [
          _getCalendarWidget(context),
          const SizedBox(height: 10.0),
          _getEventHeader(context),
          const SizedBox(height: 10.0),
          _getEventsList(),
        ],
      ),
    );
  }

  Expanded _getEventsList() {
    return Expanded(
      child: ValueListenableBuilder<List<Event>>(
        valueListenable: _selectedEvents,
        builder: (context, value, _) {
          return ListView.builder(
            itemCount: value.length,
            itemBuilder: (context, index) {
              return Container(
                  padding: EdgeInsets.all(15),
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        offset: Offset(4, 4),
                        blurRadius: 10,
                        color: LightColor.grey.withOpacity(.2),
                      ),
                      BoxShadow(
                        offset: Offset(-3, 0),
                        blurRadius: 15,
                        color: LightColor.grey.withOpacity(.1),
                      )
                    ],
                  ),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(value[index].title),
                          Text(value[index].time),
                        ],
                      ),
                      Spacer(),
                      if (value[index].isCircular) ...[
                        Icon(
                          Icons.refresh_rounded,
                          color: LightColor.purple,
                          size: 30,
                        )
                      ],
                      if (!value[index].upcoming) ...[
                        Container(
                            height: 40,
                            width: 90,
                            child: Center(
                                child: Text(
                              'Cancelled',
                              style: TextStyle(
                                  color: Colors.red.withOpacity(0.8),
                                  fontWeight: FontWeight.bold),
                            )))
                      ]
                    ],
                  ));
            },
          );
        },
      ),
    );
  }

  Padding _getEventHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Row(
        children: [
          Text('All Events',
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold)),
          Spacer(),
          ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(LightColor.purple)),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EventViewPage()),
                );
              },
              child: Text('Day'))
        ],
      ),
    );
  }

  Container _getCalendarWidget(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: <BoxShadow>[
          BoxShadow(
            offset: Offset(4, 4),
            blurRadius: 10,
            color: LightColor.grey.withOpacity(.2),
          ),
          BoxShadow(
            offset: Offset(-3, 0),
            blurRadius: 15,
            color: LightColor.grey.withOpacity(.1),
          )
        ],
      ),
      margin: EdgeInsets.all(20),
      padding: EdgeInsets.all(10),
      child: TableCalendar<Event>(
        headerStyle: HeaderStyle(
            formatButtonDecoration: const BoxDecoration(
                color: LightColor.extraLightBlue,
                border: const Border.fromBorderSide(
                    BorderSide(color: LightColor.extraLightBlue)),
                borderRadius: const BorderRadius.all(Radius.circular(8.0))),
            titleTextStyle: TextStyle(
                fontSize: 17,
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.w800)),
        calendarStyle: CalendarStyle(
            outsideDaysVisible: false,
            todayTextStyle: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold)),
        calendarBuilders: CalendarBuilders(
          markerBuilder: (context, day, events) {
            if (events.length == 0) {
              return null;
            } else {
              return Container(
                height: 10,
                width: 10,
                decoration: BoxDecoration(
                    color: LightColor.iconColor,
                    borderRadius: BorderRadius.circular(5.0)),
                margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
              );
            }
          },
          selectedBuilder: (context, date, events) => Container(
              margin: const EdgeInsets.all(4.0),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(10.0)),
              child: Text(
                date.day.toString(),
                style: TextStyle(color: Colors.white),
              )),
          todayBuilder: (context, date, events) => Container(
              margin: const EdgeInsets.all(4.0),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: LightColor.extraLightBlue,
                  borderRadius: BorderRadius.circular(10.0)),
              child: Text(
                date.day.toString(),
                style: TextStyle(color: Theme.of(context).primaryColor),
              )),
        ),
        firstDay: kFirstDay,
        lastDay: kLastDay,
        focusedDay: _focusedDay,
        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
        rangeStartDay: _rangeStart,
        rangeEndDay: _rangeEnd,
        calendarFormat: _calendarFormat,
        rangeSelectionMode: _rangeSelectionMode,
        eventLoader: _getEventsForDay,
        startingDayOfWeek: StartingDayOfWeek.monday,
        onDaySelected: _onDaySelected,
        onRangeSelected: _onRangeSelected,
        onFormatChanged: (format) {
          if (_calendarFormat != format) {
            setState(() {
              _calendarFormat = format;
            });
          }
        },
        onPageChanged: (focusedDay) {
          _focusedDay = focusedDay;
        },
      ),
    );
  }
}
