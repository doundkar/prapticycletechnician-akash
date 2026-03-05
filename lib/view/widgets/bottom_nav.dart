import 'package:bicycle_app_technician/app/modules/all_jobs/all_jobs_screen.dart';
import 'package:bicycle_app_technician/app/modules/job_list/job_list_homescreen.dart';
import 'package:bicycle_app_technician/app/modules/new_job_request/new_job_req_screen.dart';
import 'package:bicycle_app_technician/app/modules/profile/view/profile_screen.dart';
import 'package:bicycle_app_technician/app/modules/wallet/wallet_screen.dart';
import 'package:bicycle_app_technician/view/Colors/app_colors.dart';
import 'package:flutter/material.dart';

class CustomBottomNav extends StatefulWidget {
  const CustomBottomNav({super.key});

  @override
  State<CustomBottomNav> createState() => _CustomBottomNavState();
}

class _CustomBottomNavState extends State<CustomBottomNav> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    JobListHomeScreen(),
    AllJobsScreen(),
    WalletScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: Material(
        color: Colors.white,
        elevation: 12,
        shadowColor: Colors.black,
        clipBehavior: Clip.antiAlias,
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: Color.fromRGBO(229, 231, 235, 1)),
            ),
            boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.06),
                blurRadius: 20,
                offset: Offset(0, -15),
              ),
            ],
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          child: BottomNavigationBar(
            currentIndex: _currentIndex, // 👈 important
            onTap: (index) {
              setState(() {
                _currentIndex = index; // 👈 update index
              });
            },
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            selectedItemColor: AppColors.blue,
            unselectedItemColor: Colors.grey,
            selectedLabelStyle: const TextStyle(fontSize: 12),
            unselectedLabelStyle: const TextStyle(fontSize: 12),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home, size: 26),
                label: "Home",
              ),

              BottomNavigationBarItem(
                icon: Icon(Icons.cases_outlined, size: 26),
                label: "Jobs",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.wallet, size: 26),
                label: "Wallet",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person, size: 26),
                label: "Profile",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
