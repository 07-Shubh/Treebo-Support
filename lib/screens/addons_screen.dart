import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddOnsScreen extends StatefulWidget {
  const AddOnsScreen({super.key});

  @override
  State<AddOnsScreen> createState() => _AddOnsScreenState();
}

class AddOn {
  final String id;
  final String name;
  final String description;
  final double price;
  final String image;
  bool isSelected;

  AddOn({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.image,
    this.isSelected = false,
  });
}

class _AddOnsScreenState extends State<AddOnsScreen> {
  List<AddOn> _addOns = [];
  bool _isLoading = true;
  double _totalAmount = 0.0;

  @override
  void initState() {
    super.initState();
    _fetchAddOns();
  }

  Future<void> _fetchAddOns() async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    
    if (!mounted) return;
    
    setState(() {
      _addOns = [
        AddOn(
          id: '1',
          name: 'Breakfast Buffet',
          description: 'Unlimited breakfast buffet with continental and Indian options',
          price: 299,
          image: 'breakfast',
        ),
        AddOn(
          id: '2',
          name: 'Airport Transfer',
          description: 'One-way airport transfer in a private AC vehicle',
          price: 899,
          image: 'airport',
        ),
        AddOn(
          id: '3',
          name: 'Spa Package',
          description: '60-minute full body massage and spa treatment',
          price: 1499,
          image: 'spa',
        ),
        AddOn(
          id: '4',
          name: 'Late Check-out',
          description: 'Extend your stay until 4 PM (subject to availability)',
          price: 499,
          image: 'clock',
        ),
        AddOn(
          id: '5',
          name: 'Laundry Service',
          description: 'Express laundry service (up to 5kg)',
          price: 399,
          image: 'laundry',
        ),
      ];
      _isLoading = false;
    });
  }

  void _updateSelection(AddOn addOn, bool? selected) {
    if (selected == null) return;
    
    setState(() {
      addOn.isSelected = selected;
      _totalAmount = _addOns
          .where((item) => item.isSelected)
          .fold(0.0, (sum, item) => sum + item.price);
    });
  }

  Future<void> _confirmAddOns() async {
    final selectedAddOns = _addOns.where((item) => item.isSelected).toList();
    
    if (selectedAddOns.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one add-on')),
      );
      return;
    }

    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Add-ons'),
        content: Text(
          'You are about to add ${selectedAddOns.length} item(s) for a total of ₹${_totalAmount.toStringAsFixed(2)}. Proceed?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      // Simulate API call to add add-ons
      setState(() => _isLoading = true);
      await Future.delayed(const Duration(seconds: 2));
      
      if (!mounted) return;
      
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Add-ons have been added to your reservation'),
          backgroundColor: Colors.green,
        ),
      );
      
      // Return to previous screen
      Navigator.pop(context);
    }
  }

  Widget _buildAddOnItem(AddOn addOn) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: addOn.isSelected
            ? BorderSide(
                color: Theme.of(context).colorScheme.primary,
                width: 2,
              )
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: () {
          _updateSelection(addOn, !addOn.isSelected);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Image placeholder
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _getIconForAddOn(addOn.image),
                  size: 30,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      addOn.name,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      addOn.description,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '₹${addOn.price.toStringAsFixed(2)}',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
              Checkbox(
                value: addOn.isSelected,
                onChanged: (value) => _updateSelection(addOn, value),
                activeColor: Theme.of(context).colorScheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getIconForAddOn(String image) {
    switch (image) {
      case 'breakfast':
        return Icons.breakfast_dining;
      case 'airport':
        return Icons.airport_shuttle;
      case 'spa':
        return Icons.spa;
      case 'laundry':
        return Icons.local_laundry_service;
      default:
        return Icons.add_circle_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add-ons'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Enhance Your Stay',
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Select additional services to make your stay more comfortable',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 24),
                        ..._addOns.map((addOn) => _buildAddOnItem(addOn)).toList(),
                        const SizedBox(height: 80), // Space for the bottom button
                      ],
                    ),
                  ),
          ),
          // Bottom button
          if (!_isLoading)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                      Text(
                        '₹${_totalAmount.toStringAsFixed(2)}',
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _totalAmount > 0 ? _confirmAddOns : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Add to Booking',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
