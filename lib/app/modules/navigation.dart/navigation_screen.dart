import 'package:bicycle_app_technician/app/model/job_details_model.dart';
import 'package:bicycle_app_technician/app/routes/app_routes.dart';
import 'package:bicycle_app_technician/view/Colors/app_colors.dart';
import 'package:bicycle_app_technician/view/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

// 15-04-2026 Akash Doundkar
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mappls_gl/mappls_gl.dart';

import 'navigation_controller.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  bool hasReached = false;
  MapplsMapController? mapController;
  List<LatLng> routePoints = [];
  Symbol? currentSymbol;
  Symbol? destinationSymbol;

  String? eLoc;
  NavigationController controller = Get.put(NavigationController());
  Position? currentPosition;
  @override
  void initState() {
    JobDetailsModel job = Get.arguments;
    if (Get.arguments != null) {
      controller.getLatLngFromAddress(job.location ?? '');
    }
    initFlow();
    super.initState();
  }

  Future<void> initFlow() async {
    await controller.getCurrentLocation();
    await controller.getRouteFromELoc();

    setState(() {});
  }

  void drawRoute() async {
    if (mapController == null || controller.routePoints.isEmpty) return;

    // Draw route line
    await mapController!.addLine(
      LineOptions(
        geometry: controller.routePoints,
        lineColor: "#3b82f6",
        lineWidth: 4,
      ),
    );

    // Destination marker
    final dest = controller.routePoints.last;

    await mapController!.addSymbol(
      SymbolOptions(geometry: dest, iconImage: "marker-15"),
    );
  }

  Future<bool> requestCallPermission() async {
    var status = await Permission.phone.request();
    return status.isGranted;
  }

  Future<void> openSms(String phone) async {
    final Uri uri = Uri.parse("sms:$phone");
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw Exception("Could not launch SMS");
    }
  }

  @override
  Widget build(BuildContext context) {
    JobDetailsModel job = Get.arguments;

    return LayoutBuilder(
      builder: (context, constraints) {
        double maxWidth = constraints.maxWidth;
        double contentWidth = maxWidth > 1000
            ? 900
            : maxWidth > 600
            ? 600
            : maxWidth;

        bool isTablet = maxWidth > 600;
        double switchScale = maxWidth > 600 ? 0.75 : 0.60;
        return Scaffold(
          appBar: CustomAppBar(title: "Navigation"),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: maxWidth > 700 ? 400 : 280,
                    child: controller.currentPosition == null
                        ? Center(child: CircularProgressIndicator())
                        : MapplsMap(
                            initialCameraPosition: CameraPosition(
                              target: LatLng(
                                controller.currentPosition!.latitude,
                                controller.currentPosition!.longitude,
                              ),
                              zoom: 14,
                            ),

                            onMapCreated: (map) async {
                              mapController = map;

                              // Current location marker
                              await mapController!.addSymbol(
                                SymbolOptions(
                                  geometry: LatLng(
                                    controller.currentPosition!.latitude,
                                    controller.currentPosition!.longitude,
                                  ),
                                  iconImage: "marker-15",
                                ),
                              );

                              // Draw route after map ready
                              drawRoute();
                            },

                            myLocationEnabled: true,
                            myLocationTrackingMode:
                                MyLocationTrackingMode.tracking,
                          ),
                  ),

                  SizedBox(height: isTablet ? 28 : 20),

                  /// Status + ETA Row
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Status Update",
                                      style: TextStyle(
                                        fontSize: isTablet ? 16 : 14,
                                        fontWeight: FontWeight.w600,
                                        color: const Color.fromRGBO(
                                          102,
                                          112,
                                          133,
                                          1,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: isTablet ? 8 : 6),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Transform.scale(
                                          scale: switchScale,
                                          child: Switch(
                                            value: hasReached,
                                            materialTapTargetSize:
                                                MaterialTapTargetSize
                                                    .shrinkWrap,
                                            inactiveThumbColor: AppColors.blue,
                                            activeThumbColor: Colors.green,
                                            activeTrackColor: Colors.white,
                                            trackColor:
                                                const WidgetStatePropertyAll(
                                                  Color.fromRGBO(
                                                    225,
                                                    225,
                                                    225,
                                                    1,
                                                  ),
                                                ),
                                            trackOutlineColor:
                                                const WidgetStatePropertyAll(
                                                  Color.fromRGBO(
                                                    166,
                                                    166,
                                                    166,
                                                    1,
                                                  ),
                                                ),
                                            onChanged: (value) {
                                              setState(() {
                                                hasReached = value;
                                              });
                                              if (hasReached) {
                                                Get.toNamed(
                                                  AppRoutes.startJobOtp,
                                                  arguments: job,
                                                );
                                              }
                                            },
                                          ),
                                        ),
                                        // const SizedBox(width: 2),
                                        Text(
                                          hasReached ? "Reached" : "On the Way",
                                          style: TextStyle(
                                            fontSize: isTablet ? 18 : 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "ETA",
                                      style: TextStyle(
                                        fontSize: isTablet ? 16 : 14,
                                        fontWeight: FontWeight.w600,
                                        color: const Color.fromRGBO(
                                          102,
                                          112,
                                          133,
                                          1,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: isTablet ? 8 : 6),
                                    Text(
                                      "15 mins",
                                      style: TextStyle(
                                        fontSize: isTablet ? 18 : 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: isTablet ? 25 : 15),

                  /// Customer Information Card
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color.fromRGBO(227, 227, 229, 1),
                      ),
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(isTablet ? 22 : 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // SizedBox(height: isTablet ? 14 : 10),
                          Text(
                            job.customerName ?? '',
                            style: TextStyle(
                              fontSize: isTablet ? 19 : 17,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          SizedBox(height: isTablet ? 6 : 4),

                          Text(
                            job.location!,
                            style: TextStyle(
                              fontSize: isTablet ? 15 : 13,
                              color: const Color.fromRGBO(102, 112, 133, 1),
                            ),
                          ),

                          SizedBox(height: isTablet ? 14 : 10),

                          Row(
                            children: [
                              Icon(
                                Icons.access_time,
                                size: isTablet ? 20 : 16,
                                color: Colors.grey,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                "${job.date}, ",
                                style: TextStyle(
                                  fontSize: isTablet ? 17 : 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                job.time!,
                                style: TextStyle(fontSize: isTablet ? 17 : 15),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: isTablet ? 35 : 25),

                  /// Call Button
                  _buildActionButton(
                    maxWidth: maxWidth,
                    icon: Icons.call_outlined,
                    text: "Call Customer",
                    onPressed: () async {
                      // 15-04-2026 Akash Doundkar
                      if (job.customerPhone!.isNotEmpty &&
                          job.customerPhone != null) {
                        bool granted = await requestCallPermission();
                        if (granted) {
                          await FlutterPhoneDirectCaller.callNumber(
                            job.customerPhone.toString(),
                          );
                        } else {
                          Get.snackbar(
                            "Permission Denied",
                            "Phone permission is required",
                          );
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Phone number is missing"),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                  ),
                  SizedBox(height: isTablet ? 20 : 15),

                  /// Message Button
                  _buildActionButton(
                    maxWidth: maxWidth,
                    icon: Icons.chat_bubble_outline,
                    text: "Message",
                    onPressed: () async {
                      // 15-04-2026 Akash Doundkar
                      final phone = job.customerPhone;

                      if (phone != null && phone.trim().isNotEmpty) {
                        try {
                          await openSms(phone);
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Unable to open SMS"),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Phone number is missing"),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildActionButton({
    required double maxWidth,
    required IconData icon,
    required String text,
    required VoidCallback onPressed,
  }) {
    bool isTablet = maxWidth > 600;

    return InkWell(
      onTap: onPressed,
      child: Container(
        height: isTablet ? 65 : 55,
        width: double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.blue, width: 1),
          color: AppColors.lightBlue,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: isTablet ? 26 : 24, color: Colors.black),
            SizedBox(width: isTablet ? 12 : 8),
            Text(
              text,
              style: TextStyle(
                fontSize: isTablet ? 20 : 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
