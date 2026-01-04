import 'dart:async';
import 'package:flutter/material.dart';
import 'request_screen.dart';
import '../utils/constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late PageController _carouselController;
  int _currentCarouselIndex = 0;
  Timer? _carouselTimer;

  // Carousel Ads Data - Premium Modern Design
  final List<Map<String, dynamic>> _carouselAds = [
    {
      'title': 'خدمة سريعة وموثوقة',
      'subtitle': 'نصل إليك في أي مكان داخل المدينة المنورة',
      'icon': Icons.flash_on_rounded,
      'badge': '24/7',
      'gradient': [Color(0xFF42A5F5), Color(0xFF64B5F6)],
    },
    {
      'title': 'فنيون محترفون',
      'subtitle': 'فريق مدرب ومعتمد لخدمتك',
      'icon': Icons.verified_rounded,
      'badge': 'معتمد',
      'gradient': [Color(0xFF42A5F5), Color(0xFF64B5F6)],
    },
    {
      'title': 'أسعار منافسة',
      'subtitle': 'أفضل الأسعار في السوق',
      'icon': Icons.star_rounded,
      'badge': 'عروض',
      'gradient': [Color(0xFF42A5F5), Color(0xFF64B5F6)],
    },
  ];

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeIn));

    _carouselController = PageController(initialPage: 0);
    _fadeController.forward();
    _startCarouselTimer();
  }

  void _startCarouselTimer() {
    _carouselTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_carouselController.hasClients) {
        int nextPage = (_currentCarouselIndex + 1) % _carouselAds.length;
        _carouselController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _carouselController.dispose();
    _carouselTimer?.cancel();
    super.dispose();
  }

  void _openRequest(BuildContext context, String serviceType) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            RequestScreen(serviceType: serviceType),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position:
                Tween<Offset>(
                  begin: const Offset(1.0, 0.0),
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeInOutCubic,
                  ),
                ),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final color = const Color(AppConstants.primaryColorValue);

    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Carousel Ads Header
          SliverAppBar(
            expandedHeight: 220,
            floating: false,
            pinned: true,
            backgroundColor: Colors.white,
            foregroundColor: color,
            elevation: 0,
            shadowColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(background: _buildCarouselAds()),
          ),

          // Main Content
          SliverToBoxAdapter(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Quick Stats Section
                  _buildQuickStats(context, color),

                  // Services Section - Amazing Design
                  _buildAmazingServicesSection(context, color),

                  const SizedBox(height: 32),

                  // Features Section
                  _buildFeaturesSection(context, color),

                  const SizedBox(height: 32),

                  // Location Info
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: _buildLocationCard(context),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats(BuildContext context, Color color) {
    return Container(
      margin: const EdgeInsets.fromLTRB(24, 20, 24, 0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildStatItem(
              icon: Icons.flash_on_rounded,
              value: 'سريع',
              label: 'استجابة فورية',
              color: Colors.amber[700]!,
            ),
          ),
          Container(width: 1, height: 50, color: Colors.grey[200]),
          Expanded(
            child: _buildStatItem(
              icon: Icons.verified_rounded,
              value: 'آمن',
              label: 'فنيون معتمدون',
              color: Colors.blue[700]!,
            ),
          ),
          Container(width: 1, height: 50, color: Colors.grey[200]),
          Expanded(
            child: _buildStatItem(
              icon: Icons.location_on_rounded,
              value: '24/7',
              label: 'خدمة مستمرة',
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildCarouselAds() {
    return SizedBox(
      height: 220,
      child: Stack(
        children: [
          // PageView for Carousel
          PageView.builder(
            controller: _carouselController,
            onPageChanged: (index) {
              setState(() {
                _currentCarouselIndex = index;
              });
            },
            itemCount: _carouselAds.length,
            itemBuilder: (context, index) {
              final ad = _carouselAds[index];
              return _buildAdCard(ad);
            },
          ),

          // Indicators
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _carouselAds.length,
                (index) => _buildIndicator(index == _currentCarouselIndex),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdCard(Map<String, dynamic> ad) {
    final icon = ad['icon'] as IconData;
    final title = ad['title'] as String;
    final subtitle = ad['subtitle'] as String;
    final badge = ad['badge'] as String;
    final gradient = ad['gradient'] as List<Color>;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradient,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: gradient[0].withOpacity(0.4),
            blurRadius: 25,
            offset: const Offset(0, 12),
            spreadRadius: -5,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Decorative elements
          Positioned(
            top: -40,
            right: -40,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.15),
              ),
            ),
          ),
          Positioned(
            bottom: -30,
            left: -30,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.1),
              ),
            ),
          ),
          
          // Content
          Padding(
            padding: const EdgeInsets.all(22),
            child: Row(
              children: [
                // Icon Section - Premium Design
                Container(
                  width: 75,
                  height: 75,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.25),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withOpacity(0.5),
                      width: 2.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Icon(icon, color: Colors.white, size: 40),
                ),
                const SizedBox(width: 20),

                // Text Section
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 0.4,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.95),
                          fontWeight: FontWeight.w500,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),

                // Badge - Premium Design
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.5),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Text(
                    badge,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
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

  Widget _buildIndicator(bool isActive) {
    final color = const Color(AppConstants.primaryColorValue);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: isActive ? 28 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: isActive ? color : Colors.grey[300],
        borderRadius: BorderRadius.circular(4),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: color.withOpacity(0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
    );
  }

  Widget _buildAmazingServicesSection(BuildContext context, Color color) {
    // قائمة الخدمات - جميعها بنفس اللون الموحد
    final List<Map<String, dynamic>> services = [
      {
        'title': AppConstants.serviceTire,
        'subtitle': 'بنشر متنقل',
        'icon': Icons.build_circle_rounded,
      },
      {
        'title': AppConstants.serviceBattery,
        'subtitle': 'بطارية متنقلة',
        'icon': Icons.battery_charging_full_rounded,
      },
      {
        'title': AppConstants.serviceElectrical,
        'subtitle': 'خلل كهربائي',
        'icon': Icons.electrical_services_rounded,
      },
      {
        'title': AppConstants.serviceAC,
        'subtitle': 'إصلاح تكييف',
        'icon': Icons.ac_unit_rounded,
      },
      {
        'title': AppConstants.serviceOil,
        'subtitle': 'تغيير زيت',
        'icon': Icons.oil_barrel_rounded,
      },
      {
        'title': AppConstants.serviceMechanic,
        'subtitle': 'ميكانيكا',
        'icon': Icons.precision_manufacturing_rounded,
      },
      {
        'title': AppConstants.serviceKey,
        'subtitle': 'مفتاح',
        'icon': Icons.vpn_key_rounded,
      },
      {
        'title': AppConstants.serviceOther,
        'subtitle': 'خلل آخر',
        'icon': Icons.build_rounded,
      },
    ];

    return Container(
      margin: const EdgeInsets.only(top: 32, bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 6,
                      height: 32,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [color, color.withOpacity(0.6)],
                        ),
                        borderRadius: BorderRadius.circular(3),
                        boxShadow: [
                          BoxShadow(
                            color: color.withOpacity(0.5),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Text(
                      'خدماتنا',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'اختر الخدمة التي تحتاجها',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Services - Horizontal Scroll with 2 Rows
          SizedBox(
            height: 250, // ارتفاع صفين من المربعات (زيادة لتجنب overflow)
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: (services.length / 4).ceil(), // عدد المجموعات (كل مجموعة 4 خدمات = صفين)
              itemBuilder: (context, groupIndex) {
                final startIndex = groupIndex * 4;
                final endIndex = (startIndex + 4 < services.length) ? startIndex + 4 : services.length;
                final groupServices = services.sublist(startIndex, endIndex);
                
                return Container(
                  width: MediaQuery.of(context).size.width * 0.85, // عرض المجموعة
                  margin: EdgeInsets.only(right: groupIndex < (services.length / 4).ceil() - 1 ? 14 : 0),
                  child: Column(
                    children: [
                      // الصف الأول
                      Expanded(
                        child: Row(
                          children: [
                            if (groupServices.length > 0)
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 7, right: 7, bottom: 7),
                                  child: _buildCompactServiceCard(
                                    context: context,
                                    title: groupServices[0]['title'] as String,
                                    subtitle: groupServices[0]['subtitle'] as String,
                                    icon: groupServices[0]['icon'] as IconData,
                                    onTap: () => _openRequest(context, groupServices[0]['title'] as String),
                                  ),
                                ),
                              ),
                            if (groupServices.length > 1)
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 7, right: 7, bottom: 7),
                                  child: _buildCompactServiceCard(
                                    context: context,
                                    title: groupServices[1]['title'] as String,
                                    subtitle: groupServices[1]['subtitle'] as String,
                                    icon: groupServices[1]['icon'] as IconData,
                                    onTap: () => _openRequest(context, groupServices[1]['title'] as String),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      // الصف الثاني
                      Expanded(
                        child: Row(
                          children: [
                            if (groupServices.length > 2)
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 7, right: 7, top: 7),
                                  child: _buildCompactServiceCard(
                                    context: context,
                                    title: groupServices[2]['title'] as String,
                                    subtitle: groupServices[2]['subtitle'] as String,
                                    icon: groupServices[2]['icon'] as IconData,
                                    onTap: () => _openRequest(context, groupServices[2]['title'] as String),
                                  ),
                                ),
                              ),
                            if (groupServices.length > 3)
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 7, right: 7, top: 7),
                                  child: _buildCompactServiceCard(
                                    context: context,
                                    title: groupServices[3]['title'] as String,
                                    subtitle: groupServices[3]['subtitle'] as String,
                                    icon: groupServices[3]['icon'] as IconData,
                                    onTap: () => _openRequest(context, groupServices[3]['title'] as String),
                                  ),
                                ),
                              ),
                            // إذا كانت الخدمات أقل من 4، نضيف مساحة فارغة
                            if (groupServices.length < 4)
                              Expanded(child: Container()),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactServiceCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    final color = const Color(AppConstants.primaryColorValue);
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color,
                color.withOpacity(0.9),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.4),
                blurRadius: 20,
                offset: const Offset(0, 10),
                spreadRadius: -5,
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Decorative circles - أصغر بكثير
              Positioned(
                top: -10,
                right: -10,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.1),
                  ),
                ),
              ),
              Positioned(
                bottom: -8,
                left: -8,
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.08),
                  ),
                ),
              ),
              
              // Content
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Icon Section
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withOpacity(0.5),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Icon(
                        icon,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 10),
                    
                    // Text Section
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Title
                          Text(
                            title,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 0.2,
                              height: 1.2,
                            ),
                            textAlign: TextAlign.right,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 3),
                          
                          // Subtitle
                          Text(
                            subtitle,
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.white.withOpacity(0.95),
                              fontWeight: FontWeight.w500,
                              height: 1.1,
                            ),
                            textAlign: TextAlign.right,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturesSection(BuildContext context, Color color) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.grey[50]!, Colors.grey[100]!.withOpacity(0.5)],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey[200]!, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.star_rounded, color: Colors.amber[700], size: 24),
              const SizedBox(width: 12),
              const Text(
                'لماذا سهم؟',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildFeatureItem(
            icon: Icons.speed_rounded,
            title: 'سرعة في الاستجابة',
            description: 'نوصل لك خلال دقائق',
            color: Colors.blue[700]!,
          ),
          const SizedBox(height: 16),
          _buildFeatureItem(
            icon: Icons.shield_rounded,
            title: 'فنيون محترفون',
            description: 'فريق مدرب ومعتمد',
            color: Colors.blue[700]!,
          ),
          const SizedBox(height: 16),
          _buildFeatureItem(
            icon: Icons.attach_money_rounded,
            title: 'أسعار منافسة',
            description: 'أفضل الأسعار في السوق',
            color: Colors.orange[700]!,
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 22),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLocationCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue[50]!, Colors.blue[100]!.withOpacity(0.6)],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.blue[200]!, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue[100],
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.location_city_rounded,
              color: Colors.blue[700],
              size: 26,
            ),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ' خاص بمنطقة المدينة المنورة حالياً',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[900],
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 12,
                      color: Colors.blue[600],
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'قريباً في مدن أخرى',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.blue[700],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
