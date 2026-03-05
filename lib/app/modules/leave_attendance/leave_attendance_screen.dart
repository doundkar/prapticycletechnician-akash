import 'package:bicycle_app_technician/app/modules/leave_attendance/leave_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:bicycle_app_technician/view/widgets/custom_app_bar.dart';
import 'package:bicycle_app_technician/view/widgets/custom_button.dart';
import 'package:bicycle_app_technician/view/Colors/app_colors.dart';

class LeavesAttendanceScreen extends StatefulWidget {
  const LeavesAttendanceScreen({super.key});

  @override
  State<LeavesAttendanceScreen> createState() => _LeavesAttendanceScreenState();
}

class _LeavesAttendanceScreenState extends State<LeavesAttendanceScreen> {
  LeaveController controller = Get.find();

  late DateTime focusedDay;
  // DateTime? selectedDay;

  late final Set<DateTime> absentDays ;

  late final Set<DateTime> presentDays ;

  final Set<DateTime> leaveDays = {DateTime(2025, 9, 23)};

  final TextEditingController reasonController = TextEditingController(
    text: "Not well today",
  );

  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    focusedDay = DateTime(now.year,now.month,now.day);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Leaves & Attendance"),

      body: Obx(() {
        if(controller.isLoading.value){
          return Center(
            child: SizedBox(
              height: 30,
              width: 30,
              child: CircularProgressIndicator(strokeWidth: 2,color: AppColors.blue,),
            ),
          );
        }
        if(controller.hasError.value){
          return Center(
            child: Text(controller.errorMessage.value,style: TextStyle(fontSize: 26,color: Colors.red),),
          );
        }
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// CALENDAR CARD
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.white,
                  border: Border.all(color: Color.fromRGBO(232, 232, 232, 1)),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.15),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: TableCalendar(
                  firstDay: DateTime(2020),
                  lastDay: DateTime(2030),
                  focusedDay: focusedDay,
                  selectedDayPredicate: (day) => isSameDay(focusedDay, day),
                  // onDaySelected: (selected, focused) {
                  //   setState(() {
                  //     // selectedDay = selected;
                  //     focusedDay = focused;
                  //   });
                  // },
                  headerStyle: const HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                  ),
                  calendarStyle: CalendarStyle(
                    todayDecoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      shape: BoxShape.circle,
                    ),
                    selectedDecoration: const BoxDecoration(
                      color: Colors.purple,
                      shape: BoxShape.circle,
                    ),
                    markerDecoration: const BoxDecoration(
                      color: Colors.transparent,
                    ),
                  ),
                  calendarBuilders: CalendarBuilders(
                    defaultBuilder: (context, day, _) {
                      if (_isSameDay(day, controller.absentDays.value)) {
                        return _buildCircleDay(day.day, Colors.red);
                      } else if (_isSameDay(day, controller.presentDays.value)) {
                        return _buildCircleDay(day.day, Colors.green);
                      } else if (_isSameDay(day, leaveDays)) {
                        return _buildCircleDay(day.day, Colors.purple);
                      }
                      return null;
                    },
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// ABSENT CARD
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Color.fromRGBO(251, 251, 251, 1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Color.fromRGBO(221, 221, 221, 1)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Absent",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        Icon(Icons.expand_more),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      "2 days (sept 25)",
                      style: TextStyle(color: Colors.grey),
                    ),
                    Divider(),
                    SizedBox(height: 8),
                    Text("Sat 4 Sept 2025"),
                    SizedBox(height: 6),
                    Text("Tue 14 Sept 2025"),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              /// LEAVE APPLICATION
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    "Leave Application",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                  Icon(Icons.add_circle_outline, color: Colors.blue),
                ],
              ),

              const SizedBox(height: 12),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Color.fromRGBO(251, 251, 251, 1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Color.fromRGBO(221, 221, 221, 1)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Reason", style: TextStyle(color: Colors.grey)),
                    const SizedBox(height: 6),

                    TextField(
                      controller: reasonController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    Row(
                      children: [
                        Expanded(
                          child: _dateField("Start Date", "Sep 23, 2025"),
                        ),
                        const SizedBox(width: 12),
                        Expanded(child: _dateField("End Date", "Sep 23, 2025")),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              /// APPLY BUTTON (NOT bottomNavBar)
              CustomButton(
                text: "Apply for Leave",
                textSize: 16,
                textWeight: FontWeight.w600,
                textColor: Colors.white,
                bgColor: AppColors.blue,
                radius: 12,
                height: 52,
              ),

              const SizedBox(height: 30),
            ],
          ),
        );
      }),
    );
  }

  bool _isSameDay(DateTime day, Set<DateTime> days) {
    return days.any(
      (d) => d.year == day.year && d.month == day.month && d.day == day.day,
    );
  }

  Widget _buildCircleDay(int day, Color color) {
    return Center(
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        alignment: Alignment.center,
        child: Text(
          '$day',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _dateField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey)),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.grey.shade100,
          ),
          child: Text(value),
        ),
      ],
    );
  }
}
