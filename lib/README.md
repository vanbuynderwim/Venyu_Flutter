# Venyu Flutter App - Mappenstructuur

Deze Flutter app volgt Clean Architecture principes en is georganiseerd volgens Flutter best practices.

## 📁 Mappenstructuur

### `/lib/core/`
Bevat de fundamentele delen van de applicatie:
- **`constants/`** - Applicatie constanten (API URLs, kleuren, etc.)
- **`enums/`** - Enumeraties (StatusType, MatchStatus, etc.)
- **`extensions/`** - Dart extensions voor bestaande types
- **`themes/`** - App theming en styling
- **`utils/`** - Utility functies en helpers

### `/lib/data/`
Data layer - behandelt data bronnen en repositories:
- **`datasources/`** - API clients, database toegang
- **`models/`** - Data transfer objects (DTOs)
- **`repositories/`** - Repository implementaties

### `/lib/domain/`
Business logic layer:
- **`entities/`** - Business objecten
- **`repositories/`** - Repository interfaces/contracts
- **`usecases/`** - Business use cases

### `/lib/presentation/`
UI layer:
- **`pages/`** - Schermen/pages georganiseerd per functionaliteit
  - `auth/` - Login, registratie, OTP
  - `profile/` - Profiel weergave, bewerking, instellingen
  - `matches/` - Match lijst en details
  - `feed/` - Feed scherm
  - `notifications/` - Notificaties
- **`widgets/`** - Herbruikbare UI componenten
- **`providers/`** - State management (Provider/Bloc)

### `/lib/services/`
Service layer:
- **`auth/`** - Authenticatie services
- **`api/`** - API communicatie
- **`storage/`** - Lokale opslag
- **`notifications/`** - Push notifications

### `/lib/config/`
Configuratie:
- **`routes/`** - App routing configuratie
- **`dependencies/`** - Dependency injection setup

### `/lib/shared/`
Gedeelde componenten:
- **`components/`** - Gedeelde UI componenten
- **`widgets/`** - Basis widgets

### `/assets/`
Statische assets:
- **`images/`** - Afbeeldingen (logos, avatars, placeholders)
- **`fonts/`** - Custom fonts
- **`icons/`** - App iconen

## 🚀 Gebaseerd op Swift App Structuur

Deze structuur is geïnspireerd op je bestaande Swift app:
- **Models** → `domain/entities/` + `data/models/`
- **ViewModels** → `presentation/providers/`
- **Views** → `presentation/pages/` + `presentation/widgets/`
- **Managers** → `services/`
- **Components** → `shared/components/`
- **Extensions** → `core/extensions/`
- **Enums** → `core/enums/`

## 📱 Volgende Stappen

1. Implementeer basis models in `domain/entities/`
2. Maak API services in `services/api/`
3. Bouw UI componenten in `presentation/widgets/`
4. Implementeer pages in `presentation/pages/`
5. Setup state management in `presentation/providers/`