import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PrintableItemDetailsScreen extends StatelessWidget {
  var image;
  var comment;
  var usage;
  var value;
  var name;
  var phone;

  PrintableItemDetailsScreen({
    required this.image,
    this.comment,
    this.usage,
    this.value,
    this.name,
    this.phone,
  });

  Future<Uint8List> generatePdf(BuildContext context) async {
    final pdf = pw.Document();

    final Uint8List imageBytes =
    (await rootBundle.load(image)).buffer.asUint8List();

    pdf.addPage(
      pw.Page(
        build: (context) => pw.Column(
          children: [
            pw.Image(
              PdfImage.file(pdf.document, bytes: imageBytes) as pw.ImageProvider,
              width: 500,
              height: 300,
            ),
            pw.Text(name),
            pw.Text('Uso: $usage'),
            pw.Text('Valor: $value'),
            pw.Text(comment),
          ],
        ),
      ),
    );

    return pdf.save();
  }

  void sharePdf(Uint8List pdfBytes, String name) {
    // Cambié 'detalles_' a 'details_' para que coincida con el nombre del archivo PDF generado.
    Share.shareFiles(['details_$name.pdf'], text: 'Details $name');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Details'),
        backgroundColor: Color(0xff471f53),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Card(
            elevation: 30,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Image.network(
                  image,
                  height: MediaQuery.of(context).size.height / 3.5,
                  width: MediaQuery.of(context).size.width / 1.25,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Card(
            elevation: 30,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    '$name',
                    style: TextStyle(fontSize: 20.0),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Uso: $usage',
                    style: TextStyle(fontSize: 20.0),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'Valor: $value',
                    style: TextStyle(fontSize: 20.0),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    comment,
                    style: TextStyle(fontSize: 20.0),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Uint8List pdfBytes = await generatePdf(context);
          sharePdf(pdfBytes, name);
        },
        child: Icon(Icons.print),
        tooltip: 'Print or Generate Report',
      ),
    );
  }
}
