import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../statemanagement/scan_state.dart';
import '../../widgets/scan_card_widget.dart';
import '../../widgets/qrcode_scan_widget.dart';
import '../../widgets/detail_info_display_widget.dart';
import '../../statemanagement/app_verification_state.dart';
import '../../repository/repository.dart';
import 'package:temporary/statemanagement/login_state.dart';
import 'package:get/get.dart';
class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  String scannedCode = 'ລໍຖ້າສະແກນຄິວອາໂຄດ...';
  MobileScannerController? controller;

  final TextEditingController _manualCodeController = TextEditingController();
  final AppVerificationState _appVerificationState = AppVerificationState();

  final LoginState loginState =
      Get.isRegistered<LoginState>()
      ? Get.find<LoginState>()
      : Get.put(LoginState());
  String? _accessToken;

  bool isTorchOn = false; // <-- Add this
  bool hasScanned = false;
final Repository repository = Repository();

@override

  Map<String, dynamic>? _apiData;
  List<Map<String, dynamic>> matchedData = [];
  bool isCameraGranted = false;

  String _lastProcessedId = '';

  final ScrollController _scrollController = ScrollController();
  final GlobalKey _cardKey = GlobalKey();

  final String defaultImagePath = 'assets/istockphoto-1300845620-612x612.jpg';
  final String defaultQrCodePath = 'assets/Data not found!.jpeg';
  final String policeLogo = 'assets/policelogo.png';

  final String apiStatus = 'FINISHED';
  String get apiAuthorizationToken => 'Bearer ${_accessToken ?? ''}';

  String currentVillageName = '';
  String overseasCountryName = '';

Future<Map<String, dynamic>> fetchProfileById(String profileId) async {
  if (_accessToken == null || _accessToken!.isEmpty) {
    throw Exception("Access token not available");
  }

  final url = '${repository.uri}/profile/$profileId';
  final response = await http.get(
    Uri.parse(url),
    headers: {
      'Authorization': 'Bearer $_accessToken',
      'Accept': 'application/json',
    },
  );
  print("Fetching: $url");
print("Authorization: Bearer $_accessToken");


  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Unauthorized or other error: ${response.statusCode}');
  }
}

