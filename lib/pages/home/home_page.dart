import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:intl/intl.dart';
import 'package:temporary/statemanagement/app_verification_state.dart';
import 'package:temporary/statemanagement/application_aggregation_state.dart';
import 'package:temporary/statemanagement/profile_aggregation_state.dart';
import 'package:temporary/statemanagement/company_aggregation_state.dart';
import 'package:temporary/statemanagement/application_quantity_aggregation_state.dart';
import 'package:temporary/pages/donutchart/donutchart.dart';
import 'package:temporary/pages/scan/scan_page.dart';
import 'package:temporary/statemanagement/profile_donut_chart_state.dart';
import 'package:temporary/statemanagement/login_state.dart';
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
      
  final CompanyAggregationState companyState =
      Get.isRegistered<CompanyAggregationState>()
      ? Get.find<CompanyAggregationState>()
      : Get.put(CompanyAggregationState());
  final ApplicationQuantityAggregationState applicationQuantityState =
      Get.isRegistered<ApplicationQuantityAggregationState>()
      ? Get.find<ApplicationQuantityAggregationState>()
      : Get.put(ApplicationQuantityAggregationState());
  final ProfileDonutChartState profileDonutChartState =
      Get.isRegistered<ProfileDonutChartState>()
      ? Get.find<ProfileDonutChartState>()
      : Get.put(ProfileDonutChartState());
  final LoginState loginState =
      Get.isRegistered<LoginState>()
      ? Get.find<LoginState>()
      : Get.put(LoginState());

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
    profileDonutChartState.fetchNationalityCounts();
    applicationQuantityState.fetchApplicationQuantityAggregation(
      startDate: '2025-01-05',
      endDate: '2025-01-11',
      
    ).then((_) {
    print("Company total count: ${applicationQuantityState.total.value}");
  });
    companyState.fetchCompanyAggregation().then((_) {
    print("Company total count: ${companyState.totalCount.value}");
  });

    // profileState.testValues();
    print("Init role: $role");
  }

  List<Widget> get _navItems {
    if (role == 'SUPER_ADMIN' || role == 'ADMIN') {
      return const <Widget>[Icon(Icons.home), Icon(Icons.qr_code_scanner)];
    
    } else {
      return const <Widget>[Icon(Icons.qr_code_scanner)];
    }
  }


  // Format and display statistic cards
  Widget buildCard(String title, String value, String male, String female, Color color) {
    final formattedValue = NumberFormat('#,###')
        .format(int.tryParse(value.replaceAll(RegExp(r'[^\d]'), '')) ?? 0);
    final formattedMale = NumberFormat('#,###')
        .format(int.tryParse(male.replaceAll(RegExp(r'[^\d]'), '')) ?? 0);
    final formattedFemale = NumberFormat('#,###')
        .format(int.tryParse(female.replaceAll(RegExp(r'[^\d]'), '')) ?? 0);

    return Card(
      elevation: 4,
      color: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Icon(
                  Icons.badge,
                  color: Colors.white,
                ),
                
              ],
            ),

            const SizedBox(height: 10),
            Text(
              '$formattedValue',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ອອກໃໝ່',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          '$formattedMale',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ຕໍ່ບັດ',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          '$formattedFemale',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                
              ],
            ),
          ],
        ),
      ),
    );
  }
Widget buildProfileCard(
  String title,
  String value,
  String applicationCount,
  String neverApplication,
  Color color,
) {
  final formattedValue = NumberFormat('#,###')
      .format(int.tryParse(value.replaceAll(RegExp(r'[^\d]'), '')) ?? 0);
  final formattedApplicationCount = NumberFormat('#,###')
      .format(int.tryParse(applicationCount.replaceAll(RegExp(r'[^\d]'), '')) ?? 0);

  final formattedNeverApplication = NumberFormat('#,###')
      .format(int.tryParse(neverApplication.replaceAll(RegExp(r'[^\d]'), '')) ?? 0);

  return Card(
    elevation: 4,
    color: color,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    child: Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row (title + people icon)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Icon(Icons.people, color: Colors.white),
            ],
          ),

          const SizedBox(height: 10),

          // Total count
          Text(
            formattedValue,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 15),

          // Gender counts row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ອອກບັດ',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          '$formattedApplicationCount',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ຍັງບໍ່ອອກບັດ',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          '$formattedNeverApplication',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                
              ],
            ),
        ],
      ),
    ),
  );
}


