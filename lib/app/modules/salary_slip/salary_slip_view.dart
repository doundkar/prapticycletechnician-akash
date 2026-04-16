import 'package:bicycle_app_technician/app/modules/salary_slip/salary_slip_controller.dart';
import 'package:bicycle_app_technician/view/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:bicycle_app_technician/view/Colors/app_colors.dart';
import 'package:bicycle_app_technician/view/widgets/custom_button.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:intl/intl.dart';
import 'package:number_to_words/number_to_words.dart';

class EarnIncomeScreen extends StatefulWidget {
  const EarnIncomeScreen({super.key});

  @override
  State<EarnIncomeScreen> createState() => _EarnIncomeScreenState();
}

class _EarnIncomeScreenState extends State<EarnIncomeScreen> {
  late List<String> months;
  late List<int> years;

  late String selectedMonth;
  late int selectedYear;

  SalarySlipController controller = Get.find();

  @override
  void initState() {
    super.initState();

    months = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December",
    ];

    selectedMonth = DateFormat("MMMM").format(DateTime.now());
    int currentYear = DateTime.now().year;
    selectedYear = currentYear;

    years = List.generate(5, (index) => currentYear - index);
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final padding = width * 0.04;
    final spacingSmall = width * 0.02;
    final spacingMedium = width * 0.04;
    final spacingLarge = width * 0.06;

