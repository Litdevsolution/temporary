// D:\Nengxiong\Code\staypermitmobileapp\lib\widgets\ScannedCardDisplay.dart
import 'package:flutter/material.dart';

class ScanCard extends StatelessWidget {
  final String imageUrl;
  final String qrcodeUrl;
  final String defaultImagePath;
  final String policeLogo;
  final String defaultQrCodePath;
  final GlobalKey cardKey;

  final String Function(String?) getLocalizedLabel;
  final String Function(String) getValue;

  const ScanCard({
    super.key,
    required this.imageUrl,
    required this.qrcodeUrl,
    required this.defaultImagePath,
    required this.policeLogo,
    required this.defaultQrCodePath,
    required this.cardKey,
    required this.getLocalizedLabel,
    required this.getValue,
  });

  String _safe(String key) {
    final value = getValue(key);
    if (value.trim().isEmpty || value.toLowerCase() == 'null') {
      return 'ບໍ່ມີຂໍ້ມູນ!';
    }
    return value;
  }

  // New helper function to format dates
  String _formatDate(String? dateString) {
    if (dateString == null ||
        dateString.trim().isEmpty ||
        dateString.toLowerCase() == 'null') {
      return 'ບໍ່ມີຂໍ້ມູນ!';
    }
    try {
      final DateTime date = DateTime.parse(dateString);
      return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
    } catch (e) {
      return dateString;
    }
  }

  Widget _buildField(String label, String value, {bool isRed = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label:',
            style: const TextStyle(
              fontSize: 7,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 7,
              color: isRed ? Colors.red : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  // Function to show image in a dialog
  void _showImageDialog(
    BuildContext context,
    String imageUrl,
    String defaultPath,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: imageUrl.isNotEmpty
                    ? ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              Image.asset(defaultPath, fit: BoxFit.cover),
                        ),
                      )
                    : ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                        child: Image.asset(defaultPath, fit: BoxFit.cover),
                      ),
              ),

              SizedBox(
                width: double.infinity,
                child: TextButton(
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    foregroundColor: Colors.white,
                    backgroundColor: const Color.fromARGB(255, 230, 192, 137),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(16),
                        bottomRight: Radius.circular(16),
                      ),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'ປິດຮູບພາບ',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ----------------- UI -----------------
  @override
  Widget build(BuildContext context) {
    final leftColumn = [
      {'label': 'ຊື່/Name', 'key': 'profile.firstName'},
      {'label': 'ນາມສະກຸນ/Surname', 'key': 'profile.lastName'},
      {'label': 'ວັນເດືອນປີເກີດ/Date of Birth', 'key': 'profile.dateOfBirth'},
      {
        'label': 'ເອກະສານເດີນທາງ/Travel document',
        'key': 'profile.identityType',
      },
      {
        'label': 'ສະຖານທີ່ພັກເຊົາ/Living place',
        'key': 'profile.district.districtLao',
      },
    ];

    final rightColumn = [
      {'label': 'ເຊື້ອຊາດ/Race', 'key': 'profile.ethnicity.name'},
      {'label': 'ສັນຊາດ/Nationality', 'key': 'profile.nationality.name'},
      {'label': 'ເລກທີ່/No', 'key': 'profile.identityNumber'},
    ];

    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Container(
          key: cardKey,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.fromARGB(255, 247, 244, 228),
                Color.fromARGB(255, 242, 225, 193),
              ],
            ),
            border: Border.all(color: const Color.fromARGB(255, 212, 210, 196)),
            borderRadius: BorderRadius.circular(6),
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ---------- ຮູບ & QR ----------
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: Image.asset(
                            policeLogo,
                            width: 30,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    GestureDetector(
                      onTap: () =>
                          _showImageDialog(context, imageUrl, defaultImagePath),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: imageUrl.isNotEmpty
                            ? Image.network(
                                imageUrl,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Image.asset(
                                  defaultImagePath,
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Image.asset(
                                defaultImagePath,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    GestureDetector(
                      onTap: () => _showImageDialog(
                        context,
                        qrcodeUrl,
                        defaultQrCodePath,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: qrcodeUrl.isNotEmpty
                            ? Image.network(
                                qrcodeUrl,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Image.asset(
                                  defaultQrCodePath,
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Image.asset(
                                defaultQrCodePath,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ------ ສ່ວນຫົວ ------
                      const Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Text(
                          'ສາທາລະນະລັດ ປະຊາທິປະໄຕ ປະຊາຊົນລາວ',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 18),
                        child: Text(
                          "Lao People's Democratic Republic",
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Text(
                          'ໃບຢັ້ງຢຶນການພັກຊາວຊົ່ວເຄົາ / Temporary Stay Card',
                          style: TextStyle(
                            fontSize: 8,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // 1. Loop ก่อน surname
                              for (final f in leftColumn.takeWhile(
                                (e) => e['key'] != 'profile.lastName',
                              ))
                                _buildField(f['label']!, _safe(f['key']!)),

                              // 2. แสดง "ນາມສະກຸນ"
                              _buildField(
                                'ນາມສະກຸນ/Surname',
                                _safe('profile.lastName'),
                              ),

                              // 3. แสดง "ວັນເດືອນປີເກີດ" แบบ format dd/mm/yyyy
                              _buildField(
                                'ວັນເດືອນປີເກີດ/Date of Birth',
                                _formatDate(_safe('profile.dateOfBirth')),
                              ),

                              // 4. Loop ส่วนที่เหลือจาก leftColumn
                              for (final f
                                  in leftColumn
                                      .skipWhile(
                                        (e) =>
                                            e['key'] != 'profile.dateOfBirth',
                                      )
                                      .skip(1))
                                _buildField(f['label']!, _safe(f['key']!)),

                              // 5. ต่อด้วย Row ของ Position, ออกให้, หมดอายุ...
                              Row(
                                children: [
                                  const Text(
                                    'ໜ້າທີ່/Position:',
                                    style: TextStyle(
                                      fontSize: 7,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    _safe('position.laoName'),
                                    style: const TextStyle(
                                      fontSize: 7,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),

                              // ออกให้วันที
                              Row(
                                children: [
                                  const Text(
                                    'ອອກໃຫ້ວັນທີ່:',
                                    style: TextStyle(
                                      fontSize: 7,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    _formatDate(
                                      _safe('profile.identityIssueDate'),
                                    ),
                                    style: const TextStyle(
                                      fontSize: 7,
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),

                              // หมดอายุ
                              Row(
                                children: [
                                  const Text(
                                    'ໝົດອະຍຸ:',
                                    style: TextStyle(
                                      fontSize: 7,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    _formatDate(
                                      _safe('profile.identityExpiryDate'),
                                    ),
                                    style: const TextStyle(
                                      fontSize: 7,
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          const SizedBox(width: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Text(
                                    "ເລກທີ່:",
                                    style: TextStyle(fontSize: 7),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    _safe('profile.barcode'),
                                    style: const TextStyle(fontSize: 7),
                                  ),
                                  Text('/ຄຕທ', style: TextStyle(fontSize: 7)),
                                ],
                              ),
                              for (final f in rightColumn)
                                _buildField(f['label']!, _safe(f['key']!)),
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  Opacity(
                                    opacity: .8,
                                    child: Image.asset(
                                      'assets/immigration.png',
                                      width: 50,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  const Column(
                                    children: [
                                      Text(
                                        "ກົມຕຳຫຼວດຄຸ້ມຄອງຄົນຕ່າງປະເທດ",
                                        style: TextStyle(
                                          fontSize: 7,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        "Department of Foreigner Control",
                                        style: TextStyle(
                                          fontSize: 7,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
