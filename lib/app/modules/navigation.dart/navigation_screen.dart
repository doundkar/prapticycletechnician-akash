// import 'package:bicycle_app_technician/app/model/job_details_model.dart';
// import 'package:bicycle_app_technician/app/routes/app_routes.dart';
// import 'package:bicycle_app_technician/view/Colors/app_colors.dart';
// import 'package:bicycle_app_technician/view/widgets/custom_app_bar.dart';
// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:get/get.dart';

// // 15-04-2026 Akash Doundkar
// import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:mappls_gl/mappls_gl.dart';

// import 'navigation_controller.dart';

// class NavigationScreen extends StatefulWidget {
//   const NavigationScreen({super.key});

//   @override
//   State<NavigationScreen> createState() => _NavigationScreenState();
// }

// class _NavigationScreenState extends State<NavigationScreen> {
//   bool hasReached = false;
//   MapplsMapController? mapController;
//   List<LatLng> routePoints = [];
//   Symbol? currentSymbol;
//   Symbol? destinationSymbol;

//   String? eLoc;
//   NavigationController controller = Get.put(NavigationController());
//   Position? currentPosition;
//   @override
//   void initState() {
//     initFlow();

//     super.initState();
//   }

//   Future<void> initFlow() async {
//     await controller.getCurrentLocation();
//     JobDetailsModel job = Get.arguments;
//     if (Get.arguments != null) {
//       controller.getLatLngFromAddress(job.location ?? '');
//     }
//     setState(() {});
//   }

//   Future<bool> requestCallPermission() async {
//     var status = await Permission.phone.request();
//     return status.isGranted;
//   }

//   Future<void> openSms(String phone) async {
//     final Uri uri = Uri.parse("sms:$phone");
//     if (await canLaunchUrl(uri)) {
//       await launchUrl(uri, mode: LaunchMode.externalApplication);
//     } else {
//       throw Exception("Could not launch SMS");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     JobDetailsModel job = Get.arguments;

//     return LayoutBuilder(
//       builder: (context, constraints) {
//         double maxWidth = constraints.maxWidth;
//         double contentWidth = maxWidth > 1000
//             ? 900
//             : maxWidth > 600
//             ? 600
//             : maxWidth;

