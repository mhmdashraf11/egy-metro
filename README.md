# Cairo Metro Guide 🚇

Cairo Metro Guide (egy_metro) is a feature-rich, high-performance offline-first Flutter application designed to help commuters navigate the Cairo Metro system easily. It computes the shortest path between stations, calculates ticket pricing dynamically, shows nearby stations using real-time GPS, and offers interactive, zoomable, and fully localized maps.

---

## 📸 App Showcase

Below is a categorized visual walkthrough showcasing the app's light/dark modes, localization support, and core feature views.

### 🇬🇧 English UI (Light & Dark Mode)

#### 🏠 Home, Lines & Maps
| Light Home Screen | Dark Home Screen | Metro Lines List | HD Interactive Map |
| --- | --- | --- | --- |
| <img src="app%20screenshots/light%20mode%20home%20screen.jpeg" width="220" alt="Light Home Screen"> | <img src="app%20screenshots/darkMode%20HomeScreen.jpeg" width="220" alt="Dark Home Screen"> | <img src="app%20screenshots/light%20mode%20lines.jpeg" width="220" alt="Metro Lines"> | <img src="app%20screenshots/en%20map%20for%20en%20language.jpeg" width="220" alt="English Map"> |

#### 🗺️ Route Planner & Path Finder
| Route Planner Form | Dijkstra Shortest Path | Detailed Stops List | Interchange Stations |
| --- | --- | --- | --- |
| <img src="app%20screenshots/light%20mode%20route%20planning.jpeg" width="220" alt="Route Planner Form"> | <img src="app%20screenshots/route%20planning%20result.jpeg" width="220" alt="Dijkstra Shortest Path"> | <img src="app%20screenshots/route%20planning%20result%20details.jpeg" width="220" alt="Stops List"> | <img src="app%20screenshots/lines%20showing%20the%20interchange%20stations.jpeg" width="220" alt="Interchange Stations"> |

#### 🏷️ Line-Specific Details & Planner Variations
| Line 1 Stations | Line 2 Stations | Line 3 Stations | Search Form Variant |
| --- | --- | --- | --- |
| <img src="app%20screenshots/line1.jpeg" width="220" alt="Line 1"> | <img src="app%20screenshots/line2.jpeg" width="220" alt="Line 2"> | <img src="app%20screenshots/line3.jpeg" width="220" alt="Line 3"> | <img src="app%20screenshots/route%20planning.jpeg" width="220" alt="Search Form"> |

#### 🎫 Favorites, Pricing & Settings
| Saved Favorites | Ticket Price Banner | Fares Calculator | App Settings (EN) |
| --- | --- | --- | --- |
| <img src="app%20screenshots/showing%20favorites%20route%20section.jpeg" width="220" alt="Favorites Section"> | <img src="app%20screenshots/tickets%20pricing.jpeg" width="220" alt="Ticket Price Banner"> | <img src="app%20screenshots/tickets%20pricing2.jpeg" width="220" alt="Fares Calculator"> | <img src="app%20screenshots/settings%20screen.png" width="220" alt="Settings Screen"> |

---

### 🇪🇬 Arabic UI (Full Localization)

| Arabic Home Page | Arabic Metro Lines | Arabic Map Screen | Arabic Route Planner | Arabic Settings |
| --- | --- | --- | --- | --- |
| <img src="app%20screenshots/arabic%20language%20home%20page.png" width="180" alt="AR Home"> | <img src="app%20screenshots/arabic%20lang%20lines.png" width="180" alt="AR Lines"> | <img src="app%20screenshots/arabic%20lang%20lines%20and%20ar%20map.png" width="180" alt="AR Map"> | <img src="app%20screenshots/ar%20route%20planning.png" width="180" alt="AR Router"> | <img src="app%20screenshots/arabic%20lang%20settings.png" width="180" alt="AR Settings"> |

---

## ✨ Features

- 📍 **Dijkstra Route Planner**: Instantly find the fastest route between any two stations across Line 1, Line 2, and Line 3, complete with details on number of stops, duration, and transit interchanges (e.g., Sadat, Shohadaa, Nasser).
- 🎫 **Dynamic Ticket Pricing**: Computes ticket fares on-the-fly based on the count of stops in your journey:
  - **1 - 9 stops**: 10 EGP
  - **10 - 16 stops**: 12 EGP
  - **17 - 23 stops**: 15 EGP
  - **24+ stops**: 20 EGP
- 🗺️ **Interactive Metro Maps**: High-definition, fully zoomable, localized maps that dynamically match the selected language (Arabic Map vs. English Map).
- 🛰️ **GPS Nearest Station & Card navigation**: Instantly lookup your closest metro station, showing walking distances, estimated walking times, and direct link launches to Google Maps.
- ⭐ **Favorites Manager**: Save your frequent routes for rapid offline access directly from the home screen.
- 🎨 **Adaptive Theme & Localization**: Full system/light/dark theme modes, and bilingual support (Arabic & English) persistent across app restarts.
- 🗄️ **Robust Offline Support**: SQLite storage and seeding using the Floor database framework.

---

## 🛠️ Architecture & Tech Stack

This project follows **Clean Architecture** patterns segmented by feature layers:
```text
lib/
├── core/
│   ├── database/     # SQLite configuration, Migrations, and Seeding
│   ├── router/       # GoRouter/AppRouter named routing configuration
│   ├── services/     # Local Storage & Core Business Services
│   ├── theme/        # Light and Dark theme palettes (Material 3)
│   └── translations/ # Localization engine
└── features/
    ├── favorites/    # User favorite routes
    ├── home/         # Dashboard / Main view
    ├── metro_lines/  # Interactive lines details & Maps
    ├── nearby_stations/ # Geolocation-based calculations
    ├── route_planner/ # Dijkstra router & search bottom sheet
    ├── settings/     # Persisting theme mode and language configurations
    └── ticket_pricing/ # Interactive tariff calculators
```

### Core Technologies
- **State Management**: `flutter_bloc` (Cubit pattern)
- **Local Storage**: `floor` (SQLite ORM) & `shared_preferences` (settings persistence)
- **Dependency Injection**: `get_it` (Service Locator)
- **Geolocation**: `geolocator`
- **Interactive Views**: `photo_view`

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (>= 3.11.0)
- Android SDK / Xcode (for iOS)

### Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/mhmdashraf11/egy-metro.git
   cd egy-metro
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Run code generation (for Floor ORM):**
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

4. **Run the app:**
   ```bash
   flutter run
   ```

### Running Tests
To run unit and widget tests:
```bash
flutter test
```
