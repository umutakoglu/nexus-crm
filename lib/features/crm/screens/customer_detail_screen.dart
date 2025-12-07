import 'package:crm/features/crm/models/customer_model.dart';
import 'package:flutter/material.dart';

class CustomerDetailScreen extends StatelessWidget {
  final CustomerModel customer;

  const CustomerDetailScreen({super.key, required this.customer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          customer.companyName ?? customer.authorizedPerson,
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // Gelecekte düzenleme özelliği eklenecek
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Düzenleme özelliği yakında...')),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Başlık Kartı
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Theme.of(
                        context,
                      ).primaryColor.withOpacity(0.1),
                      child: Icon(
                        customer.isCorporate ? Icons.business : Icons.person,
                        size: 40,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      customer.companyName ?? customer.authorizedPerson,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    if (customer.companyName != null &&
                        customer.isCorporate) ...[
                      const SizedBox(height: 8),
                      Text(
                        customer.authorizedPerson,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(color: Colors.grey[600]),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Bilgi Kartı
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  _buildDetailTile(
                    context,
                    icon: Icons.phone,
                    title: 'Telefon',
                    subtitle: customer.phone,
                  ),
                  const Divider(height: 1),
                  _buildDetailTile(
                    context,
                    icon: Icons.email,
                    title: 'E-posta',
                    subtitle: customer.email,
                  ),
                  const Divider(height: 1),
                  _buildDetailTile(
                    context,
                    icon: Icons.badge,
                    title: customer.isCorporate
                        ? 'Vergi Numarası'
                        : 'TC Kimlik No',
                    subtitle: customer.taxId,
                  ),
                  const Divider(height: 1),
                  _buildDetailTile(
                    context,
                    icon: Icons.location_on,
                    title: 'Adres',
                    subtitle: customer.address,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Theme.of(context).primaryColor),
      ),
      title: Text(
        title,
        style: const TextStyle(fontSize: 14, color: Colors.grey),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
    );
  }
}
