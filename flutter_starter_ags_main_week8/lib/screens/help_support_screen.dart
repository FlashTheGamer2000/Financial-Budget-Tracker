import 'package:flutter/material.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> phoneNumbers = [
      {'title': 'Customer Care (Main)', 'number': '+62 813-2902-1001'},
      {'title': 'Customer Care (Secondary)', 'number': '+62 878-3009-1699'},
      {'title': 'Technical Support', 'number': '+62 819-3414-3771'},
      {'title': 'Account & Billing', 'number': '+62 813-8859-6985'},
      {'title': 'Emergency Helpline', 'number': '+62 813-8155-5790'},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        title: const Text(
          'Help & Support',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        backgroundColor: const Color(0xFF1E293B),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Need Assistance?',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Contact our support team directly via phone or email.',
              style: TextStyle(fontSize: 14, color: Color(0xFF64748B)),
            ),
            const SizedBox(height: 20),

            // Email Support Card
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFF1E293B),
                  child: Icon(Icons.email, color: Colors.white, size: 20),
                ),
                title: const Text(
                  'Email Support',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: const Text('nicholas.student@altaglobalsch.com'),
                trailing: IconButton(
                  icon: const Icon(Icons.copy, color: Color(0xFF64748B)),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Email copied to clipboard!')),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 24),

            const Text(
              'Phone Helpline Numbers',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 12),

            // Phone Numbers List
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: phoneNumbers.length,
                separatorBuilder: (ctx, idx) =>
                    const Divider(height: 1, indent: 16, endIndent: 16),
                itemBuilder: (ctx, idx) {
                  final item = phoneNumbers[idx];
                  return ListTile(
                    leading: const Icon(
                      Icons.phone_outlined,
                      color: Color(0xFF1E293B),
                    ),
                    title: Text(
                      item['title']!,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    subtitle: Text(
                      item['number']!,
                      style: const TextStyle(color: Color(0xFF64748B)),
                    ),
                    trailing: const Icon(
                      Icons.chevron_right,
                      color: Color(0xFF94A3B8),
                    ),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Calling ${item['number']}...')),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
