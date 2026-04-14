class SalarySlipModel {
  int? year;
  int? month;
  String? monthName;
  bool? isGenerated;
  Technician? technician;
  Attendance? attendance;
  SalarySlip? salarySlip;
  String? pdfUrl;

  SalarySlipModel(
      {this.year,
      this.month,
      this.monthName,
      this.isGenerated,
      this.technician,
      this.attendance,
      this.salarySlip,
      this.pdfUrl});

  SalarySlipModel.fromJson(Map<String, dynamic> json) {
    year = json['year'];
    month = json['month'];
    monthName = json['month_name'];
    isGenerated = json['is_generated'];
    technician = json['technician'] != null
        ? new Technician.fromJson(json['technician'])
        : null;
    attendance = json['attendance'] != null
        ? new Attendance.fromJson(json['attendance'])
        : null;
    salarySlip = json['salary_slip'] != null
        ? new SalarySlip.fromJson(json['salary_slip'])
        : null;
    pdfUrl = json['pdf_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['year'] = this.year;
    data['month'] = this.month;
    data['month_name'] = this.monthName;
    data['is_generated'] = this.isGenerated;
    if (this.technician != null) {
      data['technician'] = this.technician!.toJson();
    }
    if (this.attendance != null) {
      data['attendance'] = this.attendance!.toJson();
    }
    if (this.salarySlip != null) {
      data['salary_slip'] = this.salarySlip!.toJson();
    }
    data['pdf_url'] = this.pdfUrl;
    return data;
  }
}

class Technician {
  int? id;
  String? name;
  String? phone;
  String? email;
  String? dateOfJoining;

  Technician({this.id, this.name, this.phone, this.email, this.dateOfJoining});

  Technician.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    phone = json['phone'];
    email = json['email'];
    dateOfJoining = json['date_of_joining'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['date_of_joining'] = this.dateOfJoining;
    return data;
  }
}

class Attendance {
  Summary? summary;
  int? workedMinutes;
  int? totalDays;

  Attendance({this.summary, this.workedMinutes, this.totalDays});

  Attendance.fromJson(Map<String, dynamic> json) {
    summary =
        json['summary'] != null ? new Summary.fromJson(json['summary']) : null;
    workedMinutes = json['worked_minutes'];
    totalDays = json['total_days'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.summary != null) {
      data['summary'] = this.summary!.toJson();
    }
    data['worked_minutes'] = this.workedMinutes;
    data['total_days'] = this.totalDays;
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

  Summary(
      {this.present,
      this.absent,
      this.halfDay,
      this.holiday,
      this.weekoff,
      this.leave});

  Summary.fromJson(Map<String, dynamic> json) {
    present = json['present'];
    absent = json['absent'];
    halfDay = json['half_day'];
    holiday = json['holiday'];
    weekoff = json['weekoff'];
    leave = json['leave'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['present'] = this.present;
    data['absent'] = this.absent;
    data['half_day'] = this.halfDay;
    data['holiday'] = this.holiday;
    data['weekoff'] = this.weekoff;
    data['leave'] = this.leave;
    return data;
  }
}

class SalarySlip {
  String? title;
  String? generatedAt;
  List<Earnings>? earnings;
  int? grossEarnings;
  int? totalDeductions;
  int? netPay;
  String? notes;

  SalarySlip(
      {this.title,
      this.generatedAt,
      this.earnings,
      this.grossEarnings,
      this.totalDeductions,
      this.netPay,
      this.notes});

  SalarySlip.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    generatedAt = json['generated_at'];
    if (json['earnings'] != null) {
      earnings = <Earnings>[];
      json['earnings'].forEach((v) {
        earnings!.add(new Earnings.fromJson(v));
      });
    }
    grossEarnings = json['gross_earnings'];
    totalDeductions = json['total_deductions'];
    netPay = json['net_pay'];
    notes = json['notes'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['generated_at'] = this.generatedAt;
    if (this.earnings != null) {
      data['earnings'] = this.earnings!.map((v) => v.toJson()).toList();
    }
    data['gross_earnings'] = this.grossEarnings;
    data['total_deductions'] = this.totalDeductions;
    data['net_pay'] = this.netPay;
    data['notes'] = this.notes;
    return data;
  }
}

class Earnings {
  String? key;
  String? label;
  int? amount;

  Earnings({this.key, this.label, this.amount});

  Earnings.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    label = json['label'];
    amount = json['amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['key'] = this.key;
    data['label'] = this.label;
    data['amount'] = this.amount;
    return data;
  }
}
