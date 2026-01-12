import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruiteforest/feature/auth/bloc/auth_bloc.dart';
import 'package:fruiteforest/feature/auth/presentation/createuser/create_user_page.dart';
import 'package:fruiteforest/feature/homepage/presentation/home_page.dart';

class OtpVerificationPage extends StatelessWidget {
  final String phone;
  OtpVerificationPage({super.key, required this.phone});

  final otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            if (state.flow == 1) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) {
                    return const CreateProfilePage();
                  },
                ),
              );
            } else if (state.flow == 2) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) {
                    return const HomePage();
                  },
                ),
              );
            }
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("OTP sent to $phone"),
              TextField(
                controller: otpController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(hintText: "Enter OTP"),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  context.read<AuthBloc>().add(
                    VerifyOtpEvent(phone: phone, otp: otpController.text),
                  );
                },
                child: const Text("Verify OTP"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
