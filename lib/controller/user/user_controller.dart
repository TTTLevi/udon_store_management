import 'package:do_an_ck/models/user.dart';
import 'package:do_an_ck/services/user_service.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  var userList = <User>[].obs;
  var errorMessage = ''.obs;
  var isLoading = true.obs;

  final UserService userService;
  UserController({required this.userService});

  get selectedUser => null;

  @override
  void onInit() {
    super.onInit();
    fetchAllUsers();
  }

  void fetchAllUsers() async {
    try {
      isLoading(true);
      final allUsers = await userService.getAllUsers();
      userList.assignAll(allUsers.where((user) => user.role.toLowerCase() == 'staff').toList());
    } catch (e) {
      errorMessage('Load users error: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<User?> fetchUserById(String userId) async {
    try {
      isLoading.value = true;
      return await userService.getUserById(userId);
    } catch (e) {
      errorMessage.value = 'Lỗi tải người dùng: $e';
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteUser(String userId) async {
    try {
      isLoading.value = true;
      await userService.deleteUser(userId);
      userList.removeWhere((user) => user.id == userId);
      Get.snackbar('Thành công', 'Xóa nhân viên thành công');
    } catch (e) {
      errorMessage.value = 'Lỗi xóa nhân viên: $e';
      Get.snackbar('Lỗi', 'Không thể xóa nhân viên: $e');
    } finally {
      isLoading.value = false;
    }
  }

}
