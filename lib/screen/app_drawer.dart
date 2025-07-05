import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppDrawer extends StatefulWidget {
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer>
    with SingleTickerProviderStateMixin {
  bool isPreferencesExpanded = false;
  bool isAllergensExpanded = false;

  // Dynamic lists and states
  List<String> preferences = ['Protein', 'Carbs', 'Fats', 'Fiber'];
  List<String> allergens = ['Lactose', 'Peanuts', 'Mustard', 'Eggs', 'Soy'];
  Map<String, bool> preferenceStates = {};
  Map<String, bool> allergenStates = {};

  // Controllers for text fields
  TextEditingController _preferenceController = TextEditingController();
  TextEditingController _allergenController = TextEditingController();

  late AnimationController _controller;
  late Animation<double> _animation;

  // Modern color palette
  final Color primaryColor = const Color(0xFF00C853); // Emerald
  final Color secondaryColor = const Color(0xFF009688); // Teal
  final Color accentColor = const Color(0xFF80CBC4); // Light Teal
  final Color cardGlassColor = Colors.white.withOpacity(0.35); // For glassmorphism
  final Color shadowColor = Colors.black.withOpacity(0.08);

  @override
  void initState() {
    super.initState();
    // Initialize states
    preferences.forEach((pref) => preferenceStates[pref] = false);
    allergens.forEach((allergen) => allergenStates[allergen] = false);

    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    _preferenceController.dispose();
    _allergenController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF00C853),
              Color(0xFF009688),
            ],
          ),
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // Drawer Header
            Container(
              constraints: BoxConstraints(
                minHeight: 80,
                maxHeight: MediaQuery.of(context).size.height * 0.12,
              ),
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 8.0,
                bottom: 16.0,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [primaryColor, secondaryColor],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Center(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'Food Settings',
                    style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10.0),

            // Preferences Section
            _buildDropdownContainer(
              title: 'Preferences',
              isExpanded: isPreferencesExpanded,
              onToggle: () {
                setState(() {
                  isPreferencesExpanded = !isPreferencesExpanded;
                });
                if (isPreferencesExpanded) {
                  _controller.forward();
                } else {
                  _controller.reverse();
                }
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                height: isPreferencesExpanded ? null : 0,
                child: Column(
                  children: [
                    ...preferences.map((pref) => _buildToggleOption(
                          pref,
                          preferenceStates[pref]!,
                          (value) {
                            setState(() {
                              preferenceStates[pref] = value;
                            });
                          },
                        )),
                    _buildAddField(
                      controller: _preferenceController,
                      onAdd: () {
                        _addItem(
                          _preferenceController.text,
                          preferences,
                          preferenceStates,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20.0),

            // Allergens Section
            _buildDropdownContainer(
              title: 'Allergens',
              isExpanded: isAllergensExpanded,
              onToggle: () {
                setState(() {
                  isAllergensExpanded = !isAllergensExpanded;
                });
                if (isAllergensExpanded) {
                  _controller.forward();
                } else {
                  _controller.reverse();
                }
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                height: isAllergensExpanded ? null : 0,
                child: Column(
                  children: [
                    ...allergens.map((allergen) => _buildToggleOption(
                          allergen,
                          allergenStates[allergen]!,
                          (value) {
                            setState(() {
                              allergenStates[allergen] = value;
                            });
                          },
                        )),
                    _buildAddField(
                      controller: _allergenController,
                      onAdd: () {
                        _addItem(
                          _allergenController.text,
                          allergens,
                          allergenStates,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addItem(String text, List<String> list, Map<String, bool> stateMap) {
    if (text.isNotEmpty && !list.contains(text)) {
      setState(() {
        list.add(text);
        stateMap[text] = false;
      });
      _preferenceController.clear();
      _allergenController.clear();
    }
  }

  Widget _buildAddField({
    required TextEditingController controller,
    required VoidCallback onAdd,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: 'Add new item',
                contentPadding: EdgeInsets.symmetric(horizontal: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.add,
                color: const Color(0xFF00C853)), // Primary color
            onPressed: onAdd,
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownContainer({
    required String title,
    required bool isExpanded,
    required VoidCallback onToggle,
    required Widget child,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: cardGlassColor,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            blurRadius: 10.0,
            offset: Offset(0, 4),
          ),
        ],
        backgroundBlendMode: BlendMode.overlay,
      ),
      child: Column(
        children: [
          // Title Bar
          InkWell(
            onTap: onToggle,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [primaryColor, secondaryColor],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16.0),
                  topRight: Radius.circular(16.0),
                ),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
              child: Row(
                children: [
                  Text(
                    title,
                    style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: child,
            crossFadeState: isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 300),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleOption(
      String title, bool currentValue, ValueChanged<bool> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.roboto(
              fontSize: 16.0,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          Switch(
            value: currentValue,
            activeColor: const Color(0xFF00C853), // Primary color
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
