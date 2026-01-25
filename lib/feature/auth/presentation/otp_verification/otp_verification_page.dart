import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruiteforest/common/utils/snackbars/error_snackbar_widget.dart';
import 'package:fruiteforest/feature/auth/bloc/auth_bloc.dart';
import 'package:fruiteforest/feature/auth/presentation/createuser/create_user_page.dart';
import 'package:fruiteforest/feature/auth/presentation/widgets/bottom_button_auth_widget.dart';
import 'package:fruiteforest/feature/homepage/presentation/home_page.dart';
import 'package:fruiteforest/feature/auth/presentation/widgets/otp_textfield.dart';

class OtpVerificationPage extends StatefulWidget {
  final String phone;

  const OtpVerificationPage({super.key, required this.phone});

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  String enteredOtp = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            if (state.flow == 1) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const CreateProfilePage()),
              );
            } else if (state.flow == 2) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const HomePage()),
              );
            }
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  const SizedBox(height: 160),
                  Text(
                    "Enter OTP",
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "OTP has been sent to +91 ${widget.phone}",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 40),

                  /// ✅ OTP FIELD
                  OtpTextField(
                    onCompleted: (otp) {
                      enteredOtp = otp;
                    },
                  ),
                ],
              ),

              /// ✅ VERIFY BUTTON
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  return BottomButtonAuthWidget(
                    isLoading: state is AuthLoading,
                    buttonText: "VERIFY OTP",
                    onTap: () {
                      if (enteredOtp.length != 6) {
                        AppErrorSnackBar.show(
                          context,
                          "Enter valid 6 digit OTP",
                        );
                        return;
                      }

                      context.read<AuthBloc>().add(
                        VerifyOtpEvent(phone: widget.phone, otp: enteredOtp),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
