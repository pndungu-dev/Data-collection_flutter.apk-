import 'package:connectivity/connectivity.dart';
import 'package:data_collection_app/global_params.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MainApp());
}

String? validateDOB(String value) {
  if (value.isEmpty) {
    return 'Please enter your date of birth';
  }

  // Regular expression for YYYY-MM-DD format
  RegExp regex = RegExp(r'^\d{4}-\d{2}-\d{2}$');

  if (!regex.hasMatch(value)) {
    return 'Use YYYY-MM-DD format';
  }

  List<String> parts = value.split('-');
  int year = int.tryParse(parts[0]) ?? 0;
  int month = int.tryParse(parts[1]) ?? 0;
  int day = int.tryParse(parts[2]) ?? 0;

  if (year < 1900 || year > DateTime.now().year) {
    return 'Please enter a valid year';
  }

  if (month < 1 || month > 12) {
    return 'Please enter a valid month';
  }

  if (day < 1 || day > 31) {
    return 'Please enter a valid day';
  }

  return null;
}

Future<bool> checkInternetConnection() async {
  try {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      return false;
    } else {
      return true;
    }
  } on Exception catch (e) {
    print(e);
  }
  return false;
}

Future<void> saveOnline(Map<String, dynamic> data) async {
  final url = APIEndpoints().POST_URL;
  final response = await http.post(Uri.parse(url), body: data);
  if (response.statusCode == 200) {
    Map<String, dynamic> responseData = jsonDecode(response.body);
    String message = responseData['message'];
    if (kDebugMode) {
      print(message);
    }
  } else {
    if (kDebugMode) {
      print("ERROR OCCURED\n");
    }
    try {
      Map<String, dynamic> errorResponse = jsonDecode(response.body);
      if (errorResponse.containsKey('message')) {
        if (kDebugMode) {
          print('Error: ${errorResponse['message']}');
        }
      } else {
        if (kDebugMode) {
          print('Error: ${response.body}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error: ${response.body}');
      }
    }
  }
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF253AA5),
          title: const Text(
            "Data Collection App",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: const SingleChildScrollView(child: MyForm()),
      ),
    );
  }
}

class MyForm extends StatefulWidget {
  const MyForm({super.key});

  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class MyCustomFormState extends State<MyForm> {
  final _formKey = GlobalKey<FormState>();
  final _surnameFocusNode = FocusNode();
  final _firstNameFocusNode = FocusNode();
  final _lastNameFocusNode = FocusNode();
  final _dobFocusNode = FocusNode();
  final _maritalFocusNode = FocusNode();

  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _siblingsController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();
  String? _selectedMaritalStatus;
  String? _selectedFundingStatus;

  @override
  void dispose() {
    _surnameFocusNode.dispose();
    _firstNameFocusNode.dispose();
    _lastNameFocusNode.dispose();
    _dobFocusNode.dispose();
    _maritalFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Please fill in the form below.\nAll fields marked with * are mandatory',
            style:
                TextStyle(fontStyle: FontStyle.italic, fontSize: 13, height: 1),
            textAlign: TextAlign.center,
          ),
          Form(
            key: _formKey,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        controller: _surnameController,
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please the Surname';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.text,
                        textCapitalization: TextCapitalization.characters,
                        decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: "Surname *"),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        controller: _firstNameController,
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please the first name';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.text,
                        textCapitalization: TextCapitalization.characters,
                        decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: "First name *"),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        controller: _lastNameController,
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the last name';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.text,
                        textCapitalization: TextCapitalization.characters,
                        decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: "Last name *"),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        controller: _dobController,
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          return validateDOB(value!);
                        },
                        keyboardType: TextInputType.datetime,
                        //textCapitalization: TextCapitalization.values,
                        decoration: const InputDecoration(
                            border: UnderlineInputBorder(), labelText: "DOB *"),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      flex: 2,
                      child: DropdownButtonFormField<String>(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Choose your marital status';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          // Handle the selected value here
                          setState(() {
                            _selectedMaritalStatus = value!;
                          });
                        },
                        items: <String>[
                          'Single',
                          'Married',
                          'Divorced',
                          'Widowed'
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: "Marital Status *",
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: DropdownButtonFormField<String>(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Yes or No';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          // Handle the selected value here
                          setState(() {
                            _selectedFundingStatus = value!;
                          });
                        },
                        items: <String>[
                          'Yes',
                          'No',
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          labelStyle: TextStyle(fontSize: 18),
                          labelText: "Funded before? *",
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      flex: 1,
                      child: TextFormField(
                        controller: _siblingsController,
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              int.parse(value) < 0) {
                            return 'How many 0,1,2...';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: "Siblings *"),
                      ),
                    ),
                  ],
                ),
                TextFormField(
                  controller: _commentController,
                  maxLines: 5,
                  keyboardType: TextInputType.multiline,
                  maxLength: 100,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Any other comment"),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: ElevatedButton(
                    onPressed: () async {
                      // Validate returns true if the form is valid, or false otherwise.
                      if (_formKey.currentState!.validate()) {
                        // If the form is valid, display a snackbar. In the real world,
                        // you'd often call a server or save the information in a database.
                        Map<String, dynamic> formData = {
                          'surname': _surnameController.text,
                          'firstname': _firstNameController.text,
                          'lastname': _lastNameController.text,
                          'dob': _dobController.text,
                          'marital': _selectedMaritalStatus,
                          'funded': _selectedFundingStatus,
                          'siblings': _siblingsController.text,
                          'comment': _commentController.text,
                        };
                        if (kDebugMode) {
                          print(formData);
                          if (await checkInternetConnection()) {
                            print('We have internet');
                            saveOnline(formData);
                          } else {
                            print('Oops! We dont have internet');
                            print('Oops! We dont have internet');
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      'No active internet connection. Saving to local db')),
                            );
                          }
                        }
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Processing Data')),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Saved')),
                        );
                      }
                    },
                    child: const Text('Submit'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: ElevatedButton(
                    onPressed: () {
                      _surnameController.text = 'JOHN';
                      _firstNameController.text = 'ALI';
                      _lastNameController.text = 'JAMES';
                      _dobController.text = '2008-01-23';
                      _siblingsController.text = '8';
                      _commentController.text = "Humble family";
                      setState(() {
                        _selectedMaritalStatus = 'Single';
                        _selectedFundingStatus = 'No';
                      });
                    },
                    child: const Text('Autofill'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
