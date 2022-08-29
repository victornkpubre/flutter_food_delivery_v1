import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/controllers/auth_controller.dart';
import 'package:food_delivery/models/signup_body_model.dart';
import 'package:food_delivery/route/route_helper.dart';
import 'package:food_delivery/utils/colors.dart';
import 'package:food_delivery/utils/dimensions.dart';
import 'package:food_delivery/views/auth/sign_in_page.dart';
import 'package:food_delivery/views/base/custom_loader.dart';
import 'package:food_delivery/views/base/show_custom_message.dart';
import 'package:food_delivery/widgets/app_text_field.dart';
import 'package:food_delivery/widgets/big_text.dart';
import 'package:get/get.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  @override
  Widget build(BuildContext context) {
    var nameController = TextEditingController();
    var emailController = TextEditingController();
    var passwordController = TextEditingController();
    var phoneController = TextEditingController();
    var socialSignUpImages = ["t.png", "f.png", "g.png"];

    void _registration(AuthController authController) {
      String name = nameController.text.trim();
      String email = emailController.text.trim();
      String password = passwordController.text.trim();
      String phone = phoneController.text.trim();

      if (name.isEmpty) {
        showCustomSnackBar("Type in your name", title: "Name");
      } else if (phone.isEmpty) {
        showCustomSnackBar("Type in your phone number", title: "Phone number");
      } else if (email.isEmpty) {
        showCustomSnackBar("Type in your email", title: "Email address");
      } else if (!GetUtils.isEmail(email)) {
        showCustomSnackBar("Type in a valid email address",
            title: "Valid email address");
      } else if (password.isEmpty) {
        showCustomSnackBar("Type in your password", title: "Password");
      } else if (password.length < 6) {
        showCustomSnackBar("Password can't be less than six character",
            title: "Password");
      } else {
        showCustomSnackBar("All went well", title: "Perfect");
        SignUpBody signUpBody = SignUpBody(
          name: name,
          phone: phone,
          email: email,
          password: password,
        );

        //register
        authController.registration(signUpBody).then((status) {
          if (status.isSuccess) {
            print("Success Registration");
            showCustomSnackBar("Success Registration", isError: false);
            Get.offNamed(GetRouter.getInitial());
          } else {
            showCustomSnackBar(status.message, title: "Failed Registration" );
            print(status.message);
          }
        });
      }
    }

    return Scaffold(
        backgroundColor: Colors.white,
        body: GetBuilder<AuthController>(builder: (_authController) {
          return !_authController.isLoading
              ? SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      SizedBox(height: Dimensions.screenHeight * 0.05),
                      //Logo
                      Container(
                        decoration:
                            BoxDecoration(shape: BoxShape.circle, boxShadow: [
                          BoxShadow(
                              blurRadius: 1,
                              spreadRadius: -25,
                              offset: Offset(3, 3),
                              color: Colors.grey.withOpacity(0.2)),
                        ]),
                        padding: EdgeInsets.all(Dimensions.height30),
                        child: Center(
                          child: CircleAvatar(
                            radius: Dimensions.radius30 * 4,
                            backgroundColor: Colors.white,
                            backgroundImage: const AssetImage(
                                "assets/image/logo part 1.png"),
                          ),
                        ),
                      ),

                      //Form
                      AppTextField(
                          textController: nameController,
                          hintText: "Name",
                          icon: Icons.person),
                      SizedBox(height: Dimensions.height20),
                      AppTextField(
                          textController: emailController,
                          hintText: "Email",
                          icon: Icons.email),
                      SizedBox(height: Dimensions.height20),
                      AppTextField(
                          isObscure: true,
                          textController: passwordController,
                          hintText: "Password",
                          icon: Icons.password),
                      SizedBox(height: Dimensions.height20),
                      AppTextField(
                          textController: phoneController,
                          hintText: "Phone",
                          icon: Icons.phone),
                      SizedBox(height: Dimensions.height20),

                      //Button
                      GestureDetector(
                        onTap: () {
                          _registration(_authController);
                        },
                        child: Container(
                          width: Dimensions.screenWidth / 3,
                          height: Dimensions.screenHeight / 15,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(Dimensions.radius30),
                              color: AppColors.mainColor),
                          child: Center(
                              child: BigText(
                            text: "Sign Up",
                            size: Dimensions.font24,
                            color: Colors.white,
                          )),
                        ),
                      ),
                      SizedBox(
                        height: Dimensions.height10,
                      ),

                      //Login
                      Container(
                        padding: EdgeInsets.all(Dimensions.height15),
                        child: RichText(
                            text: TextSpan(
                                text: "Have an account already? Login",
                                recognizer: TapGestureRecognizer()
                                 ..onTap = (() => Get.back()),
                                style: TextStyle(
                                  color: Colors.grey[500],
                                  fontSize: Dimensions.font24,
                                ))),
                      ),
                      SizedBox(
                        height: Dimensions.height15,
                      ),

                      //Social Login
                      Wrap(
                        children: List.generate(3, (index) {
                          return Container(
                            padding: EdgeInsets.all(Dimensions.width10 * 3),
                            child: CircleAvatar(
                              radius: Dimensions.radius20 * 3,
                              backgroundImage: AssetImage(
                                  "assets/image/" + socialSignUpImages[index]),
                            ),
                          );
                        }),
                      )
                    ],
                  ),
                )
              : CustomLoader();
        }));
  }
}
