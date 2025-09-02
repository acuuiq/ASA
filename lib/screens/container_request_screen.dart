import 'package:flutter/material.dart';

class ContainerRequestScreen extends StatefulWidget {
  final List<Map<String, dynamic>> containerTypes;
  final Color serviceColor;
  final bool isFirstContainerFree;

  const ContainerRequestScreen({
    super.key,
    required this.containerTypes,
    required this.serviceColor,
    required this.isFirstContainerFree,
  });

  @override
  _ContainerRequestScreenState createState() => _ContainerRequestScreenState();
}
//
class _ContainerRequestScreenState extends State<ContainerRequestScreen> {
  late String _selectedContainerType;
  int _quantity = 1;
  bool _needsInstallation = true;
  String? _specialInstructions;
  String? _selectedLocation;
  final List<String> _locations = [
    'أمام المنزل',
    'خلف المنزل',
    'بجانب البوابة',
    'مكان آخر (حدد في الملاحظات)'
  ];

  @override
  void initState() {
    super.initState();
    _selectedContainerType = widget.containerTypes.first['type'];
  }

  void _submitRequest() {
    final selectedContainer = widget.containerTypes.firstWhere(
      (c) => c['type'] == _selectedContainerType,
    );
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تأكيد الطلب'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, size: 60, color: Colors.green),
            const SizedBox(height: 20),
            const Text(
              'هل أنت متأكد من طلب الحاوية؟',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            Text(
              '${selectedContainer['type']} × $_quantity',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              'المبلغ الإجمالي: ${selectedContainer['price'] * _quantity} دينار',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('تم تقديم طلب الحاوية بنجاح'),
                  backgroundColor: Colors.green,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: widget.serviceColor,
            ),
            child: const Text('تأكيد'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedContainer = widget.containerTypes.firstWhere(
      (c) => c['type'] == _selectedContainerType,
    );

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('اختر نوع الحاوية'),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 150,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.containerTypes.length,
                      itemBuilder: (context, index) {
                        final container = widget.containerTypes[index];
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedContainerType = container['type'];
                            });
                          },
                          child: Container(
                            width: 140,
                            margin: const EdgeInsets.only(right: 12),
                            decoration: BoxDecoration(
                              color: _selectedContainerType == container['type']
                                  ? widget.serviceColor.withOpacity(0.1)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: _selectedContainerType == container['type']
                                    ? widget.serviceColor
                                    : Colors.grey[300]!,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  container['icon'],
                                  size: 40,
                                  color: container['color'],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  container['type'],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: _selectedContainerType == container['type']
                                        ? widget.serviceColor
                                        : Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${container['price']} دينار',
                                  style: TextStyle(
                                    color: _selectedContainerType == container['type']
                                        ? widget.serviceColor
                                        : Colors.grey[700],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  
                  const SizedBox(height: 20),

                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                selectedContainer['icon'],
                                size: 30,
                                color: selectedContainer['color'],
                              ),
                              const SizedBox(width: 10),
                              Text(
                                selectedContainer['type'],
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          _buildDetailRow('السعر:', '${selectedContainer['price']} دينار'),
                          _buildDetailRow('الأبعاد:', selectedContainer['dimensions']),
                          _buildDetailRow('الوزن:', selectedContainer['weight']),
                          const SizedBox(height: 8),
                          Text(
                            selectedContainer['description'],
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 20),

                  _buildSectionTitle('الكمية المطلوبة'),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.remove,
                            color: _quantity > 1 ? widget.serviceColor : Colors.grey,
                          ),
                          onPressed: _quantity > 1
                              ? () => setState(() => _quantity--)
                              : null,
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              '$_quantity',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.add,
                            color: widget.serviceColor,
                          ),
                          onPressed: () => setState(() => _quantity++),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  SwitchListTile(
                    title: const Text('تركيب الحاوية'),
                    subtitle: const Text('سيتم تحديد موعد للتركيب من قبل الفني'),
                    value: _needsInstallation,
                    onChanged: (value) =>
                        setState(() => _needsInstallation = value),
                    activeColor: widget.serviceColor,
                    contentPadding: EdgeInsets.zero,
                  ),

                  const SizedBox(height: 20),

                  _buildSectionTitle('موقع تركيب الحاوية'),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    value: _selectedLocation,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    ),
                    items: _locations.map((location) {
                      return DropdownMenuItem<String>(
                        value: location,
                        child: Text(location),
                      );
                    }).toList(),
                    onChanged: (value) =>
                        setState(() => _selectedLocation = value),
                    hint: const Text('اختر موقع التركيب'),
                  ),

                  const SizedBox(height: 20),

                  _buildSectionTitle('تعليمات إضافية (اختياري)'),
                  const SizedBox(height: 10),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'أدخل أي تعليمات خاصة بتركيب الحاوية...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.all(16),
                    ),
                    maxLines: 3,
                    onChanged: (value) => _specialInstructions = value,
                  ),

                  const SizedBox(height: 30),

                  Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          const Text(
                            'ملخص الطلب',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildSummaryRow('نوع الحاوية', _selectedContainerType),
                          _buildSummaryRow('الكمية', '$_quantity'),
                          _buildSummaryRow('الموقع', _selectedLocation ?? 'غير محدد'),
                          _buildSummaryRow(
                            'التركيب',
                            _needsInstallation ? 'مطلوب' : 'غير مطلوب',
                          ),
                          const Divider(height: 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'المبلغ الإجمالي:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '${selectedContainer['price'] * _quantity} دينار',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: widget.serviceColor,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                          if (widget.isFirstContainerFree &&
                              _selectedContainerType == 'صغيرة (120 لتر)')
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 5),
                                  const Text(
                                    'الحاوية الأولى مجانية',
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
          
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  spreadRadius: 0,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submitRequest,
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.serviceColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'تأكيد الطلب',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 8),
          Text(value),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}