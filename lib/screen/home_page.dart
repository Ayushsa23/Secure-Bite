import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:secure_bite/screen/app_drawer.dart';
import 'package:secure_bite/screen/productdetails.dart';
import 'package:secure_bite/screen/user_profile.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  late AnimationController _fabController;
  late Animation<double> _fabAnimation;
  late PageController _pageController;
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;
  final ScrollController _scrollController = ScrollController();
  bool _showStickyLabel = false;

  // Dynamic Banner Variables
  final List<Color> _bannerColors = [
    Colors.blueAccent,
    Colors.greenAccent,
    Colors.orangeAccent,
    Colors.purpleAccent,
    Colors.redAccent,
  ];
  final List<String> _bannerMessages = [
    'Get 20% off on your next order!',
    'New feature: Track your calories!',
    'Engage with our community for tips!',
    'Check out our latest healthy recipes!',
  ];
  int _currentBannerIndex = 0;

  // Define a modern color palette
  final Color primaryColor = const Color(0xFF00C853); // Emerald
  final Color secondaryColor = const Color(0xFF009688); // Teal
  final Color accentColor = const Color(0xFF80CBC4); // Light Teal
  final Color backgroundColor = const Color(0xFFF0F4F8); // Soft background
  final Color cardGlassColor = Colors.white.withOpacity(0.35); // For glassmorphism
  final Color shadowColor = Colors.black.withOpacity(0.08);

  // Remove the direct initialization of text styles here
  late final TextStyle headingStyle = GoogleFonts.montserrat(
    fontSize: 26,
    fontWeight: FontWeight.bold,
    color: primaryColor,
    letterSpacing: 1.2,
  );
  late final TextStyle subHeadingStyle = GoogleFonts.montserrat(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: secondaryColor,
    letterSpacing: 1.1,
  );
  late final TextStyle bodyStyle = GoogleFonts.openSans(
    fontSize: 16,
    color: Colors.black87,
    letterSpacing: 0.5,
  );

  void _navigateToFeaturedDetails(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailsPage(
            imagePath: featuredImages[index],
            productName: 'Featured Item ${index + 1}',
            description:
                'Detailed information about featured item ${index + 1}'),
      ),
    );
  }

  final List<String> featuredImages = [
    'assets/a.jpeg',
    'assets/b.jpeg',
    'assets/c.jpeg',
    'assets/d.jpeg',
    'assets/e.jpeg',
  ];

  final List<Map<String, String>> healthyTips = [
    {
      'image': 'assets/tips1.jpeg',
      'text': 'Stay hydrated by drinking plenty of water throughout the day.',
    },
    {
      'image': 'assets/tips2.jpeg',
      'text': 'Incorporate more fruits and vegetables into your meals.',
    },
    {
      'image': 'assets/tips3.jpeg',
      'text': 'Choose whole grains over refined grains for better nutrition.',
    },
    {
      'image': 'assets/tips4.jpeg',
      'text': 'Limit added sugars and focus on natural sweeteners.',
    },
  ];

  final List<Map<String, String>> recentProducts = [
    {
      'image': 'assets/product1.jpeg',
      'name': 'Product 1',
    },
    {
      'image': 'assets/product2.jpeg',
      'name': 'Product 2',
    },
    {
      'image': 'assets/product3.jpeg',
      'name': 'Product 3',
    },
  ];

  int _currentTipIndex = 0;
  int _currentFeaturedIndex = 0;
  Timer? _tipTimer;
  final ImagePicker _picker = ImagePicker();
  bool _isPickerVisible = true;
  bool _contentVisible = false;

  @override
  void initState() {
    super.initState();
    _startTipSlideshow();
    _pageController = PageController(viewportFraction: 0.8);
    _pageController.addListener(_updateFeaturedIndex);

    _fabController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    _fabAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _fabController, curve: Curves.easeInOut),
    );

    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOut,
    ));

    _scrollController.addListener(_handleScroll);

    Future.delayed(const Duration(milliseconds: 300), () {
      _slideController.forward();
      setState(() => _contentVisible = true);
    });
  }

  void _handleScroll() {
    if (_scrollController.offset > 100 && !_showStickyLabel) {
      setState(() {
        _showStickyLabel = true;
      });
    } else if (_scrollController.offset <= 100 && _showStickyLabel) {
      setState(() {
        _showStickyLabel = false;
      });
    }
  }

  Widget _buildStickyLabel() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: _showStickyLabel
          ? Container(
              key: const ValueKey('sticky'),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: cardGlassColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: shadowColor,
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
                backgroundBlendMode: BlendMode.overlay,
              ),
              child: Row(
                children: [
                  Icon(Icons.restaurant_menu, color: primaryColor),
                  const SizedBox(width: 12),
                  Text('Decode Labels, Choose Health',
                      style: GoogleFonts.montserrat(
                          fontSize: 18, color: Colors.black87)),
                ],
              ),
            )
          : const SizedBox.shrink(key: ValueKey('empty')),
    );
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _currentBannerIndex = (_currentBannerIndex + 1) % _bannerMessages.length;
    });

    final fetchFuture = Future.delayed(Duration(seconds: 1));
    final delayFuture = Future.delayed(Duration(seconds: 2));

    await Future.wait([fetchFuture, delayFuture]);
  }

  void _updateFeaturedIndex() {
    int page = _pageController.page?.round() ?? 0;
    if (page != _currentFeaturedIndex) {
      setState(() => _currentFeaturedIndex = page);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tipTimer?.cancel();
    _pageController.dispose();
    _fabController.dispose();
    _slideController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _startTipSlideshow() {
    _tipTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      setState(
          () => _currentTipIndex = (_currentTipIndex + 1) % healthyTips.length);
    });
  }

  void _pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      showDialog(
        context: context,
        builder: (BuildContext context) => _buildImageDialog(image),
      );
    }
  }

  Widget _buildImageDialog(XFile image) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Image Selected',
                style: GoogleFonts.roboto(fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.file(File(image.path)),
            ),
            const SizedBox(height: 10),
            Text('Path: ${image.path}', style: GoogleFonts.openSans()),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK', style: TextStyle(color: Colors.teal)),
            ),
          ],
        ),
      ),
    );
  }

  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) => _buildSourceDialog(),
    );
  }

  Widget _buildSourceDialog() {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: Text('Select Source',
          style: GoogleFonts.roboto(fontWeight: FontWeight.bold)),
      content: SizedBox(
        height: 120,
        child: Column(
          children: [
            _buildSourceTile(
                Icons.photo_library, 'Gallery', ImageSource.gallery),
            _buildSourceTile(Icons.camera_alt, 'Camera', ImageSource.camera),
          ],
        ),
      ),
    );
  }

  ListTile _buildSourceTile(IconData icon, String title, ImageSource source) {
    return ListTile(
      leading: Icon(icon, color: Colors.teal),
      title: Text(title, style: GoogleFonts.openSans()),
      onTap: () {
        Navigator.pop(context);
        _pickImage(source);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: _buildAppBar(),
      drawer: AppDrawer(),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: NotificationListener<ScrollNotification>(
        onNotification: (scrollNotification) {
          if (scrollNotification is ScrollUpdateNotification) {
            setState(() => _isPickerVisible =
                scrollNotification.scrollDelta! > 0 ? false : true);
          }
          return true;
        },
        child: Stack(
          children: [
            RefreshIndicator(
              onRefresh: _handleRefresh,
              displacement: 40,
              backgroundColor: isDark ? Theme.of(context).cardColor : accentColor,
              child: SingleChildScrollView(
                controller: _scrollController,
                child: AnimatedOpacity(
                  opacity: _contentVisible ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 500),
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          _buildSearchBar(),
                          const SizedBox(height: 20),
                          _buildPageLabel(),
                          const SizedBox(height: 20),
                          _buildFeaturedSection(),
                          const SizedBox(height: 20),
                          _buildHealthyTips(),
                          const SizedBox(height: 20),
                          _buildRecentProducts(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if (_isPickerVisible) _buildScannerButton(),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: _buildStickyLabel(),
            ),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      elevation: 0,
      title: Text('Secure-Bite',
          style: GoogleFonts.montserrat(
              fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white)),
      backgroundColor: primaryColor,
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.account_circle, size: 30, color: Colors.white),
          onPressed: () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => UserProfileScreen())),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        gradient: isDark
            ? LinearGradient(
                colors: [Color(0xFF23272F), Color(0xFF181A20)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : LinearGradient(
                colors: [primaryColor.withOpacity(0.12), accentColor.withOpacity(0.12)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
              color: shadowColor,
              blurRadius: 16,
              offset: const Offset(0, 8))
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.search, color: isDark ? Colors.white54 : secondaryColor.withOpacity(0.7)),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _searchController,
              style: GoogleFonts.openSans(color: isDark ? Colors.white : Colors.black87),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Search for healthy options...',
                hintStyle: GoogleFonts.openSans(color: isDark ? Colors.white54 : Colors.grey),
              ),
            ),
          ),
          if (_searchController.text.isNotEmpty)
            IconButton(
              icon: Icon(Icons.clear, color: isDark ? Colors.white54 : secondaryColor.withOpacity(0.7)),
              onPressed: () => setState(() => _searchController.clear()),
            ),
        ],
      ),
    );
  }

  Widget _buildPageLabel() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: BoxDecoration(
        gradient: isDark
            ? LinearGradient(
                colors: [Color(0xFF23272F), Color(0xFF181A20)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : LinearGradient(
                colors: [primaryColor, secondaryColor],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.restaurant_menu, color: isDark ? Colors.white : Colors.white.withOpacity(0.95)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Decode Labels, Choose Health',
              style: GoogleFonts.montserrat(fontSize: 19, color: Colors.white),
              softWrap: false,
              overflow: TextOverflow.visible,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedSection() {
    return Column(
      children: [
        Text(
          'Featured',
          style: headingStyle,
        ),
        const SizedBox(height: 15),
        SizedBox(
          height: 200,
          child: PageView.builder(
            controller: _pageController,
            itemCount: featuredImages.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () => _navigateToFeaturedDetails(index),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: shadowColor,
                        blurRadius: 18,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: ParallaxImage(
                      image: featuredImages[index],
                      pageController: _pageController,
                      index: index,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            featuredImages.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: _currentFeaturedIndex == index ? 14 : 8,
              height: _currentFeaturedIndex == index ? 14 : 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentFeaturedIndex == index
                    ? primaryColor
                    : accentColor.withOpacity(0.5),
                boxShadow: _currentFeaturedIndex == index
                    ? [
                        BoxShadow(
                          color: primaryColor.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : [],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHealthyTips() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Healthy Tips', style: subHeadingStyle.copyWith(color: isDark ? Colors.white : subHeadingStyle.color)),
        const SizedBox(height: 15),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          child: Container(
            key: ValueKey(_currentTipIndex),
            height: 260,
            child: Column(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor.withOpacity(isDark ? 0.98 : 0.92),
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: shadowColor,
                            blurRadius: 18,
                            offset: const Offset(0, 8),
                          ),
                        ],
                        backgroundBlendMode: BlendMode.overlay,
                      ),
                      child: Image.asset(
                        healthyTips[_currentTipIndex]['image']!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  healthyTips[_currentTipIndex]['text']!,
                  textAlign: TextAlign.center,
                  style: bodyStyle.copyWith(color: isDark ? Colors.white : bodyStyle.color),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRecentProducts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Recent Products', style: subHeadingStyle),
        const SizedBox(height: 15),
        SizedBox(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: recentProducts.length,
            itemBuilder: (context, index) => _buildProductItem(index),
          ),
        ),
      ],
    );
  }

  Widget _buildProductItem(int index) {
    return GestureDetector(
      onTap: () => _navigateToProductDetails(index),
      child: Hero(
        tag: recentProducts[index]['name']!,
        child: Material(
          color: Colors.transparent,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            width: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              gradient: LinearGradient(
                colors: [accentColor.withOpacity(0.18), Colors.white.withOpacity(0.7)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: shadowColor,
                  blurRadius: 14,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: shadowColor,
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Image.asset(
                        recentProducts[index]['image']!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 110,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  recentProducts[index]['name']!,
                  style: bodyStyle,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToProductDetails(int index) {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (context, animation, secondaryAnimation) =>
            ProductDetailsPage(
          imagePath: recentProducts[index]['image']!,
          productName: recentProducts[index]['name']!,
          description:
              'Detailed information about ${recentProducts[index]['name']}',
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var begin = Offset(0.0, 1.0);
          var end = Offset.zero;
          var curve = Curves.easeInOut;
          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);
          return SlideTransition(position: offsetAnimation, child: child);
        },
      ),
    );
  }

  Widget _buildScannerButton() {
    return Positioned(
      bottom: 30,
      right: 30,
      child: ScaleTransition(
        scale: _fabAnimation,
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: primaryColor.withOpacity(0.25),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
            borderRadius: BorderRadius.circular(50),
          ),
          child: FloatingActionButton(
            heroTag: 'scanner',
            onPressed: _showImageSourceDialog,
            backgroundColor: primaryColor,
            child: const Icon(Icons.qr_code_scanner, color: Colors.white, size: 30),
          ),
        ),
      ),
    );
  }
}

class ParallaxImage extends StatelessWidget {
  final String image;
  final PageController pageController;
  final int index;

  const ParallaxImage({
    required this.image,
    required this.pageController,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Flow(
      delegate: ParallaxFlowDelegate(
        pageController: pageController,
        index: index,
      ),
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.asset(
            image,
            fit: BoxFit.cover,
          ),
        ),
      ],
    );
  }
}

class ParallaxFlowDelegate extends FlowDelegate {
  final PageController pageController;
  final int index;

  ParallaxFlowDelegate({
    required this.pageController,
    required this.index,
  }) : super(repaint: pageController);

  @override
  void paintChildren(FlowPaintingContext context) {
    final pageOffset = pageController.page ?? 0;  
    final offset = (index - pageOffset) * context.size.width * 0.5;
    context.paintChild(
      0,
      transform: Matrix4.translationValues(offset, 0, 0),
    );
  }

  @override
  bool shouldRepaint(covariant FlowDelegate oldDelegate) => true;
}