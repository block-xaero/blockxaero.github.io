import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';
import 'dart:html' as html;

void main() {
  runApp(const CyanWebsite());
}

// =============================================================================
// ANIMATED CONSTELLATION WIDGET
// =============================================================================

class AnimatedConstellation extends StatefulWidget {
  final double size;
  const AnimatedConstellation({super.key, this.size = 400});

  @override
  State<AnimatedConstellation> createState() => _AnimatedConstellationState();
}

class _AnimatedConstellationState extends State<AnimatedConstellation>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _flowController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _flowAnimation;

  @override
  void initState() {
    super.initState();
    
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    )..repeat(reverse: true);
    
    _flowController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();
    
    _pulseAnimation = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    
    _flowAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_flowController);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _flowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: Listenable.merge([_pulseController, _flowController]),
        builder: (context, child) {
          return CustomPaint(
            size: Size(widget.size, widget.size),
            painter: ConstellationPainter(
              pulseValue: _pulseAnimation.value,
              flowValue: _flowAnimation.value,
            ),
          );
        },
      ),
    );
  }
}

class ConstellationPainter extends CustomPainter {
  final double pulseValue;
  final double flowValue;

  ConstellationPainter({required this.pulseValue, required this.flowValue});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final scale = size.width / 400;
    
    // Node positions (relative to center)
    final topLeft = center + Offset(-70 * scale, -100 * scale);
    final topRight = center + Offset(70 * scale, -100 * scale);
    final bottom = center + Offset(0, 120 * scale);
    
    // Edge paint
    final edgePaint = Paint()
      ..color = Monokai.cyan.withOpacity(0.25)
      ..strokeWidth = 2 * scale
      ..strokeCap = StrokeCap.round;
    
    // Draw edges
    canvas.drawLine(center, topLeft, edgePaint);
    canvas.drawLine(center, topRight, edgePaint);
    canvas.drawLine(center, bottom, edgePaint);
    
    // Draw flowing particles
    _drawFlowingParticle(canvas, center, topLeft, flowValue, scale);
    _drawFlowingParticle(canvas, center, topRight, (flowValue + 0.33) % 1.0, scale);
    _drawFlowingParticle(canvas, center, bottom, (flowValue + 0.66) % 1.0, scale);
    
    // Outer nodes
    _drawNode(canvas, topLeft, 10 * scale, 0.6 + (pulseValue - 1.0) * 0.2);
    _drawNode(canvas, topRight, 10 * scale, 0.6 + ((pulseValue - 0.9) * 0.3).abs());
    _drawNode(canvas, bottom, 10 * scale, 0.6 + ((pulseValue - 1.1) * 0.25).abs());
    
    // Center node (larger, pulsing)
    _drawCenterNode(canvas, center, 18 * scale * pulseValue);
  }

  void _drawFlowingParticle(Canvas canvas, Offset from, Offset to, double t, double scale) {
    // Particle flows from outer node to center
    final pos = Offset.lerp(to, from, t)!;
    final opacity = t < 0.1 ? t * 10 : (t > 0.9 ? (1.0 - t) * 10 : 1.0);
    
    final particlePaint = Paint()
      ..color = Monokai.cyan.withOpacity(0.8 * opacity)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 3 * scale);
    
    canvas.drawCircle(pos, 4 * scale, particlePaint);
  }

  void _drawNode(Canvas canvas, Offset pos, double radius, double opacity) {
    // Outer glow
    final glowPaint = Paint()
      ..color = Monokai.cyan.withOpacity(0.15 * opacity)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, radius * 0.8);
    canvas.drawCircle(pos, radius * 1.5, glowPaint);
    
    // Dark core
    final corePaint = Paint()..color = const Color(0xFF004d4d).withOpacity(opacity);
    canvas.drawCircle(pos, radius, corePaint);
    
    // Bright ring
    final ringPaint = Paint()..color = Monokai.cyan.withOpacity(opacity);
    canvas.drawCircle(pos, radius * 0.65, ringPaint);
    
    // Center dot
    final dotPaint = Paint()..color = const Color(0xFFb2ebf2).withOpacity(opacity);
    canvas.drawCircle(pos, radius * 0.25, dotPaint);
  }

  void _drawCenterNode(Canvas canvas, Offset pos, double radius) {
    // Strong glow
    final glowPaint = Paint()
      ..color = Monokai.cyan.withOpacity(0.2)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, radius);
    canvas.drawCircle(pos, radius * 1.8, glowPaint);
    
    // Dark base
    final basePaint = Paint()..color = const Color(0xFF003d3d);
    canvas.drawCircle(pos, radius, basePaint);
    
    // Gradient middle
    final midPaint = Paint()..color = Monokai.cyan.withOpacity(0.9);
    canvas.drawCircle(pos, radius * 0.7, midPaint);
    
    // Bright center
    final centerPaint = Paint()..color = const Color(0xFFb2ebf2);
    canvas.drawCircle(pos, radius * 0.4, centerPaint);
    
    // White core
    final whitePaint = Paint()..color = Colors.white;
    canvas.drawCircle(pos, radius * 0.15, whitePaint);
  }

  @override
  bool shouldRepaint(ConstellationPainter oldDelegate) {
    return oldDelegate.pulseValue != pulseValue || oldDelegate.flowValue != flowValue;
  }
}