Widget buildApplicationCard(
  String title,
  String value,
  String male,
  String female,
  Color color,
) {
  final formattedValue = NumberFormat('#,###')
      .format(int.tryParse(value.replaceAll(RegExp(r'[^\d]'), '')) ?? 0);
  final formattedMale = NumberFormat('#,###')
      .format(int.tryParse(male.replaceAll(RegExp(r'[^\d]'), '')) ?? 0);
  final formattedFemale = NumberFormat('#,###')
      .format(int.tryParse(female.replaceAll(RegExp(r'[^\d]'), '')) ?? 0);

  return Card(
    elevation: 4,
    color: color,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    child: Padding(
      padding: const EdgeInsets.all(6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Icon(
                Icons.badge,
                color: Colors.white,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            formattedValue,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 36),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: ImageIcon(
                      AssetImage('assets/woman.png'),
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 2),
                  Text(
                    formattedFemale,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: ImageIcon(
                      AssetImage('assets/man.png'),
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 2),
                  Text(
                    formattedMale,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

  Widget buildCompanyCard(String title, String value, Color color) {
    final formattedValue = NumberFormat('#,###')
        .format(int.tryParse(value.replaceAll(RegExp(r'[^\d]'), '')) ?? 0);

    return Card(
      elevation: 4,
      color: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    Text(
      title,
      style: const TextStyle(
        fontSize: 14,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    ),
    const Icon(
      Icons.business,
      color: Colors.white,
    ),
    
  ],
),

            const SizedBox(height: 10),
            Text(
              '$formattedValue',
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
         
          _buildResponsiveCards([
            Obx(
              () => buildCard(
                'ຈຳນວນຄັ້ງອອກບັດ',
                '${applicationState.total.value != 0 ? applicationState.total.value : 0}',
                '${applicationState.male.value != 0 ? applicationState.male.value : 0}',
                '${applicationState.female.value != 0 ? applicationState.female.value : 0}',
                Colors.orange,
              ),
            ),
            
            Obx(
              () {
                final total = profileState.total.value;
                final applicationCount = profileState.applicationCount.value;
                final neverApplication = profileState.neverApplication.value;

                return buildProfileCard(
                  'ຈຳນວນຄົນ',
                  '$total',
                  '$applicationCount',
                  '$neverApplication',
                  Colors.red.shade300,
                );
              },
            ),

          ]),

          const SizedBox(height: 20),

          // Group 2: ຈຳນວນຜູ້ລົງທະບຽນ
          
          _buildResponsiveCards([
            Obx(
              () => buildApplicationCard(
                'ຈຳນວນບັດ',
                '${applicationQuantityState.total.value != 0 ? applicationQuantityState.total.value : 0}',
                '${applicationQuantityState.male.value != 0 ? applicationQuantityState.male.value : 0}',  
                '${applicationQuantityState.female.value != 0 ? applicationQuantityState.female.value : 0}',
                Colors.lightBlue,
              ),
            ),

          Obx(() => buildCompanyCard(
            'ຫົວໜ່ວຍທຸລະກິດ',
            '${companyState.totalCount.value}', // reactive value
            Colors.green,
          ),),

          ]),
          const SizedBox(height: 15),
          Obx(() {
            if (profileDonutChartState.nationalityList.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            // Build dataMap inside Obx
            final dataMap = <String, double>{};
            for (var item in profileDonutChartState.nationalityList) {
              dataMap[item.name] = item.count.toDouble();
            }

            return DonutChartWidget(
              dataMap: dataMap,
              colorList: [
                Colors.lightBlue,
                Colors.red,
                Colors.green,
                Colors.orange,
                Colors.purple,
              ],
            );
          }),
        ],
      ),
    ),
  );
}

/// Responsive cards: Row on large screens, Grid on small screens
Widget _buildResponsiveCards(List<Widget> cards) {
  return LayoutBuilder(
    builder: (context, constraints) {
      final isLargeScreen = constraints.maxWidth >= 700; // iPad/Desktop breakpoint

      if (isLargeScreen) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: cards
        .map((card) => Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: card,
              ),
            ))
        .toList(),
  );
} else {
  return GridView.count(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    crossAxisCount: 2,
    mainAxisSpacing: 12,
    crossAxisSpacing: 12,
    childAspectRatio: 1.1,
    children: cards,
  );
}

    },
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
  if (role == 'SUPER_ADMIN' || role == 'ADMIN') {
    switch (_selectedIndex) {
      case 0:
        return _buildHomeContent(); // Home tab
      case 1:
        return ScanPage(); // Scanner tab
      default:
        return _buildHomeContent();
    }
  } else {
    // Normal users only have one tab — scanner
    return ScanPage();
  }
}

  @override
 Widget build(BuildContext context) {
    return Scaffold(
      appBar: (role == 'SUPER_ADMIN' || role == 'ADMIN')
        ? (_selectedIndex == 0
            ? AppBar(
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
            )
            : null) // 🔥 No AppBar when ScanPage is opened
        : null,

      body: _buildBody(),
      bottomNavigationBar: CurvedNavigationBar(
        index: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: Colors.white,
        color: const Color(0xFFCFEAFD),
        buttonBackgroundColor: const Color(0xFFCFEAFD),
        animationDuration: const Duration(milliseconds: 300),
        items: _navItems,
      ),
    );
  }
}