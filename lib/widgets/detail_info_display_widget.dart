// D:\Nengxiong\Code\staypermitmobileapp\lib\widgets\DetailInfoDisplay.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DetailInfoDisplay extends StatelessWidget {
  final String Function(String?) getLocalizedLabel;
  final String Function(String) getValue;

  const DetailInfoDisplay({
    super.key,
    required this.getLocalizedLabel,
    required this.getValue,
  });

  IconData _getSectionIcon(String sectionTitle) {
    switch (sectionTitle) {
      case 'ຂໍ້ມູນສ່ວນຕົວ':
        return Icons.person_outline;
      case 'ລາຍລະຂໍ້ມູນອຽດບັດ':
        return Icons.credit_card;
      case 'ການຈ້າງງານ':
        return Icons.work_outline;
      case 'ສະຖານທີ່':
        return Icons.location_on_outlined;
      case 'ທີ່ຢູ່ຕ່າງປະເທດ':
        return Icons.public;
      default:
        return Icons.info_outline;
    }
  }

  // This function checks if the card is still valid (expiry date is today or in the future)
  bool _isCardValid(String expiryDateString) {
    if (expiryDateString.isEmpty) {
      return false;
    }
    try {
      final DateTime expiryDate = DateFormat(
        'dd/MM/yyyy',
      ).parse(expiryDateString);
      final DateTime now = DateTime.now();

      final DateTime today = DateTime(now.year, now.month, now.day);
      final DateTime expiryDateOnly = DateTime(
        expiryDate.year,
        expiryDate.month,
        expiryDate.day,
      );

      return expiryDateOnly.isAfter(today) ||
          expiryDateOnly.isAtSameMomentAs(today);
    } catch (e) {
      print(
        'Error parsing expiry date for validation: $expiryDateString, Error: $e',
      );
      return false;
    }
  }

  // This function checks if the card is expired (expiry date is in the past)
  bool _isCardExpired(String expiryDateString) {
    if (expiryDateString.isEmpty) {
      return false; // Cannot be expired if no date is provided
    }
    try {
      final DateTime expiryDate = DateFormat(
        'dd/MM/yyyy',
      ).parse(expiryDateString);
      final DateTime now = DateTime.now();

      final DateTime today = DateTime(now.year, now.month, now.day);
      final DateTime expiryDateOnly = DateTime(
        expiryDate.year,
        expiryDate.month,
        expiryDate.day,
      );

      return expiryDateOnly.isBefore(
        today,
      ); // Returns true if expiry date is before today
    } catch (e) {
      print(
        'Error parsing expiry date for expiration check: $expiryDateString, Error: $e',
      );
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, List<String>> groupedKeys = {
      'ຂໍ້ມູນສ່ວນຕົວ': [
        "profile.identityNumber",
        "profile.phoneNumber",
        "profile.dateOfBirth",
        "profile.gender",
        "profile.nationality.name",
        "profile.ethnicity.name",
        "profile.identityType",
      ],
      'ລາຍລະຂໍ້ມູນອຽດບັດ': [
        "type",
        "number.price.duration",
        "profile.application.issueDate",
        "application.expiryDate",
        "number.price.type",
        "number.price.price",
      ],
      'ການຈ້າງງານ': [
        "company.name",
        "company.officeId",
        "position.laoName",
        "office.name",
      ],
      'ສະຖານທີ່': [
        "profile.currentVillageId",
        "profile.currentVillage",
        "profile.district.districtLao",
        "profile.province.provinceLao",
      ],
      'ທີ່ຢູ່ຕ່າງປະເທດ': [
        "profile.overseasProvince",
        "profile.overseasCountryId",
        "profile.overseasCountry",
      ],
    };

    final String fullName = getValue('fullName');
    final String priceName = getValue('number.price.name');
    final String expiryDateString = getValue('profile.identityExpiryDate');

    final bool isValid = _isCardValid(expiryDateString);
    final bool isExpired = _isCardExpired(expiryDateString); // Check if expired

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Row(
              //   children: [
              //     const Icon(Icons.info_outline, size: 20, color: Colors.black),
              //     const SizedBox(width: 8),
              //     const Text(
              //       'ລາຍລະອຽດ',
              //       style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              //     ),
              //   ],
              // ),
              if (fullName.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
                  child: Text(
                    fullName,
                    style: const TextStyle(
                      fontSize: 24,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              if (priceName.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: Text(
                    priceName,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color.fromARGB(255, 90, 90, 90),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              const SizedBox(height: 6),
              if (isValid)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 18,
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        'ບັດຍັງຢູ່ໃນອາຍຸການໃຊ້ງານ',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                )
              else if (isExpired) // New condition for expired
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.cancel, // Red X icon
                        color: Colors.red,
                        size: 18,
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        'ບັດໝົດອາຍຸການໃຊ້ງານ', // "Card not valid"
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16.0),

          ...groupedKeys.entries.map((entry) {
            final sectionTitle = entry.key;
            final keys = entry.value;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      _getSectionIcon(sectionTitle),
                      size: 20,
                      color: Colors.black,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      sectionTitle,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
               ),
                const SizedBox(height: 6),
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDEE9F1),
                    border: Border.all(
                      color: const Color.fromARGB(255, 213, 213, 213),
                    ),
                    borderRadius: BorderRadius.circular(6),
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromARGB(
                          255,
                          211,
                          211,
                          211,
                        ).withOpacity(.2),
                        blurRadius: 1.5,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: keys.map((key) {
                      final value = getValue(key);
                      if (value.isEmpty) {
                        return const SizedBox();
                      }
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              getLocalizedLabel(key),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              value,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF666666),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            );
          }).toList(),
        ],
      ),
    );
  }
}
