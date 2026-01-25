import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruiteforest/common/utils/snackbars/error_snackbar_widget.dart';
import 'package:fruiteforest/common/widget/textfield_widget.dart';
import 'package:fruiteforest/feature/auth/bloc/auth_bloc.dart';
import 'package:fruiteforest/feature/auth/presentation/otp_verification/otp_verification_page.dart';
import 'package:fruiteforest/feature/auth/presentation/widgets/bottom_button_auth_widget.dart';
import 'package:fruiteforest/feature/auth/presentation/widgets/terms_and_policy_widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final phoneController = TextEditingController();
  bool isPolicyAccepted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is OtpSentSuccess) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    OtpVerificationPage(phone: phoneController.text),
              ),
            );
          } else if (state is AuthError) {
            AppErrorSnackBar.show(context, state.message);
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  const SizedBox(height: 180),
                  Text(
                    "Get Started",
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                ],
              ),
              Column(
                children: [
                  AppTextField(
                    hintText: "Enter your phone number",
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 25),
                  TermsAndPolicyWidget(
                    onChanged: (value) {
                      isPolicyAccepted = value;
                    },
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    "Currently our app only available in INDIA\nSupport us to expand",
                    style: Theme.of(context).textTheme.labelMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 15),
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      return BottomButtonAuthWidget(
                        isLoading: state is AuthLoading,
                        onTap: () {
                          final phone = phoneController.text.trim();

                          if (phone.isEmpty) {
                            AppErrorSnackBar.show(
                              context,
                              "Please enter your phone number",
                            );
                            return;
                          }

                          if (phone.length != 10) {
                            AppErrorSnackBar.show(
                              context,
                              "Please enter a valid 10-digit phone number",
                            );
                            return;
                          }

                          if (!isPolicyAccepted) {
                            AppErrorSnackBar.show(
                              context,
                              "Please accept Terms & Conditions",
                            );
                            return;
                          }

                          context.read<AuthBloc>().add(SendOtpEvent(phone));
                        },
                        buttonText: "GET OTP",
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
