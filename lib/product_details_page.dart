import 'package:flutter/material.dart';

class ProductDetailsPage extends StatelessWidget {
  final Map<String, dynamic> product;

  const ProductDetailsPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product['title']),
        centerTitle: true,
        // زر الرجوع يتم إضافته تلقائياً بواسطة Flutter في الـ AppBar
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // عرض الصورة
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  product['thumbnail'],
                  height: 250,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),
            
            // عرض الاسم
            Text(
              product['title'],
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            
            // عرض السعر
            Text(
              'السعر: \$${product['price']}',
              style: const TextStyle(fontSize: 20, color: Colors.green, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            
            // جميع التفاصيل الخاصة بالعنصر
            const Text(
              'تفاصيل المنتج:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              product['description'], 
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 10),
            
            // تفاصيل إضافية (التقييم والعلامة التجارية)
            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber),
                Text(' التقييم: ${product['rating']}'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}