// =============================================================================
// MONOKAI THEME (exact colors from ThemeManager.swift)
// =============================================================================

class Monokai {
  static const Color background = Color(0xFF272822);
  static const Color surface = Color(0xFF3E3D32);
  static const Color surfaceHover = Color(0xFF4E4D42);
  static const Color foreground = Color(0xFFF8F8F2);
  static const Color foregroundSecondary = Color(0xFFCFCFC2);
  static const Color comment = Color(0xFF75715E);
  static const Color divider = Color(0xFF4A4A40);
  
  static const Color red = Color(0xFFF92672);
  static const Color green = Color(0xFFA6E22E);
  static const Color yellow = Color(0xFFE6DB74);
  static const Color blue = Color(0xFF56B6C2);
  static const Color cyan = Color(0xFF66D9EF);
  static const Color purple = Color(0xFFAE81FF);
  static const Color orange = Color(0xFFFD971F);
  static const Color pink = Color(0xFFF92672);
  
  // Darker background for hero
  static const Color heroBackground = Color(0xFF1a1a17);
}

// =============================================================================
// MAIN APP
// =============================================================================

class CyanWebsite extends StatelessWidget {
  const CyanWebsite({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cyan - Collaboration Platform',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Monokai.background,
        colorScheme: ColorScheme.dark(
          primary: Monokai.cyan,
          secondary: Monokai.green,
          surface: Monokai.surface,
          background: Monokai.background,
        ),
        textTheme: GoogleFonts.jetBrainsMonoTextTheme(
          ThemeData.dark().textTheme,
        ).apply(
          bodyColor: Monokai.foreground,
          displayColor: Monokai.foreground,
        ),
      ),
      home: const CyanHomePage(),
    );
  }
}

// =============================================================================
// HOME PAGE
// =============================================================================

class CyanHomePage extends StatefulWidget {
  const CyanHomePage({super.key});

  @override
  State<CyanHomePage> createState() => _CyanHomePageState();
}

