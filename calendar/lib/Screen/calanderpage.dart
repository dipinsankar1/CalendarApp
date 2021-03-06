import 'package:flutter/material.dart';
import 'package:device_calendar/device_calendar.dart';

class CalendarPage extends StatefulWidget {
  // Function _calendarCallback;

  // CalendarPage(this._calendarCallback);

  @override
  CalendarPageState createState() {
    return CalendarPageState();
  }
}

class CalendarPageState extends State<CalendarPage> {
  DeviceCalendarPlugin _deviceCalendarPlugin = DeviceCalendarPlugin();

  late List<Calendar> _calendars;
  late Calendar _selectedCalendar;

  @override
  initState() {
    super.initState();
    _retrieveCalendars();
  }

  @override
  Widget build(BuildContext context) {
    //Scaffold shows a list of the users calendars that can be selected by the
    //user
    //After a calendar is selected, calendar info is sent back to main page
    //via calenderCallback function
    return Scaffold(
      body: Column(
        children: <Widget>[
          Text('Select Calendar'),
          ConstrainedBox(
            constraints: BoxConstraints(maxHeight: 150.0),
            child: ListView.builder(
              itemCount: _calendars?.length ?? 0,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedCalendar = _calendars[index];
                      // this.widget._calendarCallback(_selectedCalendar.id, _selectedCalendar.name, _deviceCalendarPlugin);
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Text(
                            _selectedCalendar.name.toString(),
                            style: TextStyle(fontSize: 25.0),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _retrieveCalendars() async {
    //Retrieve user's calendars from mobile device
    //Request permissions first if they haven't been granted
    try {
      var permissionsGranted = await _deviceCalendarPlugin.hasPermissions();
      if (permissionsGranted.isSuccess) {
        permissionsGranted = await _deviceCalendarPlugin.requestPermissions();
        if (!permissionsGranted.isSuccess) {
          return;
        }
      }

      final calendarsResult = await _deviceCalendarPlugin.retrieveCalendars();
      setState(() {
        _calendars = calendarsResult?.data as List<Calendar>;
      });
    } catch (e) {
      print(e);
    }
  }
}
