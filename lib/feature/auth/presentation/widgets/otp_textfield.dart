import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fruiteforest/common/theme/colors/colors.dart';

class OtpTextField extends StatefulWidget {
  final Function(String) onCompleted;

  const OtpTextField({super.key, required this.onCompleted});

  @override
  State<OtpTextField> createState() => _OtpTextFieldState();
}

class _OtpTextFieldState extends State<OtpTextField> {
  final List<TextEditingController> _controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );

  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  void _onChanged(int index, String value) {
    if (value.length == 1) {
      if (index < 5) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();
        _submitOtp();
      }
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  void _submitOtp() {
    String otp = _controllers.map((c) => c.text).join();
    if (otp.length == 6) {
      widget.onCompleted(otp);
    }
  }

  Widget _buildBox(int index) {
    return SizedBox(
      width: 50,
      height: 60,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          /// 🔹 Shadow (back)
          Positioned(
            top: -3,
            left: 3,
            child: Container(
              width: 50,
              height: 60,
              decoration: BoxDecoration(
                color: AppColors.black,
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),

          /// 🔹 Front white box
          Container(
            width: 50,
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.backgroundColor, // ✅ white
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: AppColors.black, width: 2),
            ),
            child: KeyboardListener(
              focusNode: FocusNode(),
              onKeyEvent: (event) {
                // Handle backspace on empty field
                if (event is KeyDownEvent &&
                    event.logicalKey == LogicalKeyboardKey.backspace) {
                  if (_controllers[index].text.isEmpty && index > 0) {
                    _focusNodes[index - 1].requestFocus();
                  }
                }
              },
              child: TextField(
                controller: _controllers[index],
                focusNode: _focusNodes[index],
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                maxLength: 1,
                style: Theme.of(
                  context,
                ).textTheme.headlineMedium?.copyWith(color: AppColors.black),
                decoration: const InputDecoration(
                  counterText: "",
                  border: InputBorder.none,
                ),
                onChanged: (value) => _onChanged(index, value),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(6, (index) => _buildBox(index)),
    );
  }
}
