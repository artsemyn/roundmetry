import 'package:flutter/material.dart';
import 'package:roundmetry/shared/widgets/sidebar.dart';

class MainLayout extends StatelessWidget {
  // 'child' adalah halaman yang akan ditampilkan di area konten
  final Widget child;
  const MainLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Widget Sidebar yang sudah kita buat
          const Sidebar(),

          // Expanded memastikan area konten mengisi sisa ruang yang tersedia
          Expanded(
            child: child,
          ),
        ],
      ),
    );
  }
}