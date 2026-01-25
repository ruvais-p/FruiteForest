import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruiteforest/common/theme/colors/colors.dart';
import 'package:fruiteforest/common/widget/textfield_widget.dart';
import 'package:fruiteforest/feature/auth/bloc/auth_bloc.dart';
import 'package:fruiteforest/common/utils/snackbars/error_snackbar_widget.dart';
import 'package:fruiteforest/feature/auth/presentation/widgets/auth_dropdown_widget.dart';
import 'package:fruiteforest/feature/auth/presentation/widgets/bottom_button_auth_widget.dart';
import 'package:fruiteforest/feature/homepage/presentation/home_page.dart';

class CreateProfilePage extends StatefulWidget {
  const CreateProfilePage({super.key});

  @override
  State<CreateProfilePage> createState() => _CreateProfilePageState();
}

class _CreateProfilePageState extends State<CreateProfilePage> {
  final nameController = TextEditingController();
  final ageController = TextEditingController();

  String? gender;
  String? profession;
  String? purpose;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is ProfileCreatedSuccess) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const HomePage()),
            );
          }
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.07),
                Text(
                  "Profile Setup",
                  style: Theme.of(context).textTheme.displayLarge,
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                AppTextField(
                  hintText: "Enter your name",
                  controller: nameController,
                ),
                const SizedBox(height: 16),
                AppTextField(
                  hintText: "Enter your age",
                  controller: ageController,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 20),

                /// ✅ Gender
                styledDropdown(
                  context: context,
                  hint: "Gender",
                  value: gender,
                  items: const ['male', 'female', 'others'],
                  onChanged: (v) => setState(() => gender = v),
                ),

                const SizedBox(height: 20),

                /// ✅ Profession
                styledDropdown(
                  context: context,
                  hint: "Profession",
                  value: profession,
                  items: const [
                    'student',
                    'working professional',
                    'entrepreneur',
                    'freelancer',
                    'techi',
                    'homemaker',
                    'other',
                  ],
                  onChanged: (v) => setState(() => profession = v),
                ),

                SizedBox(height: MediaQuery.of(context).size.height * 0.09),
                Text(
                  "What do you want to improve on?",
                  textAlign: TextAlign.left,
                  style: Theme.of(
                    context,
                  ).textTheme.labelLarge!.copyWith(color: AppColors.black),
                ),
                const SizedBox(height: 5),

                /// ✅ Purpose
                styledDropdown(
                  context: context,
                  hint: "I want to improve",
                  value: purpose,
                  items: const [
                    'focus',
                    'time management',
                    'consistency habits',
                    'reduce procrastination',
                    'study productivity',
                    'work productivity',
                    'mental clarity',
                  ],
                  onChanged: (v) => setState(() => purpose = v),
                ),

                SizedBox(height: MediaQuery.of(context).size.height * 0.1),

                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    return BottomButtonAuthWidget(
                      isLoading: state is AuthLoading,
                      onTap: () {
                        final name = nameController.text.trim();
                        final ageStr = ageController.text.trim();

                        if (name.isEmpty) {
                          AppErrorSnackBar.show(
                            context,
                            "Please enter your name",
                          );
                          return;
                        }

                        if (ageStr.isEmpty) {
                          AppErrorSnackBar.show(
                            context,
                            "Please enter your age",
                          );
                          return;
                        }

                        final age = int.tryParse(ageStr);
                        if (age == null) {
                          AppErrorSnackBar.show(
                            context,
                            "Please enter a valid age",
                          );
                          return;
                        }

                        if (gender == null) {
                          AppErrorSnackBar.show(
                            context,
                            "Please select your gender",
                          );
                          return;
                        }

                        if (profession == null) {
                          AppErrorSnackBar.show(
                            context,
                            "Please select your profession",
                          );
                          return;
                        }

                        if (purpose == null) {
                          AppErrorSnackBar.show(
                            context,
                            "Please select what you want to improve",
                          );
                          return;
                        }

                        context.read<AuthBloc>().add(
                          CreateProfileEvent(
                            name: name,
                            age: age,
                            gender: gender!,
                            profession: profession!,
                            purpose: purpose!,
                          ),
                        );
                      },
                      buttonText: "DONE",
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
