import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:ronce_tuban_app/models/region_model.dart';
import 'package:ronce_tuban_app/pages/favorite_page.dart';
import 'package:ronce_tuban_app/pages/quiz_intro_page.dart';
import 'package:ronce_tuban_app/pages/region_detail_page.dart';
import 'package:ronce_tuban_app/pages/search_page.dart';
import 'package:ronce_tuban_app/providers/auth_provider.dart';
import 'package:ronce_tuban_app/providers/tradition_provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _openRegion(BuildContext context, [RegionModel? region]) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => RegionDetailPage(region: region)),
    );
  }

  void _openQuiz(BuildContext context, RegionModel region) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => QuizIntroPage(region: region)),
    );
  }

  void _openFavorite(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const FavoritePage()),
    );
  }

  void _openSearch(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const SearchPage()),
    );
  }

  void _openProfile(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const _ProfilePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TraditionProvider>();
    final regions = provider.regions;

    return Scaffold(
      backgroundColor: const Color(0xFFFFFDFA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEAF4F7),
                      borderRadius: BorderRadius.circular(11),
                    ),
                    child: const Icon(
                      Icons.auto_stories_rounded,
                      color: Color(0xFF247BA0),
                      size: 19,
                    ),
                  ),
                  const SizedBox(width: 9),
                  const Text(
                    'Ronce Tuban',
                    style: TextStyle(
                      fontFamily: 'Serif',
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E3A4C),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Material(
                color: const Color(0xFFF1F5F5),
                borderRadius: const BorderRadius.all(Radius.circular(15)),
                child: InkWell(
                  onTap: () => _openSearch(context),
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 13,
                      vertical: 13,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.search_rounded,
                          size: 19,
                          color: Color(0xFF72909C),
                        ),
                        SizedBox(width: 9),
                        Expanded(
                          child: Text(
                            'Cari daerah atau cerita tradisi',
                            style: TextStyle(
                              color: Color(0xFF82939A),
                              fontSize: 12,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.tune_rounded,
                          color: Color(0xFF72909C),
                          size: 17,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              ...regions.map((region) {
                final tradition = region.tradisiList.first;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _RegionCard(
                    region: region,
                    isFavorite: tradition.isFavorite,
                    onOpen: () => _openRegion(context, region),
                    onFavorite: () => provider.toggleFavorit(tradition),
                    onQuiz: region.kuisList.isEmpty
                        ? null
                        : () => _openQuiz(context, region),
                  ),
                );
              }),
              const SizedBox(height: 12),
              const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    size: 13,
                    color: Color(0xFF82939A),
                  ),
                  SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      'Dokumentasi tradisi Dus-Dusan di Palang.',
                      style: TextStyle(
                        fontSize: 10,
                        height: 1.4,
                        color: Color(0xFF82939A),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 3),
              const Padding(
                padding: EdgeInsets.only(left: 18),
                child: Text(
                  'Foto tradisi Dus-Dusan: iNews',
                  style: TextStyle(
                    fontSize: 9,
                    color: Color(0xFF82939A),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.fromLTRB(18, 9, 18, 7),
          decoration: const BoxDecoration(
            color: Color(0xFFFFFDFA),
            border: Border(top: BorderSide(color: Color(0xFFE9EDEA))),
          ),
          child: Row(
            children: [
              Expanded(
                child: _NavItem(
                  icon: Icons.explore_rounded,
                  label: 'Eksplorasi',
                  active: true,
                  onTap: () {},
                ),
              ),
              Expanded(
                child: _NavItem(
                  icon: Icons.favorite_border_rounded,
                  label: 'Favorit',
                  onTap: () => _openFavorite(context),
                ),
              ),
              Expanded(
                child: _NavItem(
                  icon: Icons.person_outline_rounded,
                  label: 'Profil',
                  onTap: () => _openProfile(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RegionCard extends StatelessWidget {
  final RegionModel region;
  final bool isFavorite;
  final VoidCallback onOpen;
  final VoidCallback onFavorite;
  final VoidCallback? onQuiz;

  const _RegionCard({
    required this.region,
    required this.isFavorite,
    required this.onOpen,
    required this.onFavorite,
    this.onQuiz,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(19),
        border: Border.all(color: const Color(0xFFE6EAE8)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A1E3A4C),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Stack(
              children: [
                Image.network(
                  region.tradisiList.first.gambarUrl,
                  width: double.infinity,
                  height: 148,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: double.infinity,
                    height: 148,
                    color: const Color(0xFFE5F3FB),
                    child: const Icon(
                      Icons.auto_awesome_rounded,
                      color: Color(0xFF247BA0),
                      size: 42,
                    ),
                  ),
                ),
                Positioned(
                  right: 10,
                  top: 10,
                  child: Material(
                    color: const Color(0xF0FFFFFF),
                    shape: const CircleBorder(),
                    child: IconButton(
                      tooltip: isFavorite
                          ? 'Hapus dari favorit'
                          : 'Simpan ke favorit',
                      onPressed: onFavorite,
                      constraints:
                          const BoxConstraints.tightFor(width: 36, height: 36),
                      padding: EdgeInsets.zero,
                      icon: Icon(
                        isFavorite
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        size: 19,
                        color: const Color(0xFFEF6B5B),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Text(
                  region.nama,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E3A4C),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF4F7),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${region.tradisiList.length} tradisi',
                  style: const TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF247BA0),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            region.tradisiList.first.nama,
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF71828A),
            ),
          ),
          const SizedBox(height: 9),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: onOpen,
                  borderRadius: BorderRadius.circular(10),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Jelajahi daerah',
                          style: TextStyle(
                            color: Color(0xFF247BA0),
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 4),
                        Icon(
                          Icons.arrow_forward_rounded,
                          size: 13,
                          color: Color(0xFF247BA0),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (onQuiz != null)
                InkWell(
                  onTap: onQuiz,
                  borderRadius: BorderRadius.circular(10),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 6),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.quiz_outlined,
                          size: 13,
                          color: Color(0xFF537A83),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Kuis ${region.nama}',
                          style: const TextStyle(
                            color: Color(0xFF537A83),
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    this.active = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = active ? const Color(0xFF247BA0) : const Color(0xFF859399);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 9,
                fontWeight: active ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfilePage extends StatelessWidget {
  const _ProfilePage();

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.user;
    return Scaffold(
      backgroundColor: const Color(0xFFFFFDFA),
      appBar: AppBar(
        title: const Text(
          'Profil',
          style: TextStyle(
            color: Color(0xFF1E3A4C),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircleAvatar(
                radius: 38,
                backgroundColor: Color(0xFFEAF4F7),
                child: Icon(
                  Icons.person_outline_rounded,
                  color: Color(0xFF247BA0),
                  size: 38,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                user?.name ?? 'Pengunjung',
                style: const TextStyle(
                  color: Color(0xFF1E3A4C),
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                user?.email ??
                    'Kamu sedang menjelajahi cerita budaya Tuban sebagai tamu.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFF71828A),
                  fontSize: 13,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 18),
              OutlinedButton.icon(
                onPressed: () async {
                  final auth = context.read<AuthProvider>();
                  try {
                    await auth.signOut();
                    if (context.mounted) {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    }
                  } on DatabaseException {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content:
                              Text('Tidak dapat mengakhiri sesi. Coba lagi.'),
                        ),
                      );
                    }
                  }
                },
                icon: const Icon(Icons.logout_rounded),
                label: Text(
                  user == null ? 'Keluar dari mode tamu' : 'Keluar dari akun',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
