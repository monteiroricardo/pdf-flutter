import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';
import 'package:printing/printing.dart';

import 'models/product.dart';

class PdfPage extends StatelessWidget {
  const PdfPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Product> products = [
      Product(
        'Caderno',
        50,
      ),
      Product(
        'Tesoura',
        22,
      ),
      Product(
        'Apagador',
        12,
      ),
      Product(
        'Caneta',
        147,
      ),
      Product(
        'Borracha',
        100,
      ),
      Product(
        'Apontador',
        10,
      ),
      Product(
        'Lapiseira',
        47,
      ),
      Product(
        'Cola Quente',
        2,
      ),
      Product(
        'Cola Bastão',
        3,
      ),
      Product(
        'Marca Texto',
        8,
      ),
    ];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigoAccent.shade100,
        title: Text(
          'Relatório',
          style: GoogleFonts.workSans(fontWeight: FontWeight.bold),
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Spacer(),
                IconButton(
                  onPressed: () async {
                    printPDF(await buildPDF(products));
                  },
                  icon: const Icon(
                    Icons.print,
                    color: Colors.black54,
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    await photoPermission();
                    imageFromPDF(
                      await buildPDF(products),
                    );
                  },
                  icon: const Icon(
                    Icons.photo,
                    color: Colors.black54,
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    sharePDF(
                      await buildPDF(products),
                      'myDoc.pdf',
                    );
                  },
                  icon: const Icon(
                    Icons.share,
                    color: Colors.black54,
                  ),
                )
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
              ),
              height: 50,
              decoration: BoxDecoration(
                color: Colors.indigoAccent.shade100,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(
                    5,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Produto',
                      style: GoogleFonts.workSans(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Vendas',
                      style: GoogleFonts.workSans(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: products.length,
                itemBuilder: (ctx, index) => Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
                  height: 50,
                  color: index.isOdd ? Colors.grey[200] : Colors.white,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          products[index].name,
                          style: GoogleFonts.workSans(
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          products[index].sales.toString(),
                          style: GoogleFonts.workSans(
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<pw.Document> buildPDF(List<Product> products) async {
  final pdf = pw.Document();

  //construir pdf de pagina unica
  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        return pw.Column(
          mainAxisAlignment: pw.MainAxisAlignment.center,
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Container(
              padding: const pw.EdgeInsets.symmetric(
                horizontal: 10,
              ),
              height: 50,
              decoration: const pw.BoxDecoration(
                color: PdfColors.indigoAccent,
                borderRadius: pw.BorderRadius.vertical(
                  top: pw.Radius.circular(
                    5,
                  ),
                ),
              ),
              child: pw.Row(
                children: [
                  pw.Expanded(
                    child: pw.Text(
                      'Produto',
                      style: pw.TextStyle(
                        color: PdfColors.white,
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  pw.Expanded(
                    child: pw.Text(
                      'Vendas',
                      style: pw.TextStyle(
                        color: PdfColors.white,
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            pw.Expanded(
              child: pw.ListView.builder(
                itemCount: products.length,
                itemBuilder: (ctx, index) => pw.Container(
                  padding: const pw.EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
                  height: 50,
                  color: index.isOdd ? PdfColors.grey200 : PdfColors.white,
                  child: pw.Row(
                    children: [
                      pw.Expanded(
                        child: pw.Text(
                          products[index].name,
                          style: const pw.TextStyle(
                            color: PdfColors.black,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      pw.Expanded(
                        child: pw.Text(
                          products[index].sales.toString(),
                          style: const pw.TextStyle(
                            color: PdfColors.black,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    ),
  ); // Page

// contruir pdf de multipaginas
  /* pdf.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        return [
          pw.Container(
            alignment: pw.Alignment.center,
            color: PdfColors.orangeAccent,
            height: 728,
            child: pw.Text(
              'MOMOZII',
              style: pw.TextStyle(
                fontSize: 25,
                color: PdfColors.white,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ),
        ];
      },
    ),
  ); // Page
*/
  return pdf;
}

void printPDF(pw.Document pdf) async {
  await Printing.layoutPdf(
    onLayout: (PdfPageFormat format) async => pdf.save(),
  );
}

void sharePDF(pw.Document pdf, String docName) async {
  await Printing.sharePdf(
    bytes: await pdf.save(),
    filename: docName,
  );
}

void imageFromPDF(pw.Document pdf) async {
  await for (var page
      in Printing.raster(await pdf.save(), pages: [0], dpi: 72)) {
    //erro pois precisa expecificar quantas pages tem
    final image = await page.toPng();

    try {
      final result = await ImageGallerySaver.saveImage(image);
      if (result['isSuccess']) {
        print('sucesso');
      } else {
        print('erro');
      }
    } catch (e) {
      print('erro');
    }
  }
}

Future<void> photoPermission() async {
  if (await Permission.photos.isGranted) {
    return;
  } else {
    await Permission.photos.request();
  }
}
