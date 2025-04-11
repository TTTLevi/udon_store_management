import 'package:do_an_ck/services/authentication/authservice.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  var isLogin = false.obs;
  var isForgetPassword = false.obs;
  var isLoading = false.obs;
  var userRole = ''.obs;
  var userName = ''.obs;
  var isPasswordObscure = true.obs;
  var isConfirmPasswordObscure = true.obs;
  var rememberMe = false.obs;

  final Authservice authService = Authservice();

  @override
  void onInit() {
    super.onInit();
    checkUserLoggedIn();
  }

  Future<void> login(String email, String password) async {
    try {
      isLoading(true);
      UserCredential userCredential = await authService.login(email, password);
      Map<String, String> userInfo =
          await authService.getUserInfo(userCredential.user!.uid);
      userRole.value = userInfo['role']!;
      userName.value = userInfo['name']!;
      print('Logged in - Role: ${userRole.value}, Name: ${userName.value}');
      if (userRole.value == 'admin') {
        Get.offNamed('/admin');
      } else {
        Get.offNamed('/home');
      }
    } catch (e) {
      _handleAuthError(e);
    } finally {
      isLoading(false);
    }
  }

  Future<void> signUp(
      String email, String password, String name, String role) async {
    try {
      isLoading(true);
      UserCredential userCredential = await authService.signUp(email, password);
      await authService.firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'email': email,
        'name': name,
        'role': role,
      });
      userName.value = name;
      userRole.value = role;
      Get.snackbar('Thành công', 'Đăng ký thành công');
      Get.offNamed('/login');
    } catch (e) {
      _handleAuthError(e);
    } finally {
      isLoading(false);
    }
  }

  Future<void> signOut() async {
    await authService.signOut();
    isLogin.value = false;
    userName.value = '';
    userRole.value = '';
    Get.offAllNamed('/login');
  }

  Future<void> resetPassword(String email) async {
    try {
      isLoading(true);
      await authService.resetPassword(email);
      Get.snackbar('Thành công', 'Vui lòng kiểm tra email để đặt lại mật khẩu');
      Get.offNamed('/login');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading(false);
    }
  }

  Future<void> checkUserLoggedIn() async {
    final user = authService.auth.currentUser;
    if (user != null) {
      isLogin.value = true;
      Map<String, String> userInfo =
          await authService.getUserInfo(user.uid); // Lấy thông tin từ Firestore
      userRole.value = userInfo['role'] ?? '';
      userName.value = userInfo['name'] ?? '';
      print(
          'User logged in - Role: ${userRole.value}, Name: ${userName.value}');
    } else {
      isLogin.value = false;
    }
  }

  void togglePasswordVisibility() {
    isPasswordObscure.value = !isPasswordObscure.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordObscure.value = !isConfirmPasswordObscure.value;
  }

  Future<void> savePassword(
      String email, String password, bool rememberMe) async {
    final prefs = await SharedPreferences.getInstance();
    if (rememberMe) {
      prefs.setString('email', email);
      prefs.setString('password', password);
    } else {
      prefs.remove('email');
      prefs.remove('password');
    }
  }

  Future<Map<String, String?>> getSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('email');
    String? password = prefs.getString('password');
    return {'email': email, 'password': password};
  }

  Future<bool> checkEmailExists(String email) async {
    final snapshot = await authService.firestore
        .collection('users')
        .where('email', isEqualTo: email)
        .get();
    return snapshot.docs.isNotEmpty;
  }

  void _handleAuthError(dynamic error) {
    String errorMessage;
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'invalid-email':
          errorMessage = 'Email không hợp lệ. Vui lòng kiểm tra lại.';
          break;
        case 'email-already-in-use':
          errorMessage = 'Email đã được sử dụng. Vui lòng chọn email khác.';
          break;
        case 'weak-password':
          errorMessage = 'Mật khẩu quá yếu. Vui lòng nhập mật khẩu mạnh hơn.';
          break;
        case 'operation-not-allowed':
          errorMessage = 'Tài khoản không được phép thực hiện thao tác này.';
          break;
        default:
          errorMessage = 'Đã có lỗi xảy ra: ${error.message}';
      }
    } else {
      errorMessage = 'Đã có lỗi xảy ra: $error';
    }
    // Get.snackbar('Lỗi', errorMessage, snackPosition: SnackPosition.BOTTOM);
    print('Auth error: $error');
  }
}
