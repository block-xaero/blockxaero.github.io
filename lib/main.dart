import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math' as math;
import 'dart:html' as html;

void main() {
  runApp(const CyanWebsite());
}

// =============================================================================
// MONOKAI THEME
// =============================================================================

class Monokai {
  static const Color background = Color(0xFF272822);
  static const Color surface = Color(0xFF3E3D32);
  static const Color foreground = Color(0xFFF8F8F2);
  static const Color foregroundSecondary = Color(0xFFCFCFC2);
  static const Color comment = Color(0xFF75715E);
  static const Color divider = Color(0xFF4A4A40);
  
  static const Color green = Color(0xFFA6E22E);
  static const Color cyan = Color(0xFF66D9EF);
  static const Color purple = Color(0xFFAE81FF);
  static const Color orange = Color(0xFFFD971F);
  
  static const Color darkBg = Color(0xFF0d0d0a);
}

// =============================================================================
// PLATFORM DETECTION
// =============================================================================

enum AppPlatform { macOS, windows, linux, iOS, android, unknown }

AppPlatform detectPlatform() {
  final userAgent = html.window.navigator.userAgent.toLowerCase();
  final platform = html.window.navigator.platform?.toLowerCase() ?? '';
  
  if (platform.contains('mac') || userAgent.contains('macintosh')) {
    return AppPlatform.macOS;
  } else if (platform.contains('win') || userAgent.contains('windows')) {
    return AppPlatform.windows;
  } else if (userAgent.contains('linux') && !userAgent.contains('android')) {
    return AppPlatform.linux;
  } else if (userAgent.contains('iphone') || userAgent.contains('ipad')) {
    return AppPlatform.iOS;
  } else if (userAgent.contains('android')) {
    return AppPlatform.android;
  }
  return AppPlatform.unknown;
}

String platformName(AppPlatform p) {
  switch (p) {
    case AppPlatform.macOS: return 'macOS';
    case AppPlatform.windows: return 'Windows';
    case AppPlatform.linux: return 'Linux';
    case AppPlatform.iOS: return 'iOS';
    case AppPlatform.android: return 'Android';
    default: return 'Your Platform';
  }
}

