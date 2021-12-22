import 'timetable.entity.dart';

class TimeTableHour {
  TimeTableEntity _klasse = TimeTableEntity("", null);
  TimeTableEntity _teacher = TimeTableEntity("", null);
  TimeTableEntity _subject = TimeTableEntity("", null);
  TimeTableEntity _room = TimeTableEntity("", null);

  String _activityType = "";
  int _id = -1;
  DateTime start = DateTime(0);
  DateTime end = DateTime(0);

  String code = "regular";

  ///Der Stundenindex beschreibt die Stunde am Tag. z.B. hourIndex 1 wäre die erste Stunde um 8:00 Uhr
  int hourIndex = -1;

  DateTime _parseDate(String date, String time) {
    return DateTime.parse(date.substring(0, 4) +
        "-" +
        date.substring(4, 6) +
        "-" +
        date.substring(6, 8) +
        " " +
        (time.length == 3
            ? "0" + time.substring(0, 1) + ":" + time.substring(1) + ":00"
            : time.substring(0, 2) + ":" + time.substring(2) + ":00"));
  }

  String getActivityType() {
    return _activityType;
  }

  int getId() {
    return _id;
  }

  DateTime getStartTime() {
    return start;
  }

  DateTime getEndTime() {
    return end;
  }

  ///@return Die Klasse der Stunde als TimeTableEntity objekt
  TimeTableEntity getClazz() {
    return _klasse;
  }

  ///@return Der Lehrer der Stunde als TimeTableEntity objekt
  TimeTableEntity getTeacher() {
    return _teacher;
  }

  ///@return Das Fach der Stunde als TimeTableEntity objekt
  TimeTableEntity getSubject() {
    return _subject;
  }

  ///@return Der Raum der Stunde als TimeTableEntity objekt
  TimeTableEntity getRoom() {
    return _room;
  }

  TimeTableHour(dynamic data) {
    _id = data['id'];

    start = _parseDate(data['date'].toString(), data['startTime'].toString());
    end = _parseDate(data['date'].toString(), data['endTime'].toString());

    _activityType = data['activityType'];

    if (data['k1'] != null) {
      _klasse = TimeTableEntity("kl", data['kl']);
    } else {
      _klasse = TimeTableEntity("kl", null);
      _klasse.longName = "unknown";
      _klasse.name = "unknown";
    }

    if (data['te'] != null) {
      _teacher = TimeTableEntity("te", data['te']);
    } else {
      _teacher.name = "---";
      _teacher.longName = "Ausfall/SOL/Vertretung";
    }

    _subject = TimeTableEntity("su", data['su']);

    _room = TimeTableEntity("ro", data['ro']);

    if (data['code'] != null) {
      code = data['code'];
    }
  }

  ///Der Titel der Stunde. Im Format HH:mm - HH:mm
  String getTitle() {
    return (start.hour < 10 ? "0" + start.hour.toString() : start.hour.toString()) +
        ":" +
        (start.minute < 10 ? "0" + start.minute.toString() : start.minute.toString()) +
        " - " +
        (end.hour < 10 ? "0" + end.hour.toString() : end.hour.toString()) +
        ":" +
        (end.minute < 10 ? "0" + end.minute.toString() : end.minute.toString());
  }
}
