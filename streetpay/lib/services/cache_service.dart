class CacheService {
  static final Map<String, _CacheEntry> _cache = {};

  static T? get<T>(String key, {Duration maxAge = const Duration(minutes: 2)}) {
    final entry = _cache[key];
    if (entry == null) return null;
    if (DateTime.now().difference(entry.timestamp) > maxAge) {
      _cache.remove(key);
      return null;
    }
    return entry.value as T?;
  }

  static void set(String key, dynamic value) {
    _cache[key] = _CacheEntry(value, DateTime.now());
  }

  static void invalidate(String key) => _cache.remove(key);

  static void clear() => _cache.clear();

  static bool has(String key, {Duration maxAge = const Duration(minutes: 2)}) {
    return get<dynamic>(key, maxAge: maxAge) != null;
  }
}

class _CacheEntry {
  final dynamic value;
  final DateTime timestamp;
  const _CacheEntry(this.value, this.timestamp);
}
