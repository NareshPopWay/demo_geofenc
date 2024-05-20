// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';



class ScannerScreen extends StatefulWidget {
  const ScannerScreen({Key? key})
      : super(key: key);

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  bool flashState = false;
  late QRViewController controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  bool _cameraOn = true;
  bool isLoading = false;
  int scanCount = 0;
  bool hasInternet = false;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    final double statusBarHeight= MediaQuery.of(context).padding.top;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          SizedBox(
            height: screenHeight,
            child: _cameraOn
                ? _buildQrView(context)
                : Container(color: Colors.blueAccent),
          ),
          Container(
              padding: EdgeInsets.only(top: statusBarHeight),
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 15, 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            height:screenHeight *0.10,
                            width: screenWidth *0.12,
                            decoration: BoxDecoration(
                              color: Colors.blueAccent,
                              shape: BoxShape.circle,
                            ),
                            margin: EdgeInsets.fromLTRB(screenWidth*0.02, 0, 0,0),
                            child: Padding(
                              padding:  EdgeInsets.only(left:screenWidth*0.02),
                              child:  Icon(Icons.arrow_back_ios,color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )),
          Positioned(
            bottom: screenHeight * 0.28,
            left: screenWidth * 0.05,
            right: screenWidth * 0.05,
            child: Center(
              child: Text(
                'Align QR Code within frame to scan',
                style: TextStyle(
                    color: Colors.blueAccent,
                    fontSize: screenWidth * 0.044,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
          Positioned(
            bottom: screenHeight * 0.12,
            left: screenHeight * 0.05,
            right: screenHeight * 0.05,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: screenHeight * 0.02),
                Container(
                  height:screenHeight *0.04,
                  width: screenWidth *0.09,
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(05),
                  ),
                  child: GestureDetector(
                    child: flashState
                        ? Center(
                      child: Icon(Icons.flash_off,
                          color: Colors.white, size: screenWidth *0.07),
                    )
                        : Center(
                      child: Icon(Icons.flash_on,
                          color: Colors.white, size: screenWidth *0.07),
                    ),
                    onTap: () {
                      setState(() {
                        flashState = !flashState;
                      });
                      controller.toggleFlash();
                    },
                  ),
                ),
                SizedBox(height: 01),
                Text(
                  'Flash',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: screenWidth*0.040,
                      fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
          // Visibility(
          //   visible: isLoading,
          //   child: loaderView(context, loadcolor: AppConstant.primaryColor),
          // ),
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {

    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    var scanArea = (MediaQuery.of(context).size.width < 400.0 ||
        MediaQuery.of(context).size.height < 400.0)
        ? 270.0
        : 3200.0;
    return NotificationListener<SizeChangedLayoutNotification>(
      child: SizeChangedLayoutNotifier(
        key: const Key('qr-size-notifier'),
        child: QRView(
          key: qrKey,
          onQRViewCreated: _onQRViewCreated,
          overlay: QrScannerOverlayShape(
            borderColor: Colors.blueAccent,
            borderRadius: 25,
            borderLength: 50,
            borderWidth: 6,
            cutOutSize: scanArea,
          ),
        ),
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
      controller.resumeCamera();
    });
    controller.scannedDataStream.listen((scanData) async {
      if(_cameraOn){
        print(isLoading.toString() + '==' + _cameraOn.toString());
        setState(() {
          isLoading= true;
        });
        await controller.pauseCamera();
        Fluttertoast.showToast(
            msg: 'QR Code is scanned',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0
        );
        await controller.resumeCamera();
        // if(scanData.code!.contains('TMS')){
        //   Fluttertoast.showToast(
        //       msg: 'QR Code is not valid',
        //       toastLength: Toast.LENGTH_SHORT,
        //       gravity: ToastGravity.BOTTOM,
        //       timeInSecForIosWeb: 1,
        //       backgroundColor: Colors.black,
        //       textColor: Colors.white,
        //       fontSize: 16.0
        //   );
        // }else{
        //   Fluttertoast.showToast(
        //       msg: 'QR Code is not valid',
        //       toastLength: Toast.LENGTH_SHORT,
        //       gravity: ToastGravity.BOTTOM,
        //       timeInSecForIosWeb: 1,
        //       backgroundColor: Colors.black,
        //       textColor: Colors.white,
        //       fontSize: 16.0
        //   );
        //   await controller.resumeCamera();
        // }
        setState(() {
          isLoading= false;
        });
      }
    });
  }

  @override
  void reassemble() {
    super.reassemble();
    print("reassemble");
    if (mounted && _cameraOn) {
      if (Platform.isAndroid) {
        controller.pauseCamera();
      } else if (Platform.isIOS) {
        controller.resumeCamera();
      }
    }
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      print("resumed=");
      startCamera();
    }
    if (state == AppLifecycleState.paused) {
      print("paused=");
      pauseCamera();
    }
  }

  Future<void> startCamera() async {
    if (controller != null) {
      controller.resumeCamera();
    }
    _cameraOn = true;
    setState(() {});
  }

  Future<void> pauseCamera() async {
    if (controller != null) {
      controller.pauseCamera();
    }
    _cameraOn = false;
    setState(() {});
  }
}
