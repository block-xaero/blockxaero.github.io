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
  
  static const Color heroBackground = Color(0xFF1a1a17);
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
        colorScheme: ColorScheme.dark(
          primary: Monokai.cyan,
          secondary: Monokai.green,
          surface: Monokai.surface,
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
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);
    
    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 768;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Main hero with constellation
            _buildHeroSection(size, isMobile),
            // Expanded content based on selection
            if (_selectedNode != null) _buildExpandedContent(_selectedNode!, isMobile),
            // Footer
            _buildFooter(isMobile),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSection(Size size, bool isMobile) {
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(
        minHeight: isMobile ? size.height * 0.9 : size.height * 0.85,
      ),
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.center,
          radius: 1.2,
          colors: [
            Color(0xFF1a1a17),
            Monokai.darkBackground,
          ],
        ),
      ),
      child: Stack(
        children: [
          // Navbar
          _buildNavbar(isMobile),
          // Central content
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 60),
                // Headline
                Text(
                  'Cyan',
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: isMobile ? 28 : 36,
                    fontWeight: FontWeight.w700,
                    color: Monokai.cyan,
                    letterSpacing: 4,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Collaboration that keeps up with you',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: isMobile ? 14 : 16,
                    color: Monokai.foregroundSecondary,
                  ),
                ),
                SizedBox(height: isMobile ? 40 : 60),
                // Interactive Constellation
                _buildConstellation(isMobile),
                SizedBox(height: isMobile ? 40 : 50),
                // Download + signup (compact)
                _buildDownloadSection(isMobile),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavbar(bool isMobile) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        height: 56,
        padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 40),
        child: Row(
          children: [
            // Logo
            Image.asset(
              'assets/cyan-wordmark.png',
              height: 24,
              filterQuality: FilterQuality.high,
            ),
            const Spacer(),
            _buildRequestDemoButton(),
          ],
        ),
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
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          decoration: BoxDecoration(
            border: Border.all(color: Monokai.cyan.withOpacity(0.5)),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            'Request Demo',
            style: GoogleFonts.jetBrainsMono(
              color: Monokai.cyan,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // INTERACTIVE CONSTELLATION
  // ===========================================================================

  Widget _buildConstellation(bool isMobile) {
    final nodeSize = isMobile ? 260.0 : 340.0;
    
    return SizedBox(
      width: nodeSize,
      height: nodeSize,
      child: AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (context, child) {
          return CustomPaint(
            painter: ConstellationBackgroundPainter(
              pulseValue: _pulseAnimation.value,
              selectedNode: _selectedNode,
            ),
            child: Stack(
              children: [
                // Center node - Cyan core
                _buildCenterNode(nodeSize),
                // Top node - Collaboration
                _buildOuterNode(
                  nodeSize: nodeSize,
                  angle: -90,
                  distance: nodeSize * 0.38,
                  label: 'Collaboration',
                  sublabel: 'Real-time teamwork',
                  icon: Icons.people_outline,
                  color: Monokai.green,
                  nodeId: 'collaboration',
                ),
                // Bottom-left node - Workspaces
                _buildOuterNode(
                  nodeSize: nodeSize,
                  angle: 150,
                  distance: nodeSize * 0.38,
                  label: 'Workspaces',
                  sublabel: 'Notes • Canvas • Chat',
                  icon: Icons.dashboard_outlined,
                  color: Monokai.purple,
                  nodeId: 'workspaces',
                ),
                // Bottom-right node - P2P
                _buildOuterNode(
                  nodeSize: nodeSize,
                  angle: 30,
                  distance: nodeSize * 0.38,
                  label: 'Peer-to-Peer',
                  sublabel: 'Fast • Private • Secure',
                  icon: Icons.hub_outlined,
                  color: Monokai.orange,
                  nodeId: 'p2p',
                ),
                // Bottom center - Lens AI
                _buildOuterNode(
                  nodeSize: nodeSize,
                  angle: 90,
                  distance: nodeSize * 0.42,
                  label: 'Lens AI',
                  sublabel: 'Your AI assistant',
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
    final size = nodeSize * 0.22;
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
                gradient: RadialGradient(
                  colors: [
                    Monokai.cyan,
                    Monokai.cyan.withOpacity(0.6),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Monokai.cyan.withOpacity(0.4),
                    blurRadius: 30,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Center(
                child: Container(
                  width: size * 0.4,
                  height: size * 0.4,
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
    required String sublabel,
    required IconData icon,
    required Color color,
    required String nodeId,
  }) {
    final radians = angle * (math.pi / 180);
    final centerX = nodeSize / 2;
    final centerY = nodeSize / 2;
    final x = centerX + distance * math.cos(radians);
    final y = centerY + distance * math.sin(radians);
    
    final isSelected = _selectedNode == nodeId;
    final nodeWidth = nodeSize * 0.28;

    return Positioned(
      left: x - nodeWidth / 2,
      top: y - nodeWidth / 2,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () => _selectNode(nodeId),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: nodeWidth,
            height: nodeWidth,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? color.withOpacity(0.25) : Monokai.surface.withOpacity(0.8),
              border: Border.all(
                color: isSelected ? color : color.withOpacity(0.4),
                width: isSelected ? 2 : 1,
              ),
              boxShadow: isSelected
                  ? [BoxShadow(color: color.withOpacity(0.3), blurRadius: 20)]
                  : null,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: color, size: nodeWidth * 0.28),
                SizedBox(height: nodeWidth * 0.06),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.jetBrainsMono(
                    color: Monokai.foreground,
                    fontSize: nodeWidth * 0.11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (nodeWidth > 70) ...[
                  SizedBox(height: nodeWidth * 0.02),
                  Text(
                    sublabel,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.jetBrainsMono(
                      color: Monokai.comment,
                      fontSize: nodeWidth * 0.08,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // DOWNLOAD SECTION (COMPACT)
  // ===========================================================================

  Widget _buildDownloadSection(bool isMobile) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 24 : 40),
      child: Column(
        children: [
          // Download buttons
          Wrap(
            spacing: 12,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: [
              _buildDownloadButton(Icons.laptop_mac, 'macOS'),
              _buildDownloadButton(Icons.laptop_windows, 'Windows'),
            ],
          ),
          const SizedBox(height: 24),
          // Email signup
          if (!_emailSubmitted)
            Container(
              constraints: const BoxConstraints(maxWidth: 360),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: Monokai.surface,
                        borderRadius: const BorderRadius.horizontal(left: Radius.circular(4)),
                        border: Border.all(color: Monokai.divider),
                      ),
                      child: TextField(
                        controller: _emailController,
                        style: GoogleFonts.jetBrainsMono(color: Monokai.foreground, fontSize: 13),
                        decoration: InputDecoration(
                          hintText: 'you@company.com',
                          hintStyle: GoogleFonts.jetBrainsMono(color: Monokai.comment, fontSize: 13),
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
                      height: 40,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: const BoxDecoration(
                        color: Monokai.cyan,
                        borderRadius: BorderRadius.horizontal(right: Radius.circular(4)),
                      ),
                      child: Center(
                        child: Text(
                          'Notify Me',
                          style: GoogleFonts.jetBrainsMono(
                            color: Monokai.darkBackground,
                            fontSize: 12,
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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: Monokai.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Monokai.green.withOpacity(0.3)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_circle, color: Monokai.green, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    "You're on the list!",
                    style: GoogleFonts.jetBrainsMono(color: Monokai.green, fontSize: 13),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDownloadButton(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Monokai.surface,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Monokai.divider),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Monokai.foreground, size: 18),
          const SizedBox(width: 10),
          Text(
            label,
            style: GoogleFonts.jetBrainsMono(color: Monokai.foreground, fontSize: 13),
          ),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Monokai.orange.withOpacity(0.2),
              borderRadius: BorderRadius.circular(3),
            ),
            child: Text(
              'Soon',
              style: GoogleFonts.jetBrainsMono(
                color: Monokai.orange,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _submitEmail() {
    if (_emailController.text.isNotEmpty && _emailController.text.contains('@')) {
      setState(() => _emailSubmitted = true);
    }
  }

  // ===========================================================================
  // EXPANDED CONTENT
  // ===========================================================================

  Widget _buildExpandedContent(String nodeId, bool isMobile) {
    Widget content;
    
    switch (nodeId) {
      case 'collaboration':
        content = _buildCollaborationContent(isMobile);
        break;
      case 'workspaces':
        content = _buildWorkspacesContent(isMobile);
        break;
      case 'p2p':
        content = _buildP2PContent(isMobile);
        break;
      case 'lens':
        content = _buildLensContent(isMobile);
        break;
      default:
        content = const SizedBox();
    }

    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(isMobile ? 24 : 48),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: content,
          ),
        ),
      ),
    );
  }

  Widget _buildCollaborationContent(bool isMobile) {
    return _buildContentCard(
      color: Monokai.green,
      title: 'Real-time Collaboration',
      description: 'Work together seamlessly. Every change syncs instantly across your team — no refresh needed, no conflicts.',
      features: [
        'See teammates\' cursors and selections live',
        'Comments and threads in context',
        'Presence indicators show who\'s online',
        'Works offline, syncs when reconnected',
      ],
    );
  }

  Widget _buildWorkspacesContent(bool isMobile) {
    return _buildContentCard(
      color: Monokai.purple,
      title: 'Unified Workspaces',
      description: 'Notes, notebooks, canvas, and chat — all in one place. Stop switching between tools.',
      features: [
        'Notes: Rich documents with markdown',
        'Notebooks: Run Python, SQL, visualize data',
        'Canvas: Diagrams, sketches, visual thinking',
        'Chat: Conversations where the work happens',
      ],
    );
  }

  Widget _buildP2PContent(bool isMobile) {
    return _buildContentCard(
      color: Monokai.orange,
      title: 'Peer-to-Peer Architecture',
      description: 'Your data flows directly between team members. No cloud servers storing your work.',
      features: [
        'Direct sync via QUIC protocol',
        'End-to-end encryption by default',
        'Faster than traditional cloud apps',
        'Built on Rust, Iroh, and Tokio',
      ],
    );
  }

  Widget _buildLensContent(bool isMobile) {
    return _buildContentCard(
      color: Monokai.cyan,
      title: 'Cyan Lens AI',
      description: 'Your intelligent workspace assistant. Surfaces what matters without you digging.',
      features: [
        'Asks: Questions waiting for answers',
        'Decisions: Choices made and pending',
        'Nudges: What needs your attention',
        'Pulse: Your team\'s activity summary',
      ],
    );
  }

  Widget _buildContentCard({
    required Color color,
    required String title,
    required String description,
    required List<String> features,
  }) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Monokai.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 24,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: GoogleFonts.jetBrainsMono(
                  color: Monokai.foreground,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            description,
            style: GoogleFonts.jetBrainsMono(
              color: Monokai.foregroundSecondary,
              fontSize: 14,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 20),
          ...features.map((f) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.check, color: color, size: 18),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    f,
                    style: GoogleFonts.jetBrainsMono(
                      color: Monokai.foreground,
                      fontSize: 13,
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

  // ===========================================================================
  // FOOTER
  // ===========================================================================

  Widget _buildFooter(bool isMobile) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 48,
        vertical: 32,
      ),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Monokai.divider)),
      ),
      child: Column(
        children: [
          Wrap(
            spacing: 24,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: [
              _footerLink('Request Demo'),
              _footerLink('Privacy'),
              _footerLink('Twitter'),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            '© 2026 Cyan • 21-day free trial',
            style: GoogleFonts.jetBrainsMono(
              color: Monokai.comment,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _footerLink(String text) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Text(
        text,
        style: GoogleFonts.jetBrainsMono(
          color: Monokai.foregroundSecondary,
          fontSize: 12,
        ),
      ),
    );
  }
}

// =============================================================================
// CONSTELLATION BACKGROUND PAINTER
// =============================================================================

class ConstellationBackgroundPainter extends CustomPainter {
  final double pulseValue;
  final String? selectedNode;

  ConstellationBackgroundPainter({required this.pulseValue, this.selectedNode});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final distance = size.width * 0.38;
    
    // Calculate node positions
    final topAngle = -90 * (math.pi / 180);
    final bottomLeftAngle = 150 * (math.pi / 180);
    final bottomRightAngle = 30 * (math.pi / 180);
    final bottomAngle = 90 * (math.pi / 180);
    
    final top = center + Offset(distance * math.cos(topAngle), distance * math.sin(topAngle));
    final bottomLeft = center + Offset(distance * math.cos(bottomLeftAngle), distance * math.sin(bottomLeftAngle));
    final bottomRight = center + Offset(distance * math.cos(bottomRightAngle), distance * math.sin(bottomRightAngle));
    final bottom = center + Offset(size.width * 0.42 * math.cos(bottomAngle), size.width * 0.42 * math.sin(bottomAngle));

    final linePaint = Paint()
      ..color = Monokai.cyan.withOpacity(0.15)
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;

    // Draw lines from center to each node
    canvas.drawLine(center, top, linePaint);
    canvas.drawLine(center, bottomLeft, linePaint);
    canvas.drawLine(center, bottomRight, linePaint);
    canvas.drawLine(center, bottom, linePaint);
  }

  @override
  bool shouldRepaint(ConstellationBackgroundPainter oldDelegate) {
    return oldDelegate.pulseValue != pulseValue || oldDelegate.selectedNode != selectedNode;
  }
}
