import 'package:bicycle_app_technician/app/modules/auth/controller/sign_up_controller.dart';
import 'package:bicycle_app_technician/app/routes/app_routes.dart';
import 'package:bicycle_app_technician/view/Colors/app_colors.dart';
import 'package:bicycle_app_technician/view/widgets/custom_button.dart';
import 'package:bicycle_app_technician/view/widgets/custom_snackbar.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:validate_phone_number/validation.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _referralCodeController = TextEditingController();

  final SignUpController controller = Get.find();

  bool _isPasswordVisible = false;

  Future<void> _selectDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        _dobController.text =
            "${pickedDate.day.toString().padLeft(2, '0')}/"
            "${pickedDate.month.toString().padLeft(2, '0')}/"
            "${pickedDate.year}";
      });
    }
  }

  @override
  void dispose() {
    _dobController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBg,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            double maxWidth = constraints.maxWidth;
        
            // Tablet support
            double contentWidth = maxWidth > 600 ? 500 : maxWidth;
        
            return Obx(
              () => Center(
                child: SizedBox(
                  width: contentWidth,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: maxWidth * 0.04),
              
                        /// Title
                        Center(
                          child: Column(
                            children: const [
                              Text(
                                "Sign Up",
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                "Create an account to continue!",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Color.fromRGBO(108, 114, 120, 1),
                                ),
                              ),
                            ],
                          ),
                        ),
              
                        SizedBox(height: maxWidth * 0.08),
              
                        /// First & Last Name
                        Row(
                          children: [
                            Expanded(
                              child: _buildTextField(
                                "First Name*",
                                "John",
                                controller: _firstNameController,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildTextField(
                                "Last Name*",
                                "Doe",
                                controller: _lastNameController,
                              ),
                            ),
                          ],
                        ),
              
                        SizedBox(height: maxWidth * 0.05),
              
                        _buildTextField(
                          "Email*",
                          "example@gmail.com",
                          controller: _emailController,
                        ),
              
                        SizedBox(height: maxWidth * 0.05),
              
                        _buildTextField(
                          "Date of birth*",
                          "DD/MM/YYYY",
                          controller: _dobController,
                          readOnly: true,
                          suffixIcon: Icons.calendar_today_outlined,
                          onTap: _selectDate,
                        ),
              
                        SizedBox(height: maxWidth * 0.05),
              
                        _buildPhoneField(),
              
                        SizedBox(height: maxWidth * 0.05),
              
                        _buildTextField(
                          "Set Password*",
                          "*******",
                          controller: _passwordController,
                          isPassword: true,
                        ),

                        SizedBox(height: maxWidth * 0.05),

                        _buildTextField("Promo Code", "PCS00XXX",controller: _referralCodeController),
              
                        SizedBox(height: maxWidth * 0.12),
              
                        /// Next Button
                        InkWell(
                          onTap: () async {
                            if (_emailController.text.isNotEmpty) {
                              bool isValid = EmailValidator.validate(
                                _emailController.text.trim(),
                              );
                              if (!isValid) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  CustomSnackbar.show(
                                    title: "Please enter a valid email",
                                    color: Colors.red[300]!,
                                  ),
                                );
                                return;
                              }
                            } 
                            if (_phoneController.text.isNotEmpty) {
                              bool isValid = Validator.validatePhoneNumber(
                                _phoneController.text.trim(),
                                "IN",
                              );
                              if (!isValid) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  CustomSnackbar.show(
                                    title: "Please enter a valid number",
                                    color: Colors.red[300]!,
                                  ),
                                );
                                return;
                              }
                            } 
                            if (_firstNameController.text
                                    .trim()
                                    .isEmpty ||
                                _lastNameController.text.trim().isEmpty ||
                                _dobController.text.trim().isEmpty ||
                                _phoneController.text.trim().isEmpty ||
                                _passwordController.text.trim().isEmpty ||
                                _emailController.text.trim().isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                CustomSnackbar.show(
                                  title: "Please fill all the required fields",
                                  color: Colors.red[300]!,
                                ),
                              );
                              return;
                            } else if (_passwordController.text.trim().length <
                                8) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                CustomSnackbar.show(
                                  title: "Password too short",
                                  color: Colors.red[300]!,
                                ),
                              );
                              return;
                            } else {
                              Map<String, dynamic> body = {
                                "first_name": _firstNameController.text.trim(),
                                "last_name": _lastNameController.text.trim(),
                                "email": _emailController.text.trim(),
                                "phone": _phoneController.text.trim(),
                                "dob": _dobController.text.trim(),
                                "password": _passwordController.text.trim(),
                                "promo_code":_referralCodeController.text.trim()
                              };
                              await controller.signUp(body);
                              if (controller.isStep1Completed.value) {
                                Get.toNamed(AppRoutes.verification);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  CustomSnackbar.show(
                                    title: controller.errorMessage.value,
                                    color: Colors.red[300]!,
                                  ),
                                );
                              }
                            }
                          },
                          child: CustomButton(
                            text: "Next",
                            isLoading: controller.isLoading.value,
                            textSize: 16,
                            textWeight: FontWeight.w600,
                            textColor: Colors.white,
                            bgColor: AppColors.blue,
                            radius: 10,
                            height: 48,
                          ),
                        ),
              
                        SizedBox(height: maxWidth * 0.05),
              
                        /// Login Text
                        Center(
                          child: InkWell(
                            onTap: () {
                              Get.toNamed(AppRoutes.signIn);
                            },
                            child: RichText(
                              text: TextSpan(
                                text: "Already have an account? ",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                                children: [
                                  TextSpan(
                                    text: "Login",
                                    style: TextStyle(
                                      color: Colors.orange,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
              
                        SizedBox(height: maxWidth * 0.05),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  /// Reusable TextField
  Widget _buildTextField(
    String label,
    String hint, {
    TextEditingController? controller,
    IconData? suffixIcon,
    bool isPassword = false,
    VoidCallback? onTap,
    bool readOnly = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Color.fromRGBO(108, 114, 120, 1),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color.fromRGBO(237, 241, 243, 1)),
            boxShadow: const [
              BoxShadow(
                color: Color.fromRGBO(228, 229, 231, 0.24),
                offset: Offset(0, 1),
                blurRadius: 2,
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            obscureText: isPassword ? !_isPasswordVisible : false,
            readOnly: readOnly,
            onTap: onTap,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(
                fontSize: 14,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 16,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              suffixIcon: isPassword
                  ? IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        size: 18,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    )
                  : (suffixIcon != null ? Icon(suffixIcon, size: 18) : null),
            ),
          ),
        ),
      ],
    );
  }

  /// Phone Field
  Widget _buildPhoneField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Phone Number*",
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Color.fromRGBO(108, 114, 120, 1),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color.fromRGBO(237, 241, 243, 1)),
            boxShadow: const [
              BoxShadow(
                color: Color.fromRGBO(228, 229, 231, 0.24),
                offset: Offset(0, 1),
                blurRadius: 2,
              ),
            ],
          ),
          child: Row(
            children: [
              const SizedBox(width: 12),
              const Text("+91", style: TextStyle(fontWeight: FontWeight.w500)),
              // const Icon(Icons.keyboard_arrow_down, size: 18),
              const SizedBox(width: 8),
              Container(height: 24, width: 1, color: Colors.grey.shade300),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: "",
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
