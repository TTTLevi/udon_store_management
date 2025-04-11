import 'package:do_an_ck/bindings/authBinding.dart';
import 'package:do_an_ck/bindings/cartBinding.dart';
import 'package:do_an_ck/bindings/invoiceBinding.dart';
import 'package:do_an_ck/bindings/onboardBinding.dart';
import 'package:do_an_ck/bindings/orderListBinding.dart';
import 'package:do_an_ck/bindings/productBinding.dart';
import 'package:do_an_ck/bindings/userBinding.dart';
import 'package:do_an_ck/pages/admin/product/add_product.dart';
import 'package:do_an_ck/pages/admin/product/product.dart';
import 'package:do_an_ck/pages/admin/product/product_detail.dart';
import 'package:do_an_ck/pages/admin/user/user_view.dart';
import 'package:do_an_ck/pages/admin/widgets/bot_navbar_admin.dart';
import 'package:do_an_ck/pages/common/login/login_page.dart';
import 'package:do_an_ck/pages/common/password/forget_password.dart';
import 'package:do_an_ck/pages/common/singup/signup_page.dart';
import 'package:do_an_ck/pages/staffs/cart_page.dart';
import 'package:do_an_ck/pages/staffs/staff_product_detail.dart';
import 'package:do_an_ck/pages/staffs/widgets/bot_navbar_staff.dart';
import 'package:do_an_ck/routes/app_routes.dart';
import 'package:get/get.dart';

import '../pages/common/onbroading/onboarding_page.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: Routes.ONBOARDING,
      page: () => const OnboardingPage(),
      binding: Onboardbinding(),
    ),
    GetPage(
      name: Routes.LOGIN,
      page: () => LoginPage(),
      bindings: [Authbinding(), Productbinding()],
    ),
    GetPage(
      name: Routes.SIGNUP,
      page: () => SignUpPage(),
      binding: Authbinding(),
    ),
    GetPage(
      name: Routes.FORGOTPASSWORD,
      page: () => ForgetPasswordPage(),
    ),
    GetPage(
      name: Routes.HOME,
      page: () => const BottomNavigationStaff(),
      bindings: [Productbinding(), Authbinding()],
    ),
    GetPage(
      name: Routes.ADMIN,
      page: () => const BottomNavigationAdmin(),
      bindings: [Productbinding(), Userbinding(), OrderListBinding()],
    ),
    GetPage(
      name: Routes.PRODUCT,
      page: () => Product(),
      bindings: [Productbinding()],
    ),
    GetPage(
      name: Routes.PRODUCTDETAIL,
      page: () => ProductDetail(),
    ),
    GetPage(
      name: Routes.ADDPRODUCT,
      page: () => AddProductScreen(),
    ),
    GetPage(
      name: Routes.USER,
      page: () => UserView(),
    ),
    GetPage(name: Routes.STAFFPRODUCTDETAIL,
      page: () => StaffProductDetail(),
      bindings: [Productbinding(), Cartbinding()],
    ),
    GetPage(name: Routes.CART,
      page: () => CartPage(),
      bindings: [Cartbinding(), Invoicebinding()],
    ),
  ];
}
