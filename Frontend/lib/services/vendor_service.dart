import 'package:supabase_flutter/supabase_flutter.dart';

class VendorService {
  VendorService._();

  static SupabaseClient get _client => Supabase.instance.client;

  /// Returns ['All', ...categories from Supabase] in the saved order.
  static Future<List<String>> fetchCategories() async {
    final rows = await _client
        .from('categories')
        .select('name')
        .order('sort_order', ascending: true);

    return [
      'All',
      ...rows.map((row) => row['name'] as String),
    ];
  }

  /// Returns vendors in the exact map shape the existing HomeScreen UI uses.
  static Future<List<Map<String, dynamic>>> fetchVendors() async {
    final rows = await _client
        .from('vendors')
        .select()
        .eq('is_active', true)
        .order('rating', ascending: false);

    return rows.map<Map<String, dynamic>>((row) {
      return {
        'name': row['name'] as String,
        'category': row['category'] as String,
        'rating': (row['rating'] as num).toDouble(),
        'price': (row['avg_price'] as num).toInt(),
        'time': row['prep_time'] as String,
        'delivery': row['has_delivery'] as bool,
        'pickup': row['has_pickup'] as bool,
        'isOpen': row['is_open'] as bool,
        'image': (row['image_url'] as String?) ?? '',
      };
    }).toList();
  }
}