class _CyanHomePageState extends State<CyanHomePage> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _emailController = TextEditingController();
  bool _isScrolled = false;
  bool _emailSubmitted = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final isScrolled = _scrollController.offset > 50;
    if (isScrolled != _isScrolled) {
      setState(() => _isScrolled = isScrolled);
    }
  }

  void _scrollToSection(String section) {
    // Simple scroll - in production you'd use keys
    double offset = 0;
    switch (section) {
      case 'features':
        offset = 800;
        break;
      case 'lens':
        offset = 1400;
        break;
      case 'download':
        offset = 100;
        break;
    }
    _scrollController.animateTo(
      offset,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  void _submitEmail() {
    if (_emailController.text.isNotEmpty && _emailController.text.contains('@')) {
      // For now, just show confirmation
      // TODO: Wire to Buttondown or your backend
      setState(() => _emailSubmitted = true);
      // Could also open mailto or post to API
      print('Email submitted: ${_emailController.text}');
    }
  }

  void _openRequestDemo() async {
    final uri = Uri.parse('mailto:demo@blockxaero.io?subject=Cyan Demo Request');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;

    return Scaffold(
      body: Stack(
        children: [
          // Main content
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                _buildHero(isMobile),
                _buildFeatures(isMobile),
                _buildLensAI(isMobile),
                _buildWhyCyan(isMobile),
                _buildFooter(isMobile),
              ],
            ),
          ),
          // Fixed navbar
          _buildNavbar(isMobile),
        ],
      ),
    );
  }

  // ===========================================================================
  // NAVBAR
  // ===========================================================================

  Widget _buildNavbar(bool isMobile) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: 64,
      decoration: BoxDecoration(
        color: _isScrolled 
            ? Monokai.background.withOpacity(0.95) 
            : Colors.transparent,
        border: Border(
          bottom: BorderSide(
            color: _isScrolled ? Monokai.divider : Colors.transparent,
            width: 1,
          ),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 48),
        child: Row(
          children: [
            // Logo
            Image.asset(
              'assets/cyan-wordmark.png',
              height: 32,
              filterQuality: FilterQuality.high,
            ),
            const Spacer(),
            if (!isMobile) ...[
              _navLink('Features', () => _scrollToSection('features')),
              const SizedBox(width: 32),
              _navLink('Lens AI', () => _scrollToSection('lens')),
              const SizedBox(width: 32),
              _navLink('Download', () => _scrollToSection('download')),
              const SizedBox(width: 32),
              _buildRequestDemoButton(),
            ] else
              IconButton(
                icon: const Icon(Icons.menu, color: Monokai.foreground),
                onPressed: () => _showMobileMenu(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _navLink(String text, VoidCallback onTap) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Text(
          text,
          style: GoogleFonts.jetBrainsMono(
            color: Monokai.foregroundSecondary,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildRequestDemoButton() {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: _openRequestDemo,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            border: Border.all(color: Monokai.cyan.withOpacity(0.5)),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            'Request Demo',
            style: GoogleFonts.jetBrainsMono(
              color: Monokai.cyan,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  void _showMobileMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Monokai.surface,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text('Features', style: GoogleFonts.jetBrainsMono(color: Monokai.foreground)),
              onTap: () {
                Navigator.pop(context);
                _scrollToSection('features');
              },
            ),
            ListTile(
              title: Text('Lens AI', style: GoogleFonts.jetBrainsMono(color: Monokai.foreground)),
              onTap: () {
                Navigator.pop(context);
                _scrollToSection('lens');
              },
            ),
            ListTile(
              title: Text('Download', style: GoogleFonts.jetBrainsMono(color: Monokai.foreground)),
              onTap: () {
                Navigator.pop(context);
                _scrollToSection('download');
              },
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _openRequestDemo();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Monokai.cyan.withOpacity(0.2),
                  foregroundColor: Monokai.cyan,
                ),
                child: Text('Request Demo', style: GoogleFonts.jetBrainsMono()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // HERO SECTION
  // ===========================================================================

  Widget _buildHero(bool isMobile) {
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(minHeight: isMobile ? 750 : 850),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFF0d0d0a),
            Monokai.heroBackground,
            Monokai.background,
          ],
        ),
      ),
      child: Stack(
        children: [
          // Animated constellation - more prominent
          Positioned.fill(
            child: Center(
              child: AnimatedConstellation(size: isMobile ? 350 : 500),
            ),
          ),
          // Content
          Padding(
            padding: EdgeInsets.fromLTRB(
              isMobile ? 24 : 48,
              140,
              isMobile ? 24 : 48,
              80,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 800),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Main headline
                    Text(
                      'Collaboration that\nkeeps up with you',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: isMobile ? 32 : 52,
                        fontWeight: FontWeight.w700,
                        color: Monokai.foreground,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Subheadline
                    Text(
                      'Boards. Notes. Notebooks. Canvas. Chat.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: isMobile ? 16 : 20,
                        color: Monokai.cyan,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Real-time sync. Complete privacy. No compromises.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: isMobile ? 14 : 16,
                        color: Monokai.foregroundSecondary,
                      ),
                    ),
                    const SizedBox(height: 40),
                    // Tech badges - business friendly
                    Wrap(
                      spacing: 12,
                      runSpacing: 8,
                      alignment: WrapAlignment.center,
                      children: [
                        _buildTechBadge('Peer-to-Peer', Monokai.cyan),
                        _buildTechBadge('End-to-End Encrypted', Monokai.green),
                        _buildTechBadge('Lightning Fast', Monokai.orange),
                      ],
                    ),
                    const SizedBox(height: 48),
                    // Download buttons
                    Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      alignment: WrapAlignment.center,
                      children: [
                        _buildDownloadButton(
                          icon: Icons.laptop_mac,
                          label: 'macOS',
                          comingSoon: true,
                        ),
                        _buildDownloadButton(
                          icon: Icons.laptop_windows,
                          label: 'Windows',
                          comingSoon: true,
                        ),
                      ],
                    ),
                    const SizedBox(height: 48),
                    // Email signup
                    _buildEmailSignup(isMobile),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTechBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: GoogleFonts.jetBrainsMono(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildDownloadButton({
    required IconData icon,
    required String label,
    bool comingSoon = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      decoration: BoxDecoration(
        color: Monokai.surface,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Monokai.divider),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Monokai.foreground, size: 20),
          const SizedBox(width: 12),
          Text(
            label,
            style: GoogleFonts.jetBrainsMono(
              color: Monokai.foreground,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (comingSoon) ...[
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Monokai.orange.withOpacity(0.2),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                'Soon',
                style: GoogleFonts.jetBrainsMono(
                  color: Monokai.orange,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEmailSignup(bool isMobile) {
    if (_emailSubmitted) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Monokai.green.withOpacity(0.1),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: Monokai.green.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle, color: Monokai.green, size: 20),
            const SizedBox(width: 12),
            Text(
              "You're on the list. We'll be in touch.",
              style: GoogleFonts.jetBrainsMono(
                color: Monokai.green,
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        Text(
          '// get notified when we launch',
          style: GoogleFonts.jetBrainsMono(
            color: Monokai.comment,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: 44,
                  decoration: BoxDecoration(
                    color: Monokai.surface,
                    borderRadius: const BorderRadius.horizontal(
                      left: Radius.circular(6),
                    ),
                    border: Border.all(color: Monokai.divider),
                  ),
                  child: TextField(
                    controller: _emailController,
                    style: GoogleFonts.jetBrainsMono(
                      color: Monokai.foreground,
                      fontSize: 14,
                    ),
                    decoration: InputDecoration(
                      hintText: 'you@company.com',
                      hintStyle: GoogleFonts.jetBrainsMono(
                        color: Monokai.comment,
                        fontSize: 14,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                    onSubmitted: (_) => _submitEmail(),
                  ),
                ),
              ),
              GestureDetector(
                onTap: _submitEmail,
                child: Container(
                  height: 44,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Monokai.cyan,
                    borderRadius: const BorderRadius.horizontal(
                      right: Radius.circular(6),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'Notify Me',
                      style: GoogleFonts.jetBrainsMono(
                        color: Monokai.heroBackground,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ===========================================================================
  // FEATURES SECTION
  // ===========================================================================

  Widget _buildFeatures(bool isMobile) {
    final features = [
      _FeatureItem(
        icon: '📝',
        title: 'Notes',
        description: 'Rich documents with real-time collaboration. Always in sync.',
        color: Monokai.green,
      ),
      _FeatureItem(
        icon: '📓',
        title: 'Notebook',
        description: 'Interactive code and data. Python, SQL — run it, share it.',
        color: Monokai.purple,
      ),
      _FeatureItem(
        icon: '🎨',
        title: 'Canvas',
        description: 'Whiteboard for ideas. Diagrams, sketches, visual thinking.',
        color: Monokai.orange,
      ),
      _FeatureItem(
        icon: '💬',
        title: 'Chat',
        description: 'Conversations in context. Discuss right where the work happens.',
        color: Monokai.cyan,
      ),
    ];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 48,
        vertical: 80,
      ),
      color: Monokai.background,
      child: Column(
        children: [
          Text(
            'One workspace for everything',
            style: GoogleFonts.jetBrainsMono(
              color: Monokai.foreground,
              fontSize: isMobile ? 24 : 36,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Stop switching tools. Start shipping work.',
            style: GoogleFonts.jetBrainsMono(
              color: Monokai.foregroundSecondary,
              fontSize: isMobile ? 14 : 16,
            ),
          ),
          const SizedBox(height: 56),
          Wrap(
            spacing: 24,
            runSpacing: 24,
            alignment: WrapAlignment.center,
            children: features.map((f) => _buildFeatureCard(f, isMobile)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(_FeatureItem feature, bool isMobile) {
    return Container(
      width: isMobile ? double.infinity : 260,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Monokai.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Monokai.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            feature.icon,
            style: const TextStyle(fontSize: 32),
          ),
          const SizedBox(height: 16),
          Text(
            feature.title,
            style: GoogleFonts.jetBrainsMono(
              color: feature.color,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            feature.description,
            style: GoogleFonts.jetBrainsMono(
              color: Monokai.foregroundSecondary,
              fontSize: 13,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // LENS AI SECTION
  // ===========================================================================

  Widget _buildLensAI(bool isMobile) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 48,
        vertical: 80,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Monokai.surface.withOpacity(0.5),
            Monokai.background,
          ],
        ),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Monokai.purple.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'CYAN LENS AI',
                  style: GoogleFonts.jetBrainsMono(
                    color: Monokai.purple,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 2,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'Know what matters,\nwithout digging',
                textAlign: TextAlign.center,
                style: GoogleFonts.jetBrainsMono(
                  color: Monokai.foreground,
                  fontSize: isMobile ? 28 : 40,
                  fontWeight: FontWeight.w600,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Lens AI watches your workspace and surfaces what needs attention.\nOpen questions. Pending decisions. Blockers. All in one view.',
                textAlign: TextAlign.center,
                style: GoogleFonts.jetBrainsMono(
                  color: Monokai.foregroundSecondary,
                  fontSize: 14,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 48),
              Wrap(
                spacing: 16,
                runSpacing: 16,
                alignment: WrapAlignment.center,
                children: [
                  _buildLensFeature('Asks', 'Questions awaiting answers', Monokai.cyan),
                  _buildLensFeature('Decisions', 'Choices made and pending', Monokai.green),
                  _buildLensFeature('Nudges', 'What needs your attention', Monokai.orange),
                  _buildLensFeature('Pulse', 'Your team\'s activity summary', Monokai.purple),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLensFeature(String title, String description, Color color) {
    return Container(
      width: 180,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.jetBrainsMono(
              color: color,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: GoogleFonts.jetBrainsMono(
              color: Monokai.foregroundSecondary,
              fontSize: 11,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // WHY CYAN SECTION
  // ===========================================================================

  Widget _buildWhyCyan(bool isMobile) {
    final points = [
      _WhyPoint(
        icon: Icons.bolt,
        title: 'Faster than cloud',
        description: 'Direct peer-to-peer sync means your team sees changes instantly — no waiting on servers.',
        color: Monokai.yellow,
      ),
      _WhyPoint(
        icon: Icons.lock_outline,
        title: 'Complete privacy',
        description: 'Your data never touches our servers. End-to-end encrypted between your team, always.',
        color: Monokai.green,
      ),
      _WhyPoint(
        icon: Icons.speed,
        title: 'Enterprise reliability',
        description: 'Built on battle-tested technology trusted by leading companies worldwide.',
        color: Monokai.cyan,
      ),
      _WhyPoint(
        icon: Icons.devices,
        title: 'Works everywhere',
        description: 'macOS, Windows, and iOS. Your workspace follows you across all your devices.',
        color: Monokai.purple,
      ),
    ];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 48,
        vertical: 80,
      ),
      color: Monokai.background,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Column(
            children: [
              Text(
                'Why teams choose Cyan',
                style: GoogleFonts.jetBrainsMono(
                  color: Monokai.foreground,
                  fontSize: isMobile ? 24 : 36,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'The speed of local. The power of connected.',
                style: GoogleFonts.jetBrainsMono(
                  color: Monokai.foregroundSecondary,
                  fontSize: isMobile ? 14 : 16,
                ),
              ),
              const SizedBox(height: 56),
              isMobile
                  ? Column(
                      children: points.map((p) => _buildWhyPointCard(p)).toList(),
                    )
                  : Wrap(
                      spacing: 24,
                      runSpacing: 24,
                      alignment: WrapAlignment.center,
                      children: points.map((p) => _buildWhyPointCard(p)).toList(),
                    ),
              const SizedBox(height: 56),
              // Tech footer - subtle
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: Monokai.surface.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Monokai.divider),
                ),
                child: Wrap(
                  spacing: 24,
                  runSpacing: 8,
                  alignment: WrapAlignment.center,
                  children: [
                    _buildTechFooterItem('Rust'),
                    _buildTechFooterItem('QUIC'),
                    _buildTechFooterItem('Iroh'),
                    _buildTechFooterItem('Tokio'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWhyPointCard(_WhyPoint point) {
    return Container(
      width: 200,
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Monokai.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: point.color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: point.color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(point.icon, color: point.color, size: 20),
          ),
          const SizedBox(height: 16),
          Text(
            point.title,
            style: GoogleFonts.jetBrainsMono(
              color: Monokai.foreground,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            point.description,
            style: GoogleFonts.jetBrainsMono(
              color: Monokai.foregroundSecondary,
              fontSize: 12,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTechFooterItem(String label) {
    return Text(
      label,
      style: GoogleFonts.jetBrainsMono(
        color: Monokai.comment,
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
    );
  }



  // ===========================================================================
  // FOOTER
  // ===========================================================================

  Widget _buildFooter(bool isMobile) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 48,
        vertical: 48,
      ),
      decoration: BoxDecoration(
        color: Monokai.surface.withOpacity(0.5),
        border: Border(
          top: BorderSide(color: Monokai.divider),
        ),
      ),
      child: Column(
        children: [
          // Logo
          Image.asset(
            'assets/cyan-wordmark.png',
            height: 28,
            filterQuality: FilterQuality.high,
          ),
          const SizedBox(height: 24),
          // Links
          Wrap(
            spacing: 32,
            runSpacing: 16,
            alignment: WrapAlignment.center,
            children: [
              _footerLink('Request Demo', _openRequestDemo),
              _footerLink('Privacy', () {}),
              _footerLink('Twitter', () async {
                final uri = Uri.parse('https://twitter.com/blockxaero');
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri);
                }
              }),
            ],
          ),
          const SizedBox(height: 32),
          Text(
            '© 2026 Cyan. All rights reserved.',
            style: GoogleFonts.jetBrainsMono(
              color: Monokai.comment,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '21-day free trial • No credit card required',
            style: GoogleFonts.jetBrainsMono(
              color: Monokai.comment.withOpacity(0.7),
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _footerLink(String text, VoidCallback onTap) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Text(
          text,
          style: GoogleFonts.jetBrainsMono(
            color: Monokai.foregroundSecondary,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}

// =============================================================================
// DATA CLASSES
// =============================================================================

class _FeatureItem {
  final String icon;
  final String title;
  final String description;
  final Color color;

  _FeatureItem({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
  });
}

class _WhyPoint {
  final IconData icon;
  final String title;
  final String description;
  final Color color;

  _WhyPoint({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
  });
}
