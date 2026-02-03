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

    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
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
      endDrawer: _buildPremiumServicesDrawer(context, color),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // New Hero Header
          SliverToBoxAdapter(
            child: HomeHeader(
              onPickLocation: () {
                // يمكن إضافة وظيفة اختيار الموقع هنا لاحقاً
              },
            ),
          ),

          // Premium Services Banner
          SliverToBoxAdapter(
            child: _buildPremiumServicesBanner(context, color),
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

  Widget _buildAmazingServicesSection(BuildContext context, Color color) {
    // قائمة الخدمات - جميعها بنفس اللون الموحد
    final List<Map<String, dynamic>?> services = [
      {
        'title': AppConstants.serviceBattery,
        'subtitle': 'خلل بطارية ',
        'icon': Icons.battery_charging_full_rounded,
        'imagePath': 'assets/images/battery.png', // صورة البطارية
      },
      {
        'title': AppConstants.serviceKey,
        'subtitle': 'مفتاح',
        'icon': Icons.vpn_key_rounded,
        'imagePath': 'assets/images/key.png',
      },
      {
        'title': AppConstants.serviceTireChange,
        'subtitle': 'تغيير إطارات',
        'icon': Icons.change_circle_rounded,
        'imagePath': 'assets/images/tire.png',
      },
      {
        'title': AppConstants.serviceOil,
        'subtitle': 'تغيير زيت',
        'icon': Icons.oil_barrel_rounded,
        'imagePath': 'assets/images/oil.png',
      },
      {
        'title': AppConstants.serviceElectrical,
        'subtitle': 'خلل كهربائي',
        'icon': Icons.electrical_services_rounded,
        'imagePath': 'assets/images/Electrical.png', // صورة الخلل الكهربائي
      },
      {
        'title': AppConstants.serviceAC,
        'subtitle': 'إصلاح تكييف',
        'icon': Icons.ac_unit_rounded,
        'imagePath': 'assets/images/cool.png',
      },
      {
        'title': AppConstants.serviceTire,
        'subtitle': 'بنزين',
        'icon': Icons.build_circle_rounded,
        'imagePath': 'assets/images/fuel.png',
      },
      {
        'title': AppConstants.serviceMechanic,
        'subtitle': 'ميكانيكا',
        'icon': Icons.precision_manufacturing_rounded,
        'imagePath': 'assets/images/Mechanical.png', // صورة الميكانيكا
      },
      {
        'title': AppConstants.serviceFullInspection,
        'subtitle': 'فحص شامل',
        'icon': Icons.search_rounded,
        'imagePath': 'assets/images/checkup.png',
      },
      // عنصر فارغ لضمان أن خدمة السحب تكون في الصف الثاني
      null,
      {
        'title': AppConstants.serviceTow,
        'subtitle': 'خدمة السحب',
        'icon': Icons.local_shipping_rounded,
        'imagePath': 'assets/images/truck.png',
      },
    ];

    return Container(
      margin: const EdgeInsets.only(top: 24, bottom: 16),
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
              itemCount: (services.length / 4)
                  .ceil(), // عدد المجموعات (كل مجموعة 4 خدمات = صفين)
              itemBuilder: (context, groupIndex) {
                final startIndex = groupIndex * 4;
                final endIndex = (startIndex + 4 < services.length)
                    ? startIndex + 4
                    : services.length;
                final groupServices = services
                    .sublist(startIndex, endIndex)
                    .whereType<Map<String, dynamic>>()
                    .toList();

                return Container(
                  width:
                      MediaQuery.of(context).size.width * 0.85, // عرض المجموعة
                  margin: EdgeInsets.only(
                    right: groupIndex < (services.length / 4).ceil() - 1
                        ? 14
                        : 0,
                  ),
                  child: Column(
                    children: [
                      // الصف الأول
                      Expanded(
                        child: Row(
                          children: [
                            if (groupServices.isNotEmpty)
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    left: 7,
                                    right: 7,
                                    bottom: 7,
                                  ),
                                  child: _buildCompactServiceCard(
                                    context: context,
                                    title: groupServices[0]['title'] as String,
                                    subtitle:
                                        groupServices[0]['subtitle'] as String,
                                    icon: groupServices[0]['icon'] as IconData,
                                    imagePath:
                                        groupServices[0]['imagePath']
                                            as String?,
                                    onTap: () => _openRequest(
                                      context,
                                      groupServices[0]['title'] as String,
                                    ),
                                  ),
                                ),
                              ),
                            if (groupServices.length > 1)
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    left: 7,
                                    right: 7,
                                    bottom: 7,
                                  ),
                                  child: _buildCompactServiceCard(
                                    context: context,
                                    title: groupServices[1]['title'] as String,
                                    subtitle:
                                        groupServices[1]['subtitle'] as String,
                                    icon: groupServices[1]['icon'] as IconData,
                                    imagePath:
                                        groupServices[1]['imagePath']
                                            as String?,
                                    onTap: () => _openRequest(
                                      context,
                                      groupServices[1]['title'] as String,
                                    ),
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
                                  padding: const EdgeInsets.only(
                                    left: 7,
                                    right: 7,
                                    top: 7,
                                  ),
                                  child: _buildCompactServiceCard(
                                    context: context,
                                    title: groupServices[2]['title'] as String,
                                    subtitle:
                                        groupServices[2]['subtitle'] as String,
                                    icon: groupServices[2]['icon'] as IconData,
                                    imagePath:
                                        groupServices[2]['imagePath']
                                            as String?,
                                    onTap: () => _openRequest(
                                      context,
                                      groupServices[2]['title'] as String,
                                    ),
                                  ),
                                ),
                              ),
                            if (groupServices.length > 3)
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    left: 7,
                                    right: 7,
                                    top: 7,
                                  ),
                                  child: _buildCompactServiceCard(
                                    context: context,
                                    title: groupServices[3]['title'] as String,
                                    subtitle:
                                        groupServices[3]['subtitle'] as String,
                                    icon: groupServices[3]['icon'] as IconData,
                                    imagePath:
                                        groupServices[3]['imagePath']
                                            as String?,
                                    onTap: () => _openRequest(
                                      context,
                                      groupServices[3]['title'] as String,
                                    ),
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
    String? imagePath, // معامل اختياري للصورة
  }) {
    final color = const Color(AppConstants.primaryColorValue);
    final bool hasImage = imagePath != null && imagePath.isNotEmpty;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            // إذا كانت هناك صورة، استخدمها كخلفية
            image: imagePath != null && imagePath.isNotEmpty
                ? DecorationImage(
                    image: AssetImage(imagePath),
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                  )
                : null,
            // إذا لم تكن هناك صورة، استخدم gradient
            gradient: hasImage
                ? null
                : LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [color, color.withOpacity(0.9)],
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
              // Overlay داكن خفيف للصورة لتحسين قراءة النص
              if (hasImage)
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.01), // خفيف جداً
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),

              // Decorative circles - فقط إذا لم تكن هناك صورة
              if (!hasImage) ...[
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
              ],

              // Content
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 14,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Icon Section - فقط إذا لم تكن هناك صورة
                    if (!hasImage) ...[
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
                        child: Icon(icon, color: Colors.white, size: 22),
                      ),
                      const SizedBox(width: 10),
                    ],

                    // Text Section
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Title - مقاسات الخدمات
                          Text(
                            title,
                            style: TextStyle(
                              fontSize: title == AppConstants.serviceBattery
                                  ? 17
                                  : 19, // تكبير من 14/16 إلى 17/19
                              fontWeight: FontWeight.normal, // بدون Bold
                              color: const Color(0xFF1A3E75),
                              letterSpacing:
                                  title == AppConstants.serviceBattery
                                  ? 0.3
                                  : 0.2,
                              height: 1.2,
                              shadows: [
                                Shadow(
                                  color: Colors.white.withOpacity(0.8),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                                Shadow(
                                  color: Colors.white.withOpacity(0.6),
                                  blurRadius: 4,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.right,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          // Price
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppConstants.isServicePriceVariable(title)
                                  ? Colors.white.withOpacity(0.25)
                                  : Colors.white.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              AppConstants.getServicePriceText(title),
                              style: const TextStyle(
                                fontSize: 13, // تكبير من 11 إلى 13
                                color: Color(0xFF1A3E75),
                                fontWeight: FontWeight.normal, // بدون Bold
                                height: 1.0,
                                shadows: [
                                  Shadow(
                                    color: Colors.white,
                                    blurRadius: 3,
                                    offset: Offset(0, 1),
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.right,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
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

  // قائمة الخدمات المتميزة (مشتركة)
  List<Map<String, dynamic>> _getPremiumServices() {
    return [
      {
        'title': AppConstants.serviceSubscription,
        'subtitle': 'اشتراك شهري/سنوي',
        'icon': Icons.card_membership_rounded,
        'badge': 'حصري',
        'gradient': [Color(0xFFFFD700), Color(0xFFFFA500)],
      },
      {
        'title': AppConstants.serviceLoyalty,
        'subtitle': 'برنامج نقاط الولاء',
        'icon': Icons.stars_rounded,
        'badge': 'حصري',
        'gradient': [Color(0xFFFF6B6B), Color(0xFFFF8E8E)],
      },
      {
        'title': AppConstants.serviceDiscount,
        'subtitle': 'خصومات للعملاء المتكررين',
        'icon': Icons.local_offer_rounded,
        'badge': 'حصري',
        'gradient': [Color(0xFF4ECDC4), Color(0xFF44A08D)],
      },
      {
        'title': AppConstants.serviceVIP,
        'subtitle': 'خدمة VIP (أولوية)',
        'icon': Icons.diamond_rounded,
        'badge': 'حصري',
        'gradient': [Color(0xFF9D50BB), Color(0xFF6E48AA)],
      },
    ];
  }

  Widget _buildPremiumServicesBanner(BuildContext context, Color color) {
    return Builder(
      builder: (builderContext) => Container(
        margin: const EdgeInsets.fromLTRB(20, 12, 20, 0),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => Scaffold.of(builderContext).openEndDrawer(),
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFFFD700),
                    Color(0xFFFFA500),
                    Color(0xFFFF6B6B),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFFFFD700).withOpacity(0.4),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                    spreadRadius: -5,
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Icon
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.25),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withOpacity(0.5),
                        width: 2,
                      ),
                    ),
                    child: const Icon(
                      Icons.star_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Text
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'خدمات متميزة حصرية',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 0.3,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'اضغط للاطلاع على الخدمات المميزة',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withOpacity(0.95),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Arrow
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.25),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPremiumServicesDrawer(BuildContext context, Color color) {
    final premiumServices = _getPremiumServices();

    return Drawer(
      width: MediaQuery.of(context).size.width * 0.85,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.grey[50]!, Colors.grey[100]!],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
                  ),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'خدمات متميزة حصرية',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Services List
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: premiumServices.length,
                  itemBuilder: (context, index) {
                    final service = premiumServices[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _buildPremiumServiceCardForDrawer(
                        context: context,
                        title: service['title'] as String,
                        subtitle: service['subtitle'] as String,
                        icon: service['icon'] as IconData,
                        badge: service['badge'] as String,
                        gradient: service['gradient'] as List<Color>,
                        onTap: () {
                          Navigator.pop(context);
                          _openRequest(context, service['title'] as String);
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPremiumServiceCardForDrawer({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required String badge,
    required List<Color> gradient,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: gradient,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: gradient[0].withOpacity(0.3),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            children: [
              // Icon
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.5),
                    width: 2,
                  ),
                ),
                child: Icon(icon, color: Colors.white, size: 26),
              ),
              const SizedBox(width: 16),
              // Text
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            badge,
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.9),
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // Arrow
              const Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.white,
                size: 18,
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
              Text(
                'لماذا ${AppConstants.appName}؟',
                style: const TextStyle(
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

// New Home Header Widget
class HomeHeader extends StatefulWidget {
  const HomeHeader({
    super.key,
    required this.onPickLocation,
    this.logoAssetPath = 'assets/images/shm_logo.png',
    this.heightFactor = 0.60,
  });

  final VoidCallback onPickLocation;
  final String logoAssetPath;
  final double heightFactor;

  @override
  State<HomeHeader> createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> {
  late Timer _timer;
  int _currentIndex = 0;

  final List<String> _messages = [
    'نصلك في أي مكان ',
    'نحن في خدمتك 24 ساعة',
    'خبرة وسرعة استجابة عالية',
  ];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (mounted) {
        setState(() {
          _currentIndex = (_currentIndex + 1) % _messages.length;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  static const Color _blue2 = Color(0xFF6CB6FF);
  static const Color _bg = Color(0xFFF6F9FF);
  static const Color _textDark = Color(0xFF1A3E75);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final headerH = size.height * widget.heightFactor;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: SizedBox(
        width: double.infinity,
        height: headerH,
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/images/map_bg.png',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  // Fallback إذا لم توجد الصورة
                  return Container(color: _blue2.withOpacity(0.1));
                },
              ),
            ),

            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white.withOpacity(0.05),
                      _blue2.withOpacity(0.08),
                      Colors.white.withOpacity(0.85),
                    ],
                  ),
                ),
              ),
            ),
            // النص في الزاوية اليسرى العلوية
            Positioned(
              top: 24,
              left: 18,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${AppConstants.appName} خدمة موثوقة وسريعة',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: _textDark,
                      height: 1.2,
                      shadows: [
                        Shadow(
                          color: Colors.white.withOpacity(0.8),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 600),
                    transitionBuilder: (child, animation) {
                      final slideAnimation = Tween<Offset>(
                        begin: const Offset(-1.0, 0),
                        end: Offset.zero,
                      ).animate(animation);
                      return SlideTransition(
                        position: slideAnimation,
                        child: FadeTransition(opacity: animation, child: child),
                      );
                    },
                    child: Text(
                      _messages[_currentIndex],
                      key: ValueKey(_messages[_currentIndex]),
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: _textDark,
                        height: 1.3,
                        shadows: [
                          Shadow(
                            color: Colors.white,
                            blurRadius: 6,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 28,
                decoration: const BoxDecoration(
                  color: _bg,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                ),
                child: Center(
                  child: Container(
                    width: 42,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
