import 'package:bicycle_app_technician/app/model/job_details_model.dart';
import 'package:bicycle_app_technician/app/routes/app_routes.dart';
import 'package:bicycle_app_technician/view/Colors/app_colors.dart';
import 'package:bicycle_app_technician/view/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
  Symbol? currentSymbol;
  Symbol? destinationSymbol;
  bool isRouteDrawn = false;
  bool isStyleLoaded = false;

  final NavigationController controller = Get.put(NavigationController());

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      tryDrawRoute();
    });
    initFlow();
  }

  Future<void> initFlow() async {
    await controller.getCurrentLocation();
    JobDetailsModel job = Get.arguments;

    if (job != null) {
      await controller.getLatLngFromAddress(job.location ?? '');
    }
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

  Future<void> tryDrawRoute() async {
    if (!isStyleLoaded ||
        mapController == null ||
        controller.routePoints.isEmpty ||
        isRouteDrawn)
      return;

    isRouteDrawn = true;

    print("🔥 FINAL DRAW");

    await mapController!.clearLines();
    await mapController!.clearSymbols();

    /// Current marker
    await mapController!.addSymbol(
      SymbolOptions(
        geometry: controller.routePoints.first,
        iconImage: "marker-15",
      ),
    );

    /// Destination marker
    await mapController!.addSymbol(
      SymbolOptions(
        geometry: controller.routePoints.last,
        iconImage: "marker-15",
      ),
    );

    /// Route line
    await mapController!.addLine(
      LineOptions(
        geometry: controller.routePoints,
        lineColor: "#FF0000",
        lineWidth: 5,
      ),
    );
  }

  // GOOGLE MAP NAVIGATION USING routePoints
  Future<void> openGoogleMapFromRoute() async {
    if (controller.routePoints.isEmpty) {
      print("Route not ready");
      return;
    }

    final start = controller.routePoints.first;
    final end = controller.routePoints.last;

    final url = Uri.parse(
      "https://www.google.com/maps/dir/?api=1"
      "&origin=${start.latitude},${start.longitude}"
      "&destination=${end.latitude},${end.longitude}"
      "&travelmode=driving",
    );

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      print("Could not open Google Maps");
    }
  }

  @override
  Widget build(BuildContext context) {
    JobDetailsModel job = Get.arguments;

    return LayoutBuilder(
      builder: (context, constraints) {
        double maxWidth = constraints.maxWidth;
        bool isTablet = maxWidth > 600;

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
                    child: Stack(
                      children: [
                        GetBuilder<NavigationController>(
                          builder: (controller) {
                            if (controller.currentPosition == null) {
                              return Center(child: CircularProgressIndicator());
                            }

                            return MapplsMap(
                              initialCameraPosition: CameraPosition(
                                target: LatLng(
                                  controller.currentPosition!.latitude,
                                  controller.currentPosition!.longitude,
                                ),
                                zoom: 14,
                              ),
                              onMapCreated: (map) async {
                                mapController = map;
                                print("🗺️ MAP CREATED");
                                await mapController!.addSymbol(
                                  SymbolOptions(
                                    geometry: LatLng(
                                      controller.currentPosition!.latitude,
                                      controller.currentPosition!.longitude,
                                    ),
                                    iconImage: "marker-15",
                                  ),
                                );
                              },

                              // onStyleLoadedCallback: () async {
                              //   print("✅ STYLE READY");
                              //   isStyleLoaded = true;

                              //   await tryDrawRoute(); // 🔥 try when style ready
                              // },
                              myLocationEnabled: true,
                              myLocationTrackingMode:
                                  MyLocationTrackingMode.tracking,
                            );
                          },
                        ),

                        Positioned(
                          bottom: 15,
                          right: 15,
                          child: FloatingActionButton(
                            onPressed: () async {
                              await openGoogleMapFromRoute();
                            },
                            backgroundColor: Colors.blue,
                            child: const Icon(Icons.navigation),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: isTablet ? 28 : 20),

                  /// STATUS + ETA
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
                                    SizedBox(height: 6),
                                    Row(
                                      children: [
                                        Transform.scale(
                                          scale: isTablet ? 0.75 : 0.60,
                                          child: Switch(
                                            value: hasReached,
                                            onChanged: (value) {
                                              setState(() {
                                                hasReached = value;
                                              });
                                              if (value) {
                                                Get.toNamed(
                                                  AppRoutes.startJobOtp,
                                                  arguments: job,
                                                );
                                              }
                                            },
                                          ),
                                        ),
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
                                    Text("ETA"),
                                    SizedBox(height: 6),
                                    Text("15 mins"),
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

                  /// CUSTOMER CARD
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(isTablet ? 22 : 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color.fromRGBO(227, 227, 229, 1),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(job.customerName ?? ''),
                        SizedBox(height: 4),
                        Text(job.location ?? ''),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Icon(Icons.access_time, size: 16),
                            SizedBox(width: 5),
                            Text("${job.date}, ${job.time}"),
                          ],
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 20),

                  /// CALL BUTTON
                  _buildActionButton(
                    maxWidth: maxWidth,
                    icon: Icons.call_outlined,
                    text: "Call Customer",
                    onPressed: () async {
                      if (job.customerPhone != null &&
                          job.customerPhone!.isNotEmpty) {
                        bool granted = await requestCallPermission();
                        if (granted) {
                          await FlutterPhoneDirectCaller.callNumber(
                            job.customerPhone!,
                          );
                        }
                      }
                    },
                  ),

                  SizedBox(height: 15),

                  /// MESSAGE BUTTON
                  _buildActionButton(
                    maxWidth: maxWidth,
                    icon: Icons.chat_bubble_outline,
                    text: "Message",
                    onPressed: () async {
                      if (job.customerPhone != null) {
                        await openSms(job.customerPhone!);
                      }
                    },
                  ),
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.navigation),
                      label: const Text("Navigate"),
                      onPressed: () async {
                        await openGoogleMapFromRoute();
                      },
                    ),
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
          border: Border.all(color: AppColors.blue),
          color: AppColors.lightBlue,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Icon(icon), SizedBox(width: 8), Text(text)],
        ),
      ),
    );
  }
}
