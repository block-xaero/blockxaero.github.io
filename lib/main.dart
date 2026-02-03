import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math' as math;

void main() {
  runApp(const CyanWebsite());
}

// =============================================================================
// MONOKAI THEME
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
  
  static const Color darkBackground = Color(0xFF0d0d0a);
}

// =============================================================================
// MAIN APP
// =============================================================================

class CyanWebsite extends StatelessWidget {
  const CyanWebsite({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cyan',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Monokai.darkBackground,
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

class _CyanHomePageState extends State<CyanHomePage> with TickerProviderStateMixin {
  String? _selectedNode;
  final TextEditingController _emailController = TextEditingController();
  bool _emailSubmitted = false;
  
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    )..repeat(reverse: true);
    
    _pulseAnimation = Tween<double>(begin: 0.92, end: 1.08).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _selectNode(String? node) {
    setState(() {
      _selectedNode = _selectedNode == node ? null : node;
    });
  }

  void _submitEmail() {
    if (_emailController.text.isNotEmpty && _emailController.text.contains('@')) {
      setState(() => _emailSubmitted = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 900;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.5,
            colors: [Color(0xFF151512), Monokai.darkBackground],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Navbar
              _buildNavbar(),
              // Main content
              Expanded(
                child: isMobile 
                    ? _buildMobileLayout(size)
                    : _buildDesktopLayout(size),
              ),
              // Platforms + Email
              _buildBottomSection(isMobile),
              // Footer
              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavbar() {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Image.asset(
            'assets/cyan-wordmark.png',
            height: 22,
            filterQuality: FilterQuality.high,
          ),
          const Spacer(),
          _buildRequestDemoButton(),
        ],
      ),
    );
  }

  Widget _buildRequestDemoButton() {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () async {
          final uri = Uri.parse('mailto:demo@blockxaero.io?subject=Cyan Demo Request');
          if (await canLaunchUrl(uri)) await launchUrl(uri);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            border: Border.all(color: Monokai.cyan.withOpacity(0.5)),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            'Request Demo',
            style: GoogleFonts.jetBrainsMono(
              color: Monokai.cyan,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // DESKTOP LAYOUT - Side by side
  // ===========================================================================

  Widget _buildDesktopLayout(Size size) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Row(
        children: [
          // Left side - Title + Constellation
          Expanded(
            flex: 5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Title
                Text(
                  'Cyan',
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    color: Monokai.cyan,
                    letterSpacing: 3,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Collaboration that keeps up with you',
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 13,
                    color: Monokai.foregroundSecondary,
                  ),
                ),
                const SizedBox(height: 24),
                // Constellation
                _buildConstellation(240),
              ],
            ),
          ),
          // Right side - Content panel
          Expanded(
            flex: 5,
            child: Center(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: _selectedNode != null
                    ? _buildContentPanel(_selectedNode!)
                    : _buildDefaultPanel(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // MOBILE LAYOUT - Stacked
  // ===========================================================================

  Widget _buildMobileLayout(Size size) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 16),
            // Title
            Text(
              'Cyan',
              style: GoogleFonts.jetBrainsMono(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: Monokai.cyan,
                letterSpacing: 3,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Collaboration that keeps up with you',
              textAlign: TextAlign.center,
              style: GoogleFonts.jetBrainsMono(
                fontSize: 12,
                color: Monokai.foregroundSecondary,
              ),
            ),
            const SizedBox(height: 20),
            // Constellation
            _buildConstellation(220),
            const SizedBox(height: 16),
            // Content panel
            if (_selectedNode != null) ...[
              _buildContentPanel(_selectedNode!),
              const SizedBox(height: 16),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDefaultPanel() {
    return Container(
      key: const ValueKey('default'),
      constraints: const BoxConstraints(maxWidth: 380),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Monokai.surface.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Monokai.divider),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.touch_app, color: Monokai.cyan.withOpacity(0.5), size: 32),
          const SizedBox(height: 12),
          Text(
            'Tap a node to explore',
            style: GoogleFonts.jetBrainsMono(
              color: Monokai.foregroundSecondary,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Collaboration • Workspaces • P2P • AI',
            style: GoogleFonts.jetBrainsMono(
              color: Monokai.comment,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // CONSTELLATION
  // ===========================================================================

  Widget _buildConstellation(double nodeSize) {
    return SizedBox(
      width: nodeSize,
      height: nodeSize,
      child: AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (context, child) {
          return CustomPaint(
            painter: ConstellationPainter(
              pulseValue: _pulseAnimation.value,
              selectedNode: _selectedNode,
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // Center node
                _buildCenterNode(nodeSize),
                // Outer nodes - Y shape
                _buildOuterNode(
                  nodeSize: nodeSize,
                  angle: -90, // Top
                  distance: 0.42,
                  label: 'Collaboration',
                  icon: Icons.people_outline,
                  color: Monokai.green,
                  nodeId: 'collaboration',
                ),
                _buildOuterNode(
                  nodeSize: nodeSize,
                  angle: 210, // Bottom-left
                  distance: 0.42,
                  label: 'Workspaces',
                  icon: Icons.dashboard_outlined,
                  color: Monokai.purple,
                  nodeId: 'workspaces',
                ),
                _buildOuterNode(
                  nodeSize: nodeSize,
                  angle: -30, // Bottom-right
                  distance: 0.42,
                  label: 'Peer-to-Peer',
                  icon: Icons.hub_outlined,
                  color: Monokai.orange,
                  nodeId: 'p2p',
                ),
                _buildOuterNode(
                  nodeSize: nodeSize,
                  angle: 90, // Bottom center
                  distance: 0.48,
                  label: 'Lens AI',
                  icon: Icons.auto_awesome,
                  color: Monokai.cyan,
                  nodeId: 'lens',
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCenterNode(double nodeSize) {
    final size = nodeSize * 0.16; // Smaller center
    return Positioned(
      left: (nodeSize - size) / 2,
      top: (nodeSize - size) / 2,
      child: AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _pulseAnimation.value,
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const RadialGradient(
                  colors: [Monokai.cyan, Color(0xFF338899)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Monokai.cyan.withOpacity(0.5),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Center(
                child: Container(
                  width: size * 0.35,
                  height: size * 0.35,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildOuterNode({
    required double nodeSize,
    required double angle,
    required double distance,
    required String label,
    required IconData icon,
    required Color color,
    required String nodeId,
  }) {
    final radians = angle * (math.pi / 180);
    final centerX = nodeSize / 2;
    final centerY = nodeSize / 2;
    final actualDistance = nodeSize * distance;
    final x = centerX + actualDistance * math.cos(radians);
    final y = centerY + actualDistance * math.sin(radians);
    
    final isSelected = _selectedNode == nodeId;
    final nodeDiameter = nodeSize * 0.26;

    return Positioned(
      left: x - nodeDiameter / 2,
      top: y - nodeDiameter / 2,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () => _selectNode(nodeId),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: nodeDiameter,
            height: nodeDiameter,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? color.withOpacity(0.2) : Monokai.surface.withOpacity(0.9),
              border: Border.all(
                color: isSelected ? color : color.withOpacity(0.5),
                width: isSelected ? 2 : 1.5,
              ),
              boxShadow: isSelected
                  ? [BoxShadow(color: color.withOpacity(0.4), blurRadius: 16)]
                  : null,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: color, size: nodeDiameter * 0.28),
                SizedBox(height: nodeDiameter * 0.04),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.jetBrainsMono(
                    color: Monokai.foreground,
                    fontSize: nodeDiameter * 0.13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // CONTENT PANEL
  // ===========================================================================

  Widget _buildContentPanel(String nodeId) {
    final data = _getNodeData(nodeId);
    
    return Container(
      key: ValueKey(nodeId),
      constraints: const BoxConstraints(maxWidth: 380),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Monokai.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: data['color'].withOpacity(0.4)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 3,
                height: 20,
                decoration: BoxDecoration(
                  color: data['color'],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  data['title'],
                  style: GoogleFonts.jetBrainsMono(
                    color: Monokai.foreground,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => _selectNode(null),
                child: Icon(Icons.close, color: Monokai.comment, size: 18),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            data['description'],
            style: GoogleFonts.jetBrainsMono(
              color: Monokai.foregroundSecondary,
              fontSize: 12,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 14),
          ...List.generate(data['features'].length, (i) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.check, color: data['color'], size: 14),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    data['features'][i],
                    style: GoogleFonts.jetBrainsMono(
                      color: Monokai.foreground,
                      fontSize: 11,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Map<String, dynamic> _getNodeData(String nodeId) {
    switch (nodeId) {
      case 'collaboration':
        return {
          'color': Monokai.green,
          'title': 'Real-time Collaboration',
          'description': 'Work together seamlessly. Every change syncs instantly — no refresh, no conflicts.',
          'features': [
            'See teammates\' cursors live',
            'Comments and threads in context',
            'Works offline, syncs when back',
          ],
        };
      case 'workspaces':
        return {
          'color': Monokai.purple,
          'title': 'Unified Workspaces',
          'description': 'Notes, notebooks, canvas, and chat — all in one place.',
          'features': [
            'Notes: Rich docs with markdown',
            'Notebooks: Run Python, SQL, visualize',
            'Canvas: Diagrams & visual thinking',
            'Chat: Conversations in context',
          ],
        };
      case 'p2p':
        return {
          'color': Monokai.orange,
          'title': 'Peer-to-Peer Architecture',
          'description': 'Direct sync between team members. No cloud servers.',
          'features': [
            'QUIC protocol — faster than HTTP',
            'End-to-end encrypted by default',
            'Built on Rust, Iroh & Tokio',
          ],
        };
      case 'lens':
        return {
          'color': Monokai.cyan,
          'title': 'Cyan Lens AI',
          'description': 'Your intelligent workspace assistant.',
          'features': [
            'Asks: Questions awaiting answers',
            'Decisions: Choices made & pending',
            'Nudges: What needs attention',
            'Pulse: Team activity summary',
          ],
        };
      default:
        return {};
    }
  }

  // ===========================================================================
  // BOTTOM SECTION - Platforms + Email
  // ===========================================================================

  Widget _buildBottomSection(bool isMobile) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 40,
        vertical: 16,
      ),
      child: Column(
        children: [
          // Platform buttons
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: [
              _buildPlatformChip(Icons.laptop_mac, 'macOS'),
              _buildPlatformChip(Icons.laptop_windows, 'Windows'),
              _buildPlatformChip(Icons.computer, 'Linux'),
              _buildPlatformChip(Icons.phone_iphone, 'iOS'),
              _buildPlatformChip(Icons.phone_android, 'Android'),
            ],
          ),
          const SizedBox(height: 16),
          // Email signup
          if (!_emailSubmitted)
            Container(
              constraints: const BoxConstraints(maxWidth: 340),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 36,
                      decoration: BoxDecoration(
                        color: Monokai.surface,
                        borderRadius: const BorderRadius.horizontal(left: Radius.circular(4)),
                        border: Border.all(color: Monokai.divider),
                      ),
                      child: TextField(
                        controller: _emailController,
                        style: GoogleFonts.jetBrainsMono(color: Monokai.foreground, fontSize: 12),
                        decoration: InputDecoration(
                          hintText: 'you@company.com',
                          hintStyle: GoogleFonts.jetBrainsMono(color: Monokai.comment, fontSize: 12),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                        ),
                        onSubmitted: (_) => _submitEmail(),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: _submitEmail,
                    child: Container(
                      height: 36,
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: const BoxDecoration(
                        color: Monokai.cyan,
                        borderRadius: BorderRadius.horizontal(right: Radius.circular(4)),
                      ),
                      child: Center(
                        child: Text(
                          'Notify Me',
                          style: GoogleFonts.jetBrainsMono(
                            color: Monokai.darkBackground,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          else
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: Monokai.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Monokai.green.withOpacity(0.3)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_circle, color: Monokai.green, size: 14),
                  const SizedBox(width: 6),
                  Text(
                    "You're on the list!",
                    style: GoogleFonts.jetBrainsMono(color: Monokai.green, fontSize: 11),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPlatformChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Monokai.surface.withOpacity(0.7),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Monokai.divider),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Monokai.foreground, size: 14),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.jetBrainsMono(color: Monokai.foreground, fontSize: 10),
          ),
          const SizedBox(width: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
            decoration: BoxDecoration(
              color: Monokai.orange.withOpacity(0.2),
              borderRadius: BorderRadius.circular(2),
            ),
            child: Text(
              'Soon',
              style: GoogleFonts.jetBrainsMono(
                color: Monokai.orange,
                fontSize: 8,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // FOOTER
  // ===========================================================================

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        '© 2026 Cyan • 21-day free trial • Request Demo',
        style: GoogleFonts.jetBrainsMono(
          color: Monokai.comment,
          fontSize: 10,
        ),
      ),
    );
  }
}

// =============================================================================
// CONSTELLATION PAINTER
// =============================================================================

class ConstellationPainter extends CustomPainter {
  final double pulseValue;
  final String? selectedNode;

  ConstellationPainter({required this.pulseValue, this.selectedNode});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    
    // Calculate positions
    final positions = {
      'collaboration': _getPosition(center, size, -90, 0.42),
      'workspaces': _getPosition(center, size, 210, 0.42),
      'p2p': _getPosition(center, size, -30, 0.42),
      'lens': _getPosition(center, size, 90, 0.48),
    };

    final linePaint = Paint()
      ..color = Monokai.cyan.withOpacity(0.12)
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;

    // Draw lines from center to each node
    for (final pos in positions.values) {
      canvas.drawLine(center, pos, linePaint);
    }
  }

  Offset _getPosition(Offset center, Size size, double angle, double distanceRatio) {
    final radians = angle * (math.pi / 180);
    final distance = size.width * distanceRatio;
    return center + Offset(distance * math.cos(radians), distance * math.sin(radians));
  }

  @override
  bool shouldRepaint(ConstellationPainter oldDelegate) {
    return oldDelegate.pulseValue != pulseValue || oldDelegate.selectedNode != selectedNode;
  }
}
