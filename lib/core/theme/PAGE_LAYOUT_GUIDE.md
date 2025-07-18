# Page Layout Guide

## Standaard Pagina Padding

Alle pagina's in de Venyu app moeten een consistente horizontal padding hebben van **16px** (links en rechts).

## Gebruik van StandardPageLayout

### Basis gebruik
```dart
// Voor een standaard pagina met scrolling
Scaffold(
  body: StandardPageLayout(
    child: Column(
      children: [
        // Je content hier
      ],
    ),
  ),
)
```

### Alleen horizontal padding
```dart
// Als je de vertical padding wilt aanpassen
Scaffold(
  body: StandardPageLayout(
    customPadding: AppModifiers.pagePaddingHorizontal,
    child: Column(
      children: [
        // Je content hier
      ],
    ),
  ),
)
```

### Niet-scrollbare pagina
```dart
// Voor pagina's die niet hoeven te scrollen
Scaffold(
  body: StandardPageLayout(
    scrollable: false,
    child: Column(
      children: [
        // Je content hier
      ],
    ),
  ),
)
```

## Beschikbare Padding Constanten

- `AppModifiers.pagePadding` - 16px horizontal, 24px vertical
- `AppModifiers.pagePaddingHorizontal` - 16px horizontal, 0px vertical
- `AppModifiers.paddingHorizontalMedium` - 16px horizontal (EdgeInsets.symmetric)

## Wanneer wel/niet gebruiken

### ✅ Gebruik StandardPageLayout voor:
- Lijst screens
- Detail screens
- Form screens
- Settings screens
- Alle reguliere content pagina's

### ❌ Gebruik GEEN StandardPageLayout voor:
- Screens met edge-to-edge content (zoals image viewers)
- Screens met custom layouts (zoals onboarding)
- Screens waar je zelf volledige controle over padding wilt

## Componenten die al rekening houden met padding

Sommige componenten hebben al ingebouwde padding en hoeven niet extra padding:
- `CardItem` - heeft al interne padding
- `OptionButton` - heeft al interne padding
- `ActionButton` - heeft al interne padding

## Voorbeeld uit main.dart

```dart
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Venyu')),
      body: StandardPageLayout(  // 16px horizontal padding
        child: Column(
          children: [
            Text('Title'),
            ProgressBar(...),  // Perfect aligned
            OptionButton(...), // Perfect aligned
            ActionButton(...), // Perfect aligned
          ],
        ),
      ),
    );
  }
}
```

Dit zorgt ervoor dat alle componenten consistent uitgelijnd zijn met 16px padding van de schermranden.