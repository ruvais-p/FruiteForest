import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
          // Navigate back to store page after successful address addition
          Navigator.pop(context);
        } else if (state is StorePurchaseFailed) {
          setState(() => _isSubmitting = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add Shipping Address'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Please add your shipping address to complete the purchase',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _addressController,
                  decoration: const InputDecoration(
                    labelText: 'Address',
                    hintText: 'Enter your complete address',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.location_on),
                  ),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your address';
                    }
                    if (value.trim().length < 10) {
                      return 'Please enter a complete address';
                    }
                    return null;
                  },
                  enabled: !_isSubmitting,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _stateController,
                  decoration: const InputDecoration(
                    labelText: 'State',
                    hintText: 'Enter your state',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.map),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your state';
                    }
                    return null;
                  },
                  enabled: !_isSubmitting,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _districtController,
                  decoration: const InputDecoration(
                    labelText: 'District',
                    hintText: 'Enter your district',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.location_city),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your district';
                    }
                    return null;
                  },
                  enabled: !_isSubmitting,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _postOfficeController,
                  decoration: const InputDecoration(
                    labelText: 'Post Office',
                    hintText: 'Enter your post office',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.local_post_office),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your post office';
                    }
                    return null;
                  },
                  enabled: !_isSubmitting,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _postPinController,
                  decoration: const InputDecoration(
                    labelText: 'PIN Code',
                    hintText: 'Enter 6-digit PIN code',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.pin_drop),
                  ),
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your PIN code';
                    }
                    if (!RegExp(r'^[0-9]{6}$').hasMatch(value.trim())) {
                      return 'PIN code must be exactly 6 digits';
                    }
                    return null;
                  },
                  enabled: !_isSubmitting,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitAddress,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: _isSubmitting
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text(
                          'Save Address & Complete Purchase',
                          style: TextStyle(fontSize: 16),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
