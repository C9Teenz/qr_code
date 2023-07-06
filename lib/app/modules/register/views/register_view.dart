import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../controllers/auth_controller.dart';
import '../../../routes/app_pages.dart';
import '../controllers/register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  RegisterView({Key? key}) : super(key: key);
  final TextEditingController emailC = TextEditingController();
  final TextEditingController passC = TextEditingController();
  final AuthController authC = Get.find<AuthController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Register'),
          centerTitle: true,
        ),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              controller: emailC,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(9),
                  ),
                  labelText: 'Email'),
            ),
            const SizedBox(
              height: 15,
            ),
            Obx(
              () => TextFormField(
                keyboardType: TextInputType.text,
                controller: passC,
                obscureText: controller.ishidden.value,
                decoration: InputDecoration(
                    suffixIcon: IconButton(
                        onPressed: () => controller.ishidden.toggle(),
                        icon: Icon(controller.ishidden.value == true
                            ? Icons.remove_red_eye
                            : Icons.remove_red_eye_outlined)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(9),
                    ),
                    labelText: 'Password'),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            TextButton(
                onPressed: () {
                  Get.toNamed(Routes.login);
                },
                child: const Text("Have an account? Login")),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9))),
              onPressed: () async {
                if (controller.isLoading.isFalse) {
                  if (emailC.text.isNotEmpty && passC.text.isNotEmpty) {
                    controller.isLoading(true);
                    Map<String, dynamic> result =
                        await authC.register(emailC.text, passC.text);
                    controller.isLoading(false);
                    if (result['error'] == true) {
                      Get.snackbar("error", result['message']);
                    } else {
                      Get.offAllNamed(Routes.login);
                    }
                  } else {
                    Get.snackbar("error", "Email and password is empty");
                  }
                }
              },
              child: Obx(
                () => Text(
                    controller.isLoading.isFalse ? 'Register' : 'Loading...'),
              ),
            )
          ],
        ));
  }
}
