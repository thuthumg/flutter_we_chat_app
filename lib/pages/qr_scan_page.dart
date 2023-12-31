import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:we_chat_app/blocs/contacts_page_bloc.dart';
import 'package:we_chat_app/pages/home_page.dart';
import 'package:we_chat_app/resources/colors.dart';
import 'package:we_chat_app/resources/dimens.dart';

class QRScanPage extends StatefulWidget {

  ContactsPageBloc contactsPageBloc;

   QRScanPage({Key? key,required this.contactsPageBloc}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRScanState();
}

class _QRScanState extends State<QRScanPage> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(flex: 4, child: _buildQrView(context)),
          Expanded(
            flex: 1,
            child: Container(
             // fit: BoxFit.contain,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  if (result != null)
                    Text(
                        'Barcode Type: ${describeEnum(result!.format)}   Data: ${result!.code}')
                  else
                    const Text('Scan a code'),

                  GestureDetector(
                    onTap: () async {
                          final picker = ImagePicker();
                          final pickedImage =
                              await picker.getImage(source: ImageSource.gallery);

                          if (pickedImage != null) {
                            // final qrCode = await controller?.scanFromPath(pickedImage.path);
                            controller?.scannedDataStream.listen((scanData) {
                              setState(() {
                                result = scanData;

                                if (result != null) {
                                  // Handle the scanned QR code from the gallery here
                                  print('Scanned QR code from gallery: $result');
                                } else {
                                  print('No QR code found in the selected image.');
                                }
                              });
                            });
                          }
                    },
                    child: SelectImageQRView(),
                  )
                  // SelectImageQR()
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;

        widget.contactsPageBloc.saveQRScanUserVO(
            widget.contactsPageBloc.userVO?.id??"",
            result!.code??"").then((value) => Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomePage(navigateIndex: 2,)),
              (route) => false, // Remove all routes
        )
        );

      });
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    debugPrint('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}

class SelectImageQRView extends StatelessWidget {
  const SelectImageQRView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: MARGIN_MEDIUM),
        height: 45,
        width: 300,
        decoration: BoxDecoration(
            borderRadius:
                BorderRadius.circular(MARGIN_MEDIUM),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3), // changes the position of the shadow
              ),
            ],
            color: Colors.white),
        child: Padding(
          padding: const EdgeInsets.all(MARGIN_CARD_MEDIUM_2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/contacts/select_image_icon.png',
                scale: 3,
              ),
              SizedBox(width: MARGIN_CARD_MEDIUM_2,),
              Text(
                'Select Image for QR Scan',
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: TEXT_REGULAR,
                    color: SECONDARY_COLOR),
              ),
            ],
          ),
        )


        );
  }
}
