/// LinkedIn URL validator utility
/// Dart port of Swift LinkedInValidator
class LinkedInValidator {
  /// Controleert de **structuur** van een persoonlijk LinkedIn‑profiel‑URL.
  static bool isValidFormat(String urlString) {
    final normalizedURL = _normalizeURL(urlString);
    final uri = Uri.tryParse(normalizedURL);
    if (uri == null) return false;
    
    // Accepteer alle LinkedIn hosts (ook landspecifiek zoals nl.linkedin.com)
    final host = uri.host.toLowerCase();
    if (host != 'linkedin.com' && !host.endsWith('.linkedin.com')) {
      return false;
    }
    
    final path = uri.path.toLowerCase();
    
    // Check of het pad begint met /in/ en een username heeft
    if (!path.startsWith('/in/')) return false;
    
    // Haal de username uit het pad (alles na /in/)
    final username = path.substring(4).split('/').first;
    if (username.isEmpty) return false;
    
    // Username mag alleen geldige karakters bevatten
    final usernameRegex = RegExp(r'^[a-zA-Z0-9\-_%]+$');
    return usernameRegex.hasMatch(username);
  }

  /// Controleert of `firstName` én `lastName` in de username voorkomen.
  static bool nameMatches(String urlString, String firstName, String lastName) {
    if (!isValidFormat(urlString)) return false;
    if (firstName.isEmpty || lastName.isEmpty) return true;

    final normalizedURL = _normalizeURL(urlString);
    final uri = Uri.tryParse(normalizedURL);
    if (uri == null) return false;
    
    final path = uri.path;
    if (!path.toLowerCase().startsWith('/in/')) return false;
    
    final username = path.substring(4).split('/').first;
    final decodedUsername = Uri.decodeFull(username);
    final normUsername = _normalizeText(decodedUsername);
    final normFirst = _normalizeText(firstName);
    final normLast = _normalizeText(lastName);
    
    return normUsername.contains(normFirst) && normUsername.contains(normLast);
  }
  
  /// Normaliseert een LinkedIn URL naar standaard formaat: https://www.linkedin.com/in/username
  static String? normalizeForStorage(String urlString) {
    if (!isValidFormat(urlString)) return null;
    
    final normalizedURL = _normalizeURL(urlString);
    final uri = Uri.tryParse(normalizedURL);
    if (uri == null) return null;
    
    final path = uri.path;
    if (!path.toLowerCase().startsWith('/in/')) return null;
    
    // Haal username uit pad (zonder trailing content)
    final username = path.substring(4).split('/').first;
    if (username.isEmpty) return null;
    
    // Return gestandaardiseerd formaat
    return 'https://www.linkedin.com/in/$username';
  }

  /// Normaliseert een LinkedIn URL door protocol toe te voegen indien nodig
  static String _normalizeURL(String urlString) {
    final cleaned = urlString.trim();
    
    // Als het al een protocol heeft, return as-is
    if (cleaned.toLowerCase().startsWith('http://') || 
        cleaned.toLowerCase().startsWith('https://')) {
      return cleaned;
    }
    
    // Voeg https:// toe
    return 'https://$cleaned';
  }

  /// Normaliseert tekst voor naam matching
  static String _normalizeText(String text) {
    // Dart equivalent van Swift's folding options
    return text
        .toLowerCase()
        .replaceAll(RegExp(r'[àáâãäåæ]'), 'a')
        .replaceAll(RegExp(r'[èéêë]'), 'e')
        .replaceAll(RegExp(r'[ìíîï]'), 'i')
        .replaceAll(RegExp(r'[òóôõöø]'), 'o')
        .replaceAll(RegExp(r'[ùúûü]'), 'u')
        .replaceAll(RegExp(r'[ýÿ]'), 'y')
        .replaceAll(RegExp(r'[ñ]'), 'n')
        .replaceAll(RegExp(r'[ç]'), 'c')
        .replaceAll(RegExp(r'[^a-z0-9]'), '');
  }
}