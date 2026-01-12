import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruiteforest/feature/auth/bloc/auth_bloc.dart';
import 'package:fruiteforest/feature/homepage/presentation/home_page.dart';

class CreateProfilePage extends StatefulWidget {
  const CreateProfilePage({super.key});

  @override
  State<CreateProfilePage> createState() => _CreateProfilePageState();
}

class _CreateProfilePageState extends State<CreateProfilePage> {
  final nameController = TextEditingController();
  final ageController = TextEditingController();

  String gender = 'male';
  String profession = 'student';
  String purpose = 'focus';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create Profile")),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is ProfileCreatedSuccess) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const HomePage()),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Name"),
              ),
              TextField(
                controller: ageController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Age"),
              ),

              const SizedBox(height: 16),
              _dropdown("Gender", gender, [
                'male',
                'female',
                'others',
              ], (v) => setState(() => gender = v)),

              _dropdown("Profession", profession, [
                'student',
                'working professional',
                'entrepreneur',
                'freelancer',
                'techi',
                'homemaker',
                'other',
              ], (v) => setState(() => profession = v)),

              _dropdown(
                "What do you mainly want to improve?",
                purpose,
                [
                  'focus',
                  'time management',
                  'consistency habits',
                  'reduce procrastination',
                  'study productivity',
                  'work productivity',
                  'mental clarity',
                ],
                (v) => setState(() => purpose = v),
              ),

              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  context.read<AuthBloc>().add(
                    CreateProfileEvent(
                      name: nameController.text,
                      age: int.parse(ageController.text),
                      gender: gender,
                      profession: profession,
                      purpose: purpose,
                    ),
                  );
                },
                child: const Text("Continue"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dropdown(
    String label,
    String value,
    List<String> items,
    ValueChanged<String> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        DropdownButton<String>(
          value: value,
          isExpanded: true,
          items: items
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: (v) => onChanged(v!),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
