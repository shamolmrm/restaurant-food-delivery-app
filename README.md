# Feastly — Restaurant & Food Delivery App

A premium Flutter food delivery app with restaurant browsing, cart, checkout, order tracking, and an AI assistant for recommendations.

## Features

- Restaurant & food browsing with search and filters
- Cart, checkout, and multiple payment options
- Order tracking and order history
- Favorites, reviews, and offers
- Live chat and AI assistant
- Address management
- Admin screens
- Push notifications

## Tech Stack

| | |
|---|---|
| Framework | Flutter / Dart |
| State Management | Provider |
| Routing | go_router |
| Networking | Dio |
| Local Storage | Hive, shared_preferences |
| UI | Google Fonts, Iconsax, cached_network_image, flutter_animate |

## Project Structure

```
lib/
├── core/           # constants, routes, theme, utils
├── models/
├── providers/
├── screens/          # auth, home, restaurant, food, cart, checkout, order,
│                     # payment, favorites, reviews, offers, chat, ai_assistant,
│                     # notifications, address, admin, settings...
└── widgets/          # animations, buttons, cards, inputs, loaders
```

## Getting Started

```bash
flutter pub get
flutter run
```
