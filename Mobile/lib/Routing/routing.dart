import 'package:get/get.dart';
import 'package:testing/Pages/Admin/Doctor/doctor.dart';
import 'package:testing/Pages/Admin/Doctor/operationrequest.dart';
import 'package:testing/Pages/Admin/Doctor/shareprofile.dart';
import 'package:testing/Pages/Admin/Laboratories/laboratories.dart';
import 'package:testing/Pages/Admin/Laboratories/viewlaboratories.dart';
import 'package:testing/Pages/Admin/Pharmacies/viewpharmacies.dart';
import 'package:testing/Pages/Admin/admin.dart';
import 'package:testing/Pages/Admin/Pharmacies/pharmacies.dart';
import 'package:testing/Pages/Admin/Doctor/viewprofile.dart';
import 'package:testing/Pages/Administrator/profiels.dart';
import 'package:testing/Pages/Administrator/specializations.dart';
import 'package:testing/Pages/Administrator/users.dart';
import 'package:testing/Pages/Administrator/userstype.dart';
import 'package:testing/Pages/ForgetPassword/forgetauth.dart';
import 'package:testing/Pages/ForgetPassword/forgetchangepassword.dart';
import 'package:testing/Pages/ForgetPassword/forgetpassowrd.dart';
import 'package:testing/Pages/Setting/adminaccount.dart';
import 'package:testing/Pages/Setting/setting.dart';
import 'package:testing/Pages/Administrator/administrator.dart';
import 'package:testing/Pages/Setting/useraccount.dart';
import 'package:testing/Pages/SignIn/authintication.dart';
 import 'package:testing/Pages/User/reportdetails.dart';
import 'package:testing/Pages/User/userpage.dart';
import 'package:testing/Pages/Login/login.dart';
import 'package:testing/Pages/Setting/changepassword.dart';
import 'package:testing/Pages/User/viewspecializations.dart';
import 'package:testing/Pages/User/notification.dart';
import 'package:testing/Pages/OnBoarding/onboarding.dart';
import 'package:testing/Pages/SignIn/signin.dart';
import 'package:testing/Pages/showimage.dart';
import 'approuting.dart';
import 'middleware.dart';

