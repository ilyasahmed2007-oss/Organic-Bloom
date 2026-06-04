import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Organic Bloom Cosmetic',
      theme: ThemeData(primarySwatch: Colors.green),
      home: const BillingPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class BillingPage extends StatefulWidget {
  const BillingPage({super.key});
  @override
  State<BillingPage> createState() => _BillingPageState();
}

class _BillingPageState extends State<BillingPage> {
  final InAppPurchase _iap = InAppPurchase.instance;
  List<ProductDetails> _products = [];
  bool _available = false;

  final Set<String> _kIds = {
    'monthly_plan',
    'quarterly_plan',
    'yearly_plan'
  };

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    _available = await _iap.isAvailable();
    if (!_available) return;
    final ProductDetailsResponse response = await _iap.queryProductDetails(_kIds);
    setState(() {
      _products = response.productDetails;
    });
  }

  Future<void> _buy(ProductDetails product) async {
    final PurchaseParam purchaseParam = PurchaseParam(productDetails: product);
    _iap.buyNonConsumable(purchaseParam: purchaseParam);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Organic Bloom Cosmetic')),
      body: _products.isEmpty
         ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _products.length,
              itemBuilder: (context, index) {
                final product = _products[index];
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    title: Text(product.title),
                    subtitle: Text(product.description),
                    trailing: ElevatedButton(
                      onPressed: () => _buy(product),
                      child: Text(product.price),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
