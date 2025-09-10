import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9), // Latar belakang yang lebih lembut
      appBar: AppBar(
        title: const Text('Beranda', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          // Hero Banner
          _buildHeroBanner(context),
          const SizedBox(height: 32),

          // Kartu Statistik
          _buildStatsCards(),
          const SizedBox(height: 32),
          
          // Daftar Materi Terbaru
          _buildRecentMaterials(context),
        ],
      ),
    );
  }

  // Widget untuk Hero Banner
  Widget _buildHeroBanner(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF15803D), Color(0xFF69BF64)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Continue Your Learning Journey',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 8),
          const Text(
            'Explore new materials and practice questions',
            style: TextStyle(fontSize: 18, color: Colors.white70),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => context.go('/materi-list'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF15803D),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Start Learning', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(width: 8),
                Icon(Icons.arrow_forward, size: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget untuk Kartu Statistik
  Widget _buildStatsCards() {
    return GridView.count(
      crossAxisCount: 4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 0.9,
      children: [
        _StatCard(icon: Icons.book, title: 'Completed Materials', value: '12', subtitle: '+2 last week'),
        _StatCard(icon: Icons.trending_up, title: 'Practice Score', value: '85%', subtitle: 'Average'),
        _StatCard(icon: Icons.star, title: 'XP Gained', value: '1,250', subtitle: '+70 today'),
        _StatCard(icon: Icons.access_time, title: 'Study Time', value: '24h', subtitle: 'This month'),
      ],
    );
  }

  // Widget untuk daftar Materi dengan kartu yang lebih kecil
  Widget _buildRecentMaterials(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Recent Materials', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            TextButton(
              onPressed: () => context.go('/materi-list'),
              child: const Text('View All', style: TextStyle(color: Color(0xFF15803D))),
            ),
          ],
        ),
        const SizedBox(height: 16),
        GridView.count(
          crossAxisCount: 4, // <-- Menggunakan 4 kolom agar kartu lebih kecil
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 0.8, // <-- Rasio disesuaikan agar pas
          children: List.generate(4, (index) => _MaterialCard(index: index + 1)),
        ),
      ],
    );
  }
}

// Widget kustom untuk kartu statistik
class _StatCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final String subtitle;

  const _StatCard({required this.icon, required this.title, required this.value, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: const Color(0xFFF0FDF4),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(child: Text(title, style: const TextStyle(fontSize: 14, color: Colors.black54), overflow: TextOverflow.ellipsis)),
                Icon(icon, color: Colors.grey.shade400, size: 20),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF15803D))),
                Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            )
          ],
        ),
      ),
    );
  }
}

// Widget kustom untuk kartu materi
class _MaterialCard extends StatelessWidget {
  final int index;
  const _MaterialCard({required this.index});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              color: Colors.grey.shade300,
              child: const Center(child: Icon(Icons.image, color: Colors.grey, size: 40)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('MATERI $index', style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  icon: const Icon(Icons.download, size: 16),
                  label: const Text('Download'),
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 36),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}