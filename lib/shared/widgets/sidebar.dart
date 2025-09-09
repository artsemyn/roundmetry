import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:roundmetry/main.dart';

import '../../main.dart'; // <-- 1. Tambahkan import ini

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(right: BorderSide(color: Colors.grey[300]!, width: 1)),
      ),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(24.0),
            child: Row(
              children: [
                Icon(Icons.star, color: Colors.green, size: 28),
                SizedBox(width: 10),
                Text(
                  'ROUND GEOMETRY',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
          // 2. Tambahkan properti onTap pada setiap ListTile
          Expanded(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.home_rounded),
                  title: const Text('Beranda'),
                  onTap: () {
                    // Navigasi ke rute '/' yang sudah kita definisikan
                    context.go('/');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.book_rounded),
                  title: const Text('Materi'),
                  onTap: () {
                    // Navigasi ke rute '/materi'
                    context.go('/materi');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.person_rounded),
                  title: const Text('Profil'),
                  onTap: () {
                    // Rute untuk profil belum kita buat, jadi kita beri komentar dulu
                    // context.go('/profil');
                    print('Tombol Profil diklik!');
                  },
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.logout), // Ganti ikon menjadi logout
            title: const Text('Logout'),      // Ganti teks menjadi Logout
            onTap: () async {
              // Panggil fungsi signOut dari Supabase
              await supabase.auth.signOut();
            },
          ),
        ],
      ),
    );
  }
}
