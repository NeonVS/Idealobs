import 'package:flutter/material.dart';
import 'package:flutter_plugin_pdf_viewer/flutter_plugin_pdf_viewer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class PdfViewer extends StatefulWidget {
  static const routeName = '/pdf_view';
  @override
  _PdfViewerState createState() => _PdfViewerState();
}

class _PdfViewerState extends State<PdfViewer> {
  bool _isLoading = true;
  bool _isInit = true;
  PDFDocument document;
  String downloadUrl;

  Future<void> changePDF(url) async {
    try {
      document = await PDFDocument.fromURL(url);
    } catch (error) {
      print(error);
      throw error;
    }
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if (_isInit) {
      _isInit = false;
      setState(() {
        _isLoading = true;
      });
      downloadUrl = ModalRoute.of(context).settings.arguments as String;
      downloadUrl.replaceAll(' ', '%20');
      changePDF(downloadUrl).then((value) {
        setState(() {
          _isLoading = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final spinKit =
        SpinKitCubeGrid(color: Theme.of(context).primaryColor, size: 50);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Attachment'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor.withOpacity(0.8),
      ),
      body: Center(
        child: document != null ? PDFViewer(document: document) : spinKit,
      ),
    );
  }
}
