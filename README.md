# Cairo Metro Guide 🚇

Cairo Metro Guide (egy_metro) is a feature-rich, high-performance offline-first Flutter application designed to help commuters navigate the Cairo Metro system easily. It computes the shortest path between stations, calculates ticket pricing dynamically, shows nearby stations using real-time GPS, and offers interactive, zoomable, and fully localized maps.

---

## 📸 App Showcase

Below is a complete visual walkthrough of the app's interfaces:

### Main Features & Home Screen
| Home Page (Light) | Quick Navigation | Route Details | Search bottom sheet |
| --- | --- | --- | --- |
| <img src="app%20screenshots/WhatsApp%20Image%202026-06-30%20at%2012.49.38%20PM.jpeg" width="220" alt="Home Screen"> | <img src="app%20screenshots/WhatsApp%20Image%202026-06-30%20at%2012.49.39%20PM.jpeg" width="220" alt="Quick Navigation"> | <img src="app%20screenshots/WhatsApp%20Image%202026-06-30%20at%2012.49.39%20PM%20%281%29.jpeg" width="220" alt="Route Details"> | <img src="app%20screenshots/WhatsApp%20Image%202026-06-30%20at%2012.49.39%20PM%20%282%29.jpeg" width="220" alt="Search"> |

### Location, Map, and Settings
| Nearby Stations | Interactive Map (EN) | Settings Menu | Interactive Map (AR) |
| --- | --- | --- | --- |
| <img src="app%20screenshots/WhatsApp%20Image%202026-06-30%20at%2012.49.40%20PM.jpeg" width="220" alt="Nearby Stations"> | <img src="app%20screenshots/WhatsApp%20Image%202026-06-30%20at%2012.49.41%20PM.jpeg" width="220" alt="EN Map"> | <img src="app%20screenshots/WhatsApp%20Image%202026-06-30%20at%2012.49.41%20PM%20%281%29.jpeg" width="220" alt="Settings"> | <img src="app%20screenshots/WhatsApp%20Image%202026-06-30%20at%2012.49.42%20PM.jpeg" width="220" alt="AR Map"> |

### Station Details & Dark Mode UI
| Route Detail (GPS) | Station View | Ticket Pricing | Line View |
| --- | --- | --- | --- |
| <img src="app%20screenshots/WhatsApp%20Image%202026-06-30%20at%2012.49.42%20PM%20%281%29.jpeg" width="220" alt="GPS Route"> | <img src="app%20screenshots/WhatsApp%20Image%202026-06-30%20at%2012.49.42%20PM%20%282%29.jpeg" width="220" alt="Stations"> | <img src="app%20screenshots/WhatsApp%20Image%202026-06-30%20at%2012.49.42%20PM%20%283%29.jpeg" width="220" alt="Pricing Calculator"> | <img src="app%20screenshots/WhatsApp%20Image%202026-06-30%20at%2012.49.42%20PM%20%284%29.jpeg" width="220" alt="Lines"> |

### Favorites & Pricing details
| Saved Favorites | Route Summary | Station Timetable | Multi-line Transfer |
| --- | --- | --- | --- |
| <img src="app%20screenshots/WhatsApp%20Image%202026-06-30%20at%2012.49.43%20PM.jpeg" width="220" alt="Favorites"> | <img src="app%20screenshots/WhatsApp%20Image%202026-06-30%20at%2012.49.43%20PM%20%281%29.jpeg" width="220" alt="Summary"> | <img src="app%20screenshots/WhatsApp%20Image%202026-06-30%20at%2012.49.43%20PM%20%282%29.jpeg" width="220" alt="Timetable"> | <img src="app%20screenshots/WhatsApp%20Image%202026-06-30%20at%2012.49.43%20PM%20%283%29.jpeg" width="220" alt="Transfer info"> |

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
