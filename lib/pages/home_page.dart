// lib/pages/home_page.dart

import 'package:flutter/material.dart';
import 'package:anime_store/models/product.dart';
import 'package:anime_store/services/product_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isLoggedIn = false;
  String _currentFilter = 'All Products';
  late Future<List<Product>> _productsFuture;
  final ProductService _productService = ProductService();

  static const String _baseUrl = 'http://10.0.2.2:8080';

  @override
  void initState() {
    super.initState();
    _fetchProducts(); // Initial fetch of all products
  }

  // Function to fetch products based on the current filter
  void _fetchProducts() {
    setState(() {
      // Calls the service with the current filter string
      _productsFuture = _productService.fetchProducts(category: _currentFilter);
    });
  }

  // Function called when a category is tapped in the Drawer
  void _filterProducts(String category) {
    setState(() {
      _currentFilter = category;
      _fetchProducts(); // Fetch data for the new category
      Navigator.of(context).pop(); // Close drawer after selection
    });
  }

  // --- Widget Builders ---

  Widget _buildDrawer() {
    // Builds the sidebar with categories
    final List<String> categories = ['Cosplay', 'Figurines', 'Manga', 'Plushies', 'Clothing'];

    return Drawer(
      child: Column(
        children: [
          // Logo Section (DrawerHeader)
          DrawerHeader( // FIX 1: Removed 'const'
            decoration: const BoxDecoration(color: Colors.blueGrey),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'C:\Users\Msi\StudioProjects\anime_store_api\public_assets',
                    height: 60,
                  ),
                  const Text('Anime Store', style: TextStyle(color: Colors.white, fontSize: 16)),
                ],
              ),
            ),
          ),
          // Categories List
          ...categories.map((cat) => ListTile( // FIX 2: Removed 'const'
            title: Text(cat),
            // Highlight the selected category
            selected: _currentFilter == cat, // Uses state, so cannot be const
            onTap: () => _filterProducts(cat),
          )).toList(),
          const Divider(),
          // Home button to clear filter
          ListTile(
            title: const Text('All Products'),
            selected: _currentFilter == 'All Products',
            onTap: () => _filterProducts('All Products'),
          ),
        ],
      ),
    );
  }

  Widget _buildFooterNavigationBar() {
    // Builds the persistent bottom navigation bar
    return BottomNavigationBar(
      currentIndex: 0,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Cart/Orders'),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
      ],
      onTap: (index) {
        // Navigation logic will go here
        print('Tapped index $index');
      },
    );
  }

  Widget _buildProductGrid(List<Product> products) {
    // Creates the grid view with 2 columns
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // 2 items wide
        childAspectRatio: 0.7, // Adjust height to fit image and text
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        final String fullImageUrl = _baseUrl + product.imageUrl;

        return Card(
          elevation: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.network(
                    fullImageUrl,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(child: Icon(Icons.broken_image, size: 50, color: Colors.grey));
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                    product.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
                child: Text(
                    product.category,
                    style: TextStyle(color: Colors.grey[600], fontSize: 12)
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
                    child: Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        style: const TextStyle(color: Colors.deepOrange, fontWeight: FontWeight.bold)
                    ),
                  ),
                  // Add to Cart Button (Far Right)
                  IconButton(
                    icon: const Icon(Icons.add_shopping_cart, size: 20, color: Colors.blueGrey),
                    onPressed: () {
                      // Add to cart logic here
                      print('Added ${product.name} to cart');
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Display the Logo
            Image.asset(
              'assets/app_logo.png',
              height: 30, // Adjust size as needed
            ),
            const SizedBox(width: 8),
            // Display the current filter/category name
            Text(_currentFilter, style: const TextStyle(fontSize: 18)),
          ],
        ),
        backgroundColor: Colors.blueGrey,
        actions: [
          // User Icon on the right
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'logout') {
                setState(() => _isLoggedIn = false);
              }
            },
            itemBuilder: (context) => [
              if (_isLoggedIn)
                const PopupMenuItem(value: 'logout', child: Text('Log Out'))
              else ...[
                const PopupMenuItem(value: 'login', child: Text('Log In')),
                const PopupMenuItem(value: 'signup', child: Text('Sign Up')),
              ],
            ],
            icon: const Icon(Icons.person),
          ),
        ],
      ),
      drawer: _buildDrawer(), // Sidebar (Drawer)
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Search Bar ---
            const TextField(
              decoration: InputDecoration(
                hintText: 'Search all products...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
              ),
              // Search logic goes here
            ),
            const SizedBox(height: 20),

            // --- Quote Section ---
            const Center(
              child: Text(
                "\"We deliver your favourite Anime merchandise to your doorstep\"",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic, color: Colors.blueGrey),
              ),
            ),
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 10),

            // --- Product Display (Grid) ---
            FutureBuilder<List<Product>>(
              future: _productsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error loading products: ${snapshot.error}'));
                } else if (snapshot.data == null || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No products found for this category.'));
                } else {
                  return _buildProductGrid(snapshot.data!);
                }
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildFooterNavigationBar(), // Footer Navigation
    );
  }
}