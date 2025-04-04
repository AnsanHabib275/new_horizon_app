// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names, use_key_in_widget_constructors, prefer_interpolation_to_compose_strings, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:new_horizon_app/core/constants/asset_constants.dart';
import 'package:new_horizon_app/core/models/patientdetails.dart';
import 'package:new_horizon_app/core/services/apis/user/benefitverificationdetailsapi.dart';
import 'package:new_horizon_app/ui/utils/colors.dart';
import 'package:new_horizon_app/ui/views/screens/viewscreens/datasubmission2.dart';
import 'package:new_horizon_app/ui/views/screens/viewscreens/details.dart';
import 'package:new_horizon_app/ui/views/screens/viewscreens/patients.dart';
import 'package:new_horizon_app/ui/views/screens/viewscreens/patientspending.dart';
import 'package:new_horizon_app/ui/views/screens/viewscreens/patientsrejected.dart';
import 'package:searchbar_animation/searchbar_animation.dart';
import 'package:shimmer/shimmer.dart';

class AllPatients extends StatefulWidget {
  const AllPatients({super.key});

  @override
  State<AllPatients> createState() => _AllPatientsState();
}

class _AllPatientsState extends State<AllPatients> {
  TextEditingController textController = TextEditingController();
  var heights = Get.height;
  var widths = Get.width;
  List<BenefitDetails>? patientsList;
  List<BenefitDetails>? filteredPatientsList;

  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    loadPatients();
  }

  Future<void> refreshPatients() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });
    await loadPatients();
  }

  Future<void> loadPatients() async {
    try {
      var fetchedPatients =
          await Getbenefitsverificationdetails.GetBenefitDetails(context);
      setState(() {
        patientsList = fetchedPatients;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage =
            'Hang Tight! We are trying to resolve the issue at our end.';
      });
    }
  }

  void filterSearchResults(String query) {
    if (query.isEmpty) {
      filteredPatientsList = patientsList;
    } else {
      filteredPatientsList = patientsList?.where((patient) {
        // Assuming patient has a name property for the search
        // Add or modify conditions based on the properties you want to search by
        return patient.firstName.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // FocusScope.of(context).unfocus();
      },
      child: MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_outlined,
                    size: 20, color: Colors.black), // Change the color here
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: const Text(
                'Patients',
                style: TextStyle(color: Colors.black),
              ),
            ),
            body: Column(
              children: [
                const SizedBox(
                  height: 25,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      GestureDetector(
                          onTap: () {},
                          child: Container(
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom:
                                    BorderSide(color: Colors.blue, width: 2.0),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Text(
                                '  All Patients  ',
                                style: TextStyle(
                                    fontFamily: 'Segoe UI',
                                    fontSize: heights <= 690 && widths <= 430
                                        ? 11
                                        : 14,
                                    fontWeight: FontWeight.w600,
                                    color: appcolor.textColor),
                              ),
                            ),
                          )),
                      SizedBox(
                        width: heights <= 690 && widths <= 430 ? 4 : 6,
                      ),
                      GestureDetector(
                          onTap: () async {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Patients()));
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text(
                              '  Verified  ',
                              style: TextStyle(
                                  fontFamily: 'Segoe UI',
                                  fontSize:
                                      heights <= 690 && widths <= 430 ? 11 : 14,
                                  color: Colors.grey),
                            ),
                          )),
                      SizedBox(
                        width: heights <= 690 && widths <= 430 ? 4 : 6,
                      ),
                      GestureDetector(
                        onTap: () async {
                          // context.loaderOverlay.show();

                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const PatientsPending()));
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text('  Pending',
                              style: TextStyle(
                                  fontFamily: 'Segoe UI',
                                  fontSize:
                                      heights <= 690 && widths <= 430 ? 11 : 14,
                                  color: Colors.grey)),
                        ),
                      ),
                      SizedBox(
                        width: heights <= 690 && widths <= 430 ? 4 : 6,
                      ),
                      GestureDetector(
                        onTap: () async {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const PatientsRejected()));
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text('  Rejected',
                              style: TextStyle(
                                  fontFamily: 'Segoe UI',
                                  fontSize:
                                      heights <= 690 && widths <= 430 ? 11 : 14,
                                  color: Colors.grey)),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  width: heights <= 690 && widths <= 430 ? 4 : 6,
                ),
                SearchBarAnimation(
                  textEditingController: textController,
                  isOriginalAnimation: false,
                  searchBoxWidth: Get.width - 17,
                  isSearchBoxOnRightSide: true,
                  searchBoxBorderColour: Colors.transparent,
                  buttonBorderColour: Colors.transparent,
                  enableButtonShadow: false,
                  onChanged: (val) {
                    filterSearchResults(val);
                  },
                  enableKeyboardFocus: true,
                  onExpansionComplete: () {},
                  onCollapseComplete: () {
                    textController.clear();
                    filterSearchResults('');
                  },
                  onPressButton: (isSearchBarOpens) {
                    debugPrint(
                        'do something before animation started. It\'s the ${isSearchBarOpens ? 'opening' : 'closing'} animation');
                  },
                  trailingWidget: const Icon(
                    Icons.search,
                    size: 20,
                    color: Colors.black,
                  ),
                  secondaryButtonWidget: const Icon(
                    Icons.close,
                    size: 20,
                    color: Colors.black,
                  ),
                  buttonWidget: const Icon(
                    Icons.search,
                    size: 20,
                    color: Colors.black,
                  ),
                ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: refreshPatients,
                    child: buildPatientsList(),
                  ),
                )
              ],
            )),
      ),
    );
  }

  Widget buildPatientsList() {
    var currentList = isLoading ? [] : filteredPatientsList ?? patientsList;

    if (errorMessage != null) {
      return Center(
          child: Padding(
        padding: const EdgeInsets.only(top: 80.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(AssetConstants.nofavicon),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Text(
                errorMessage!,
                style: const TextStyle(
                    fontFamily: 'Humanist Sans',
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ));
    }

    if (isLoading) {
      return buildLoadingList();
    }

    if (currentList == null || currentList.isEmpty) {
      return Center(
          child: Padding(
        padding: const EdgeInsets.only(top: 80.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(AssetConstants.nofavicon),
            const Padding(
              padding: EdgeInsets.only(top: 20),
              child: Text(
                'No Patients Found',
                style: TextStyle(
                    fontFamily: 'Humanist Sans',
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ));
    }

    return ListView.builder(
      itemCount: currentList.length,
      itemBuilder: (context, index) {
        var patientsdata = currentList[index];
        return PatientsCard(
          name: patientsdata.firstName,
          date: patientsdata.entryDate,
          diagnosisStatus: patientsdata.diagnosis,
          lname: patientsdata.lastName,
          bvId: patientsdata.bvId,
          status: patientsdata.status,
          date_of_service: patientsdata.dateOfService,
          provider: patientsdata.provider,
          insurance_carrier: patientsdata.insuranceCarrier,
          approved_for: patientsdata.approvedFor,
          valid_till: patientsdata.validTill,
          company: patientsdata.company,
          policy_number: patientsdata.policyNumber,
          dob: patientsdata.dateOfBirth,
          diagnosis: patientsdata.diagnosis,
        );
      },
    );
  }

  Widget buildLoadingList() {
    return ListView.builder(
      itemCount: 6,
      itemBuilder: (context, index) {
        return Padding(
          padding:
              const EdgeInsets.only(left: 9.0, right: 9.0, top: 0, bottom: 7),
          child: Card(
            elevation: 1.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        color: Colors.grey[300],
                        width: 85,
                        height: 85,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            width: 70,
                            height: 15,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(30),
                                  bottomRight: Radius.circular(30)),
                            ),
                          ),
                        ),
                        SizedBox(height: Get.height * 0.005),
                        Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            width: double.infinity,
                            height: 14,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(30),
                                  bottomRight: Radius.circular(30)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    children: <Widget>[
                      Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(2),
                          ),
                          height: 18,
                          width: 28,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 32.0),
                        child: Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(5),
                            ),
                            height: 22,
                            width: 62,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

String formatDate(String rawDate) {
  return rawDate.split('T')[0];
}

Color? getStatusColor(String status, {bool forText = false}) {
  switch (status.toLowerCase()) {
    case 'pending':
      return forText ? Colors.red : Colors.red[100];
    case 'verified':
      return forText
          ? const Color.fromRGBO(87, 173, 0, 1)
          : const Color.fromRGBO(87, 173, 0, 0.2);
    case 'rejected':
      return forText ? Colors.grey : Colors.grey[300];
    case 'shipped':
      return forText
          ? const Color.fromARGB(255, 138, 138, 139)
          : Colors.blue[100];
    default:
      return null;
  }
}

class PatientsCard extends StatelessWidget {
  final String name;
  final String lname;
  final String date;
  final String diagnosisStatus;
  final String bvId;
  final String status;
  final String company;
  final String date_of_service;
  final String provider;
  final String approved_for;
  final String valid_till;
  final String insurance_carrier;
  final String diagnosis;
  final String dob;

  final int policy_number;

  const PatientsCard(
      {required this.name,
      required this.lname,
      required this.date,
      required this.diagnosisStatus,
      required this.bvId,
      required this.company,
      required this.approved_for,
      required this.valid_till,
      required this.status,
      required this.policy_number,
      required this.date_of_service,
      required this.insurance_carrier,
      required this.diagnosis,
      required this.dob,
      required this.provider});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              if (status == 'VERIFIED') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BenefitVerifcationDetails(
                      data: bvId,
                      date: date,
                      fname: name,
                      lname: lname,
                      aprroved_for: approved_for,
                      valid_until: valid_till,
                      company: company,
                      provider: provider,
                      insurance_carrier: insurance_carrier,
                      policy_number: policy_number,
                      diagnosis: diagnosis,
                      date_of_service: date_of_service,
                      dob: dob,
                      status: status,
                    ),
                  ),
                );
              } else if (status == 'REJECTED') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DataSubmisiion2(data: bvId),
                  ),
                );
              }
            },
            child: Card(
              color: Colors.white,
              margin: EdgeInsets.zero,
              elevation: 1.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(0),
                    child: ClipRRect(
                      child: Container(
                        decoration: BoxDecoration(
                            color: const Color.fromRGBO(233, 244, 250, 1),
                            borderRadius: BorderRadius.circular(10)),
                        width: 85,
                        height: 85,
                        child: Center(
                            child: Text(
                          "# " + policy_number.toString(),
                          style: const TextStyle(
                              color: Color.fromRGBO(3, 111, 173, 1),
                              fontWeight: FontWeight.w500,
                              fontSize: 13),
                        )),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0, top: 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(height: Get.height * 0.01),
                          Text(
                            name,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Segoe UI',
                              fontSize: 15,
                            ),
                          ),
                          SizedBox(height: Get.height * 0.02),
                          Text(
                            formatDate(date),
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Segoe UI',
                              fontSize: 14,
                              color: Color.fromARGB(255, 103, 103, 103),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: Get.height * 0.01),
                        Padding(
                          padding: const EdgeInsets.only(right: 1.0),
                          child: Text(
                            diagnosisStatus,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Segoe UI',
                              fontSize: 14,
                            ),
                          ),
                        ),
                        SizedBox(height: Get.height * 0.016),
                        Padding(
                          padding: const EdgeInsets.only(right: 12.0, top: 2),
                          child: Container(
                            height: 20,
                            width: 55,
                            decoration: BoxDecoration(
                                color: getStatusColor(status),
                                borderRadius: BorderRadius.circular(3)),
                            child: Center(
                              child: Text(
                                status,
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontFamily: 'Segoe UI',
                                  fontSize: 11,
                                  color: getStatusColor(status, forText: true),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
