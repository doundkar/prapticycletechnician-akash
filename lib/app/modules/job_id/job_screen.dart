import 'package:bicycle_app_technician/app/routes/app_routes.dart';
import 'package:bicycle_app_technician/view/Colors/app_colors.dart';
import 'package:bicycle_app_technician/app/modules/select_item/select_items_screen.dart';
import 'package:bicycle_app_technician/view/widgets/custom_app_bar.dart';
import 'package:bicycle_app_technician/view/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

class JobScreen extends StatefulWidget {
  const JobScreen({super.key});

  @override
  State<JobScreen> createState() => _JobScreenState();
}

class _JobScreenState extends State<JobScreen> {
  final List<TextEditingController> _controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  int focusedIndex = -1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    for (int i = 0; i < _focusNodes.length; i++) {
      _focusNodes[i].addListener(() {
        if (_focusNodes[i].hasFocus) {
          setState(() {
            focusedIndex = i;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "JOB ID : 12345", icon: Icons.arrow_back_ios),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "JOB ID:12345",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: Color.fromRGBO(102, 112, 133, 1),
                      ),
                    ),
                    Spacer(),
                    Text(
                      "Started",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color.fromRGBO(80, 202, 153, 1),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  "Service",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color.fromRGBO(102, 112, 133, 1),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  "Brake Setting",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Icon(Icons.access_time, size: 20, color: Colors.black),
                    const SizedBox(width: 5),
                    Text(
                      "30 min",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      "- ₹99",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(3),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(4, (index) => otpField(index)),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Need Extra Parts",
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 15),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => SelectItemsScreen(),
                      ),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.blue, width: 1),
                      color: AppColors.blue.withOpacity(0.2),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add, size: 20, color: Colors.black),
                        const SizedBox(width: 5),
                        Text(
                          "Add Parts",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                ListView.separated(
                  physics: BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return partCard(name: "Break Cable");
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(height: 10);
                  },
                  itemCount: 3,
                ),
                const SizedBox(height: 20),
                InkWell(
                  onTap: () {
                    Get.toNamed(AppRoutes.selectItem);
                  },
                  child: CustomButton(
                    text: "Complete Job",
                    textSize: 18,
                    textWeight: FontWeight.w600,
                    textColor: Colors.white,
                    bgColor: AppColors.blue,
                    radius: 10,
                    height: 50,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget otpField(int index) {
    return Container(
      decoration: BoxDecoration(
        color: focusedIndex == index
            ? Color.fromRGBO(255, 137, 31, 0.3)
            : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: focusedIndex == index
            ? BoxBorder.all(color: AppColors.orange)
            : BoxBorder.all(color: Color.fromRGBO(219, 219, 219, 1)),
      ),
      height: 60,
      width: 60,
      alignment: Alignment.center,
      child: TextField(
        style: TextStyle(fontSize: 18),
        textAlign: TextAlign.center,
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        maxLength: 1,
        cursorColor: Colors.black,
        decoration: InputDecoration(
          counterText: "",
          // isDense: true,
          contentPadding: EdgeInsets.zero,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        onChanged: (value) {
          if (value.isNotEmpty) {
            if (index < 5) {
              FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
            } else {
              FocusScope.of(context).unfocus();
            }
          } else {
            if (index > 0) {
              FocusScope.of(context).requestFocus(_focusNodes[index]);
            }
          }
        },
      ),
    );
  }

  Widget partCard({required String name}) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Image.asset(
            "assets/part.png",
            height: 20,
            width: 20,
            fit: BoxFit.cover,
          ),
          const SizedBox(width: 10),
          Text(
            name,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
          ),
          Spacer(),
          Icon(Icons.cancel_outlined, size: 20, color: Colors.black),
        ],
      ),
    );
  }
}
