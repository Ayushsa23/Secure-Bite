import 'package:flutter/material.dart';

class ScrollingLabelSection extends StatefulWidget {
  @override
  _ScrollingLabelSectionState createState() => _ScrollingLabelSectionState();
}

class _ScrollingLabelSectionState extends State<ScrollingLabelSection> {
  final ScrollController _scrollController = ScrollController();
  bool _showLabel = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    // Show label when scrolled past 100 pixels
    if (_scrollController.offset > 100 && !_showLabel) {
      setState(() {
        _showLabel = true;
      });
    } else if (_scrollController.offset <= 100 && _showLabel) {
      setState(() {
        _showLabel = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                // Your existing content goes here
                Container(
                  height: 800, // Placeholder for content
                  color: Colors.grey[200],
                  child: Center(
                    child: Text(
                      'Scroll down to see the label',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Sticky Label
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AnimatedOpacity(
              opacity: _showLabel ? 1.0 : 0.0,
              duration: Duration(milliseconds: 300),
              child: _buildStickyLabel(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStickyLabel() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blueAccent, Colors.purpleAccent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Special Offer!',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Get 20% off on your next order.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.local_offer,
            color: Colors.white,
            size: 30,
          ),
        ],
      ),
    );
  }
}