void _toggleTorch() {
    if (controller != null) {
      controller!.toggleTorch();
      setState(() {
        isTorchOn = !isTorchOn;
      });
    }
  }
  
  void _fetchProfileNames(String profileId) async {
    try {
      final profileData = await fetchProfileById(profileId);

      setState(() {
        currentVillageName = profileData['currentVillage']?['villageLao'] ?? '';
        overseasCountryName = profileData['overseasCountry']?['name'] ?? '';
      });

      print("currentVillageName: $currentVillageName");
      print("overseasCountryName: $overseasCountryName");
    } catch (e) {
      print('Error fetching profile details: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    controller = MobileScannerController();

    _accessToken = _appVerificationState.accessToken;
    _requestCameraPermission();

  _initAccessToken();
  }
Future<void> _initAccessToken() async {
  await _appVerificationState.initialize(); // Load token from storage
  setState(() {
    _accessToken = _appVerificationState.accessToken; // Now _accessToken has value
  });
}

  void _requestCameraPermission() async {
    var status = await Permission.camera.status;
    if (!status.isGranted) {
      status = await Permission.camera.request();
    }

    if (mounted) {
      setState(() {
        isCameraGranted = status.isGranted;
        if (isCameraGranted) {
          if (controller == null) {
            controller = MobileScannerController();
          }
          controller?.start();
        }
      });
    }
  }


  @override
  void dispose() {
    controller?.dispose();
    _scrollController.dispose();
    _manualCodeController.dispose();
    super.dispose();
  }

void _onDetect(BarcodeCapture capture) {
  final barcodes = capture.barcodes;
  if (barcodes.isEmpty) return;

  final code = barcodes.first.rawValue;
  if (code == null) return;

  // Take only the last 7 characters
  final last7Digits = code.length >= 7 ? code.substring(code.length - 7) : code;

  if (last7Digits == _lastProcessedId) return; // prevent duplicate scans

  _lastProcessedId = last7Digits;
  _processCode(last7Digits); // send only last 7 digits
}



  void _processCode(String code) async {
  setState(() {
    hasScanned = true;
    scannedCode = 'ກຳລັງດຶງຂໍ້ມູນ...';
    matchedData = [];
  });

  try {
    // Create an instance of ScanState
    final scanState = ScanState();

    final fetchedData = await scanState.fetchApplicationByBarcode(
      barcode: code,
      status: apiStatus,
      authorizationToken: apiAuthorizationToken,
    );

    if (fetchedData != null && fetchedData.isNotEmpty) {
      setState(() {
        matchedData = [fetchedData];
        _apiData = fetchedData;
        scannedCode = '';
        _manualCodeController.clear();
        _lastProcessedId = '';
        _fetchProfileNames(fetchedData['profile']['id'].toString());
      });
    } else {
      setState(() {
        matchedData = [];
        _apiData = null;
        scannedCode = 'ໄອດີ $_lastProcessedId ບໍ່ມີຂໍ້ມູນ';
      });
    }
  } catch (e) {
    setState(() {
      matchedData = [];
      _apiData = null;
      scannedCode = 'ເກີດຂໍ້ຜິດພາດໃນການດຶງຂໍ້ມູນ: $e';
    });
  }
}


  void _resetScreen() {
    hasScanned = false;
    controller?.dispose();
    controller = MobileScannerController();
    controller?.start();

    setState(() {
      matchedData = [];
      _apiData = null;
      scannedCode = 'ລໍຖ້າສະແກນຄິວອາໂຄດ...';
      _manualCodeController.clear();
      _lastProcessedId = '';
    });
  }

  String _getNestedValue(String key) {
    Map<String, dynamic>? currentData = _apiData;

    if (currentData == null || currentData.isEmpty) {
      return '';
    }

    List<String> parts = key.split('.');
    dynamic current = currentData;

    for (int i = 0; i < parts.length; i++) {
      String part = parts[i];
      if (current is Map<String, dynamic> && current.containsKey(part)) {
        current = current[part];
      } else {
        return '';
      }
    }
    return current?.toString() ?? '';
  }

  String _getValue(String key) {
    if (key == 'fullName') {
      return '${_getNestedValue("profile.firstName")} ${_getNestedValue("profile.lastName")}'
          .trim()
          .toUpperCase();
    } else if (key == 'number.price.price') {
      final price = _getNestedValue(key);
      if (price.isNotEmpty) {
        return '\$$price';
      }
      return '';
    } else if (key == 'profile.application.issueDate' ||
        key == 'profile.application.issueDate' ||
        key == 'profile.dateOfBirth') {
      final dateString = _getNestedValue(key);
      if (dateString.isNotEmpty) {
        try {
          final dateTime = DateTime.parse(dateString);
          return DateFormat('dd/MM/yyyy').format(dateTime);
        } catch (e) {
          print('Error parsing date for $key: $e');
          return dateString;
        }
      }
      return '';
    } else if (key == 'profile.currentVillage') {
      return _getNestedValue('profile.currentVillage.villageLao');
    } else if (key == 'profile.overseasCountry') {
      return _getNestedValue('profile.overseasCountry.name');
    }

    return _getNestedValue(key);
  }

  String _getLocalizedLabel(String? key) {
    if (key == null) return '';
    switch (key) {
      case 'profile.identityNumber':
        return 'ເລກຟອມ:';
      case 'profile.phoneNumber':
        return 'ເບີໂທ:';
      case 'profile.dateOfBirth':
        return 'ວັນເດືອນປີເກີດ:';
      case 'profile.identityType':
        return 'ປະເພດເອກະສານ:';
      case 'profile.gender':
        return 'ເພດ:';
      case 'profile.nationality.name':
        return 'ສັນຊາດ:';
      case 'profile.ethnicity.name':
        return 'ເຊື້ອຊາດ:';
      case 'profile.currentVillageId':
        return 'ບ້ານ:';
      case 'profile.district.districtLao':
        return 'ເມືອງ:';
      case 'profile.province.provinceLao':
        return 'ແຂວງ:';
      case 'profile.application.issueDate':
        return 'ອອກໃຫ້ວັນທີ:';
      case 'profile.application.expiryDate':
        return 'ວັນໝົດວັນທີ:';
      case 'number.number':
        return 'ເລກທີ່:';
      case 'profile.overseasProvince':
        return 'ແຂວງ:';
      case 'type':
        return 'ປະເພດ:';
      case 'number.price.type':
        return 'ປະເພດບັດ:';
      case 'number.price.price':
        return 'ລາຄາ:';
      case 'number.price.duration':
        return 'ໄລຍະເວລາ:';
      case 'company.name':
        return 'ບໍລິສັດ:';
      case 'company.officeId':
        return 'ລະຫັດທຸລະກິດ:';
      case 'position.laoName':
        return 'ຕຳແໜ່ງ:';
      case 'office.name':
        return 'ສຳນັກງານ:';
      case 'profile.overseasCountryId':
        return 'ປະເທດ:';
      default:
        return key;
    }
  }

  bool get _shouldShowResetButton {
    if (matchedData.isNotEmpty) return true;
    if (scannedCode != 'ລໍຖ້າສະແກນຄິວອາໂຄດ...') return true;
    return false;
  }

  bool get _shouldShowInputAndScanner {
    return matchedData.isEmpty && scannedCode == 'ລໍຖ້າສະແກນຄິວອາໂຄດ...';
  }

  @override
  Widget build(BuildContext context) {
    final String imageUrl = _getValue("profile.image");
    final String qrcodeUrlFromApi = _getValue("profile.barcode");
    print("imageUrl: $imageUrl");
    print("qrcodeUrlFromApi: $qrcodeUrlFromApi");

    return Scaffold(
      appBar: hasScanned
    ? AppBar(
        backgroundColor: Color(0xFFCFEAFD),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: _resetScreen
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 5.0),
            child: IconButton(
              icon: const Icon(Icons.power_settings_new),
              onPressed: () {
                loginState.logout();
              },
            ),
          ),
        ],
      )
    : AppBar(
              title: const Text('ກົມ 207'),
              backgroundColor: const Color(0xFFCFEAFD),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 5.0),
                  child: IconButton(
                    icon: const Icon(Icons.power_settings_new),
                    onPressed: () {
                      loginState.logout();
                    },
                  ),
                ),
              ],
            ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              if (_shouldShowInputAndScanner)
                Column(
                  children: [
                    if (isCameraGranted)
                      if (isCameraGranted)
  SizedBox(
    height: 400,
    child: Stack(
      children: [
        QRCodeScanner(
  controller: controller,
  onDetect: _onDetect,
  isCameraGranted: isCameraGranted,
  // allowDuplicates: false, <-- REMOVE THIS
),
        const ScannerOverlay(
          width: 100,
          height: 100,
          borderColor: Colors.red,
          borderWidth: 3,
          cornerLength: 30,
        ),
       Positioned(
  bottom: 20, // distance from bottom
  left: 0,
  right: 0,
  child: Center(
    child: IconButton(
      icon: Icon(
        isTorchOn ? Icons.flash_on : Icons.flash_off,
        size: 40, // larger if you want
      ),
      onPressed: _toggleTorch,
    ),
  ),
),
      ],
    ),
  )

                    else
                      const Padding(
                        padding: EdgeInsets.all(30),
                        child: Column(
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 10),
                            Text("ກຳລັງຂໍສິດໃຊ້ກ້ອງ..."),
                          ],
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          TextField(
                            controller: _manualCodeController,
                            decoration: InputDecoration(
                              labelText: 'ປ້ອນເລກຄິວອາໂຄດ ຫຼື ID',
                              border: const OutlineInputBorder(),
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  _manualCodeController.clear();
                                },
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            onSubmitted: (value) {
                              if (value.isNotEmpty) {
                                final last7Digits = value.length >= 7 ? value.substring(value.length - 7) : value;
                                _lastProcessedId = last7Digits;
                                _processCode(last7Digits);
                              }
                            },

                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                if (_manualCodeController.text.isNotEmpty) {
                                  final last7Digits = _manualCodeController.text.length >= 7
                                      ? _manualCodeController.text.substring(_manualCodeController.text.length - 7)
                                      : _manualCodeController.text;
                                  _lastProcessedId = last7Digits;
                                  _processCode(last7Digits);
                                }
                              },

                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF74D2FA),
                                padding: const EdgeInsets.all(10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                elevation: 2,
                                shadowColor: const Color(0xFF74D2FA),
                              ),
                              child: const Text(
                                'ກວດສອບຂໍ້ມູນ',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              if (matchedData.isNotEmpty)
                Column(
                  children: [
                    ScanCard(
                      imageUrl: imageUrl,
                      qrcodeUrl: qrcodeUrlFromApi,
                      defaultImagePath: defaultImagePath,
                      defaultQrCodePath: defaultQrCodePath,
                      policeLogo: policeLogo,
                      cardKey: _cardKey,
                      getLocalizedLabel: _getLocalizedLabel,
                      getValue: _getValue,
                    ),
                    const SizedBox(height: 20),
                    DetailInfoDisplay(
                      getLocalizedLabel: _getLocalizedLabel,
                      getValue: _getValue,
                    ),
                  ],
                )
              else if (scannedCode != 'ລໍຖ້າສະແກນຄິວອາໂຄດ...')
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Text(
                    scannedCode,
                    style: const TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ),
              
            ],
          ),
        ),
      ),
    );
  }
}


