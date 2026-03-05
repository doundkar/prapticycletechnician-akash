import 'package:bicycle_app_technician/app/modules/add_parts/binding/add_parts_binding.dart';
import 'package:bicycle_app_technician/app/modules/add_parts/view/approval_screen.dart';
import 'package:bicycle_app_technician/app/modules/add_parts/view/component_fitting_screen.dart';
import 'package:bicycle_app_technician/app/modules/add_parts/view/select_parts_screen.dart';
import 'package:bicycle_app_technician/app/modules/all_jobs/all_jobs_screen.dart';
import 'package:bicycle_app_technician/app/modules/auth/binding/sign_in_binding.dart';
import 'package:bicycle_app_technician/app/modules/auth/binding/sign_up_binding.dart';
import 'package:bicycle_app_technician/app/modules/auth/view/sign_in/number_verification_screen.dart';
import 'package:bicycle_app_technician/app/modules/auth/view/sign_up/identity_pending_screen.dart';
import 'package:bicycle_app_technician/app/modules/auth/view/sign_up/identity_rejected_screen.dart';
import 'package:bicycle_app_technician/app/modules/customer_review/customer_review_binding.dart';
import 'package:bicycle_app_technician/app/modules/customer_review/customer_review_screen.dart';
import 'package:bicycle_app_technician/app/modules/job_completion/job_completion_screen.dart';
import 'package:bicycle_app_technician/app/modules/job_id/job_id_binding.dart';
import 'package:bicycle_app_technician/app/modules/job_list/job_list_binding.dart';
import 'package:bicycle_app_technician/app/modules/job_list/job_list_homescreen.dart';
import 'package:bicycle_app_technician/app/modules/job_progress/job_progress_screen.dart';
import 'package:bicycle_app_technician/app/modules/job_start/binding/job_progress_binding.dart';
import 'package:bicycle_app_technician/app/modules/job_start/view/start_job_screen.dart';
import 'package:bicycle_app_technician/app/modules/job_start/view/start_otp_screen.dart';
import 'package:bicycle_app_technician/app/modules/leave_attendance/leave_attendance_screen.dart';
import 'package:bicycle_app_technician/app/modules/leave_attendance/leave_binding.dart';
import 'package:bicycle_app_technician/app/modules/new_job_request/new_job_req_screen.dart';
import 'package:bicycle_app_technician/app/modules/notification/notification_binding.dart';
import 'package:bicycle_app_technician/app/modules/notification/notification_screen.dart';
import 'package:bicycle_app_technician/app/modules/profile/profile_binding.dart';
import 'package:bicycle_app_technician/app/modules/profile/view/edit_profile_screen.dart';
import 'package:bicycle_app_technician/app/modules/profile/view/number_update_verification_screen.dart';
import 'package:bicycle_app_technician/app/modules/profile/view/profile_screen.dart';
import 'package:bicycle_app_technician/app/modules/refer_earn/refer_and_earn_screen.dart';
import 'package:bicycle_app_technician/app/modules/salary_slip/salary_slip_binding.dart';
import 'package:bicycle_app_technician/app/modules/salary_slip/salary_slip_view.dart';
import 'package:bicycle_app_technician/app/modules/select_item/select_item_binding.dart';
import 'package:bicycle_app_technician/app/modules/select_item/select_items_screen.dart';
import 'package:bicycle_app_technician/app/modules/suppport/help_support_screen.dart';
import 'package:bicycle_app_technician/app/modules/navigation.dart/navigation_binding.dart';
import 'package:bicycle_app_technician/app/modules/navigation.dart/navigation_screen.dart';
import 'package:bicycle_app_technician/app/modules/auth/view/sign_up/identity_approved_screen.dart';
import 'package:bicycle_app_technician/app/modules/auth/view/sign_up/verification_screen.dart';
import 'package:bicycle_app_technician/app/routes/app_routes.dart';
import 'package:bicycle_app_technician/app/modules/auth/view/sign_up/signup_view.dart';
import 'package:bicycle_app_technician/app/modules/auth/view/sign_in/signin_screen.dart';
import 'package:bicycle_app_technician/app/modules/job_id/job_screen.dart';
import 'package:bicycle_app_technician/app/modules/wallet/wallet_screen.dart';
import 'package:bicycle_app_technician/utils/shared_prefs.dart';
import 'package:bicycle_app_technician/view/widgets/bottom_nav.dart';
import 'package:bicycle_app_technician/view/widgets/bottom_nav_binding.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

class AppPages {

