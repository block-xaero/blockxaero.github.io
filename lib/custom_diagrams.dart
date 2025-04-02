// custom_diagrams.dart
import 'package:flutter/material.dart';

// ZeroID Architecture Diagram
class ZeroIDArchitectureDiagram extends StatelessWidget {
  const ZeroIDArchitectureDiagram({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      child: CustomPaint(
        painter: ZeroIDDiagramPainter(),
        size: const Size(double.infinity, 400),
      ),
    );
  }
}

class ZeroIDDiagramPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Set up background
    final Paint bgPaint = Paint()
      ..color = const Color(0xFF1A1A2E)
      ..style = PaintingStyle.fill;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    final Paint boxPaint = Paint()
      ..color = Colors.blueAccent.withOpacity(0.2)
      ..style = PaintingStyle.fill;

    final Paint linePaint = Paint()
      ..color = Colors.blueAccent
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final TextPainter textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    // Add title
    textPainter.text = const TextSpan(
      text: 'ZeroID Architecture',
      style: TextStyle(
          color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
    );
    textPainter.layout();
    textPainter.paint(canvas,
        Offset((size.width - textPainter.width) / 2, size.height * 0.02));

    // Draw the DID Module
    final Rect didRect = Rect.fromLTWH(size.width * 0.1, size.height * 0.1,
        size.width * 0.3, size.height * 0.2);
    canvas.drawRRect(
        RRect.fromRectAndRadius(didRect, const Radius.circular(8)), boxPaint);

    textPainter.text = const TextSpan(
      text: 'DID:Peer Module',
      style: TextStyle(
          color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
    );
    textPainter.layout();
    textPainter.paint(
        canvas,
        Offset(didRect.left + (didRect.width - textPainter.width) / 2,
            didRect.top + (didRect.height - textPainter.height) / 2));

    // Draw the ZK Proof Module
    final Rect zkRect = Rect.fromLTWH(size.width * 0.6, size.height * 0.1,
        size.width * 0.3, size.height * 0.2);
    canvas.drawRRect(
        RRect.fromRectAndRadius(zkRect, const Radius.circular(8)), boxPaint);

    textPainter.text = const TextSpan(
      text: 'ZK Proof System',
      style: TextStyle(
          color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
    );
    textPainter.layout();
    textPainter.paint(
        canvas,
        Offset(zkRect.left + (zkRect.width - textPainter.width) / 2,
            zkRect.top + (zkRect.height - textPainter.height) / 2));

    // Draw the Merkle Tree Module
    final Rect merkleRect = Rect.fromLTWH(size.width * 0.1, size.height * 0.5,
        size.width * 0.3, size.height * 0.2);
    canvas.drawRRect(
        RRect.fromRectAndRadius(merkleRect, const Radius.circular(8)),
        boxPaint);

    textPainter.text = const TextSpan(
      text: 'Merkle Tree System',
      style: TextStyle(
          color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
    );
    textPainter.layout();
    textPainter.paint(
        canvas,
        Offset(merkleRect.left + (merkleRect.width - textPainter.width) / 2,
            merkleRect.top + (merkleRect.height - textPainter.height) / 2));

    // Draw the Blockchain Interface Module
    final Rect blockchainRect = Rect.fromLTWH(size.width * 0.6,
        size.height * 0.5, size.width * 0.3, size.height * 0.2);
    canvas.drawRRect(
        RRect.fromRectAndRadius(blockchainRect, const Radius.circular(8)),
        boxPaint);

    textPainter.text = const TextSpan(
      text: 'OneChain Interface',
      style: TextStyle(
          color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
    );
    textPainter.layout();
    textPainter.paint(
        canvas,
        Offset(
            blockchainRect.left +
                (blockchainRect.width - textPainter.width) / 2,
            blockchainRect.top +
                (blockchainRect.height - textPainter.height) / 2));

    // Draw connection lines
    // DID to ZK
    canvas.drawLine(Offset(didRect.right, didRect.center.dy),
        Offset(zkRect.left, zkRect.center.dy), linePaint);

    // DID to Merkle
    canvas.drawLine(Offset(didRect.center.dx, didRect.bottom),
        Offset(didRect.center.dx, merkleRect.top), linePaint);

    // ZK to Blockchain
    canvas.drawLine(Offset(zkRect.center.dx, zkRect.bottom),
        Offset(zkRect.center.dx, blockchainRect.top), linePaint);

    // Merkle to Blockchain
    canvas.drawLine(Offset(merkleRect.right, merkleRect.center.dy),
        Offset(blockchainRect.left, blockchainRect.center.dy), linePaint);

    // Add some labels for the connections
    const TextStyle connectorStyle = TextStyle(
      color: Colors.white70,
      fontSize: 12,
    );

    // DID to ZK connection label
    textPainter.text =
        const TextSpan(text: 'Identity Verification', style: connectorStyle);
    textPainter.layout();
    textPainter.paint(
        canvas,
        Offset((didRect.right + zkRect.left) / 2 - textPainter.width / 2,
            didRect.center.dy - 20));

    // Merkle to Blockchain connection label
    textPainter.text =
        const TextSpan(text: 'Data Verification', style: connectorStyle);
    textPainter.layout();
    textPainter.paint(
        canvas,
        Offset(
            (merkleRect.right + blockchainRect.left) / 2 -
                textPainter.width / 2,
            merkleRect.center.dy - 20));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

// OneChain Architecture Diagram
class OneChainArchitectureDiagram extends StatelessWidget {
  const OneChainArchitectureDiagram({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      child: CustomPaint(
        painter: OneChainDiagramPainter(),
        size: const Size(double.infinity, 400),
      ),
    );
  }
}

class OneChainDiagramPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Set up background
    final Paint bgPaint = Paint()
      ..color = const Color(0xFF1A1A2E)
      ..style = PaintingStyle.fill;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    final Paint boxPaint = Paint()
      ..color = Colors.greenAccent.withOpacity(0.2)
      ..style = PaintingStyle.fill;

    final Paint linePaint = Paint()
      ..color = Colors.greenAccent
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final TextPainter textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    // Add title
    textPainter.text = const TextSpan(
      text: 'OneChain Architecture',
      style: TextStyle(
          color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
    );
    textPainter.layout();
    textPainter.paint(canvas,
        Offset((size.width - textPainter.width) / 2, size.height * 0.02));

    // Draw Consensus Module
    final Rect consensusRect = Rect.fromLTWH(size.width * 0.35,
        size.height * 0.15, size.width * 0.3, size.height * 0.15);
    canvas.drawRRect(
        RRect.fromRectAndRadius(consensusRect, const Radius.circular(8)),
        boxPaint);

    textPainter.text = const TextSpan(
      text: 'Consensus Mechanism',
      style: TextStyle(
          color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
    );
    textPainter.layout();
    textPainter.paint(
        canvas,
        Offset(
            consensusRect.left + (consensusRect.width - textPainter.width) / 2,
            consensusRect.top +
                (consensusRect.height - textPainter.height) / 2));

    // Draw Block Structure
    final Rect blockRect = Rect.fromLTWH(size.width * 0.1, size.height * 0.4,
        size.width * 0.25, size.height * 0.2);
    canvas.drawRRect(
        RRect.fromRectAndRadius(blockRect, const Radius.circular(8)), boxPaint);

    textPainter.text = const TextSpan(
      text: 'Block Structure',
      style: TextStyle(
          color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
    );
    textPainter.layout();
    textPainter.paint(
        canvas,
        Offset(blockRect.left + (blockRect.width - textPainter.width) / 2,
            blockRect.top + (blockRect.height - textPainter.height) / 2));

    // Draw Smart Contract System
    final Rect contractRect = Rect.fromLTWH(size.width * 0.375,
        size.height * 0.4, size.width * 0.25, size.height * 0.2);
    canvas.drawRRect(
        RRect.fromRectAndRadius(contractRect, const Radius.circular(8)),
        boxPaint);

    textPainter.text = const TextSpan(
      text: 'Smart Contract System',
      style: TextStyle(
          color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
    );
    textPainter.layout();
    textPainter.paint(
        canvas,
        Offset(contractRect.left + (contractRect.width - textPainter.width) / 2,
            contractRect.top + (contractRect.height - textPainter.height) / 2));

    // Draw NFT Registry
    final Rect nftRect = Rect.fromLTWH(size.width * 0.65, size.height * 0.4,
        size.width * 0.25, size.height * 0.2);
    canvas.drawRRect(
        RRect.fromRectAndRadius(nftRect, const Radius.circular(8)), boxPaint);

    textPainter.text = const TextSpan(
      text: 'NFT Registry',
      style: TextStyle(
          color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
    );
    textPainter.layout();
    textPainter.paint(
        canvas,
        Offset(nftRect.left + (nftRect.width - textPainter.width) / 2,
            nftRect.top + (nftRect.height - textPainter.height) / 2));

    // Draw XaeroFlux Integration
    final Rect xaeroRect = Rect.fromLTWH(size.width * 0.35, size.height * 0.7,
        size.width * 0.3, size.height * 0.15);
    canvas.drawRRect(
        RRect.fromRectAndRadius(xaeroRect, const Radius.circular(8)), boxPaint);

    textPainter.text = const TextSpan(
      text: 'XaeroFlux Integration',
      style: TextStyle(
          color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
    );
    textPainter.layout();
    textPainter.paint(
        canvas,
        Offset(xaeroRect.left + (xaeroRect.width - textPainter.width) / 2,
            xaeroRect.top + (xaeroRect.height - textPainter.height) / 2));

    // Draw connections
    // Consensus to all three modules below
    canvas.drawLine(
        Offset(consensusRect.center.dx, consensusRect.bottom),
        Offset(consensusRect.center.dx,
            consensusRect.bottom + (blockRect.top - consensusRect.bottom) / 2),
        linePaint);

    canvas.drawLine(
        Offset(consensusRect.center.dx,
            consensusRect.bottom + (blockRect.top - consensusRect.bottom) / 2),
        Offset(blockRect.center.dx,
            consensusRect.bottom + (blockRect.top - consensusRect.bottom) / 2),
        linePaint);

    canvas.drawLine(
        Offset(blockRect.center.dx,
            consensusRect.bottom + (blockRect.top - consensusRect.bottom) / 2),
        Offset(blockRect.center.dx, blockRect.top),
        linePaint);

    canvas.drawLine(
        Offset(consensusRect.center.dx,
            consensusRect.bottom + (blockRect.top - consensusRect.bottom) / 2),
        Offset(contractRect.center.dx,
            consensusRect.bottom + (blockRect.top - consensusRect.bottom) / 2),
        linePaint);

    canvas.drawLine(
        Offset(contractRect.center.dx,
            consensusRect.bottom + (blockRect.top - consensusRect.bottom) / 2),
        Offset(contractRect.center.dx, contractRect.top),
        linePaint);

    canvas.drawLine(
        Offset(consensusRect.center.dx,
            consensusRect.bottom + (blockRect.top - consensusRect.bottom) / 2),
        Offset(nftRect.center.dx,
            consensusRect.bottom + (blockRect.top - consensusRect.bottom) / 2),
        linePaint);

    canvas.drawLine(
        Offset(nftRect.center.dx,
            consensusRect.bottom + (blockRect.top - consensusRect.bottom) / 2),
        Offset(nftRect.center.dx, nftRect.top),
        linePaint);

    // All three modules to XaeroFlux
    canvas.drawLine(
        Offset(blockRect.center.dx, blockRect.bottom),
        Offset(blockRect.center.dx,
            blockRect.bottom + (xaeroRect.top - blockRect.bottom) / 2),
        linePaint);

    canvas.drawLine(
        Offset(blockRect.center.dx,
            blockRect.bottom + (xaeroRect.top - blockRect.bottom) / 2),
        Offset(xaeroRect.center.dx,
            blockRect.bottom + (xaeroRect.top - blockRect.bottom) / 2),
        linePaint);

    canvas.drawLine(
        Offset(xaeroRect.center.dx,
            blockRect.bottom + (xaeroRect.top - blockRect.bottom) / 2),
        Offset(xaeroRect.center.dx, xaeroRect.top),
        linePaint);

    canvas.drawLine(
        Offset(contractRect.center.dx, contractRect.bottom),
        Offset(contractRect.center.dx,
            blockRect.bottom + (xaeroRect.top - blockRect.bottom) / 2),
        linePaint);

    canvas.drawLine(
        Offset(nftRect.center.dx, nftRect.bottom),
        Offset(nftRect.center.dx,
            blockRect.bottom + (xaeroRect.top - blockRect.bottom) / 2),
        linePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

// XaeroFlux Architecture Diagram
class XaeroFluxArchitectureDiagram extends StatelessWidget {
  const XaeroFluxArchitectureDiagram({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      child: CustomPaint(
        painter: XaeroFluxDiagramPainter(),
        size: const Size(double.infinity, 400),
      ),
    );
  }
}

class XaeroFluxDiagramPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Set up background
    final Paint bgPaint = Paint()
      ..color = const Color(0xFF1A1A2E)
      ..style = PaintingStyle.fill;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    final Paint boxPaint = Paint()
      ..color = Colors.orangeAccent.withOpacity(0.2)
      ..style = PaintingStyle.fill;

    final Paint linePaint = Paint()
      ..color = Colors.orangeAccent
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final TextPainter textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    // Add title
    textPainter.text = const TextSpan(
      text: 'XaeroFlux Architecture',
      style: TextStyle(
          color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
    );
    textPainter.layout();
    textPainter.paint(canvas,
        Offset((size.width - textPainter.width) / 2, size.height * 0.02));

    // Draw Event Processor
    final Rect eventRect = Rect.fromLTWH(size.width * 0.1, size.height * 0.15,
        size.width * 0.3, size.height * 0.15);
    canvas.drawRRect(
        RRect.fromRectAndRadius(eventRect, const Radius.circular(8)), boxPaint);

    textPainter.text = const TextSpan(
      text: 'Event Processor',
      style: TextStyle(
          color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
    );
    textPainter.layout();
    textPainter.paint(
        canvas,
        Offset(eventRect.left + (eventRect.width - textPainter.width) / 2,
            eventRect.top + (eventRect.height - textPainter.height) / 2));

    // Draw Merkle Index Builder
    final Rect merkleRect = Rect.fromLTWH(size.width * 0.6, size.height * 0.15,
        size.width * 0.3, size.height * 0.15);
    canvas.drawRRect(
        RRect.fromRectAndRadius(merkleRect, const Radius.circular(8)),
        boxPaint);

    textPainter.text = const TextSpan(
      text: 'Merkle Index Builder',
      style: TextStyle(
          color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
    );
    textPainter.layout();
    textPainter.paint(
        canvas,
        Offset(merkleRect.left + (merkleRect.width - textPainter.width) / 2,
            merkleRect.top + (merkleRect.height - textPainter.height) / 2));

    // Draw RocksDB Storage
    final Rect rocksdbRect = Rect.fromLTWH(size.width * 0.35, size.height * 0.4,
        size.width * 0.3, size.height * 0.15);
    canvas.drawRRect(
        RRect.fromRectAndRadius(rocksdbRect, const Radius.circular(8)),
        boxPaint);

    textPainter.text = const TextSpan(
      text: 'RocksDB Storage',
      style: TextStyle(
          color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
    );
    textPainter.layout();
    textPainter.paint(
        canvas,
        Offset(rocksdbRect.left + (rocksdbRect.width - textPainter.width) / 2,
            rocksdbRect.top + (rocksdbRect.height - textPainter.height) / 2));

    // Draw Sync Engine
    final Rect syncRect = Rect.fromLTWH(size.width * 0.1, size.height * 0.65,
        size.width * 0.3, size.height * 0.15);
    canvas.drawRRect(
        RRect.fromRectAndRadius(syncRect, const Radius.circular(8)), boxPaint);

    textPainter.text = const TextSpan(
      text: 'Sync Engine',
      style: TextStyle(
          color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
    );
    textPainter.layout();
    textPainter.paint(
        canvas,
        Offset(syncRect.left + (syncRect.width - textPainter.width) / 2,
            syncRect.top + (syncRect.height - textPainter.height) / 2));

    // Draw Verification System
    final Rect verifyRect = Rect.fromLTWH(size.width * 0.6, size.height * 0.65,
        size.width * 0.3, size.height * 0.15);
    canvas.drawRRect(
        RRect.fromRectAndRadius(verifyRect, const Radius.circular(8)),
        boxPaint);

    textPainter.text = const TextSpan(
      text: 'Verification System',
      style: TextStyle(
          color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
    );
    textPainter.layout();
    textPainter.paint(
        canvas,
        Offset(verifyRect.left + (verifyRect.width - textPainter.width) / 2,
            verifyRect.top + (verifyRect.height - textPainter.height) / 2));

    // Draw connections
    // Event Processor to Merkle Index Builder
    canvas.drawLine(Offset(eventRect.right, eventRect.center.dy),
        Offset(merkleRect.left, merkleRect.center.dy), linePaint);

    // Event Processor to RocksDB
    canvas.drawLine(Offset(eventRect.center.dx, eventRect.bottom),
        Offset(eventRect.center.dx, rocksdbRect.top - 15), linePaint);

    canvas.drawLine(
        Offset(eventRect.center.dx, rocksdbRect.top - 15),
        Offset(
            rocksdbRect.left + rocksdbRect.width * 0.25, rocksdbRect.top - 15),
        linePaint);

    canvas.drawLine(
        Offset(
            rocksdbRect.left + rocksdbRect.width * 0.25, rocksdbRect.top - 15),
        Offset(rocksdbRect.left + rocksdbRect.width * 0.25, rocksdbRect.top),
        linePaint);

    // Merkle Index Builder to RocksDB
    canvas.drawLine(Offset(merkleRect.center.dx, merkleRect.bottom),
        Offset(merkleRect.center.dx, rocksdbRect.top - 15), linePaint);

    canvas.drawLine(
        Offset(merkleRect.center.dx, rocksdbRect.top - 15),
        Offset(
            rocksdbRect.left + rocksdbRect.width * 0.75, rocksdbRect.top - 15),
        linePaint);

    canvas.drawLine(
        Offset(
            rocksdbRect.left + rocksdbRect.width * 0.75, rocksdbRect.top - 15),
        Offset(rocksdbRect.left + rocksdbRect.width * 0.75, rocksdbRect.top),
        linePaint);

    // RocksDB to Sync Engine
    canvas.drawLine(
        Offset(rocksdbRect.left + rocksdbRect.width * 0.25, rocksdbRect.bottom),
        Offset(rocksdbRect.left + rocksdbRect.width * 0.25,
            rocksdbRect.bottom + 15),
        linePaint);

    // Draw ZeroID Module
    boxPaint.color = Colors.purpleAccent.withOpacity(0.2);
    final Rect zeroIDRect = Rect.fromLTWH(size.width * 0.1, size.height * 0.2,
        size.width * 0.25, size.height * 0.25);
    canvas.drawRRect(
        RRect.fromRectAndRadius(zeroIDRect, const Radius.circular(8)),
        boxPaint);

    textPainter.text = const TextSpan(
      text: 'ZeroID',
      style: TextStyle(
          color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
    );
    textPainter.layout();
    textPainter.paint(
        canvas,
        Offset(zeroIDRect.left + (zeroIDRect.width - textPainter.width) / 2,
            zeroIDRect.top + 20));

    textPainter.text = const TextSpan(
      text: 'DID + ZK Proofs',
      style: TextStyle(color: Colors.white70, fontSize: 14),
    );
    textPainter.layout();
    textPainter.paint(
        canvas,
        Offset(zeroIDRect.left + (zeroIDRect.width - textPainter.width) / 2,
            zeroIDRect.top + 50));

    // Draw OneChain Module
    boxPaint.color = Colors.greenAccent.withOpacity(0.2);
    final Rect oneChainRect = Rect.fromLTWH(size.width * 0.375,
        size.height * 0.2, size.width * 0.25, size.height * 0.25);
    canvas.drawRRect(
        RRect.fromRectAndRadius(oneChainRect, const Radius.circular(8)),
        boxPaint);

    textPainter.text = const TextSpan(
      text: 'OneChain',
      style: TextStyle(
          color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
    );
    textPainter.layout();
    textPainter.paint(
        canvas,
        Offset(oneChainRect.left + (oneChainRect.width - textPainter.width) / 2,
            oneChainRect.top + 20));

    textPainter.text = const TextSpan(
      text: 'Custom Blockchain',
      style: TextStyle(color: Colors.white70, fontSize: 14),
    );
    textPainter.layout();
    textPainter.paint(
        canvas,
        Offset(oneChainRect.left + (oneChainRect.width - textPainter.width) / 2,
            oneChainRect.top + 50));

    // Draw XaeroFlux Module
    boxPaint.color = Colors.orangeAccent.withOpacity(0.2);
    final Rect xaeroFluxRect = Rect.fromLTWH(size.width * 0.65,
        size.height * 0.2, size.width * 0.25, size.height * 0.25);
    canvas.drawRRect(
        RRect.fromRectAndRadius(xaeroFluxRect, const Radius.circular(8)),
        boxPaint);

    textPainter.text = const TextSpan(
      text: 'XaeroFlux',
      style: TextStyle(
          color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
    );
    textPainter.layout();
    textPainter.paint(
        canvas,
        Offset(
            xaeroFluxRect.left + (xaeroFluxRect.width - textPainter.width) / 2,
            xaeroFluxRect.top + 20));

    textPainter.text = const TextSpan(
      text: 'P2P Storage Engine',
      style: TextStyle(color: Colors.white70, fontSize: 14),
    );
    textPainter.layout();
    textPainter.paint(
        canvas,
        Offset(
            xaeroFluxRect.left + (xaeroFluxRect.width - textPainter.width) / 2,
            xaeroFluxRect.top + 50));

    // Draw Data Flows area
    final Rect dataFlowRect = Rect.fromLTWH(size.width * 0.1, size.height * 0.6,
        size.width * 0.8, size.height * 0.3);

    boxPaint.color = Colors.blueAccent.withOpacity(0.1);
    canvas.drawRRect(
        RRect.fromRectAndRadius(dataFlowRect, const Radius.circular(8)),
        boxPaint);

    textPainter.text = const TextSpan(
      text: 'Data Flow',
      style: TextStyle(
          color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
    );
    textPainter.layout();
    textPainter.paint(
        canvas, Offset(dataFlowRect.left + 20, dataFlowRect.top + 15));

    // Draw connections between modules
    // ZeroID to OneChain
    canvas.drawLine(Offset(zeroIDRect.right, zeroIDRect.center.dy),
        Offset(oneChainRect.left, oneChainRect.center.dy), linePaint);

    // OneChain to XaeroFlux
    canvas.drawLine(Offset(oneChainRect.right, oneChainRect.center.dy),
        Offset(xaeroFluxRect.left, xaeroFluxRect.center.dy), linePaint);

    // All three to Data Flow
    canvas.drawLine(Offset(zeroIDRect.center.dx, zeroIDRect.bottom),
        Offset(zeroIDRect.center.dx, dataFlowRect.top), linePaint);

    canvas.drawLine(Offset(oneChainRect.center.dx, oneChainRect.bottom),
        Offset(oneChainRect.center.dx, dataFlowRect.top), linePaint);

    canvas.drawLine(Offset(xaeroFluxRect.center.dx, xaeroFluxRect.bottom),
        Offset(xaeroFluxRect.center.dx, dataFlowRect.top), linePaint);

    // Add connection labels
    const TextStyle smallLabelStyle = TextStyle(
      color: Colors.white70,
      fontSize: 12,
    );

    // ZeroID to OneChain label
    textPainter.text = const TextSpan(
      text: 'Identity & Proofs',
      style: smallLabelStyle,
    );
    textPainter.layout();
    textPainter.paint(
        canvas,
        Offset(
            (zeroIDRect.right + oneChainRect.left) / 2 - textPainter.width / 2,
            zeroIDRect.center.dy - 15));

    // OneChain to XaeroFlux label
    textPainter.text = const TextSpan(
      text: 'Blockchain Data',
      style: smallLabelStyle,
    );
    textPainter.layout();
    textPainter.paint(
        canvas,
        Offset(
            (oneChainRect.right + xaeroFluxRect.left) / 2 -
                textPainter.width / 2,
            oneChainRect.center.dy - 15));

    // Data Flow content
    const double bulletX = 20;
    const double startY = 45;
    const double lineHeight = 20;

    // Data flow points
    for (int i = 0; i < 3; i++) {
      // Draw bullet points
      canvas.drawCircle(
          Offset(dataFlowRect.left + bulletX,
              dataFlowRect.top + startY + (i * lineHeight)),
          3,
          Paint()..color = Colors.blueAccent);
    }

    // Data flow text
    final List<String> dataFlowPoints = [
      'User creates ZeroID identity with ZK proofs',
      'Identity data stored on OneChain blockchain',
      'P2P data syncing via XaeroFlux with merkle validation'
    ];

    for (int i = 0; i < dataFlowPoints.length; i++) {
      textPainter.text = TextSpan(
        text: dataFlowPoints[i],
        style: smallLabelStyle,
      );
      textPainter.layout();
      textPainter.paint(
          canvas,
          Offset(dataFlowRect.left + bulletX + 10,
              dataFlowRect.top + startY - 5 + (i * lineHeight)));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

// System Architecture Diagram showing how the three projects interconnect
class SystemArchitecturePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Set up background
    final Paint bgPaint = Paint()
      ..color = const Color(0xFF1A1A2E)
      ..style = PaintingStyle.fill;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    final Paint boxPaint = Paint()..style = PaintingStyle.fill;

    final Paint linePaint = Paint()
      ..color = Colors.white.withOpacity(0.7)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final TextPainter textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    // Add title
    textPainter.text = const TextSpan(
      text: 'Block-Xaero System Architecture',
      style: TextStyle(
          color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
    );
    textPainter.layout();
    textPainter.paint(canvas,
        Offset((size.width - textPainter.width) / 2, size.height * 0.02));

    // Draw ZeroID Module
    boxPaint.color = Colors.purpleAccent.withOpacity(0.2);
    final Rect zeroIDRect = Rect.fromLTWH(size.width * 0.1, size.height * 0.2,
        size.width * 0.25, size.height * 0.25);
    canvas.drawRRect(
        RRect.fromRectAndRadius(zeroIDRect, const Radius.circular(8)),
        boxPaint);

    textPainter.text = const TextSpan(
      text: 'ZeroID',
      style: TextStyle(
          color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
    );
    textPainter.layout();
    textPainter.paint(
        canvas,
        Offset(zeroIDRect.left + (zeroIDRect.width - textPainter.width) / 2,
            zeroIDRect.top + 20));

    textPainter.text = const TextSpan(
      text: 'DID + ZK Proofs',
      style: TextStyle(color: Colors.white70, fontSize: 14),
    );
    textPainter.layout();
    textPainter.paint(
        canvas,
        Offset(zeroIDRect.left + (zeroIDRect.width - textPainter.width) / 2,
            zeroIDRect.top + 50));

    // Draw OneChain Module
    boxPaint.color = Colors.greenAccent.withOpacity(0.2);
    final Rect oneChainRect = Rect.fromLTWH(size.width * 0.375,
        size.height * 0.2, size.width * 0.25, size.height * 0.25);
    canvas.drawRRect(
        RRect.fromRectAndRadius(oneChainRect, const Radius.circular(8)),
        boxPaint);

    textPainter.text = const TextSpan(
      text: 'OneChain',
      style: TextStyle(
          color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
    );
    textPainter.layout();
    textPainter.paint(
        canvas,
        Offset(oneChainRect.left + (oneChainRect.width - textPainter.width) / 2,
            oneChainRect.top + 20));

    textPainter.text = const TextSpan(
      text: 'Custom Blockchain',
      style: TextStyle(color: Colors.white70, fontSize: 14),
    );
    textPainter.layout();
    textPainter.paint(
        canvas,
        Offset(oneChainRect.left + (oneChainRect.width - textPainter.width) / 2,
            oneChainRect.top + 50));

    // Draw XaeroFlux Module
    boxPaint.color = Colors.orangeAccent.withOpacity(0.2);
    final Rect xaeroFluxRect = Rect.fromLTWH(size.width * 0.65,
        size.height * 0.2, size.width * 0.25, size.height * 0.25);
    canvas.drawRRect(
        RRect.fromRectAndRadius(xaeroFluxRect, const Radius.circular(8)),
        boxPaint);

    textPainter.text = const TextSpan(
      text: 'XaeroFlux',
      style: TextStyle(
          color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
    );
    textPainter.layout();
    textPainter.paint(
        canvas,
        Offset(
            xaeroFluxRect.left + (xaeroFluxRect.width - textPainter.width) / 2,
            xaeroFluxRect.top + 20));

    textPainter.text = const TextSpan(
      text: 'P2P Storage Engine',
      style: TextStyle(color: Colors.white70, fontSize: 14),
    );
    textPainter.layout();
    textPainter.paint(
        canvas,
        Offset(
            xaeroFluxRect.left + (xaeroFluxRect.width - textPainter.width) / 2,
            xaeroFluxRect.top + 50));

    // Draw Data Flows area
    final Rect dataFlowRect = Rect.fromLTWH(size.width * 0.1, size.height * 0.6,
        size.width * 0.8, size.height * 0.3);

    boxPaint.color = Colors.blueAccent.withOpacity(0.1);
    canvas.drawRRect(
        RRect.fromRectAndRadius(dataFlowRect, const Radius.circular(8)),
        boxPaint);

    textPainter.text = const TextSpan(
      text: 'Data Flow',
      style: TextStyle(
          color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
    );
    textPainter.layout();
    textPainter.paint(
        canvas, Offset(dataFlowRect.left + 20, dataFlowRect.top + 15));

    // Draw connections between modules
    // ZeroID to OneChain
    canvas.drawLine(Offset(zeroIDRect.right, zeroIDRect.center.dy),
        Offset(oneChainRect.left, oneChainRect.center.dy), linePaint);

    // OneChain to XaeroFlux
    canvas.drawLine(Offset(oneChainRect.right, oneChainRect.center.dy),
        Offset(xaeroFluxRect.left, xaeroFluxRect.center.dy), linePaint);

    // All three to Data Flow
    canvas.drawLine(Offset(zeroIDRect.center.dx, zeroIDRect.bottom),
        Offset(zeroIDRect.center.dx, dataFlowRect.top), linePaint);

    canvas.drawLine(Offset(oneChainRect.center.dx, oneChainRect.bottom),
        Offset(oneChainRect.center.dx, dataFlowRect.top), linePaint);

    canvas.drawLine(Offset(xaeroFluxRect.center.dx, xaeroFluxRect.bottom),
        Offset(xaeroFluxRect.center.dx, dataFlowRect.top), linePaint);

    // Add connection labels
    const TextStyle smallLabelStyle = TextStyle(
      color: Colors.white70,
      fontSize: 12,
    );

    // ZeroID to OneChain label
    textPainter.text = const TextSpan(
      text: 'Identity & Proofs',
      style: smallLabelStyle,
    );
    textPainter.layout();
    textPainter.paint(
        canvas,
        Offset(
            (zeroIDRect.right + oneChainRect.left) / 2 - textPainter.width / 2,
            zeroIDRect.center.dy - 15));

    // OneChain to XaeroFlux label
    textPainter.text = const TextSpan(
      text: 'Blockchain Data',
      style: smallLabelStyle,
    );
    textPainter.layout();
    textPainter.paint(
        canvas,
        Offset(
            (oneChainRect.right + xaeroFluxRect.left) / 2 -
                textPainter.width / 2,
            oneChainRect.center.dy - 15));

    // Data Flow content
    const double bulletX = 20;
    const double startY = 45;
    const double lineHeight = 20;

    // Data flow points
    for (int i = 0; i < 3; i++) {
      // Draw bullet points
      canvas.drawCircle(
          Offset(dataFlowRect.left + bulletX,
              dataFlowRect.top + startY + (i * lineHeight)),
          3,
          Paint()..color = Colors.blueAccent);
    }

    // Data flow text
    final List<String> dataFlowPoints = [
      'User creates ZeroID identity with ZK proofs',
      'Identity data stored on OneChain blockchain',
      'P2P data syncing via XaeroFlux with merkle validation'
    ];

    for (int i = 0; i < dataFlowPoints.length; i++) {
      textPainter.text = TextSpan(
        text: dataFlowPoints[i],
        style: smallLabelStyle,
      );
      textPainter.layout();
      textPainter.paint(
          canvas,
          Offset(dataFlowRect.left + bulletX + 10,
              dataFlowRect.top + startY - 5 + (i * lineHeight)));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
