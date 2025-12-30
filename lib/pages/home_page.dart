import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/product.dart';
import '../services/product_service.dart';
import '../services/auth_service.dart';
import 'signup_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ProductService _productService = ProductService();
  late Future<List<Product>> _productsFuture;
  String _currentFilter = 'All Products';

  // Admin logic state
  bool _isDeleteMode = false;

  @override
  void initState() {
    super.initState();
    _productsFuture = _productService.fetchProducts(category: _currentFilter);
  }

  void _refreshProducts() {
    setState(() {
      _productsFuture = _productService.fetchProducts(category: _currentFilter);
    });
  }

  // Logic for Admin to Delete Item
  void _confirmDelete(Product p) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm Delete"),
        content: Text("Are you sure you want to delete ${p.name}?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              // FIX: This calls the specific delete route we added to the server
              final response = await http.delete(
                  Uri.parse('http://10.0.2.2:8080/products/delete/${p.id}')
              );

              if (response.statusCode == 200) {
                _refreshProducts(); // Refreshes the UI after successful delete
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Item deleted successfully"))
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Error: ${response.statusCode}"))
                );
              }
            },
            child: const Text("OK", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showQuantityDialog(Product p) {
    int quantity = 1;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Add ${p.name} to Cart"),
        content: TextField(
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(hintText: "Enter Quantity"),
          onChanged: (val) => quantity = int.tryParse(val) ?? 1,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          TextButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("successfully added to cart"))
                );
              },
              child: const Text("OK")
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isAdmin = AuthService.currentUser?.role == 'admin';

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Image.asset('assets/app_logo.png', height: 35),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.account_circle, color: Colors.black, size: 24),
                Text(
                    AuthService.currentUser?.firstName ?? "Guest",
                    style: const TextStyle(fontSize: 10, color: Colors.black, fontWeight: FontWeight.bold)
                ),
              ],
            ),
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blueGrey),
              child: Text("Anime Store", style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(
              leading: const Icon(Icons.login),
              title: const Text('Login / Sign Up'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (c) => const SignupPage()));
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Filter Row
          SizedBox(
            height: 60,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              children: ['All Products', 'Clothing', 'Figurines', 'Cosplay'].map((cat) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: ChoiceChip(
                  label: Text(cat),
                  selected: _currentFilter == cat,
                  onSelected: (selected) {
                    if (selected && _currentFilter != cat) {
                      _currentFilter = cat;
                      _refreshProducts();
                    }
                  },
                ),
              )).toList(),
            ),
          ),

          // Admin Control Buttons (Only visible if admin is logged in)
          if (isAdmin)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(onPressed: () {}, child: const Text("Add Item")),
                  ElevatedButton(onPressed: () {}, child: const Text("Edit Item")),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isDeleteMode ? Colors.red : Colors.grey[300],
                    ),
                    onPressed: () {
                      setState(() => _isDeleteMode = !_isDeleteMode);
                    },
                    child: Text(_isDeleteMode ? "Cancel Delete" : "Delete Item", style: TextStyle(color: _isDeleteMode ? Colors.white : Colors.black)),
                  ),
                ],
              ),
            ),

          // Product Grid
          Expanded(
            child: FutureBuilder<List<Product>>(
              future: _productsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
                if (snapshot.hasError) return const Center(child: Text("Error loading products"));
                final products = snapshot.data!;
                return GridView.builder(
                  padding: const EdgeInsets.all(10),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final p = products[index];
                    return GestureDetector(
                      onTap: () {
                        if (_isDeleteMode) {
                          _confirmDelete(p);
                        }
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: _isDeleteMode ? Border.all(color: Colors.red, width: 2) : null,
                          ),
                          child: Column(
                            children: [
                              Expanded(
                                child: Image.network(
                                  'http://10.0.2.2:8080${p.imageUrl}',
                                  errorBuilder: (c,e,s) => const Icon(Icons.image_not_supported, size: 50),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Text(p.name, style: const TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                                    Text("\$${p.price.toStringAsFixed(2)}", style: const TextStyle(color: Colors.deepOrange)),
                                    if (!_isDeleteMode)
                                      IconButton(
                                        icon: const Icon(Icons.add_shopping_cart, color: Colors.blueGrey),
                                        onPressed: () {
                                          if (AuthService.currentUser == null) {
                                            Navigator.push(context, MaterialPageRoute(builder: (c) => const SignupPage()));
                                          } else {
                                            _showQuantityDialog(p);
                                          }
                                        },
                                      )
                                    else
                                      const Padding(
                                        padding: EdgeInsets.symmetric(vertical: 8),
                                        child: Icon(Icons.delete_forever, color: Colors.red),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}