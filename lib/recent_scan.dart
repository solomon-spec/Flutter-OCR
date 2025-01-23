// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';

// class RecentScansPage extends StatefulWidget {
//   @override
//   _RecentScansPageState createState() => _RecentScansPageState();
// }

// class _RecentScansPageState extends State<RecentScansPage> {
//   List<Map<String, String>> _scans = [];
//   bool _isLoading = true;
//   String _errorMessage = '';

//   @override
//   void initState() {
//     super.initState();
//     _fetchRecentScans();
//   }

//   // Function to retrieve the stored token
//   Future<String?> _getToken() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString('auth_token');
//   }

//   // Function to fetch recent scans from the API
//   Future<void> _fetchRecentScans() async {
//     const url = 'http://192.168.27.62:5001/recent-scans';
//     final token = await _getToken();

//     if (token == null) {
//       setState(() {
//         _isLoading = false;
//         _errorMessage = 'No authentication token found. Please log in again.';
//       });
//       return;
//     }

//     try {
//       final response = await http.get(
//         Uri.parse(url),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $token', // Include the token in the header
//         },
//       );

//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         final List<dynamic> scans = data['scans']; // Assuming the response contains a 'scans' key

//         setState(() {
//           _scans = scans.map<Map<String, String>>((scan) {
//             return {
//               'date': scan['date'],
//               'text': scan['text'],
//             };
//           }).toList();
//           _isLoading = false;
//         });
//       } else {
//         setState(() {
//           _isLoading = false;
//           _errorMessage = 'Failed to load scans: ${response.body}';
//         });
//       }
//     } catch (e) {
//       setState(() {
//         _isLoading = false;
//         _errorMessage = 'An error occurred: $e';
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Recent Scans'),
//         backgroundColor: Colors.purple,
//       ),
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : _errorMessage.isNotEmpty
//               ? Center(child: Text(_errorMessage, style: TextStyle(color: Colors.red)))
//               : _scans.isEmpty
//                   ? const Center(child: Text('No scans found.'))
//                   : ListView.builder(
//                       itemCount: _scans.length,
//                       itemBuilder: (context, index) {
//                         final scan = _scans[index];
//                         return Card(
//                           margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//                           child: ListTile(
//                             title: Text(scan['text']!),
//                             subtitle: Text(scan['date']!),
//                             trailing: const Icon(Icons.arrow_forward_ios, size: 16),
//                             onTap: () {
//                               // Handle tap on a scan (e.g., navigate to details page)
//                             },
//                           ),
//                         );
//                       },
//                     ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class RecentScansPage extends StatefulWidget {
  @override
  _RecentScansPageState createState() => _RecentScansPageState();
}

class _RecentScansPageState extends State<RecentScansPage> {
  List<Map<String, String>> _scans = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchRecentScans();
  }

  // Function to retrieve the stored token
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  // Function to fetch recent scans from the API
  Future<void> _fetchRecentScans() async {
    const url =
        'http://192.168.27.62:5001/recent-scans'; // Replace with your API endpoint
    final token = await _getToken();

    if (token == null) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'No authentication token found. Please log in again.';
      });
      return;
    }

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Include the token in the header
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> scans =
            data['scans']; // Assuming the response contains a 'scans' key

        setState(() {
          _scans = scans.map<Map<String, String>>((scan) {
            // Limit the text to 100 characters
            String textShort = scan['text'];
            if (textShort.length > 50) {
              textShort = textShort.substring(0, 50) + '...';
            }

            return {
              'date': scan['date'],
              'text': textShort,
              'fullText':
                  scan['text'], // Store the full text for details screen
            };
          }).toList();
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Failed to load scans: ${response.body}';
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'An error occurred: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recent Scans'),
        backgroundColor: Colors.purple,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
              ? Center(
                  child:
                      Text(_errorMessage, style: TextStyle(color: Colors.red)))
              : _scans.isEmpty
                  ? const Center(child: Text('No scans found.'))
                  : ListView.builder(
                      itemCount: _scans.length,
                      itemBuilder: (context, index) {
                        final scan = _scans[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 16),
                          child: ListTile(
                            title: Text(scan['text']!),
                            subtitle: Text(scan['date']!),
                            trailing:
                                const Icon(Icons.arrow_forward_ios, size: 16),
                            onTap: () {
                              // Navigate to ResultScreen with the full text
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ResultScreen(text: scan['fullText']!),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
    );
  }
}

// ResultScreen to display the full text of the scan
class ResultScreen extends StatelessWidget {
  final String text;

  const ResultScreen({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Result'),
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Text(
            text,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}
