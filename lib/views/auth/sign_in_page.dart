import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/controllers/auth_controller.dart';
import 'package:food_delivery/models/signin_body_model.dart';
import 'package:food_delivery/route/route_helper.dart';
import 'package:food_delivery/utils/colors.dart';
import 'package:food_delivery/utils/dimensions.dart';
import 'package:food_delivery/views/auth/sign_up_page.dart';
import 'package:food_delivery/views/base/custom_loader.dart';
import 'package:food_delivery/views/base/show_custom_message.dart';
import 'package:food_delivery/widgets/app_text_field.dart';
import 'package:food_delivery/widgets/big_text.dart';
import 'package:get/get.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  @override
  Widget build(BuildContext context) {
    var phoneController = TextEditingController();
    var passwordController = TextEditingController();
    var socialSignUpImages = ["t.png", "f.png", "g.png"];

    void _login( AuthController authController) {
      String phone = phoneController.text.trim();
      String password = passwordController.text.trim();

      if (phone.isEmpty) {
        showCustomSnackBar("Type in your phone", title: "Phone address");
      } else if (!GetUtils.isNumericOnly(phone)) {
        showCustomSnackBar("Type in a valid phone number",
            title: "Valid Phone number");
      } else if (password.isEmpty) {
        showCustomSnackBar("Type in your password", title: "Password");
      } else if (password.length < 6) {
        showCustomSnackBar("Password can't be less than six character",
            title: "Password");
      } else {
        showCustomSnackBar("All went well", title: "Perfect");
        SignInBody signInBody = SignInBody(
          phone: phone,
          password: password,
        );

        //login
        authController.login(signInBody).then((status) {
          if (status.isSuccess) {
            showCustomSnackBar("Success Login", isError: false);
            Get.toNamed(GetRouter.getCartPage());
          } else {
            showCustomSnackBar(status.message);
          }
        });
      }
    }

    return Scaffold(
        backgroundColor: Colors.white,
        body: GetBuilder<AuthController>( builder: (_authController) {
            return !_authController.isLoading ? SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: SizedBox(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SizedBox(height: Dimensions.screenHeight * 0.15),
                    //Logo
                    Container(
                      decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [
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
                          backgroundImage:
                              const AssetImage("assets/image/logo part 1.png"),
                        ),
                      ),
                    ),

                    //Form
                    AppTextField(
                        textController: phoneController,
                        hintText: "phone",
                        icon: Icons.phone),
                    SizedBox(height: Dimensions.height20),
                    AppTextField(
                        textController: passwordController,
                        hintText: "Password",
                        isObscure: true,
                        icon: Icons.password),
                    SizedBox(height: Dimensions.height20),

                    //Button
                    GestureDetector(
                      onTap: () {
                        _login(_authController);
                      },
                      child: Container(
                        width: Dimensions.screenWidth / 3,
                        height: Dimensions.screenHeight / 15,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(Dimensions.radius30),
                            color: AppColors.mainColor),
                        child: Center(
                            child: BigText(
                          text: "Sign In",
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
                              text: "Don't have an acoount? Register",
                              recognizer: TapGestureRecognizer()
                               ..onTap = (() => Get.to(SignUpPage(), transition: Transition.fade)),
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
              ),
            ) :CustomLoader();
          }
        ));
  }
}
