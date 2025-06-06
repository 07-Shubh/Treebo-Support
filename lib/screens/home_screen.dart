import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:treebo_self_checkin/screens/checkout_screen.dart';
import 'package:treebo_self_checkin/screens/add_ons_screen.dart';
import 'package:treebo_self_checkin/screens/auth_screen.dart';
import 'package:treebo_self_checkin/widgets/chat_bot.dart';
import 'package:treebo_self_checkin/models/notification_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  bool _isChatBotVisible = false;
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [
    {
      'text': 'Hello! I\'m your Treebo Assistant. How can I help you today?',
      'isUser': false,
      'time': DateTime.now(),
    },
  ];
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  void _sendMessage() {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;
    
    setState(() {
      _messages.add({
        'text': message,
        'isUser': true,
        'time': DateTime.now(),
      });
      _messageController.clear();
    });
    
    // Simulate bot response
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      setState(() {
        _messages.add({
          'text': _getBotResponse(message),
          'isUser': false,
          'time': DateTime.now(),
        });
      });
    });
  }

  String _getBotResponse(String message) {
    final lowerMessage = message.toLowerCase();
    
    if (lowerMessage.contains('check in') || lowerMessage.contains('check-in')) {
      return 'You can check in by tapping the "Check-in" button on the home screen. Do you need any help with the check-in process?';
    } else if (lowerMessage.contains('check out') || lowerMessage.contains('check-out')) {
      return 'You can check out by tapping the "Check-out" button on the home screen. Would you like me to help you with anything else?';
    } else if (lowerMessage.contains('wifi') || lowerMessage.contains('internet')) {
      return 'The WiFi network is "Treebo_Guest" and the password is "welcome123". Would you like me to connect you to WiFi?';
    } else if (lowerMessage.contains('breakfast') || lowerMessage.contains('food')) {
      return 'Breakfast is served from 7 AM to 10:30 AM in the dining area. You can also order room service 24/7.';
    } else if (lowerMessage.contains('thank')) {
      return 'You\'re welcome! Is there anything else I can help you with?';
    } else if (lowerMessage.contains('hello') || lowerMessage.contains('hi') || lowerMessage.contains('hey')) {
      return 'Hello! How can I assist you today?';
    } else {
      return 'I\'m here to help! You can ask me about check-in, check-out, WiFi, breakfast, or any other hotel services.';
    }
  }

  void _toggleChatBot() {
    setState(() {
      _isChatBotVisible = !_isChatBotVisible;
      if (_isChatBotVisible) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  void _showChatBot() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const ChatBot(),
    );
  }

  void _showNotifications() {
    final notifications = NotificationManager.getNotifications();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Notifications',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            TextButton(
              onPressed: () {
                NotificationManager.markAllAsRead();
                Navigator.pop(context);
                setState(() {}); // Refresh the notification count
              },
              child: const Text('Mark all as read'),
            ),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: notifications.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.notifications_none_rounded,
                        size: 48,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No notifications',
                        style: GoogleFonts.poppins(
                          color: Colors.grey[600],
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    final notification = notifications[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: notification.isRead
                            ? Colors.grey[200]
                            : Theme.of(context).colorScheme.primary,
                        child: Icon(
                          Icons.notifications_rounded,
                          color: notification.isRead
                              ? Colors.grey[600]
                              : Colors.white,
                          size: 20,
                        ),
                      ),
                      title: Text(
                        notification.title,
                        style: GoogleFonts.poppins(
                          fontWeight: notification.isRead
                              ? FontWeight.normal
                              : FontWeight.w600,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(notification.message),
                          const SizedBox(height: 4),
                          Text(
                            DateFormat('MMM d, h:mm a').format(notification.timestamp),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      onTap: () {
                        NotificationManager.markAsRead(notification.id);
                        Navigator.pop(context);
                        setState(() {}); // Refresh the notification count
                      },
                    );
                  },
                ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Treebo Hotels'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Stack(
              children: [
                const Icon(Icons.notifications_outlined),
                if (NotificationManager.getUnreadCount() > 0)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        '${NotificationManager.getUnreadCount()}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            onPressed: _showNotifications,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.primary.withOpacity(0.8),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome to Treebo!',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Experience a seamless stay with our self-service options',
                    style: GoogleFonts.poppins(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            // Main Actions
            _buildActionButton(
              label: 'Check-in',
              icon: Icons.login_rounded,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AuthScreen()),
                );
              },
              isPrimary: true,
            ),
            
            _buildActionButton(
              label: 'Check-out',
              icon: Icons.logout_rounded,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CheckoutScreen()),
                );
              },
            ),
            
            _buildActionButton(
              label: 'Add-ons & Services',
              icon: Icons.add_circle_outline_rounded,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddOnsScreen()),
                );
              },
            ),
            
            _buildActionButton(
              label: 'Need Assistance?',
              icon: Icons.help_outline_rounded,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Contact Staff'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Please contact our staff at the front desk or call us at:',
                          style: GoogleFonts.poppins(),
                        ),
                        const SizedBox(height: 16),
                        _buildContactInfoRow('📞', 'Front Desk', '+91 1234567890'),
                        const SizedBox(height: 12),
                        _buildContactInfoRow('🛎️', '24/7 Support', '+91 9876543210'),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Close'),
                      ),
                    ],
                  ),
                );
              },
            ),
            
            const SizedBox(height: 24),
            
            // Room Information
            _buildInfoRow('Room', 'Deluxe Room - 201', Icons.king_bed_rounded),
            
            const SizedBox(height: 24),
            
            // Additional Services
            Text(
              'Additional Services',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 120, // Fixed height for the row
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildServiceCard(
                    icon: Icons.restaurant_rounded,
                    label: 'Dining',
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Dining Options'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                leading: const Icon(Icons.room_service_rounded),
                                title: const Text('Room Service'),
                                subtitle: const Text('24/7 in-room dining'),
                                onTap: () {
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Room service menu will be brought to your room shortly')),
                                  );
                                },
                              ),
                              const Divider(),
                              ListTile(
                                leading: const Icon(Icons.restaurant_rounded),
                                title: const Text('Restaurant'),
                                subtitle: const Text('Open 7:00 AM - 11:00 PM'),
                                onTap: () {
                                  Navigator.pop(context);
                                  // Navigate to restaurant menu
                                },
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Close'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 12),
                  _buildServiceCard(
                    icon: Icons.local_taxi_rounded,
                    label: 'Taxi',
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Book a Taxi'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextField(
                                decoration: InputDecoration(
                                  labelText: 'Pickup Location',
                                  hintText: 'Hotel Lobby',
                                  border: const OutlineInputBorder(),
                                  prefixIcon: const Icon(Icons.location_on_rounded),
                                  filled: true,
                                  fillColor: Colors.grey[100],
                                ),
                              ),
                              const SizedBox(height: 12),
                              TextField(
                                decoration: InputDecoration(
                                  labelText: 'Destination',
                                  hintText: 'Enter destination',
                                  border: const OutlineInputBorder(),
                                  prefixIcon: const Icon(Icons.flag_rounded),
                                  filled: true,
                                  fillColor: Colors.grey[100],
                                ),
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancel'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Taxi has been booked. Please wait at the lobby.')),
                                );
                              },
                              child: const Text('Book Taxi'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 12),
                  _buildServiceCard(
                    icon: Icons.local_laundry_service_rounded,
                    label: 'Laundry',
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Laundry Service'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text('Same-day laundry service available. Please place your laundry in the provided bag.'),
                              const SizedBox(height: 16),
                              TextField(
                                decoration: InputDecoration(
                                  labelText: 'Special Instructions',
                                  hintText: 'Any special requests?',
                                  border: const OutlineInputBorder(),
                                  filled: true,
                                  fillColor: Colors.grey[100],
                                ),
                                maxLines: 3,
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancel'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Laundry service has been requested. Someone will collect your laundry shortly.')),
                                );
                              },
                              child: const Text('Request Pickup'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 12),
                  _buildServiceCard(
                    icon: Icons.wifi_rounded,
                    label: 'Wi-Fi',
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Wi-Fi Information'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Connect to our complimentary Wi-Fi:'),
                              const SizedBox(height: 16),
                              _buildWifiInfoRow('Network Name:', 'Treebo_Guest'),
                              _buildWifiInfoRow('Password:', 'welcome123'),
                              const SizedBox(height: 8),
                              const Text(
                                'Please note: Speed may vary based on your location and number of connected devices.',
                                style: TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Close'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Hotel Information
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hotel Information',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildInfoRow('Address', '123 Treebo Street, City', Icons.location_on_rounded),
                  const SizedBox(height: 12),
                  _buildInfoRow('Phone', '+91 1234567890', Icons.phone_rounded),
                  const SizedBox(height: 12),
                  _buildInfoRow('Email', 'info@treebohotel.com', Icons.email_rounded),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showChatBot,
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.chat, color: Colors.white),
      ),
    );
  }
  
  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
    bool isPrimary = false,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: isPrimary ? Theme.of(context).colorScheme.primary : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isPrimary 
                        ? Colors.white.withOpacity(0.2)
                        : Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    size: 20,
                    color: isPrimary ? Colors.white : Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    label,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: isPrimary ? Colors.white : Colors.black87,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: isPrimary ? Colors.white : Colors.grey[600],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: Theme.of(context).colorScheme.primary,
          size: 20,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.poppins(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  Widget _buildContactInfoRow(String emoji, String label, String value) {
    return Row(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 20)),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
            Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
      ],
    );
  }
  
  Widget _buildWifiInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: SelectableText(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontFamily: 'monospace',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceCard({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Container(
      width: 100, // Fixed width for each card
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 32,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 8),
                Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