class ScannerOverlay extends StatelessWidget {
  final double width;
  final double height;
  final double borderWidth;
  final Color borderColor;
  final double cornerLength;

  const ScannerOverlay({
    Key? key,
    this.width = 250,
    this.height = 250,
    this.borderWidth = 3,
    this.borderColor = Colors.red,
    this.cornerLength = 30,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CustomPaint(
        size: Size(width, height),
        painter: _ScannerOverlayPainter(
          borderColor: borderColor,
          borderWidth: borderWidth,
          cornerLength: cornerLength,
        ),
      ),
    );
  }
}

class _ScannerOverlayPainter extends CustomPainter {
  final double borderWidth;
  final Color borderColor;
  final double cornerLength;

  _ScannerOverlayPainter({
    required this.borderColor,
    required this.borderWidth,
    required this.cornerLength,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = borderColor
      ..strokeWidth = borderWidth
      ..style = PaintingStyle.stroke;

    // Top-left
    canvas.drawLine(Offset(0, 0), Offset(cornerLength, 0), paint);
    canvas.drawLine(Offset(0, 0), Offset(0, cornerLength), paint);

    // Top-right
    canvas.drawLine(
        Offset(size.width, 0), Offset(size.width - cornerLength, 0), paint);
    canvas.drawLine(Offset(size.width, 0), Offset(size.width, cornerLength), paint);

    // Bottom-left
    canvas.drawLine(
        Offset(0, size.height), Offset(cornerLength, size.height), paint);
    canvas.drawLine(
        Offset(0, size.height), Offset(0, size.height - cornerLength), paint);

    // Bottom-right
    canvas.drawLine(Offset(size.width, size.height),
        Offset(size.width - cornerLength, size.height), paint);
    canvas.drawLine(Offset(size.width, size.height),
        Offset(size.width, size.height - cornerLength), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
