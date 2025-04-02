// main.dart - Entry point of the application
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

void main() {
  runApp(const BlockXaeroApp());
}

class BlockXaeroApp extends StatelessWidget {
  const BlockXaeroApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Block-Xaero',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121212),
        textTheme: Theme.of(context).textTheme.apply(
              bodyColor: Colors.white,
              displayColor: Colors.white,
            ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final ScrollController _scrollController = ScrollController();

  final List<Widget> _pages = [
    const OverviewPage(),
    const ProjectPage(
      title: 'ZeroID',
      description:
          'A decentralized identity solution using did:peer with ZK proofs.',
      technologies: ['did:peer', 'ZK Proofs', 'OneChain', 'Merkle Trees'],
      features: [
        'Decentralized identity verification',
        'On-chain custom blockchain integration',
        'Merkle root and XOR\'d cumulative hash of leaves',
        'NFT support (on-chain with off-chain data)',
        'Privacy-preserving identity verification',
        'Seamless integration with OneChain',
      ],
      architectureComponents: [
        'Identity Protocol - Core DID implementation using did:peer standard',
        'ZK Proof System - Generates and verifies zero-knowledge proofs',
        'Merkle Tree Implementation - Structures identity data securely',
        'Blockchain Interface - Connects to OneChain for persistence',
        'NFT Module - Manages NFT issuance and verification',
        'Cryptographic Engine - Handles all encryption and signature operations',
      ],
      imagePath: 'zeroid_architecture',
      githubUrl: 'https://github.com/block-xaero/zeroid',
    ),
    const ProjectPage(
      title: 'OneChain',
      description:
          'A custom blockchain built specifically for ZeroID and integrated with XaeroFlux.',
      technologies: [
        'Blockchain',
        'ZK Proofs',
        'Merkle Trees',
        'NFTs',
        'XaeroFlux',
        'Consensus Algorithms'
      ],
      features: [
        'Custom blockchain optimized for identity verification',
        'Native support for ZK proofs',
        'NFT capabilities with off-chain data storage',
        'Integration with XaeroFlux for data syncing',
        'Specialized consensus for identity and storage operations',
        'Low latency transaction processing for identity verification',
        'Efficient proof storage and retrieval',
      ],
      architectureComponents: [
        'Consensus Mechanism - Ensures network agreement on state',
        'Block Structure - Specialized for identity and ZK proof storage',
        'Smart Contract System - Handles identity verification operations',
        'NFT Registry - Manages on-chain NFT metadata and references',
        'Cross-Chain Bridge - Facilitates interaction with other blockchains',
        'Validator Network - Provides distributed validation of proofs',
        'Merkle Root Registry - Maintains history of state changes',
      ],
      imagePath: 'onechain_architecture',
      githubUrl: 'https://github.com/block-xaero/onechain',
    ),
    const ProjectPage(
      title: 'XaeroFlux',
      description:
          'P2P decentralized, cloudless storage engine for event-based data synchronization.',
      technologies: [
        'P2P',
        'RocksDB',
        'Merkle Trees',
        'Rust',
        'Cross-beam Channels',
        'ZK Proofs',
        'Content-Addressable Storage'
      ],
      features: [
        'Decentralized, cloudless storage',
        'Event-based data processing via cross-beam channels',
        'Social network event support (posts, comments, likes, etc.)',
        'Hybrid synchronization technique using merkle roots',
        'Efficient difference detection using XOR hashing',
        'Fully peer-to-peer architecture with no central servers',
        'Privacy-preserving content sharing with encrypted data',
        'Content deduplication using content addressing',
        'Resilient to network partitions and disruptions',
      ],
      architectureComponents: [
        'Event Processor - Handles and decodes raw events',
        'Merkle Index Builder - Creates and maintains merkle trees of data',
        'RocksDB Storage - Persistent storage with specialized column families',
        'Sync Engine - Efficiently synchronizes data between peers',
        'Verification System - Validates data integrity using ZeroID proofs',
        'P2P Network Layer - Manages peer discovery and connections',
        'Content Router - Directs content requests to appropriate peers',
        'Compression Engine - Optimizes storage and transfer efficiency',
        'Event Stream - Manages real-time event processing and notification',
      ],
      imagePath: 'xaeroflux_architecture',
      githubUrl: 'https://github.com/block-xaero/xaeroflux',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Side Navigation
          NavigationRail(
            extended: MediaQuery.of(context).size.width > 800,
            minExtendedWidth: 200,
            backgroundColor: const Color(0xFF1E1E1E),
            selectedIndex: _selectedIndex,
            onDestinationSelected: (int index) {
              setState(() {
                _selectedIndex = index;
              });
              _scrollController.jumpTo(0);
            },
            destinations: const <NavigationRailDestination>[
              NavigationRailDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home),
                label: Text('Overview'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.fingerprint_outlined),
                selectedIcon: Icon(Icons.fingerprint),
                label: Text('ZeroID'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.link_outlined),
                selectedIcon: Icon(Icons.link),
                label: Text('OneChain'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.storage_outlined),
                selectedIcon: Icon(Icons.storage),
                label: Text('XaeroFlux'),
              ),
            ],
          ),
          // Main Content
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF121212),
                border: Border(
                  left: BorderSide(
                    color: Colors.grey.shade800,
                    width: 1,
                  ),
                ),
              ),
              child: Column(
                children: [
                  // AppBar
                  Container(
                    height: 60,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1E1E),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 16.0),
                          child: Row(
                            children: [
                              Icon(
                                Icons.block,
                                color: Colors.blueAccent,
                                size: 24,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'block-xaero',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.code),
                            label: const Text('GitHub'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent,
                              foregroundColor: Colors.white,
                            ),
                            onPressed: () async {
                              final Uri url =
                                  Uri.parse('https://github.com/block-xaero');
                              if (await canLaunchUrl(url)) {
                                await launchUrl(url);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Page Content
                  Expanded(
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(16.0),
                      child: _pages[_selectedIndex],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OverviewPage extends StatelessWidget {
  const OverviewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Hero Section
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 60.0, horizontal: 24.0),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A2E),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              const Icon(
                Icons.block,
                color: Colors.blueAccent,
                size: 72,
              ),
              const SizedBox(height: 24),
              const Text(
                'block-xaero',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 50,
                child: DefaultTextStyle(
                  style: const TextStyle(
                    fontSize: 20.0,
                    color: Colors.white70,
                  ),
                  child: AnimatedTextKit(
                    animatedTexts: [
                      TypewriterAnimatedText(
                        'Decentralized Identity',
                        speed: const Duration(milliseconds: 100),
                      ),
                      TypewriterAnimatedText(
                        'Custom Blockchain',
                        speed: const Duration(milliseconds: 100),
                      ),
                      TypewriterAnimatedText(
                        'P2P Storage Engine',
                        speed: const Duration(milliseconds: 100),
                      ),
                    ],
                    repeatForever: true,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'A suite of decentralized technologies for identity, storage, and blockchain',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 48),

        // Project Overview Section
        Text(
          'Our Projects',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 24),

        // Project Cards
        GridView.count(
          crossAxisCount: MediaQuery.of(context).size.width > 1000 ? 3 : 1,
          childAspectRatio: 0.8,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _buildProjectCard(
              context,
              title: 'ZeroID',
              description:
                  'Decentralized identity solution using did:peer + ZK proofs',
              icon: Icons.fingerprint,
              color: Colors.purpleAccent,
              index: 1,
            ),
            _buildProjectCard(
              context,
              title: 'OneChain',
              description: 'Custom blockchain for ZK proofs, NFTs and identity',
              icon: Icons.link,
              color: Colors.greenAccent,
              index: 2,
            ),
            _buildProjectCard(
              context,
              title: 'XaeroFlux',
              description: 'P2P decentralized, cloudless storage engine',
              icon: Icons.storage,
              color: Colors.orangeAccent,
              index: 3,
            ),
          ],
        ),

        const SizedBox(height: 48),

        // Architecture Overview
        Text(
          'System Architecture',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 24),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24.0),
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E1E),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'How the Projects Interconnect',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              Container(
                  height: 300,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(16),
                  )),
              const SizedBox(height: 24),
              const Text(
                'The block-xaero ecosystem consists of three main components that work together to provide a complete decentralized solution:',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 16),
              const _BulletPoint(
                text:
                    'ZeroID provides decentralized identity using did:peer standard and ZK proofs',
              ),
              const SizedBox(height: 8),
              const _BulletPoint(
                text:
                    'OneChain stores ZK proofs, NFTs, and identity data on a custom blockchain',
              ),
              const SizedBox(height: 8),
              const _BulletPoint(
                text:
                    'XaeroFlux enables P2P data synchronization and storage using Merkle trees',
              ),
            ],
          ),
        ),

        const SizedBox(height: 48),

        // Technical Features
        Text(
          'Key Technical Features',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 24),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            _buildFeatureCard(
              title: 'Merkle Trees',
              description:
                  'Efficient data verification and synchronization using Merkle roots and proofs',
              icon: Icons.account_tree,
            ),
            _buildFeatureCard(
              title: 'ZK Proofs',
              description:
                  'Privacy-preserving verification without revealing underlying data',
              icon: Icons.lock,
            ),
            _buildFeatureCard(
              title: 'P2P Networking',
              description:
                  'Fully decentralized communication without reliance on central servers',
              icon: Icons.device_hub,
            ),
            _buildFeatureCard(
              title: 'Hybrid Sync',
              description:
                  'Efficient data synchronization using Merkle roots and XOR hashing',
              icon: Icons.sync,
            ),
          ],
        ),

        const SizedBox(height: 64),

        // Footer
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24.0),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A2E),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              const Text(
                '© 2025 block-xaero',
                style: TextStyle(
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.code),
                    color: Colors.white70,
                    onPressed: () async {
                      final Uri url =
                          Uri.parse('https://github.com/block-xaero');
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url);
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProjectCard(BuildContext context,
      {required String title,
      required String description,
      required IconData icon,
      required Color color,
      required int index}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: const Color(0xFF1E1E1E),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          // Update the selected index in parent widget
          final homePageState =
              context.findAncestorStateOfType<_HomePageState>();
          if (homePageState != null) {
            homePageState.setState(() {
              homePageState._selectedIndex = index;
            });
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                icon,
                size: 48,
                color: color,
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 16,
                ),
              ),
              const Spacer(),
              Align(
                alignment: Alignment.centerRight,
                child: Icon(
                  Icons.arrow_forward,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard({
    required String title,
    required String description,
    required IconData icon,
  }) {
    return Container(
      width: 270,
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 36,
            color: Colors.blueAccent,
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

class ProjectPage extends StatelessWidget {
  final String title;
  final String description;
  final List<String> technologies;
  final List<String> features;
  final List<String> architectureComponents;
  final String imagePath;
  final String? githubUrl;

  const ProjectPage({
    Key? key,
    required this.title,
    required this.description,
    required this.technologies,
    required this.features,
    required this.architectureComponents,
    required this.imagePath,
    this.githubUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Project Header
        Text(
          title,
          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        Text(
          description,
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 24),

        // Technologies
        _buildSection(
          context: context,
          title: 'Technologies',
          content: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: technologies
                .map((tech) => Chip(
                      label: Text(tech),
                      backgroundColor: Colors.blueAccent.withOpacity(0.2),
                      labelStyle: const TextStyle(color: Colors.white),
                    ))
                .toList(),
          ),
        ),

        // Architecture Diagram
        _buildSection(
          context: context,
          title: 'Architecture',
          content: Container(
            height: 400,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.architecture,
                    size: 64,
                    color: Colors.blueAccent,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '$title Architecture Diagram',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Key Features
        _buildSection(
          context: context,
          title: 'Key Features',
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: features
                .map((feature) => Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: _BulletPoint(text: feature),
                    ))
                .toList(),
          ),
        ),

        // Architecture Components
        _buildSection(
          context: context,
          title: 'Architecture Components',
          content: Column(
            children: architectureComponents.map((component) {
              final parts = component.split(' - ');
              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      parts[0],
                      style: const TextStyle(
                        color: Colors.blueAccent,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      parts[1],
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),

        // GitHub CTA
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24.0),
          margin: const EdgeInsets.symmetric(vertical: 32.0),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A2E),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              const Text(
                'Explore the Code',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                icon: const Icon(Icons.code),
                label: Text('View $title on GitHub'),
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                ),
                onPressed: () async {
                  final Uri url = githubUrl != null
                      ? Uri.parse(githubUrl!)
                      : Uri.parse(
                          'https://github.com/block-xaero/${title.toLowerCase()}');
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url);
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSection({
    required BuildContext context,
    required String title,
    required Widget content,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          content,
        ],
      ),
    );
  }
}

class _BulletPoint extends StatelessWidget {
  final String text;

  const _BulletPoint({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '• ',
          style: TextStyle(
            color: Colors.blueAccent,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }
}

// pubspec.yaml content:
/*
name: block_xaero_web
description: Block-Xaero Projects Showcase

publish_to: 'none'

version: 1.0.0+1

environment:
  sdk: ">=2.17.0 <3.0.0"

dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.2
  url_launcher: ^6.1.6
  google_fonts: ^3.0.1
  flutter_svg: ^1.1.5
  animated_text_kit: ^4.2.2

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^2.0.0

flutter:
  uses-material-design: true
  assets:
    - assets/
*/