IconData platformIcon(AppPlatform p) {
  switch (p) {
    case AppPlatform.macOS: return Icons.laptop_mac;
    case AppPlatform.windows: return Icons.laptop_windows;
    case AppPlatform.linux: return Icons.computer;
    case AppPlatform.iOS: return Icons.phone_iphone;
    case AppPlatform.android: return Icons.phone_android;
    default: return Icons.devices;
  }
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
      theme: ThemeData(scaffoldBackgroundColor: Monokai.darkBg),
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
  late AppPlatform _platform;
  
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _platform = detectPlatform();
    
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
    setState(() => _selectedNode = _selectedNode == node ? null : node);
  }

  void _submitEmail() async {
    final email = _emailController.text.trim();
    if (email.isEmpty || !email.contains('@')) return;
    
    setState(() => _emailSubmitted = true);
    
    // POST to Buttondown
    try {
      html.HttpRequest.postFormData(
        'https://buttondown.com/api/emails/embed-subscribe/blockxaero',
        {'email': email},
      );
    } catch (e) {
      // Silently fail - user already sees success message
      // Buttondown will handle duplicates gracefully
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width >= 1000;
    final isTablet = size.width >= 700 && size.width < 1000;
    
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.2,
            colors: [Color(0xFF1a1815), Monokai.darkBg],
          ),
        ),
        child: SafeArea(
          child: isDesktop 
              ? _buildDesktopLayout(size)
              : isTablet
                  ? _buildTabletLayout(size)
                  : _buildMobileLayout(size),
        ),
      ),
    );
  }

  // ===========================================================================
  // DESKTOP LAYOUT
  // ===========================================================================

  Widget _buildDesktopLayout(Size size) {
    // Use more of the screen - 65% of height for constellation
    final constellationSize = (size.height * 0.65).clamp(350.0, 520.0);
    
    return Column(
      children: [
        _buildNavbar(),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Row(
              children: [
                // Left - Constellation (bigger)
                Expanded(
                  flex: 6,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildTitle(size: 48),
                      const SizedBox(height: 20),
                      _buildConstellation(constellationSize),
                    ],
                  ),
                ),
                const SizedBox(width: 24),
                // Right - Content Panel
                Expanded(
                  flex: 5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildContentArea(maxWidth: 480),
                      const SizedBox(height: 24),
                      _buildDownloadAndSignup(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        _buildFooter(),
      ],
    );
  }

  // ===========================================================================
  // TABLET LAYOUT
  // ===========================================================================

  Widget _buildTabletLayout(Size size) {
    final constellationSize = (size.height * 0.38).clamp(220.0, 300.0);
    
    return Column(
      children: [
        _buildNavbar(),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              children: [
                const SizedBox(height: 20),
                _buildTitle(size: 32),
                const SizedBox(height: 24),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildConstellation(constellationSize),
                    const SizedBox(width: 24),
                    Expanded(child: _buildContentArea(maxWidth: 350)),
                  ],
                ),
                const SizedBox(height: 24),
                _buildDownloadAndSignup(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
        _buildFooter(),
      ],
    );
  }

  // ===========================================================================
  // MOBILE LAYOUT
  // ===========================================================================

  Widget _buildMobileLayout(Size size) {
    final constellationSize = (size.width * 0.78).clamp(250.0, 340.0);
    
    return Column(
      children: [
        _buildNavbar(),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(height: 16),
                _buildTitle(size: 28),
                const SizedBox(height: 20),
                _buildConstellation(constellationSize),
                const SizedBox(height: 20),
                _buildContentArea(maxWidth: double.infinity),
                const SizedBox(height: 24),
                _buildDownloadAndSignup(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
        _buildFooter(),
      ],
    );
  }

  // ===========================================================================
  // SHARED COMPONENTS
  // ===========================================================================

  Widget _buildNavbar() {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Image.asset('assets/cyan-wordmark.png', height: 24, filterQuality: FilterQuality.high),
          const Spacer(),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () async {
                final uri = Uri.parse('mailto:anirudh.vyas@blockxaero.io?subject=Cyan Demo Request');
                if (await canLaunchUrl(uri)) await launchUrl(uri);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                decoration: BoxDecoration(
                  border: Border.all(color: Monokai.cyan.withOpacity(0.6)),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'Request Demo',
                  style: GoogleFonts.jetBrainsMono(color: Monokai.cyan, fontSize: 12, fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitle({required double size}) {
    return Column(
      children: [
        Text(
          'Cyan',
          style: GoogleFonts.jetBrainsMono(
            fontSize: size,
            fontWeight: FontWeight.w700,
            color: Monokai.cyan,
            letterSpacing: 4,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Intelligent Collaboration Workspace',
          textAlign: TextAlign.center,
          style: GoogleFonts.jetBrainsMono(fontSize: size * 0.34, color: Monokai.foregroundSecondary),
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        '© 2026 Cyan • 21-day free trial',
        style: GoogleFonts.jetBrainsMono(color: Monokai.comment, fontSize: 10),
      ),
    );
  }

  // ===========================================================================
  // CONSTELLATION
  // ===========================================================================

  Widget _buildConstellation(double size) {
    return SizedBox(
      width: size,
      height: size,
      child: AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (context, _) {
          return CustomPaint(
            painter: ConstellationPainter(pulseValue: _pulseAnimation.value),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                _buildCenterNode(size),
                _buildOuterNode(size: size, angle: -90, dist: 0.40, label: 'Collab', icon: Icons.people_outline, color: Monokai.green, id: 'collab'),
                _buildOuterNode(size: size, angle: 210, dist: 0.40, label: 'Workspace', icon: Icons.dashboard_outlined, color: Monokai.purple, id: 'workspace'),
                _buildOuterNode(size: size, angle: -30, dist: 0.40, label: 'P2P', icon: Icons.hub_outlined, color: Monokai.orange, id: 'p2p'),
                _buildOuterNode(size: size, angle: 90, dist: 0.45, label: 'Lens AI', icon: Icons.auto_awesome, color: Monokai.cyan, id: 'lens'),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCenterNode(double size) {
    final r = size * 0.14; // Slightly bigger center
    return Positioned(
      left: (size - r) / 2,
      top: (size - r) / 2,
      child: AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (context, _) {
          return Transform.scale(
            scale: _pulseAnimation.value,
            child: Container(
              width: r,
              height: r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const RadialGradient(colors: [Monokai.cyan, Color(0xFF2a8a9a)]),
                boxShadow: [BoxShadow(color: Monokai.cyan.withOpacity(0.6), blurRadius: 24, spreadRadius: 4)],
              ),
              child: Center(
                child: Container(
                  width: r * 0.35,
                  height: r * 0.35,
                  decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildOuterNode({
    required double size,
    required double angle,
    required double dist,
    required String label,
    required IconData icon,
    required Color color,
    required String id,
  }) {
    final rad = angle * (math.pi / 180);
    final cx = size / 2, cy = size / 2;
    final d = size * dist;
    final x = cx + d * math.cos(rad);
    final y = cy + d * math.sin(rad);
    final isSelected = _selectedNode == id;
    final nodeR = size * 0.26; // Bigger nodes

    return Positioned(
      left: x - nodeR / 2,
      top: y - nodeR / 2,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () => _selectNode(id),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: nodeR,
            height: nodeR,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? color.withOpacity(0.2) : Monokai.surface.withOpacity(0.9),
              border: Border.all(color: isSelected ? color : color.withOpacity(0.5), width: isSelected ? 2.5 : 1.5),
              boxShadow: isSelected ? [BoxShadow(color: color.withOpacity(0.5), blurRadius: 20)] : null,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: color, size: nodeR * 0.32),
                SizedBox(height: nodeR * 0.06),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.visible,
                  softWrap: false,
                  style: GoogleFonts.jetBrainsMono(color: Monokai.foreground, fontSize: nodeR * 0.14, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // CONTENT AREA
  // ===========================================================================

  Widget _buildContentArea({required double maxWidth}) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      child: _selectedNode != null
          ? _buildContentPanel(_selectedNode!, maxWidth)
          : _buildDefaultPanel(maxWidth),
    );
  }

  Widget _buildDefaultPanel(double maxWidth) {
    return Container(
      key: const ValueKey('default'),
      constraints: BoxConstraints(maxWidth: maxWidth),
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Monokai.surface.withOpacity(0.4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Monokai.divider),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Intelligent Collaboration Workspace',
            style: GoogleFonts.jetBrainsMono(color: Monokai.foreground, fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          Text(
            '"What\'s blocking the release?" — your answer is scattered across Slack, Jira, GitHub, and docs. Cyan connects everything into one workspace with AI that reasons across it all.',
            style: GoogleFonts.jetBrainsMono(color: Monokai.foregroundSecondary, fontSize: 12, height: 1.6),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildTagChip('P2P Sync', Monokai.green),
              _buildTagChip('Knowledge Graph', Monokai.purple),
              _buildTagChip('AI Reasoning', Monokai.cyan),
              _buildTagChip('E2E Encrypted', Monokai.orange),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(Icons.touch_app_rounded, color: Monokai.comment, size: 14),
              const SizedBox(width: 6),
              Text(
                'Tap a node to explore',
                style: GoogleFonts.jetBrainsMono(color: Monokai.comment, fontSize: 10),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTagChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: GoogleFonts.jetBrainsMono(color: color, fontSize: 10, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildContentPanel(String id, double maxWidth) {
    final d = _nodeData(id);
    return Container(
      key: ValueKey(id),
      constraints: BoxConstraints(maxWidth: maxWidth),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Monokai.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: (d['color'] as Color).withOpacity(0.5)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(width: 4, height: 22, decoration: BoxDecoration(color: d['color'], borderRadius: BorderRadius.circular(2))),
              const SizedBox(width: 12),
              Expanded(
                child: Text(d['title'], style: GoogleFonts.jetBrainsMono(color: Monokai.foreground, fontSize: 17, fontWeight: FontWeight.w600)),
              ),
              GestureDetector(
                onTap: () => _selectNode(null),
                child: const Icon(Icons.close, color: Monokai.comment, size: 20),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(d['desc'], style: GoogleFonts.jetBrainsMono(color: Monokai.foregroundSecondary, fontSize: 13, height: 1.5)),
          const SizedBox(height: 16),
          ...(d['features'] as List<String>).map((f) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.check_rounded, color: d['color'], size: 16),
                const SizedBox(width: 10),
                Expanded(child: Text(f, style: GoogleFonts.jetBrainsMono(color: Monokai.foreground, fontSize: 12, height: 1.4))),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Map<String, dynamic> _nodeData(String id) {
    final data = {
      'collab': {
        'color': Monokai.green,
        'title': 'Real-time P2P Collaboration',
        'desc': 'Direct peer-to-peer sync via QUIC. Changes propagate at WiFi speed — 100x faster than cloud round-trips. No server in the middle.',
        'features': [
          'Live cursors & presence awareness',
          'Offline-first — works without internet',
          'Conflict-free sync when reconnected',
          'End-to-end encrypted, always',
        ],
      },
      'workspace': {
        'color': Monokai.purple,
        'title': 'Unified Workspace',
        'desc': 'Slack + Confluence + JupyterHub in one place. Boards contain everything your team needs — no more tool-switching.',
        'features': [
          'Notes: Rich markdown with live collaboration',
          'Notebooks: Python, SQL, visualizations — executable docs',
          'Canvas: Diagrams, sketches, visual thinking',
          'Chat: Threaded conversations in context',
        ],
      },
      'p2p': {
        'color': Monokai.orange,
        'title': 'Decentralized Architecture',
        'desc': 'Built on Rust, Iroh, and Tokio. Your data never touches our servers — sovereign collaboration for teams who care about privacy.',
        'features': [
          'QUIC protocol with NAT traversal',
          'Content-addressed storage (Blake3)',
          'Merkle-tree sync for efficiency',
          'Works air-gapped or on local mesh',
        ],
      },
      'lens': {
        'color': Monokai.cyan,
        'title': 'Ask Your Workspace Anything',
        'desc': 'Cyan Lens connects your tools and builds a live knowledge graph of everything happening — conversations, tickets, PRs, docs. Then reasons across it to answer questions no single tool can.',
        'features': [
          '"What\'s blocking the release?" — traces Slack → Jira → PR → stuck review',
          '"Who owns the API decision?" — finds the thread, the people, the context',
          'Surfaces issues before you ask — stale questions, forgotten blockers',
          'One place for truth — no more tab switching to piece things together',
          'Connects Slack, Jira, GitHub, Confluence, Google Docs',
        ],
      },
    };
    return data[id] ?? {};
  }

  // ===========================================================================
  // DOWNLOAD & SIGNUP
  // ===========================================================================

  Widget _buildDownloadAndSignup() {
    return Column(
      children: [
        // Smart platform button
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: Monokai.surface,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: Monokai.cyan.withOpacity(0.4)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(platformIcon(_platform), color: Monokai.cyan, size: 20),
              const SizedBox(width: 12),
              Text(
                'Available on ${platformName(_platform)}',
                style: GoogleFonts.jetBrainsMono(color: Monokai.foreground, fontSize: 13, fontWeight: FontWeight.w500),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Monokai.orange.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'Coming Soon',
                  style: GoogleFonts.jetBrainsMono(color: Monokai.orange, fontSize: 10, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Also: macOS • Windows • Linux • iOS • Android',
          style: GoogleFonts.jetBrainsMono(color: Monokai.comment, fontSize: 10),
        ),
        const SizedBox(height: 18),
        // Email signup
        if (!_emailSubmitted)
          Container(
            constraints: const BoxConstraints(maxWidth: 320),
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
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14),
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
                      child: Text('Notify Me', style: GoogleFonts.jetBrainsMono(color: Monokai.darkBg, fontSize: 12, fontWeight: FontWeight.w600)),
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
              color: Monokai.green.withOpacity(0.15),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Monokai.green.withOpacity(0.4)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.check_circle, color: Monokai.green, size: 18),
                const SizedBox(width: 8),
                Text("You're on the list!", style: GoogleFonts.jetBrainsMono(color: Monokai.green, fontSize: 13)),
              ],
            ),
          ),
      ],
    );
  }
}

// =============================================================================
// CONSTELLATION PAINTER
// =============================================================================

class ConstellationPainter extends CustomPainter {
  final double pulseValue;
  ConstellationPainter({required this.pulseValue});

  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..color = Monokai.cyan.withOpacity(0.15)
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;

    for (final angle in [-90.0, 210.0, -30.0, 90.0]) {
      final dist = angle == 90 ? 0.45 : 0.40;
      final rad = angle * (math.pi / 180);
      final p = c + Offset(size.width * dist * math.cos(rad), size.width * dist * math.sin(rad));
      canvas.drawLine(c, p, paint);
    }
  }

  @override
  bool shouldRepaint(ConstellationPainter old) => old.pulseValue != pulseValue;
}
