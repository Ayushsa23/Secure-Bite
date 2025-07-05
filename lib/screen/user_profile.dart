import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:secure_bite/screen/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../main.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  bool isDarkTheme = false;
  bool areNotificationsEnabled = true;
  bool areAllergenAlertsEnabled = false;

  int userRating = 0; // Keeps track of the star rating given by the user

  // Modern color palette
  final Color primaryColor = const Color(0xFF00C853); // Emerald
  final Color secondaryColor = const Color(0xFF009688); // Teal
  final Color accentColor = const Color(0xFF80CBC4); // Light Teal
  final Color cardGlassColor = Colors.white.withOpacity(0.35); // For glassmorphism
  final Color shadowColor = Colors.black.withOpacity(0.08);

  Future<void> _logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
        (route) => false, // Removes all previous routes
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Logout failed: $e')),
      );
    }
  }

  void _toggleTheme(bool value) async {
    setState(() {
      isDarkTheme = value;
    });
    // Update global theme mode
    themeModeNotifier.value = value ? ThemeMode.dark : ThemeMode.light;
    // Persist the user's choice
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('themeMode', value ? 'dark' : 'light');
  }

  void _toggleNotifications(bool value) {
    setState(() {
      areNotificationsEnabled = value;
    });
  }

  void _toggleAllergenAlerts(bool value) {
    setState(() {
      areAllergenAlertsEnabled = value;
    });
  }

  // void _rateApp(int rating) {
  //   setState(() {
  //     userRating = rating;
  //   });
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(content: Text('Thanks for rating us $rating stars!')),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final user = FirebaseAuth.instance.currentUser;
    final String displayName = user?.displayName ?? 'User';
    final String email = user?.email ?? 'No email';
    final String phone = user?.phoneNumber ?? '';
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.bold,
            fontSize: 24.0,
            color: isDark ? Colors.white : Colors.white,
          ),
        ),
        backgroundColor: isDark ? Color(0xFF23272F) : primaryColor,
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: isDark
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF23272F), Color(0xFF181A20)],
                )
              : LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF00C853), Color(0xFF009688)],
                ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor.withOpacity(isDark ? 0.98 : 0.92),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: shadowColor,
                  blurRadius: 24,
                  offset: const Offset(0, 10),
                ),
              ],
              border: Border.all(color: accentColor.withOpacity(0.18), width: 1.2),
            ),
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                // Profile Header
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: isDark ? Colors.white12 : accentColor.withOpacity(0.25),
                      child: Icon(
                        Icons.person,
                        size: 60,
                        color: isDark ? Colors.white : secondaryColor.withOpacity(0.85),
                      ),
                    ),
                    const SizedBox(width: 20.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            displayName,
                            style: GoogleFonts.montserrat(
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : primaryColor,
                              letterSpacing: 1.1,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          if (phone.isNotEmpty)
                            Text(
                              phone,
                              style: GoogleFonts.openSans(
                                fontSize: 16.0,
                                color: isDark ? Colors.white70 : secondaryColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          if (phone.isNotEmpty) const SizedBox(height: 4.0),
                          Text(
                            email,
                            style: GoogleFonts.openSans(
                              fontSize: 17.0,
                              color: isDark ? Colors.white : Colors.black87,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 12.0),
                          TextButton(
                            onPressed: () {
                              // Add edit profile action
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: isDark ? Colors.white12 : accentColor.withOpacity(0.18),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                            ),
                            child: Text(
                              'Edit Profile',
                              style: GoogleFonts.montserrat(
                                fontSize: 16.0,
                                color: isDark ? Colors.white : primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28.0),
                // Notifications Section with Toggle
                _buildGlassSection(
                  icon: Icons.notifications,
                  iconColor: Colors.orange,
                  title: 'Notifications',
                  subtitle: areNotificationsEnabled
                      ? 'Notifications are enabled'
                      : 'Notifications are disabled',
                  value: areNotificationsEnabled,
                  onChanged: _toggleNotifications,
                  activeColor: Colors.orange,
                  cardColor: Theme.of(context).cardColor.withOpacity(isDark ? 0.98 : 0.95),
                ),
                const SizedBox(height: 18),
                // Allergen Alerts Section with Toggle
                _buildGlassSection(
                  icon: Icons.warning_amber_rounded,
                  iconColor: Colors.redAccent,
                  title: 'Allergen Alerts',
                  subtitle: areAllergenAlertsEnabled
                      ? 'Allergen alerts are enabled'
                      : 'Allergen alerts are disabled',
                  value: areAllergenAlertsEnabled,
                  onChanged: _toggleAllergenAlerts,
                  activeColor: Colors.redAccent,
                  cardColor: Theme.of(context).cardColor.withOpacity(isDark ? 0.98 : 0.95),
                ),
                const SizedBox(height: 18),
                // Theme Options Section with Toggle
                _buildGlassSection(
                  icon: isDarkTheme ? Icons.nightlight_round : Icons.wb_sunny,
                  iconColor: isDarkTheme ? Colors.blueGrey : Colors.amber,
                  title: 'Theme',
                  subtitle: isDarkTheme
                      ? 'Dark theme is enabled'
                      : 'Light theme is enabled',
                  value: isDarkTheme,
                  onChanged: _toggleTheme,
                  activeColor: primaryColor,
                  cardColor: Theme.of(context).cardColor.withOpacity(isDark ? 0.98 : 0.95),
                ),
                const SizedBox(height: 18),
                // Help Center Section
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor.withOpacity(isDark ? 0.98 : 0.95),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: accentColor.withOpacity(0.18), width: 1),
                  ),
                  child: ListTile(
                    leading: Icon(Icons.help_outline, color: Colors.green, size: 30),
                    title: Text(
                      'Help Center',
                      style: GoogleFonts.montserrat(
                        fontSize: 18.0,
                        color: isDark ? Colors.white : secondaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      'Get assistance and FAQs',
                      style: GoogleFonts.openSans(
                        fontSize: 14.0,
                        color: isDark ? Colors.white70 : Colors.black54,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 28.0),
                // Logout Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _logout(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDark ? secondaryColor : primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.0),
                      ),
                      elevation: 8,
                    ),
                    child: Text(
                      'Logout',
                      style: GoogleFonts.montserrat(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
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

  Widget _buildGlassSection({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    required Color activeColor,
    required Color cardColor,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: accentColor.withOpacity(0.13), width: 1),
      ),
      child: Row(
        children: [
          const SizedBox(width: 8),
          Icon(icon, color: isDark ? Colors.white : iconColor, size: 30),
          const SizedBox(width: 20.0),
          Expanded(
            child: SwitchListTile(
              title: Text(
                title,
                style: GoogleFonts.montserrat(
                  fontSize: 18.0,
                  color: isDark ? Colors.white : secondaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                subtitle,
                style: GoogleFonts.openSans(
                  fontSize: 14.0,
                  color: isDark ? Colors.white70 : Colors.black54,
                ),
              ),
              value: value,
              activeColor: activeColor,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}
