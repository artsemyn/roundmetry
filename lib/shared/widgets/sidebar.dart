import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:roundmetry/main.dart';

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
          ListTile(
            leading: const Icon(Icons.home_rounded),
            title: const Text('Beranda'),
            onTap: () {
              context.go('/');
            },
          ),
          ListTile(
            leading: const Icon(Icons.book_rounded),
            title: const Text('Materi'),
            onTap: () {
              context.go('/materi-list');
            },
          ),
          ListTile(
            leading: const Icon(Icons.person_rounded),
            title: const Text('Profil'),
            onTap: () {
              context.go('/profil');
            },
          ),
          const Spacer(), // Mendorong logout ke bawah
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () async {
              await supabase.auth.signOut();
            },
          ),
        ],
      ),
    );
  }
}