List<GetPage<dynamic>>? routes = [
  // OnBoarding Page + first Page
  GetPage(
      name: '/',
      page: () => const OnBoarding(),
      transition: Transition.fade,
      middlewares: [Middleware()]),

  // login page
  GetPage(
      name: AppRouting.login,
      page: () => const Login(),
      transition: Transition.fade),

  // signin page
  GetPage(
      name: AppRouting.signin,
      page: () => const Signin(),
      transition: Transition.fade),

  // auth page
  GetPage(
      name: AppRouting.authpage,
      page: () => AuthinticationPage(
          email: Get.parameters['email'] ?? '',
          usertype: Get.parameters['usertype'] ?? "4",
          password: Get.parameters['password'] ?? '',
          authauthPassword: Get.parameters['authPassword'] ?? '',
          name: Get.parameters['name'] ?? ''),
      transition: Transition.fade),


  // setting page
  GetPage(
      name: AppRouting.setting,
      page: () => const SettingPage(),
      transition: Transition.fade),
  // ChangePassword Page
  GetPage(
      name: AppRouting.changePass,
      page: () => const ChangePassword(),
      transition: Transition.fade),

// --------- ForgetPassword ---------

  // ForgetPassword Page
  GetPage(
      name: AppRouting.forgetpasswrod,
      page: () => const ForgetPassword(),
      transition: Transition.fade),

  // forgetpasswrodauth Page
  GetPage(
      name: AppRouting.forgetpasswrodauth,
      page: () => ForgetAuth(
            email: Get.parameters['email'] ?? "",
            authauthPassword: Get.parameters['authCode'] ?? "",
            usertype: Get.parameters['usertype'] ?? "",
            forgetype: Get.parameters['forgetype'] ?? "",
            id: Get.parameters['id'] ?? "",
          ),
      transition: Transition.fade),
  // forgetChangePass Page
  GetPage(
      name: AppRouting.forgetChangePass,
      page: () => ForgetChangePassword(
            id: Get.parameters['id'] ?? "",
            usertype: Get.parameters['usertype'] ?? "",
          ),
      transition: Transition.fade),

// --------- Administator ---------
  // Administrator Home page
  GetPage(
      name: AppRouting.administrator,
      page: () => const Administrator(),
      transition: Transition.fade),
  // Specializations Page
  GetPage(
      name: AppRouting.specializations,
      page: () => const Specializations(),
      transition: Transition.fade),
  // Profiles Page
  GetPage(
      name: AppRouting.profiles,
      page: () => const Profiles(),
      transition: Transition.fade),

  // users Page
  GetPage(
      name: AppRouting.users,
      page: () => const Users(),
      transition: Transition.fade),

  // usersType Page
  GetPage(
      name: AppRouting.usersType,
      page: () => const UsersType(),
      transition: Transition.fade),

// --------- Users ---------
  // User home Page
  GetPage(
      name: AppRouting.home,
      page: () => const UserPage(),
      transition: Transition.fade),

  // User notification Page
  GetPage(
      name: AppRouting.notification,
      page: () => const NotificationPage(),
      transition: Transition.fade),

  // User Personal Accoutn Page
  GetPage(
      name: AppRouting.useraccount,
      page: () => const UserAccount(),
      transition: Transition.fade),

  // User report details page
  GetPage(
      name: AppRouting.userReportDetails,
      page: () => UserReportDetails(
            item: Get.arguments,
          ),
      transition: Transition.fade),

  // showimage Page
  GetPage(
      name: AppRouting.showimage,
      page: () => Showimage(image: Get.parameters['image'] ?? ''),
      transition: Transition.fade),

  // View Specializations page
  GetPage(
      name: AppRouting.viewspecializations,
      page: () => Viewspecializations(data: Get.arguments),
      transition: Transition.fade),

// --------- Admin ---------

  // Admin home Pages
  GetPage(
      name: AppRouting.admin,
      page: () => const Admin(),
      transition: Transition.fade),

  // admin Setting personal account page
  GetPage(
      name: AppRouting.adminaccount,
      page: () => const AdminAccount(),
      transition: Transition.fade),

  // doctor page
  GetPage(
      name: AppRouting.doctor,
      page: () => const Doctors(),
      transition: Transition.fade),

  // paitent profile page
  GetPage(
      name: AppRouting.viewprofile,
      page: () => ViewProfile(
            id: Get.parameters['id'] ?? "",
            title: Get.parameters['title'] ?? "",
          ),
      transition: Transition.fade),

  // pharmacies Page
  GetPage(
      name: AppRouting.pharmacies,
      page: () => const Pharmacies(),
      transition: Transition.fade),

  // view pharmacies for paitent Page
  GetPage(
      name: AppRouting.viewpharmacies,
      page: () => ViewPharmacies(data: Get.arguments),
      transition: Transition.fade),

  // laboratories Page
  GetPage(
      name: AppRouting.laboratories,
      page: () => const Laboratories(),
      transition: Transition.fade),

  // view laboratories for paitent Page
  GetPage(
      name: AppRouting.viewlaboratories,
      page: () => ViewLaboratories(data: Get.arguments),
      transition: Transition.fade),

  // Operation Request Page
  GetPage(
      name: AppRouting.operationRequest,
      page: () => OperationRequest(
            usertype: Get.parameters['usertype'] ?? '',
            title: Get.parameters['title'] ?? '',
            data: Get.arguments,
          ),
      transition: Transition.fade),
  GetPage(
      name: AppRouting.shareprofile,
      page: () => ShareProfile(
            title: Get.parameters['title'] ?? '',
            data: Get.arguments,
          ),
      transition: Transition.fade),
];
