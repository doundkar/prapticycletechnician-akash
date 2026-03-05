class ReportModel {
  int? year;
  int? month;
  String? monthName;
  int? weeklyOffDay;
  Summary? summary;
  List<Days>? days;

  ReportModel(
      {this.year,
      this.month,
      this.monthName,
      this.weeklyOffDay,
      this.summary,
      this.days});

  ReportModel.fromJson(Map<String, dynamic> json) {
    year = json['year'];
    month = json['month'];
    monthName = json['month_name'];
    weeklyOffDay = json['weekly_off_day'];
    summary =
        json['summary'] != null ? new Summary.fromJson(json['summary']) : null;
    if (json['days'] != null) {
      days = <Days>[];
      json['days'].forEach((v) {
        days!.add(new Days.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['year'] = this.year;
    data['month'] = this.month;
    data['month_name'] = this.monthName;
    data['weekly_off_day'] = this.weeklyOffDay;
    if (this.summary != null) {
      data['summary'] = this.summary!.toJson();
    }
    if (this.days != null) {
      data['days'] = this.days!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Summary {
  int? present;
  int? absent;
  int? halfDay;
  int? holiday;
  int? weekoff;
  int? leave;
  int? workedMinutes;
  int? totalDays;

  Summary(
      {this.present,
      this.absent,
      this.halfDay,
      this.holiday,
      this.weekoff,
      this.leave,
      this.workedMinutes,
      this.totalDays});

  Summary.fromJson(Map<String, dynamic> json) {
    present = json['present'];
    absent = json['absent'];
    halfDay = json['half_day'];
    holiday = json['holiday'];
    weekoff = json['weekoff'];
    leave = json['leave'];
    workedMinutes = json['worked_minutes'];
    totalDays = json['total_days'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['present'] = this.present;
    data['absent'] = this.absent;
    data['half_day'] = this.halfDay;
    data['holiday'] = this.holiday;
    data['weekoff'] = this.weekoff;
    data['leave'] = this.leave;
    data['worked_minutes'] = this.workedMinutes;
    data['total_days'] = this.totalDays;
    return data;
  }
}

class Days {
  String? date;
  String? dayName;
  int? dayOfWeek;
  bool? isFuture;
  String? dayType;
  String? status;
  String? holidayTitle;
  String? checkInAt;
  String? checkOutAt;
  int? workedMinutes;
  bool? isOverridden;
  String? notes;

  Days(
      {this.date,
      this.dayName,
      this.dayOfWeek,
      this.isFuture,
      this.dayType,
      this.status,
      this.holidayTitle,
      this.checkInAt,
      this.checkOutAt,
      this.workedMinutes,
      this.isOverridden,
      this.notes});

  Days.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    dayName = json['day_name'];
    dayOfWeek = json['day_of_week'];
    isFuture = json['is_future'];
    dayType = json['day_type'];
    status = json['status'];
    holidayTitle = json['holiday_title'];
    checkInAt = json['check_in_at'];
    checkOutAt = json['check_out_at'];
    workedMinutes = json['worked_minutes'];
    isOverridden = json['is_overridden'];
    notes = json['notes'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['day_name'] = this.dayName;
    data['day_of_week'] = this.dayOfWeek;
    data['is_future'] = this.isFuture;
    data['day_type'] = this.dayType;
    data['status'] = this.status;
    data['holiday_title'] = this.holidayTitle;
    data['check_in_at'] = this.checkInAt;
    data['check_out_at'] = this.checkOutAt;
    data['worked_minutes'] = this.workedMinutes;
    data['is_overridden'] = this.isOverridden;
    data['notes'] = this.notes;
    return data;
  }
}
