import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // final String defaultImagePath = 'assets/istockphoto-1300845620-612x612.jpg';
  final String defaultImagePath = 'assets/profile.jpeg';
  final String defaultQrCodePath = 'assets/MS THOUN LINKCHOU.png';

  final String _expCard =
      'ບັດຢັ້ງຢຶນພັກເຊົາຊົ່ວຄາວ - Temporary Stay Card (ມຽນມ້າ 6 ເດືອນ)';
  final String _cardSatus = 'ບັດໝົດອາຍຸການໃຊ້ງານ';
  final String _identityNumber = '203802';
  final String _phoneNumber = '11111111';
  final String _dateOfBirth = '01/06/1997';
  final String _gender = 'ຍິງ';
  final String _nationality = 'Myanmar';
  final String _ethnicity = 'Myanmar';
  final String _identityType = 'nationalId';

  final String _cardType = 'NEW';
  final String _expirationTerm = 'SIX_MONTHS';
  final String _issueDate = '06/01/2011';
  final String _expirationDate = '02/06/2025';
  final String _cardCategory = 'YELLOW';
  final String _price = '80';

  final String _workPlace = 'ບໍລິສັດ ເບິນຍູເຈກົງຢຸ່ຍ ຈຳກັດຜູ້ດຽວ';
  final String _workNumber = '1';
  final String _position = 'ອະນາໄມ';
  final String _officeName = 'ເສິ້ງໄທ້';

  final String _villageLao = 'ເຂດພິເສດສາມຫລ່ຽມທອງຄຳ';
  final String _districtLao = 'ຕົ້ນເຜິ້ງ';
  final String _provinceLao = 'ບໍ່ແກ້ວ';

  final String _overseasProvince = 'MANDALAY';
  final String _overseasCountryId = 'Myanmar';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 1, bottom: 1),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 30, bottom: 10),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color.fromARGB(255, 255, 211, 150),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 3,
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        defaultImagePath,
                        width: 280,
                        height: 280,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "MS THOUN LINKCHOU",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(left: 30, right: 30),
                    child: Text(
                      _expCard,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.cancel, color: Colors.red, size: 20),
                      SizedBox(width: 6),
                      Text(
                        _cardSatus,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Container(
                    padding: const EdgeInsets.only(
                      top: 0,
                      left: 10,
                      right: 10,
                      bottom: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Color.fromARGB(255, 255, 211, 150),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Image.asset(
                      defaultQrCodePath,
                      width: 150,
                      fit: BoxFit.contain,
                    ),
                  ),

                  const SizedBox(height: 10),
                  const Text(
                    'ສະແກນ QR Code ເພື່ອກວດສອບຂໍ້ມູນ',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader('ຂໍ້ມູນສ່ວນຕົວ', Icons.person_outline),
                  _buildInfoCard([
                    _buildInfoRow('ເລກຟອມ:', _identityNumber),
                    _buildInfoRow('ເບີໂທ:', _phoneNumber),
                    _buildInfoRow('ວັນເດືອນປີເກີດ:', _dateOfBirth),
                    _buildInfoRow('ເພດ:', _gender),
                    _buildInfoRow('ສັນຊາດ:', _nationality),
                    _buildInfoRow('ເຊື້ອຊາດ:', _ethnicity),
                    _buildInfoRow('ປະເພດເອກະສານ:', _identityType),
                  ]),
                  const SizedBox(height: 25),
                  _buildSectionHeader(
                    'ລາຍລະອຽດບັດ',
                    Icons.credit_card_outlined,
                  ),
                  _buildInfoCard([
                    _buildInfoRow('ປະເພດ:', _cardType),
                    _buildInfoRow('ໄລຍະເວລາ:', _expirationTerm),
                    _buildInfoRow('ອອກໃຫ້ວັນທີ:', _issueDate),
                    _buildInfoRow('ວັນໝົດວັນທີ:', _expirationDate),
                    _buildInfoRow('ປະເພດບັດ:', _cardCategory),
                    _buildInfoRow('ລາຄາ:', '\$$_price'),
                  ]),
                  const SizedBox(height: 25),
                  _buildSectionHeader('ການຈ້າງງານ', Icons.work_outline),
                  _buildInfoCard([
                    _buildInfoRow('ບໍລິສັດ:', _workPlace),
                    _buildInfoRow('ລະຫັດທຸລະກິດ:', _workNumber),
                    _buildInfoRow('ຕຳແໜ່ງ:', _position),
                    _buildInfoRow('ສຳນັກງານ:', _officeName),
                  ]),
                  const SizedBox(height: 25),
                  _buildSectionHeader('ສະຖານທີ່', Icons.location_on_outlined),
                  _buildInfoCard([
                    _buildInfoRow('ບ້ານ:', _villageLao),
                    _buildInfoRow('ເມືອງ:', _districtLao),
                    _buildInfoRow('ແຂວງ:', _provinceLao),
                  ]),
                  const SizedBox(height: 25),
                  _buildSectionHeader('ທີ່ຢູ່ຕ່າງປະເທດ', Icons.public_outlined),
                  _buildInfoCard([
                    _buildInfoRow('ແຂວງ:', _overseasProvince),
                    _buildInfoRow('ປະເທດ:', _overseasCountryId),
                  ]),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        children: [
          Icon(icon, size: 26, color: Colors.black),
          const SizedBox(width: 10),
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(List<Widget> children) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(
          color: Color.fromARGB(255, 88, 88, 88),
          width: 0.3,
        ),
      ),
      color: const Color.fromARGB(255, 255, 254, 245),
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(children: children),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 15,
              color: Color.fromARGB(255, 112, 112, 112),
              fontWeight: FontWeight.w500,
            ),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 16,
                color: Color.fromARGB(255, 112, 112, 112),
                // fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
