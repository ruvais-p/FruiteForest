import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruiteforest/common/theme/colors/colors.dart';
import '../bloc/store_bloc.dart';
import '../model/shipping_address_model.dart';

/// Edit Shipping Address Page
///
/// Form for viewing and editing the user's shipping address.
/// Uses AppTextTheme for consistent typography.
class EditShippingAddressPage extends StatefulWidget {
  const EditShippingAddressPage({super.key});

  @override
  State<EditShippingAddressPage> createState() =>
      _EditShippingAddressPageState();
}

class _EditShippingAddressPageState extends State<EditShippingAddressPage> {
  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();
  final _postOfficeController = TextEditingController();
  final _districtController = TextEditingController();
  final _stateController = TextEditingController();
  final _postPinController = TextEditingController();
  bool _isSubmitting = false;
  bool _isLoading = true;
  bool _hasAddress = false;

  @override
  void initState() {
    super.initState();
    context.read<StoreBloc>().add(LoadShippingAddress());
  }

  @override
  void dispose() {
    _addressController.dispose();
    _postOfficeController.dispose();
    _districtController.dispose();
    _stateController.dispose();
    _postPinController.dispose();
    super.dispose();
  }

  void _populateFields(ShippingAddress address) {
    _addressController.text = address.address;
    _postOfficeController.text = address.postOffice;
    _districtController.text = address.district;
    _stateController.text = address.state;
    _postPinController.text = address.postPin;
  }

  void _submitAddress() {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSubmitting = true);

      context.read<StoreBloc>().add(
        UpdateShippingAddress(
          address: _addressController.text.trim(),
          state: _stateController.text.trim(),
          district: _districtController.text.trim(),
          postOffice: _postOfficeController.text.trim(),
          postPin: _postPinController.text.trim(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return BlocListener<StoreBloc, StoreState>(
      listener: (context, state) {
        if (state is ShippingAddressLoaded) {
          setState(() {
            _isLoading = false;
            _hasAddress = state.address != null;
          });
          if (state.address != null) {
            _populateFields(state.address!);
          }
        } else if (state is ShippingAddressUpdated) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Address updated successfully! ✓',
                style: textTheme.bodyMedium?.copyWith(color: Colors.white),
              ),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );
        } else if (state is StorePurchaseFailed) {
          setState(() => _isSubmitting = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.message,
                style: textTheme.bodyMedium?.copyWith(color: Colors.white),
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: AppBar(
          backgroundColor: AppColors.backgroundColor,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.black),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text('Edit Shipping Address', style: textTheme.titleLarge),
        ),
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(color: AppColors.yellow),
              )
            : SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Address field
                      _buildTextField(
                        controller: _addressController,
                        label: 'Address',
                        hint: 'Building name, Street, Area',
                        maxLines: 3,
                        textTheme: textTheme,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter your address';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Post Office field
                      _buildTextField(
                        controller: _postOfficeController,
                        label: 'Post Office',
                        textTheme: textTheme,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter post office';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // District field
                      _buildTextField(
                        controller: _districtController,
                        label: 'District',
                        textTheme: textTheme,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter district';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // State field
                      _buildTextField(
                        controller: _stateController,
                        label: 'State',
                        textTheme: textTheme,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter state';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // PIN Code field
                      _buildTextField(
                        controller: _postPinController,
                        label: 'PIN Code',
                        keyboardType: TextInputType.number,
                        maxLength: 6,
                        textTheme: textTheme,
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

                      // Done Button
                      SizedBox(
                        height: 56,
                        child: ElevatedButton(
                          onPressed: _isSubmitting ? null : _submitAddress,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.yellow,
                            foregroundColor: AppColors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28),
                            ),
                            elevation: 0,
                          ),
                          child: _isSubmitting
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: AppColors.black,
                                  ),
                                )
                              : Text(
                                  'DONE',
                                  style: textTheme.titleSmall?.copyWith(
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
    required String label,
    required TextTheme textTheme,
    String? hint,
    int maxLines = 1,
    int? maxLength,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      maxLength: maxLength,
      keyboardType: keyboardType,
      enabled: !_isSubmitting,
      style: textTheme.bodyLarge,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: textTheme.labelMedium,
        hintText: hint,
        hintStyle: textTheme.bodySmall,
        counterText: '',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.gray.withOpacity(0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.gray.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.yellow, width: 2),
        ),
        filled: true,
        fillColor: AppColors.backgroundColor,
      ),
      validator: validator,
    );
  }
}
