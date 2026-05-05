import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'services/api_service.dart';
import 'services/auth_service.dart';
import 'services/user_session.dart';
import 'widgets/shared_widgets.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _settingHome = false;

  Future<void> _defineHomePosition() async {
    if (_settingHome) return;
    setState(() => _settingHome = true);

    try {
      // Demande la permission GPS
      final status = await Permission.locationWhenInUse.request();
      if (!status.isGranted) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Permission de localisation refusée'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Vérifie que le GPS est activé
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Activez le GPS pour définir votre position'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Récupère la position courante
      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 15),
        ),
      );

      // Sauvegarde côté serveur
      await ApiService.updateHomePosition(
        latitude: pos.latitude,
        longitude: pos.longitude,
      );

      // Recharge le profil pour que session.hasHome devienne true
      await UserSession().loadProfile();

      if (!mounted) return;
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Position du domicile enregistrée'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur : $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _settingHome = false);
    }
  }

  Future<void> _logout() async {
    await AuthService.signOut();
    UserSession().clear();
    if (mounted) {
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    }
  }

  String _formatDate(String? isoDate) {
    if (isoDate == null) return 'N/A';
    try {
      final dt = DateTime.parse(isoDate);
      return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
    } catch (_) {
      return isoDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    final session = UserSession();

    return Scaffold(
      backgroundColor: AppColors.indigo,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              ScoreBar(
                score: session.score,
                streak: session.streak,
                avatarUrl: session.avatarUrl,
              ),
              const SizedBox(height: 24),
              _buildProfileCard(session),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const AppBottomNav(currentRoute: '/profile'),
    );
  }

  Widget _buildProfileCard(UserSession session) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.indigoDark,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 70,
            backgroundColor: const Color(0xFFBDBDBD),
            backgroundImage:
                session.avatarUrl != null ? NetworkImage(session.avatarUrl!) : null,
            child: session.avatarUrl == null
                ? const Icon(Icons.person, size: 60, color: Colors.white)
                : null,
          ),
          const SizedBox(height: 16),
          _buildButton('Change avatar', () {
            // TODO: implement avatar picker
          }),
          const SizedBox(height: 24),
          _buildInfoRow('Your name', session.nickname),
          _buildInfoRow('Total steps', session.totalSteps.toString()),
          _buildInfoRow('Inscription', _formatDate(session.dateCreation)),
          _buildInfoRow('Home position', session.hasHome ? 'Defined' : 'Not defined'),
          const SizedBox(height: 24),
          _buildButton(
            _settingHome ? 'Locating...' : 'Define home position',
            _settingHome ? () {} : _defineHomePosition,
          ),
          const SizedBox(height: 12),
          _buildButton('Disconnect', _logout,
              color: AppColors.pinkAccent.withOpacity(0.7)),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '$label : ',
            style: const TextStyle(color: Colors.white70, fontSize: 16),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(
    String label,
    VoidCallback onTap, {
    Color color = AppColors.pinkAccent,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14),
          elevation: 4,
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: AppColors.indigo,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
