import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OffersGiftsSpecialistScreen extends StatelessWidget {
  final List<Map<String, dynamic>> activeOffers = [
    {
      'id': 'OFFER-001',
      'title': 'خصم الدفع المبكر',
      'discount': '10%',
      'participants': 125,
      'startDate': DateTime.now().subtract(Duration(days: 10)),
      'endDate': DateTime.now().add(Duration(days: 20)),
      'status': 'نشط',
    },
    {
      'id': 'OFFER-002',
      'title': 'برنامج النقاط',
      'discount': 'نقاط مكافأة',
      'participants': 890,
      'startDate': DateTime.now().subtract(Duration(days: 5)),
      'endDate': DateTime.now().add(Duration(days: 25)),
      'status': 'نشط',
    },
  ];

  final List<Map<String, dynamic>> activeGifts = [
    {
      'id': 'GIFT-001',
      'name': 'كوبون خصم 20%',
      'redeemed': 45,
      'total': 100,
      'expiryDate': DateTime.now().add(Duration(days: 15)),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('العروض والهدايا - الإدارة'),
        backgroundColor: Colors.purple[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // إحصائيات العروض
            Row(
              children: [
                _buildOfferStat('العروض النشطة', '3', Colors.purple),
                SizedBox(width: 12),
                _buildOfferStat('المشتركين', '1,015', Colors.blue),
                SizedBox(width: 12),
                _buildOfferStat('معدل الاستخدام', '78%', Colors.green),
              ],
            ),
            SizedBox(height: 20),

            // العروض الحالية
            Text(
              'العروض النشطة',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: activeOffers.length,
                itemBuilder: (context, index) {
                  return _buildOfferCard(activeOffers[index]);
                },
              ),
            ),

            // الهدايا النشطة
            Text(
              'الهدايا النشطة',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: activeGifts.length,
                itemBuilder: (context, index) {
                  return _buildGiftCard(activeGifts[index]);
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.card_giftcard),
        backgroundColor: Colors.purple[700],
      ),
    );
  }

  Widget _buildOfferStat(String title, String value, Color color) {
    return Expanded(
      child: Card(
        color: color.withOpacity(0.1),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              SizedBox(height: 4),
              Text(
                title,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOfferCard(Map<String, dynamic> offer) {
    return Card(
      margin: EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(Icons.local_offer, color: Colors.purple),
        title: Text(offer['title']),
        subtitle: Text(
          'الخصم: ${offer['discount']} • المشتركين: ${offer['participants']}',
        ),
        trailing: Chip(
          label: Text(offer['status']),
          backgroundColor: Colors.purple[100],
        ),
        onTap: () {},
      ),
    );
  }

  Widget _buildGiftCard(Map<String, dynamic> gift) {
    return Card(
      margin: EdgeInsets.only(bottom: 8),
      color: Colors.amber[50],
      child: ListTile(
        leading: Icon(Icons.card_giftcard, color: Colors.amber),
        title: Text(gift['name']),
        subtitle: Text('تم الاستبدال: ${gift['redeemed']}/${gift['total']}'),
        trailing: Text(DateFormat('yyyy-MM-dd').format(gift['expiryDate'])),
      ),
    );
  }
}