//         bool isTablet = maxWidth > 600;
//         double switchScale = maxWidth > 600 ? 0.75 : 0.60;
//         return Scaffold(
//           appBar: CustomAppBar(title: "Navigation"),
//           body: SafeArea(
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 children: [
//                   SizedBox(
//                     width: double.infinity,
//                     height: maxWidth > 700 ? 400 : 280,
//                     child: controller.currentPosition == null
//                         ? Center(child: CircularProgressIndicator())
//                         : MapplsMap(
//                             initialCameraPosition: CameraPosition(
//                               target: LatLng(
//                                 controller.currentPosition!.latitude,
//                                 controller.currentPosition!.longitude,
//                               ),
//                               zoom: 14,
//                             ),

//                             onMapCreated: (map) async {
//                               mapController = map;
//                               /// Current location marker
//                               await mapController!.addSymbol(
//                                 SymbolOptions(
//                                   geometry: LatLng(
//                                     controller.currentPosition!.latitude,
//                                     controller.currentPosition!.longitude,
//                                   ),
//                                   iconImage: "marker-15",
//                                 ),
//                               );

//                               await Future.delayed(Duration(seconds: 2));

//                               if (controller.routePoints.isNotEmpty) {
//                                 await mapController!.addLine(
//                                   LineOptions(
//                                     geometry: controller.routePoints,
//                                     lineColor: "#FF0000",
//                                     lineWidth: 4,
//                                   ),
//                                 );

//                               }
//                             },
//                             myLocationEnabled: true,
//                             myLocationTrackingMode:
//                                 MyLocationTrackingMode.tracking,
//                           ),
//                   ),

//                   SizedBox(height: isTablet ? 28 : 20),

//                   /// Status + ETA Row
//                   Expanded(
//                     child: SingleChildScrollView(
//                       child: Padding(
//                         padding: const EdgeInsets.all(15),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Row(
//                               children: [
//                                 Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       "Status Update",
//                                       style: TextStyle(
//                                         fontSize: isTablet ? 16 : 14,
//                                         fontWeight: FontWeight.w600,
//                                         color: const Color.fromRGBO(
//                                           102,
//                                           112,
//                                           133,
//                                           1,
//                                         ),
//                                       ),
//                                     ),
//                                     SizedBox(height: isTablet ? 8 : 6),
//                                     Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.start,
//                                       children: [
//                                         Transform.scale(
//                                           scale: switchScale,
//                                           child: Switch(
//                                             value: hasReached,
//                                             materialTapTargetSize:
//                                                 MaterialTapTargetSize
//                                                     .shrinkWrap,
//                                             inactiveThumbColor: AppColors.blue,
//                                             activeThumbColor: Colors.green,
//                                             activeTrackColor: Colors.white,
//                                             trackColor:
//                                                 const WidgetStatePropertyAll(
//                                                   Color.fromRGBO(
//                                                     225,
//                                                     225,
//                                                     225,
//                                                     1,
//                                                   ),
//                                                 ),
//                                             trackOutlineColor:
//                                                 const WidgetStatePropertyAll(
//                                                   Color.fromRGBO(
//                                                     166,
//                                                     166,
//                                                     166,
//                                                     1,
//                                                   ),
//                                                 ),
//                                             onChanged: (value) {
//                                               setState(() {
//                                                 hasReached = value;
//                                               });
//                                               if (hasReached) {
//                                                 Get.toNamed(
//                                                   AppRoutes.startJobOtp,
//                                                   arguments: job,
//                                                 );
//                                               }
//                                             },
//                                           ),
//                                         ),
//                                         // const SizedBox(width: 2),
//                                         Text(
//                                           hasReached ? "Reached" : "On the Way",
//                                           style: TextStyle(
//                                             fontSize: isTablet ? 18 : 16,
//                                             fontWeight: FontWeight.w600,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                                 const Spacer(),
//                                 Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       "ETA",
//                                       style: TextStyle(
//                                         fontSize: isTablet ? 16 : 14,
//                                         fontWeight: FontWeight.w600,
//                                         color: const Color.fromRGBO(
//                                           102,
//                                           112,
//                                           133,
//                                           1,
//                                         ),
//                                       ),
//                                     ),
//                                     SizedBox(height: isTablet ? 8 : 6),
//                                     Text(
//                                       "15 mins",
//                                       style: TextStyle(
//                                         fontSize: isTablet ? 18 : 16,
//                                         fontWeight: FontWeight.w600,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),

//                   SizedBox(height: isTablet ? 25 : 15),

//                   /// Customer Information Card
//                   Container(
//                     width: double.infinity,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(16),
//                       border: Border.all(
//                         color: const Color.fromRGBO(227, 227, 229, 1),
//                       ),
//                       color: Colors.white,
//                     ),
//                     child: Padding(
//                       padding: EdgeInsets.all(isTablet ? 22 : 16),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           // SizedBox(height: isTablet ? 14 : 10),
//                           Text(
//                             job.customerName ?? '',
//                             style: TextStyle(
//                               fontSize: isTablet ? 19 : 17,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),

//                           SizedBox(height: isTablet ? 6 : 4),

//                           Text(
//                             job.location!,
//                             style: TextStyle(
//                               fontSize: isTablet ? 15 : 13,
//                               color: const Color.fromRGBO(102, 112, 133, 1),
//                             ),
//                           ),

//                           SizedBox(height: isTablet ? 14 : 10),

//                           Row(
//                             children: [
//                               Icon(
//                                 Icons.access_time,
//                                 size: isTablet ? 20 : 16,
//                                 color: Colors.grey,
//                               ),
//                               const SizedBox(width: 5),
//                               Text(
//                                 "${job.date}, ",
//                                 style: TextStyle(
//                                   fontSize: isTablet ? 17 : 15,
//                                   fontWeight: FontWeight.w600,
//                                 ),
//                               ),
//                               Text(
//                                 job.time!,
//                                 style: TextStyle(fontSize: isTablet ? 17 : 15),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),

//                   SizedBox(height: isTablet ? 35 : 25),

//                   /// Call Button
//                   _buildActionButton(
//                     maxWidth: maxWidth,
//                     icon: Icons.call_outlined,
//                     text: "Call Customer",
//                     onPressed: () async {
//                       // 15-04-2026 Akash Doundkar
//                       if (job.customerPhone!.isNotEmpty &&
//                           job.customerPhone != null) {
//                         bool granted = await requestCallPermission();
//                         if (granted) {
//                           await FlutterPhoneDirectCaller.callNumber(
//                             job.customerPhone.toString(),
//                           );
//                         } else {
//                           Get.snackbar(
//                             "Permission Denied",
//                             "Phone permission is required",
//                           );
//                         }
//                       } else {
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(
//                             content: Text("Phone number is missing"),
//                             backgroundColor: Colors.red,
//                           ),
//                         );
//                       }
//                     },
//                   ),
//                   SizedBox(height: isTablet ? 20 : 15),

//                   /// Message Button
//                   _buildActionButton(
//                     maxWidth: maxWidth,
//                     icon: Icons.chat_bubble_outline,
//                     text: "Message",
//                     onPressed: () async {
//                       // 15-04-2026 Akash Doundkar
//                       final phone = job.customerPhone;

//                       if (phone != null && phone.trim().isNotEmpty) {
//                         try {
//                           await openSms(phone);
//                         } catch (e) {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             SnackBar(
//                               content: Text("Unable to open SMS"),
//                               backgroundColor: Colors.red,
//                             ),
//                           );
//                         }
//                       } else {
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(
//                             content: Text("Phone number is missing"),
//                             backgroundColor: Colors.red,
//                           ),
//                         );
//                       }
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildActionButton({
//     required double maxWidth,
//     required IconData icon,
//     required String text,
//     required VoidCallback onPressed,
//   }) {
//     bool isTablet = maxWidth > 600;

//     return InkWell(
//       onTap: onPressed,
//       child: Container(
//         height: isTablet ? 65 : 55,
//         width: double.infinity,
//         alignment: Alignment.center,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(color: AppColors.blue, width: 1),
//           color: AppColors.lightBlue,
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(icon, size: isTablet ? 26 : 24, color: Colors.black),
//             SizedBox(width: isTablet ? 12 : 8),
//             Text(
//               text,
//               style: TextStyle(
//                 fontSize: isTablet ? 20 : 18,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

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
    print("📍 Route Updated");

    tryDrawRoute(); // 🔥 try when route ready
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

  /// 🔥 DRAW ROUTE
  Future<void> drawRoute() async {
    if (mapController == null || controller.routePoints.isEmpty || isRouteDrawn)
      return;

    isRouteDrawn = true;

    await mapController!.clearLines();
    await mapController!.clearSymbols();

    /// Current marker
    currentSymbol = await mapController!.addSymbol(
      SymbolOptions(
        geometry: controller.routePoints.first,
        iconImage: "marker-15",
      ),
    );

    /// Destination marker
    destinationSymbol = await mapController!.addSymbol(
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

    /// Move camera
    await mapController!.animateCamera(
      CameraUpdate.newLatLngZoom(controller.routePoints.first, 12),
    );
  }

  Future<void> tryDrawRoute() async {
  if (!isStyleLoaded ||
      mapController == null ||
      controller.routePoints.isEmpty ||
      isRouteDrawn) return;

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
                  /// 🔥 MAP
                  SizedBox(
                    width: double.infinity,
                    height: maxWidth > 700 ? 400 : 280,
                    child: GetBuilder<NavigationController>(
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

                          onStyleLoadedCallback: () async {
  print("✅ STYLE READY");
  isStyleLoaded = true;

  await tryDrawRoute(); // 🔥 try when style ready
},
                          // onStyleLoadedCallback: () async {
                          //   print("✅ STYLE LOADED");

                          //   if (controller.routePoints.isNotEmpty) {
                          //     print("🔥 DRAWING ROUTE");

                          //     await mapController!.clearLines();
                          //     await mapController!.clearSymbols();

                          //     /// Current marker
                          //     await mapController!.addSymbol(
                          //       SymbolOptions(
                          //         geometry: controller.routePoints.first,
                          //         iconImage: "marker-15",
                          //       ),
                          //     );

                          //     /// Destination marker
                          //     await mapController!.addSymbol(
                          //       SymbolOptions(
                          //         geometry: controller.routePoints.last,
                          //         iconImage: "marker-15",
                          //       ),
                          //     );

                          //     /// Route line
                          //     await mapController!.addLine(
                          //       LineOptions(
                          //         geometry: controller.routePoints,
                          //         lineColor: "#FF0000",
                          //         lineWidth: 5,
                          //       ),
                          //     );

                          //   }
                          // },
                       
                          myLocationEnabled: true,
                          myLocationTrackingMode:
                              MyLocationTrackingMode.tracking,
                        );
                      },
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
