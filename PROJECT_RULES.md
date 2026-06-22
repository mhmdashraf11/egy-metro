# Cairo Metro Guide — Project Architecture & Development Rules

## Project Overview
Cairo Metro Guide is a modern Flutter application for the metro system in Cairo, Egypt.

The app helps users:
- Find the shortest metro route
- View metro lines and stations
- Calculate ticket prices
- Find nearby stations using GPS
- View metro maps
- Save favorite routes
- Access offline metro data
- Track live metro updates in future versions

The application must feel production-ready with premium UI/UX quality.

---

# Tech Stack

## Core Stack
- Flutter (latest stable)
- Dart
- Material Design 3

## State Management
Use:
- Flutter Bloc
- Cubit

Avoid:
- GetX state management
- Global mutable states
- Business logic inside UI widgets

GetX routing is allowed only temporarily during migration if needed.

---

# Architecture

Use Clean Architecture with feature-first structure.

---

# Clean Architecture Layers

## 1. Presentation Layer

Contains:
- Screens
- Widgets
- Cubits
- States
- UI helpers

Responsibilities:
- Rendering UI
- Handling user interactions
- Listening to Cubit states

Rules:
- No business logic inside widgets
- Keep widgets reusable and modular
- UI must depend on states only
- Avoid direct database/API calls

---

## 2. Domain Layer

Contains:
- Entities
- Repository contracts
- Use cases

Responsibilities:
- Business rules
- Application logic

Rules:
- Pure Dart only
- No Flutter imports
- No external dependencies
- Independent from data layer

---

## 3. Data Layer

Contains:
- Models
- Local database
- Repository implementations
- Data sources
- DTOs

Responsibilities:
- Database operations
- Mapping models/entities
- Data persistence
- Caching

Rules:
- Keep mapping clean
- Avoid business logic here
- Repository implementation must follow domain contracts

---

# Recommended Folder Structure

```txt
lib/
│
├── core/
│   ├── constants/
│   ├── errors/
│   ├── services/
│   ├── theme/
│   ├── utils/
│   ├── widgets/
│   └── extensions/
│
├── features/
│   │
│   ├── home/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   ├── route_planner/
│   ├── metro_lines/
│   ├── nearby_stations/
│   ├── ticket_pricing/
│   ├── favorites/
│   ├── settings/
│   └── notifications/
│
├── injection_container.dart
└── main.dart
```

---

# Feature Structure

Each feature should follow:

```txt
feature_name/
│
├── data/
│   ├── datasources/
│   ├── models/
│   └── repositories/
│
├── domain/
│   ├── entities/
│   ├── repositories/
│   └── usecases/
│
└── presentation/
    ├── cubit/
    ├── pages/
    └── widgets/
```

---

# State Management Rules

## Use Cubit for:
- Route planning
- Metro lines state
- Favorites
- Theme switching
- Nearby stations
- Search
- Ticket pricing

---

# Cubit Rules

## Must
- Keep states immutable
- Use Equatable
- Emit meaningful states
- Separate UI states clearly

## Avoid
- Massive Cubits
- Business logic inside widgets
- Direct database calls inside UI

---

# Example Cubit States

```txt
Initial
Loading
Loaded
Error
Empty
```

Example:
```txt
RoutePlannerInitial
RoutePlannerLoading
RoutePlannerLoaded
RoutePlannerError
```

---

# Dependency Injection

Use:
- get_it

Responsibilities:
- Register repositories
- Register use cases
- Register Cubits
- Centralize dependencies

Avoid:
- Manual dependency passing everywhere

---

# Database Rules

## Database
Use:
- SQLite
- Drift ORM

Avoid:
- Giant JSON parsing every launch
- Unstructured local storage

---

# Database Tables

## stations
```txt
id
name_ar
name_en
lat
lng
line_id
is_interchange
```

## metro_lines
```txt
id
name_ar
name_en
color
```

## connections
```txt
id
from_station_id
to_station_id
line_id
travel_time
```

## favorite_routes
```txt
id
from_station_id
to_station_id
created_at
```

## recent_searches
```txt
id
from_station_id
to_station_id
searched_at
```

---

# Metro Routing System

Treat the metro system as a graph.

## Graph Representation

```txt
Stations = Nodes
Connections = Edges
```

Use:
- BFS
- Dijkstra

Avoid:
- Hardcoded route conditions
- Nested if/else route logic

---

# UI/UX Rules

## Design Style
The app must feel:
- Premium
- Minimal
- Smooth
- Elegant
- Production-ready

Inspired by:
- Google Maps
- Citymapper
- Moovit
- Modern fintech apps

---

# Theme Rules

Support:
- Dark mode
- Light mode
- Arabic RTL
- English LTR

---

# UI Guidelines

## Required
- Material 3
- Rounded corners
- Soft shadows
- Consistent spacing
- Responsive layouts
- Accessibility support
- Reusable widgets

## Avoid
- Cluttered layouts
- Inconsistent spacing
- Huge widgets
- Overdesigned screens

---

# Performance Rules

## Must
- Minimize rebuilds
- Use BlocBuilder selectively
- Use BlocSelector when needed
- Use const widgets
- Optimize SVG rendering

## Avoid
- Rebuilding entire pages unnecessarily
- Heavy sync work on UI thread

---

# Naming Conventions

## Files
```txt
snake_case.dart
```

## Classes
```txt
PascalCase
```

## Variables
```txt
camelCase
```

---

# Navigation

Preferred:
- GoRouter

Rules:
- Centralized routes
- Typed navigation
- Deep-link ready

---

# Localization

Use:
- Flutter localization system

Support:
- Arabic
- English

Rules:
- No hardcoded strings
- All text must be translatable
- RTL support required

---

# Error Handling

Use:
- Failure classes
- try/catch in repositories
- User-friendly messages

Avoid:
- Silent failures
- print debugging in production

---

# Metro Map System

Future support:
- Interactive SVG map
- Zoom and pan
- Animated routes
- Live train indicators

Preferred:
- Custom SVG rendering
- Mapbox integration later if needed

---

# Features Roadmap

## Current Features
- Route planner
- Metro lines explorer
- Ticket pricing
- Nearby stations
- Favorites
- Offline metro data

## Future Features
- Live metro tracking
- Congestion indicators
- Smart commute assistant
- AI route suggestions
- Voice search
- QR metro tickets
- Push notifications

---

# Code Quality Rules

## Must
- Modular architecture
- Reusable components
- Small focused files
- Meaningful naming
- Separation of concerns

## Avoid
- God widgets
- Huge files
- Tight coupling
- Duplicate code

---

# Git Workflow

## Branches
```txt
main
develop
feature/*
bugfix/*
```

## Commit Convention

```txt
feat:
fix:
refactor:
ui:
docs:
```

Example:
```txt
feat(route-planner): implement dijkstra algorithm
```

---

# Testing

## Required
- Unit tests for routing algorithms
- Cubit tests
- Repository tests
- Widget tests for critical screens

Avoid:
- Untested business logic

---

# AI Assistant Instructions

When generating code:
- Follow Clean Architecture strictly
- Use Cubit/Bloc correctly
- Keep widgets modular
- Generate scalable code
- Respect RTL support
- Follow Material 3
- Optimize performance
- Prefer readability over cleverness

Never:
- Put business logic inside UI
- Use hardcoded metro routes
- Create giant files
- Ignore localization
- Ignore accessibility

---

# Final Goal

The app should feel like:
- A real commercial transportation platform
- Modern and scalable
- Smooth and elegant
- Maintainable long-term
- Portfolio-quality production software
- Ready for future expansion