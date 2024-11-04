import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appwrite/models.dart' as models;
import '../../providers/auth_provider.dart';
import '../profile/profile_screen.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: authState.when(
        data: (user) => user != null
            ? _buildDashboardContent(context, user, ref)
            : const Center(child: Text('Not logged in', style: TextStyle(color: Colors.white))),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error', style: TextStyle(color: Colors.white))),
      ),
    );
  }

  Widget _buildDashboardContent(BuildContext context, models.User user, WidgetRef ref) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildProfileAndBalanceSection(context, ref),
          const SizedBox(height: 16),
          _buildSendReceiveAndPaymentSection(),
          const SizedBox(height: 16),
          _buildTransactionHistorySection(),
          const SizedBox(height: 16),
          _buildLogoutButton(context, ref), // Tombol logout
        ],
      ),
    );
  }

  Widget _buildProfileAndBalanceSection(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1F1F1F),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ProfileScreen()),
                  );
                },
                child: CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.grey[800],
                  child: const Icon(Icons.person, color: Colors.white, size: 32),
                ),
              ),
              const SizedBox(width: 16),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('80% Akun perlu diamankan', style: TextStyle(color: Colors.white)),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.shield, color: Colors.green, size: 16),
                        const SizedBox(width: 4),
                        const Text('80%', style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Text(
                'Rp971',
                style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.remove_red_eye, color: Colors.white),
                onPressed: () {},
              ),
            ],
          ),
          const Text(
            'Coins 98',
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildBalanceActionButton(Icons.add, 'Top Up', Colors.green),
              _buildBalanceActionButton(Icons.arrow_downward, 'Tarik Tunai', Colors.green),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceActionButton(IconData icon, String label, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 30),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(color: color)),
      ],
    );
  }

  Widget _buildSendReceiveAndPaymentSection() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF1F1F1F),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('Kirim & Terima', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Wrap(
                alignment: WrapAlignment.spaceAround,
                spacing: 8,
                children: [
                  _buildIconButton(Icons.account_balance_wallet, 'Dana', Colors.blue),
                  _buildIconButton(Icons.person, 'Wanger', Colors.blue),
                  _buildIconButton(Icons.account_balance_wallet, 'Dana', Colors.blue),
                  _buildIconButton(Icons.account_balance_wallet, 'Dana', Colors.blue),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF1F1F1F),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('Pembayaran', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Wrap(
                alignment: WrapAlignment.spaceAround,
                spacing: 8,
                children: [
                  _buildIconButton(Icons.phone_android, 'Pulsa', Colors.green),
                  _buildIconButton(Icons.flash_on, 'PLN', Colors.green),
                  _buildIconButton(Icons.wifi, 'Paket Data', Colors.green),
                  _buildIconButton(Icons.account_balance_wallet, 'e-Money', Colors.green),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildIconButton(IconData icon, String label, Color color) {
    return Column(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: color.withOpacity(0.2),
          child: Icon(icon, color: color),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
      ],
    );
  }

  Widget _buildTransactionHistorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text('Riwayat Transaksi', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        _buildTransactionItem('Google Play', '-Rp1.332', 'Tabungan by Jago'),
        const SizedBox(height: 8),
        _buildTransactionItem('Cashback Xcash', '98', 'GoPay Coins'),
      ],
    );
  }

  Widget _buildTransactionItem(String title, String amount, String description) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1F1F1F),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: Colors.white, fontSize: 16)),
              Text(description, style: const TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
          Text(amount, style: const TextStyle(color: Colors.white, fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () async {
        await ref.read(authProvider.notifier).logout();
        // Arahkan ke halaman login setelah logout
        Navigator.of(context).pushReplacementNamed('/login');
      },
      child: const Text('Logout'),
    );
  }
}
