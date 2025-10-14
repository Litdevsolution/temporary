import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:intl/intl.dart';
import 'package:staypermitappv1/statemanagement/app_verification_state.dart';
import 'package:staypermitappv1/statemanagement/application_aggregation_state.dart';
import 'package:staypermitappv1/statemanagement/profile_aggregation_state.dart';
import 'package:staypermitappv1/pages/donutchart/donutchart.dart';
import 'package:staypermitappv1/pages/scan/scan_page.dart';
class HomePage extends StatefulWidget {
  final String role;
  const HomePage({super.key, required this.role});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final appVerificationState = Get.find<AppVerificationState>();
  final ProfileAggregationState profileState =
      Get.isRegistered<ProfileAggregationState>()
      ? Get.find<ProfileAggregationState>()
      : Get.put(ProfileAggregationState());

  final ApplicationAggregationState applicationState =
      Get.isRegistered<ApplicationAggregationState>()
      ? Get.find<ApplicationAggregationState>()
      : Get.put(ApplicationAggregationState());

  late String role;

  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    role = appVerificationState.userRole ?? 'USER';
    profileState.fetchProfileAggregation(
      startDate: '2025-01-05',
      endDate: '2025-01-11',
    );
    applicationState.fetchApplicationAggregation(
      startDate: '2025-01-05',
      endDate: '2025-01-11',
    );

    // profileState.testValues();
    print("Init role: $role");
  }

  List<Widget> get _navItems {
    if (role == 'SUPER_ADMIN') {
      return const <Widget>[Icon(Icons.home), Icon(Icons.qr_code_scanner)];
    } else if (role == 'ADMIN') {
      return const <Widget>[Icon(Icons.person)];
    } else {
      return const <Widget>[Icon(Icons.qr_code_scanner)];
    }
  }

  // Format and display statistic cards
  Widget buildCard(String title, String value, Color color) {
    final formattedValue = NumberFormat('#,###')
        .format(int.tryParse(value.replaceAll(RegExp(r'[^\d]'), '')) ?? 0);

    return Card(
      elevation: 4,
      color: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '$formattedValue ຄົນ',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Home page content (statistics and cards)
  Widget _buildHomeContent() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Group 1: ຈຳນວນບັດ
            const Text(
              'ຈຳນວນຄັ້ງອອກບັດ',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 5),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.1,
              children: [
                Obx(
                  () => buildCard(
                    'ທັງໝົດ',
                    '${applicationState.total.value}',
                    Colors.lightBlue,
                  ),
                ),
                Obx(
                  () => buildCard(
                    'ເພດຍິງ',
                    '${applicationState.female.value}',
                    Colors.red.shade300,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Group 2: ຈຳນວນຜູ້ລົງທະບຽນ
            const Text(
              'ຈຳນວນຜູ້ລົງທະບຽນ',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 5),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.1,
              children: [
                Obx(
                  () => buildCard(
                    'ທັງໝົດ',
                    '${profileState.total.value}',
                    Colors.orange,
                  ),
                ),
                Obx(
                  () => buildCard(
                    'ເພດຍິງ',
                    '${profileState.female.value}',
                    Colors.green,
                  ),
                ),
              ],
            ),
            SizedBox(height: 15),
            DonutChartWidget(sumIncome: 1200000, sumExpense: 800000),
          ],
        ),
      ),
    );
  }

  // Handle bottom navigation bar index
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Page switching (if multiple pages exist later)
  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return _buildHomeContent();
      case 1:
        return ScanPage();
      default:
        return _buildHomeContent();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ກົມຕຳຫຼວດ'),
        backgroundColor: const Color(0xFFF5D9AE),
      ),
      body: _buildBody(),
      bottomNavigationBar: CurvedNavigationBar(
        index: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: Colors.white,
        color: const Color(0xFFF5D9AE),
        buttonBackgroundColor: const Color(0xFFF5D9AE),
        animationDuration: const Duration(milliseconds: 300),
        items: _navItems,
      ),
    );
  }
}
