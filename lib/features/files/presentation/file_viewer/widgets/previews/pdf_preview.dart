import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';

class PdfPreview extends StatefulWidget {
  final Uint8List bytes;

  const PdfPreview({super.key, required this.bytes});

  @override
  State<PdfPreview> createState() => _PdfPreviewState();
}

class _PdfPreviewState extends State<PdfPreview> {
  PdfControllerPinch? _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initPdf();
  }

  Future<void> _initPdf() async {
    final document = await PdfDocument.openData(widget.bytes);
    if (mounted) {
      setState(() {
        _controller = PdfControllerPinch(document: Future.value(document));
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading || _controller == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return PdfViewPinch(
      controller: _controller!,
      builders: PdfViewPinchBuilders<DefaultBuilderOptions>(
        options: const DefaultBuilderOptions(),
        documentLoaderBuilder:
            (_) => const Center(child: CircularProgressIndicator()),
        pageLoaderBuilder:
            (_) => const Center(child: CircularProgressIndicator()),
        errorBuilder:
            (_, error) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline_rounded,
                    size: 48,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Failed to render PDF',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
      ),
    );
  }
}