  static final initial = AppRoutes.signIn;
  static final routes = [
    GetPage(
      name: AppRoutes.signIn,
      page: () => SignInScreen(),
      binding: SignInBinding(),
    ),
    GetPage(
      name: AppRoutes.signUp,
      page: () => SignUpScreen(),
      binding: SignUpBinding(),
    ),
    GetPage(
      name: AppRoutes.numbileVerification,
      page: () => NumberVerificationScreen(),
      binding: SignInBinding(),
    ),
    GetPage(
      name: AppRoutes.verification,
      page: () => VerificationScreen(),
      binding: SignUpBinding(),
    ),
    GetPage(
      name: AppRoutes.jobList,
      page: () => JobListHomeScreen(),
      binding: JobListBinding(),
    ),
    GetPage(
      name: AppRoutes.newJobRequest,
      page: () => NewJobReqScreen(),
    ),
    GetPage(
      name: AppRoutes.navigation,
      page: () => NavigationScreen(),
      binding: TechnicianLocationBinding(),
    ),
     GetPage(
      name: AppRoutes.jobID,
      page: () => JobScreen(),
      binding: JobIdBinding(),
    ),
      GetPage(
      name: AppRoutes.selectItem,
      page: () => SelectItemsScreen(),
      binding: SelectItemBinding(),
    ),
    GetPage(
      name:AppRoutes.identityApproved,
      page: () => IdentityApprovedScreen(),
      binding: SignUpBinding()
    ),
    GetPage(
      name:AppRoutes.identityRejected,
      page: () => IdentityRejectedScreen(),
      binding: SignUpBinding()
    ),
    GetPage(
      name:AppRoutes.identityPending,
      page: () => IdentityPendingScreen(),
      binding: SignUpBinding()
    ),
    GetPage(
      name:AppRoutes.notifications,
      page: () => NotificationScreen(),
      binding: NotificationBinding()
    ),
    GetPage(
      name:AppRoutes.allJobs,
      page: () => AllJobsScreen(),
    ),
    GetPage(
      name:AppRoutes.startJobOtp,
      page: () => StartJobOtpScreen(),
      binding: JobProgressBinding()
    ),
    GetPage(
      name:AppRoutes.startJob,
      page: () => StartJobScreen(),
      // binding: NotificationBinding()
    ),
    GetPage(
      name:AppRoutes.completeJob,
      page: () => CompleteJobScreen(),
    ),
    GetPage(
      name:AppRoutes.progressJob,
      page: () => JobInProgressScreen(),
      // binding: NotificationBinding()
    ),
    GetPage(
      name:AppRoutes.customerReview,
      page: () => CustomerReviewScreen(),
      binding: CustomerReviewBinding()
    ),
    GetPage(
      name:AppRoutes.selectPart,
      page: () => SelectPartsScreen(),
      binding: AddPartsBinding()
    ),
    GetPage(
      name:AppRoutes.componentFitting,
      page: () => ComponentFittingScreen(),
      binding: AddPartsBinding()
    ),
    GetPage(
      name:AppRoutes.approval,
      page: () => ApprovalScreen(),
      binding: AddPartsBinding()
    ),
    GetPage(
      name:AppRoutes.wallet,
      page: () => WalletScreen(),
      // binding: NotificationBinding()
    ),
    GetPage(
      name:AppRoutes.editProfile,
      page: () => EditProfileScreen(),
      binding: ProfileBinding()
    ),
    GetPage(
      name:AppRoutes.profile,
      page: () => ProfileScreen(),
      binding: ProfileBinding()
    ),
    GetPage(
      name:AppRoutes.updateNumberVerification,
      page: () => NumberUpdateVerificationScreen(),
      binding: ProfileBinding()
    ),
    GetPage(
      name:AppRoutes.referAndEarn,
      page: () => ReferAndEarnScreen(),
      // binding: NotificationBinding()
    ),
    GetPage(
      name:AppRoutes.salarySlip,
      page: () => EarnIncomeScreen(),
      binding: SalarySlipBinding()
    ),
    GetPage(
      name:AppRoutes.leaveAttendance,
      page: () => LeavesAttendanceScreen(),
      binding: LeaveBinding()
    ),
    GetPage(
      name:AppRoutes.helpSupport,
      page: () => HelpSupportScreen(),
      // binding: NotificationBinding()
    ),
    GetPage(
      name:AppRoutes.bottomNav,
      page: () => CustomBottomNav(),
      binding: BottomNavBinding()
    )
  ];
}
