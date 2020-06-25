class Routine {

  String startTime, endTime, title;
  bool status = false;

  Routine({this.startTime, this.endTime, this.title, this.status});

  Map<String, dynamic> toMap() {

    return{
      'start_Time': startTime,
      'end_Time': endTime,
      'title': title,
      'status': status.toString(),
    };
  }
}

class RoutineList{

  List<Routine> routineList = [
    Routine(startTime: '4:00 AM', endTime: '5:00 AM', title: '', status: false),
    Routine(startTime: '5:00 AM', endTime: '6:00 AM', title: '', status: false),
    Routine(startTime: '6:00 AM', endTime: '7:00 AM', title: '', status: false),
    Routine(startTime: '7:00 AM', endTime: '8:00 AM', title: '', status: false),
    Routine(startTime: '8:00 AM', endTime: '9:00 AM', title: '', status: false),
    Routine(startTime: '9:00 AM', endTime: '10:00 AM', title: '', status: false),
    Routine(startTime: '10:00 AM', endTime: '11:00 AM', title: '', status: false),
    Routine(startTime: '11:00 PM', endTime: '12:00 PM', title: '', status: false),
    Routine(startTime: '12:00 PM', endTime: '1:00 PM', title: '', status: false),
    Routine(startTime: '1:00 PM', endTime: '2:00 PM', title: '', status: false),
    Routine(startTime: '2:00 PM', endTime: '3:00 PM', title: '', status: false),
    Routine(startTime: '3:00 PM', endTime: '4:00 PM', title: '', status: false),
    Routine(startTime: '4:00 PM', endTime: '5:00 PM', title: '', status: false),
    Routine(startTime: '5:00 PM', endTime: '6:00 PM', title: '', status: false),
    Routine(startTime: '6:00 PM', endTime: '7:00 PM', title: '', status: false),
    Routine(startTime: '7:00 PM', endTime: '8:00 PM', title: '', status: false),
    Routine(startTime: '8:00 PM', endTime: '9:00 PM', title: '', status: false),
    Routine(startTime: '9:00 PM', endTime: '10:00 PM', title: '', status: false),
    Routine(startTime: '10:00 PM', endTime: '11:00 PM', title: '', status: false),
    Routine(startTime: '11:00 PM', endTime: '12:00 PM', title: '', status: false)];
  List<Routine> getList() {

    return routineList;
  }
}