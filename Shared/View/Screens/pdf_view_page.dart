import 'package:carebuddy/Core/Components/failure_widget.dart';
import 'package:carebuddy/Core/Components/loading_widget.dart';
import 'package:easy_pdf_viewer/easy_pdf_viewer.dart';
import 'package:flutter/material.dart';

class PdfViewPage extends StatefulWidget {
  final String url;
  const PdfViewPage({super.key, required this.url});

  @override
  State<PdfViewPage> createState() => _PdfViewPageState();
}

class _PdfViewPageState extends State<PdfViewPage> {
  PDFDocument? _pdfDocument;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    loadPdf();
  }

  Future<void> loadPdf() async {
    try {
      PDFDocument document = await PDFDocument.fromURL(
        widget.url,
      );
      setState(() {
        _pdfDocument = document;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("PDF")),
      body: _isLoading
          ? const LoadingWidget()
          : _pdfDocument != null
          ? PDFViewer(document: _pdfDocument!, lazyLoad: false, showPicker: false,)
          : const FailureWidget(onTap: null, message: "Failed to load PDF")
    );
  }
}