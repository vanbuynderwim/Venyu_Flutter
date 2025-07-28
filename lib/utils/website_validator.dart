/// Website URL validation utility - Flutter equivalent of iOS WebsiteValidator
/// 
/// Provides validation and normalization for website URLs similar to the iOS implementation.
/// Validates URL structure and normalizes URLs to standard format: https://www.domain.com
class WebsiteValidator {
  /// Checks the **structure** of a website URL.
  /// 
  /// Returns true if the URL has valid format, false otherwise.
  /// Empty URLs are considered invalid.
  static bool isValidFormat(String urlString) {
    if (urlString.trim().isEmpty) return false;
    
    final normalizedURL = _normalizeURL(urlString);
    final uri = Uri.tryParse(normalizedURL);
    if (uri == null) return false;
    
    // Must have a valid host
    final host = uri.host.toLowerCase();
    if (host.isEmpty) return false;
    
    // Host may not contain spaces or invalid characters
    final hostRegex = RegExp(r'^[a-zA-Z0-9\-\.]+$');
    if (!hostRegex.hasMatch(host)) return false;
    
    // Must contain at least one dot (for TLD)
    if (!host.contains('.')) return false;
    
    // TLD must be at least 2 characters long
    final components = host.split('.');
    final tld = components.isNotEmpty ? components.last : '';
    if (tld.length < 2) return false;
    
    // May not be localhost or IP addresses (optional)
    final invalidHosts = ['localhost', '127.0.0.1', '0.0.0.0'];
    if (invalidHosts.contains(host)) return false;
    
    return true;
  }
  
  /// Normalizes a website URL to standard format: https://www.domain.com
  /// 
  /// Returns null if the URL format is invalid.
  /// Preserves path and query parameters.
  static String? normalizeForStorage(String urlString) {
    if (!isValidFormat(urlString)) return null;
    
    final normalizedURL = _normalizeURL(urlString);
    final uri = Uri.tryParse(normalizedURL);
    if (uri == null) return null;
    
    final host = uri.host.toLowerCase();
    if (host.isEmpty) return null;
    
    // Add www. if it's not there (except for subdomains)
    String finalHost;
    if (host.startsWith('www.')) {
      finalHost = host;
    } else {
      // Check if it already has a subdomain (more than 2 parts)
      final hostParts = host.split('.');
      if (hostParts.length > 2) {
        // Already has a subdomain, leave as is
        finalHost = host;
      } else {
        // Add www.
        finalHost = 'www.$host';
      }
    }
    
    // Preserve path and query parameters
    final normalizedUri = Uri(
      scheme: 'https',
      host: finalHost,
      path: uri.path,
      query: uri.query.isNotEmpty ? uri.query : null,
      fragment: uri.fragment.isNotEmpty ? uri.fragment : null,
    );
    
    return normalizedUri.toString();
  }
  
  /// Normalizes a URL by adding protocol if needed
  static String _normalizeURL(String urlString) {
    final cleaned = urlString.trim();
    
    // If it already has a protocol, return as-is
    final lowerCleaned = cleaned.toLowerCase();
    if (lowerCleaned.startsWith('http://') || lowerCleaned.startsWith('https://')) {
      return cleaned;
    }
    
    // Add https://
    return 'https://$cleaned';
  }
}