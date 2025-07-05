import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductDetailsPage extends StatefulWidget {
  final String imagePath;
  final String productName;
  final String description;

  const ProductDetailsPage({
    required this.imagePath,
    required this.productName,
    required this.description,
  });

  @override
  _ProductDetailsPageState createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  String selectedFilter = 'ALL';
  final Map<String, List<Map<String, String>>> properties = {
    'Healthy': [
      {'name': 'Quantity', 'value': '100 grams'},
    ],
    'Unhealthy': [
      {'name': 'Acrylamide', 'value': '0.05%'},
      {'name': 'Butylated hydroxyanisole', 'value': '0.05%'},
      {'name': 'Sodium bisulfite', 'value': '0.02%'},
    ],
  };

  // Modern color palette
  final Color primaryColor = const Color(0xFF00C853); // Emerald
  final Color secondaryColor = const Color(0xFF009688); // Teal
  final Color accentColor = const Color(0xFF80CBC4); // Light Teal
  final Color cardGlassColor = Colors.white.withOpacity(0.35); // For glassmorphism
  final Color shadowColor = Colors.black.withOpacity(0.08);

  void _showFullScreenImage() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.black87,
      builder: (context) {
        return GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.9,
            child: InteractiveViewer(
              panEnabled: true,
              minScale: 0.5,
              maxScale: 4.0,
              child: Hero(
                tag: widget.imagePath,
                child: Image.asset(
                  widget.imagePath,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.productName,
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.bold,
            fontSize: 24.0,
            color: Colors.white,
          ),
        ),
        backgroundColor: primaryColor,
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
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
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              decoration: BoxDecoration(
                color: cardGlassColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: shadowColor,
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
                backgroundBlendMode: BlendMode.overlay,
              ),
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Image with Tap Gesture
                  GestureDetector(
                    onTap: _showFullScreenImage,
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final width = constraints.maxWidth;
                        return Hero(
                          tag: widget.imagePath,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(18.0),
                            child: Image.asset(
                              widget.imagePath,
                              fit: BoxFit.cover,
                              width: width,
                              height: width * 0.8, // 4:5 aspect ratio
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Filter Chips
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: ['ALL', 'Healthy', 'Unhealthy'].map((filter) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: ChoiceChip(
                            label: Text(filter),
                            selected: selectedFilter == filter,
                            selectedColor: primaryColor,
                            labelStyle: GoogleFonts.montserrat(
                              color: selectedFilter == filter
                                  ? Colors.white
                                  : secondaryColor,
                            ),
                            onSelected: (selected) {
                              setState(() {
                                selectedFilter = filter;
                              });
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Product Details
                  Text(
                    widget.productName,
                    style: GoogleFonts.montserrat(
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.description,
                    style: GoogleFonts.openSans(
                      fontSize: 16.0,
                      color: secondaryColor,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Properties List
                  Column(
                    children: [
                      if (selectedFilter == 'ALL' || selectedFilter == 'Healthy')
                        _buildPropertySection('Healthy Properties', Colors.green),
                      if (selectedFilter == 'ALL' || selectedFilter == 'Unhealthy')
                        _buildPropertySection('Unhealthy Properties', Colors.red),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPropertySection(String title, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      elevation: 6,
      color: Colors.white.withOpacity(0.7),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    title,
                    style: GoogleFonts.montserrat(
                      color: color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ...properties[title.replaceAll(' Properties', '')]!
                .map((property) => Column(
                      children: [
                        _buildPropertyItem(
                            property['name']!, property['value']!),
                        const Divider(height: 20),
                      ],
                    ))
                .toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildPropertyItem(String name, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              name,
              style: GoogleFonts.openSans(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: secondaryColor,
              ),
            ),
          ),
          Text(
            value,
            style: GoogleFonts.robotoMono(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }
}
