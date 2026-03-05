import 'package:bicycle_app_technician/view/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:bicycle_app_technician/view/Colors/app_colors.dart';
import 'package:bicycle_app_technician/view/widgets/custom_button.dart';

class EarnIncomeScreen extends StatelessWidget {
  const EarnIncomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Salary Slip"),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(child: _dropdownCard("Month", "October")),
                  const SizedBox(width: 12),
                  Expanded(child: _dropdownCard("Year", "2025")),
                ],
              ),

              const SizedBox(height: 15),

              /// Date of Joining
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(232, 245, 255, 1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Icon(Icons.check_circle, color: AppColors.blue, size: 20),
                    SizedBox(width: 10),
                    Text(
                      "Date of Joining: 28 Oct 2025",
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              /// Salary Slip
              const Text(
                "Salary Slip",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,color: Color.fromRGBO(102, 112, 133, 1)),
              ),
              const SizedBox(height: 10),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: _cardDecoration(),
                child: const Text(
                  "For October 2025",
                  style: TextStyle(fontSize: 14),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: _cardDecoration(),
                child: Column(
                  children: [
                    _rowHeader("Earnings", "Deduction"),
                    const SizedBox(height: 15),
                    const Divider(height: 30),
                    _salaryRow("Basic Salary", "₹22,000.00"),
                    _salaryRow("House Rent Allowance (HRA)", "₹4,400.00"),
                    _salaryRow("Conveyance Allowance", "₹1,600.00"),
                    _salaryRow(
                      "Gross Earnings",
                      "₹28,000.00",
                      valueColor: Colors.blue,
                      isBold: true,
                    ),
                    _salaryRow(
                      "Total Deductions",
                      "₹2,000.00",
                      valueColor: Colors.red,
                      isBold: true,
                    ),
                    const Divider(height: 30),
                    Text(
                      "Net Payable (Net Pay)",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "₹26,000.00",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        color: Color.fromRGBO(57, 146, 106, 1),
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "In Words: Twenty Six Thousand Rupees Only",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),
              CustomButton(
                text: "Download (PDF)",
                textSize: 16,
                textWeight: FontWeight.w600,
                textColor: Colors.white,
                bgColor: AppColors.blue,
                radius: 10,
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Widgets

  Widget _dropdownCard(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          decoration: _cardDecoration(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(value),
              const Icon(Icons.keyboard_arrow_down),
            ],
          ),
        ),
      ],
    );
  }

  Widget _rowHeader(String left, String right) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(left, style: const TextStyle(fontWeight: FontWeight.w600)),
        Text(right, style: const TextStyle(fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _salaryRow(
    String title,
    String value, {
    Color valueColor = Colors.black,
    bool isBold = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(title)),
          Text(
            value,
            style: TextStyle(
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
      border: Border.all(color: Color.fromRGBO(219, 219, 219, 1))
    );
  }
}
