import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruiteforest/common/theme/colors/colors.dart';
import '../bloc/store_bloc.dart';

class AddShippingAddressPage extends StatefulWidget {
  final String itemId;

  const AddShippingAddressPage({super.key, required this.itemId});

  @override
  State<AddShippingAddressPage> createState() => _AddShippingAddressPageState();
}

class _AddShippingAddressPageState extends State<AddShippingAddressPage> {
  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();
  final _stateController = TextEditingController();
  final _districtController = TextEditingController();
  final _postOfficeController = TextEditingController();
  final _postPinController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _addressController.dispose();
    _stateController.dispose();
    _districtController.dispose();
    _postOfficeController.dispose();
    _postPinController.dispose();
    super.dispose();
  }

  void _submitAddress() {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSubmitting = true);

      context.read<StoreBloc>().add(
        AddShippingAddress(
          address: _addressController.text.trim(),
          state: _stateController.text.trim(),
          district: _districtController.text.trim(),
          postOffice: _postOfficeController.text.trim(),
          postPin: _postPinController.text.trim(),
          itemId: widget.itemId,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<StoreBloc, StoreState>(
      listener: (context, state) {
        if (state is ShippingAddressAdded || state is OrderPlaced) {
          Navigator.pop(context);
        } else if (state is StorePurchaseFailed) {
          setState(() => _isSubmitting = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            'Add Shipping Address',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          centerTitle: false,
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 8),

                // Address field (multiline)
                _buildTextField(
                  controller: _addressController,
                  hint: 'Address',
                  maxLines: 4,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Post Office
                _buildTextField(
                  controller: _postOfficeController,
                  hint: 'Post Office',
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter post office';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // District
                _buildTextField(
                  controller: _districtController,
                  hint: 'District',
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter district';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // State
                _buildTextField(
                  controller: _stateController,
                  hint: 'State',
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter state';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // PIN Code
                _buildTextField(
                  controller: _postPinController,
                  hint: 'PIN Code',
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter PIN code';
                    }
                    if (!RegExp(r'^[0-9]{6}$').hasMatch(value.trim())) {
                      return 'PIN code must be 6 digits';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),

                // DONE button
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isSubmitting ? null : _submitAddress,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.yellow,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      elevation: 0,
                    ),
                    child: _isSubmitting
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'DONE',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      enabled: !_isSubmitting,
      validator: validator,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 16),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.black, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.black, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.black, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        filled: false,
      ),
    );
  }
}