    return Scaffold(
      appBar: CustomAppBar(title: "Salary Slip"),
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
        return SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(child: _monthDropdown(width)),
                    SizedBox(width: spacingSmall * 2),
                    Expanded(child: _yearDropdown(width)),
                  ],
                ),

                SizedBox(height: spacingMedium),

                /// Date of Joining
                Container(
                  padding: EdgeInsets.all(padding * 0.8),
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(232, 245, 255, 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: AppColors.blue,
                        size: width * 0.05,
                      ),
                      SizedBox(width: spacingSmall * 2),
                      // 15-04-2026 Akash Doundkar
                      Text(
                        "Date of Joining: ${controller.salarySlip.value!.technician!.dateOfJoining!.toString()}",
                            // "${DateFormat("dd MMM yyyy").format(DateTime.parse(controller.salarySlip.value!.technician!.dateOfJoining!))}",
                        style: TextStyle(fontSize: width * 0.035),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: spacingLarge),

                /// Salary Slip Title
                Text(
                  "Salary Slip",
                  style: TextStyle(
                    fontSize: width * 0.04,
                    fontWeight: FontWeight.w600,
                    color: const Color.fromRGBO(102, 112, 133, 1),
                  ),
                ),

                SizedBox(height: spacingSmall * 2),

                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(padding * 0.9),
                  decoration: _cardDecoration(),
                  child: Text(
                    "For $selectedMonth $selectedYear",
                    style: TextStyle(fontSize: width * 0.035),
                  ),
                ),

                SizedBox(height: spacingLarge),

                /// Salary Details Card
                Container(
                  padding: EdgeInsets.all(padding),
                  decoration: _cardDecoration(),
                  child: Obx(() {
                    if (controller.isSalaryLoading.value) {
                      return SizedBox(
                        height: height * 0.35,
                        width: double.infinity,
                        child: Center(
                          child: SizedBox(
                            height: width * 0.08,
                            width: width * 0.08,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.blue,
                            ),
                          ),
                        ),
                      );
                    }
                    if (controller.salarySlip.value?.salarySlip == null) {
                      return SizedBox(
                        height: height*0.2,
                        width: double.infinity,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "No records found",
                              style: TextStyle(fontSize: 16, color: Colors.red),
                            ),
                          ],
                        ),
                      );
                    }
                    return Column(
                      children: [
                        _rowHeader("Earnings", "Deduction", width),

                        SizedBox(height: spacingMedium),

                        const Divider(height: 30),

                        ...controller.salarySlip.value!.salarySlip!.earnings!
                            .map((e) {
                              return _salaryRow(
                                e.label!,
                                "₹${e.amount}",
                                width,
                                valueColor: e.label == "Wallet Earning"
                                    ? AppColors.blue
                                    : Colors.black,
                              );
                            }),

                        // _salaryRow("Basic Salary", "₹", width),
                        // _salaryRow(
                        //   "House Rent Allowance (HRA)",
                        //   "₹4,400.00",
                        //   width,
                        // ),
                        // _salaryRow("Conveyance Allowance", "₹1,600.00", width),
                        _salaryRow(
                          "Gross Earnings",
                          "₹${controller.salarySlip.value!.salarySlip?.grossEarnings}",
                          width,
                          valueColor: AppColors.blue,
                          isBold: true,
                        ),

                        _salaryRow(
                          "Total Deductions",
                          "₹${controller.salarySlip.value!.salarySlip?.totalDeductions}",
                          width,
                          valueColor: Colors.red,
                          isBold: true,
                        ),

                        const Divider(height: 30),

                        Text(
                          "Net Payable (Net Pay)",
                          style: TextStyle(
                            fontSize: width * 0.042,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        SizedBox(height: spacingSmall * 2),
// 15-04-2026 Akash Doundkar
                        Text(
                          "₹${controller.salarySlip.value!.salarySlip?.netPay}",
                          style: TextStyle(
                            fontSize: width * 0.08,
                            fontWeight: FontWeight.w700,
                            color: const Color.fromRGBO(57, 146, 106, 1),
                          ),
                        ),

                        SizedBox(height: spacingSmall),
// 15-04-2026 Akash Doundkar
                        Text(
                          "In Words: ${(NumberToWord().convert(
                            "en-in",
                            controller.salarySlip.value?.salarySlip?.netPay?.toInt() ?? 0,
                          )).capitalize}",
                          // "In Words: ${(NumberToWord().convert("en-in", controller.salarySlip.value!.salarySlip?.netPay)).capitalize} ",
                          style: TextStyle(
                            fontSize: width * 0.03,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    );
                  }),
                ),

                SizedBox(height: spacingLarge),

                CustomButton(
                  text: "Download (PDF)",
                  textSize: 16,
                  textWeight: FontWeight.w600,
                  textColor: Colors.white,
                  bgColor: AppColors.blue,
                  radius: 10,
                  height: width * 0.12,
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  /// Month Dropdown
  Widget _monthDropdown(double width) {
    final spacingSmall = width * 0.02;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Month", style: TextStyle(fontSize: width * 0.04)),
        SizedBox(height: spacingSmall),

        Container(
          padding: EdgeInsets.symmetric(horizontal: width * 0.03),
          decoration: _cardDecoration(),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedMonth,
              isExpanded: true,
              items: months.map((month) {
                return DropdownMenuItem(value: month, child: Text(month));
              }).toList(),
              onChanged: (value) async {
                setState(() {
                  selectedMonth = value!;
                });
                await controller.getSalarySlip(
                  DateFormat('MMMM').parse(selectedMonth).month,
                  selectedYear,
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  /// Year Dropdown
  Widget _yearDropdown(double width) {
    final spacingSmall = width * 0.02;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Year", style: TextStyle(fontSize: width * 0.04)),
        SizedBox(height: spacingSmall),

        Container(
          padding: EdgeInsets.symmetric(horizontal: width * 0.03),
          decoration: _cardDecoration(),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              value: selectedYear,
              isExpanded: true,
              items: years.map((year) {
                return DropdownMenuItem(
                  value: year,
                  child: Text(year.toString()),
                );
              }).toList(),
              onChanged: (value) async {
                setState(() {
                  selectedYear = value!;
                });
                await controller.getSalarySlip(
                  DateFormat('MMMM').parse(selectedMonth).month,
                  selectedYear,
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _rowHeader(String left, String right, double width) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          left,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: width * 0.038,
          ),
        ),
        Text(
          right,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: width * 0.038,
          ),
        ),
      ],
    );
  }

  Widget _salaryRow(
    String title,
    String value,
    double width, {
    Color valueColor = Colors.black,
    bool isBold = false,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: width * 0.015),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(title, style: TextStyle(fontSize: width * 0.035)),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: width * 0.035,
              fontWeight: isBold ? FontWeight.w600 : FontWeight.w400,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 6,
          offset: const Offset(0, 3),
        ),
      ],
      border: const Border.fromBorderSide(
        BorderSide(color: Color.fromRGBO(219, 219, 219, 1)),
      ),
    );
  }
}
