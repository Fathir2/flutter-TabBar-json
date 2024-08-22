import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainTabBar(),
    );
  }
}

class MainTabBar extends StatefulWidget {
  @override
  _MainTabBarState createState() => _MainTabBarState();
}

class _MainTabBarState extends State<MainTabBar> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this); // 3 tabs
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tab Bar Example'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(icon: Icon(Icons.info), text: 'Kesehatan'),
            Tab(icon: Icon(Icons.home), text: 'Home'),
            Tab(icon: Icon(Icons.place), text: 'Pariwisata'),
            Tab(icon: Icon(Icons.person), text: 'Profile'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          DataListScreen(),  // Halaman untuk data kesehatan
          HomeScreen(),      // Placeholder untuk halaman Home
          PariwisataScreen(), // Placeholder untuk halaman Pariwisata
// Suggested code may be subject to a license. Learn more: ~LicenseLog:2429726846.
          ProfileScreen(name: 'Sagtiana Fathir'),    // Placeholder untuk halaman Profile
        ],
      ),
    );
  }
}

// Halaman pertama yang menggunakan API
class DataListScreen extends StatelessWidget {
  Future<List<User>> fetchUsers() async {
    final response = await http.get(Uri.parse(
        'https://ws.jakarta.go.id/gateway/DataPortalSatuDataJakarta/1.0/satudata?kategori=dataset&tipe=detail&url=data-pelayanan-gawat-darurat-level-1-satu-yang-harus-diberikan-sarana-kesehatan-rs'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['data'];
      return data.map((user) => User.fromJson(user)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Info Kesehatan'),
      ),
      body: FutureBuilder<List<User>>(
        future: fetchUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No data available'));
          } else {
            final users = snapshot.data!;
            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return ListTile(
                  title: Text(user.periodeData),
                  subtitle: Text(user.jenisRumahSakit),
                );
              },
            );
          }
        },
      ),
    );
  }
}

// Model untuk API data
class User {
  final String periodeData;
  final String jenisRumahSakit;

  User({required this.jenisRumahSakit, required this.periodeData});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      periodeData: json['periode_data'],
      jenisRumahSakit: json['jenis_rumah_sakit'],
    );
  }
}

// Placeholder untuk halaman Home
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Welcome to Home Screen'),
    );
  }
}

// Placeholder untuk halaman Pariwisata

class PariwisataScreen extends StatelessWidget {
  Future<List<Pariwisata>> fetchPariwisata() async {
    final response = await http.get(Uri.parse(
        'https://ws.jakarta.go.id/gateway/DataPortalSatuDataJakarta/1.0/satudata?kategori=dataset&tipe=detail&url=jumlah-usaha-jasa-makanan-dan-minuman-pariwisata-yang-memiliki-perizinan'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['data'];
      return data.map((pariwisata) => Pariwisata.fromJson(pariwisata)).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Info Pariwisata'),
      ),
      body: FutureBuilder<List<Pariwisata>>(
        future: fetchPariwisata(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No data available'));
          } else {
            final pariwisataList = snapshot.data!;
            return ListView.builder(
              itemCount: pariwisataList.length,
              itemBuilder: (context, index) {
                final pariwisata = pariwisataList[index];
                return ListTile(
                  title: Text(pariwisata.periodeData),
                  subtitle: Text(pariwisata.jenisRumahSakit),
                );
              },
            );
          }
        },
      ),
    );
  }
}

// Model untuk API data
class Pariwisata {
  final String periodeData;
  final String jenisRumahSakit;

  Pariwisata({required this.jenisRumahSakit, required this.periodeData});

  factory Pariwisata.fromJson(Map<String, dynamic> json) {
    return Pariwisata(
      periodeData: json['periode_data'],
      jenisRumahSakit: json['jenis_usaha'],
    );
  }
}

class ProfileScreen extends StatelessWidget {
  final String name;

  ProfileScreen({required this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Center(
        child: Text(
          'Nama: $name',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}