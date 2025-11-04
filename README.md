<!-- Dunno App Information & Links -->
<br />

![GitHub repo size](https://img.shields.io/github/repo-size/KaylaPosthumusOW/dunno_app?color=ff6b9d)
![GitHub watchers](https://img.shields.io/github/watchers/KaylaPosthumusOW/dunno_app?color=ff6b9d)
![GitHub language count](https://img.shields.io/github/languages/count/KaylaPosthumusOW/dunno_app?color=ff6b9d)
![GitHub code size in bytes](https://img.shields.io/github/languages/code-size/KaylaPosthumusOW/dunno_app?color=ff6b9d)

<!-- HEADER SECTION -->
<h5 align="center">Kayla Posthumus - 231096</h5>
<h6 align="center">Interactive Development 300 • 2025</h6>
</br>
<p align="center">
  <div align="center">
   <img src="assets/mockups/dunno_logo_placeholder.png" alt="Dunno Logo" height="70">
  </div>
  <h3 align="center">Dunno</h3>
  <p align="center">
   Never be stumped for gift ideas again. Dunno is an AI-powered gift suggestion platform that helps you find the perfect present for anyone, anytime.<br>
   <a href="#getting-started"><strong>Explore the docs »</strong></a>
   <br />
   <br />
   <a href="#demo">View Demo</a>
   ·
   <a href="https://github.com/KaylaPosthumusOW/dunno_app/issues">Report Bug</a>
   ·
   <a href="https://github.com/KaylaPosthumusOW/dunno_app/issues">Request Feature</a>
  </p>

## Table of Contents
- [About Dunno](#about-dunno)
- [Built With](#built-with)
- [Getting Started](#getting-started)
- [Dunno Features & Functionality](#dunno-features--functionality)
- [User Testing](#user-testing)
- [Screenshots](#screenshots)
- [Development](#development)
- [Author](#author)
- [Contact](#contact)

## About Dunno
<img src="assets/mockups/homepage_mockup.png" alt="Dunno Homepage" height="400" align="center">

### Project Description
Dunno is an innovative AI-powered gift suggestion application that eliminates the guesswork from gift-giving. Whether you're shopping for a close friend, family member, or colleague, Dunno leverages artificial intelligence to generate personalized gift recommendations based on detailed profiles, preferences, and occasions.

The app features a sophisticated social component where users can connect with friends, create and share collections of their interests, and receive gift suggestions based on their personal preferences. With integrated AI technology powered by OpenAI, Dunno provides contextual, budget-aware, and location-specific gift recommendations.

## Built With
- **Flutter 3.9+**: Cross-platform UI toolkit for native mobile applications
- **Dart**: Modern programming language optimized for Flutter development
- **Firebase Suite**: 
  - Authentication (email/password, Google Sign-In, Apple Sign-In)
  - Firestore (real-time database for user data, collections, gift boards)
  - Storage (image and file uploads)
  - Analytics & Crashlytics (performance monitoring)
  - Remote Config (feature flags and configuration)
  - Messaging (push notifications)
- **OpenAI GPT Integration**: AI-powered gift suggestion generation
- **BLoC Pattern**: State management for predictable and testable code
- **GoRouter**: Declarative navigation and routing
- **Get It**: Dependency injection for clean architecture
- **Lottie**: Beautiful animations and loading indicators
- **Additional Libraries**:
  - `cached_network_image`: Optimized image loading and caching
  - `flutter_typeahead`: Smart search functionality
  - `table_calendar`: Interactive calendar components
  - `syncfusion_flutter_sliders`: Custom UI components

## Getting Started

### Prerequisites
- Flutter SDK 3.9.0 or higher
- Dart 3.0.0 or higher
- iOS 12.0+ / Android API level 21+
- Active Firebase project
- OpenAI API key for gift suggestions

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/KaylaPosthumusOW/dunno_app.git
   cd dunno_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Environment Configuration**
   - Create a `.env` file in the root directory
   - Add your OpenAI API key:
     ```
     OPENAI_API_KEY=your_openai_api_key_here
     ```

4. **Firebase Setup**
   - Add your `google-services.json` (Android) to `android/app/`
   - Add your `GoogleService-Info.plist` (iOS) to `ios/Runner/`
   - Update `firebase_options.dart` with your Firebase configuration

5. **Run the application**
   ```bash
   flutter run
   ```

## Dunno Features & Functionality

### 🎁 AI-Powered Gift Suggestions
<img src="assets/mockups/ai_suggestions_mockup.png" alt="AI Gift Suggestions" height="300" align="right">

- **Quick Suggestions**: Generate instant gift ideas based on basic recipient information
- **Friend-Based Suggestions**: Leverage friend's collection data for personalized recommendations
- **Advanced Filtering**: Filter by budget, category, relationship type, and location
- **Smart Refinement**: Iterative improvement of suggestions based on user feedback
- **Local Store Integration**: Prioritizes South African retailers (Takealot, Woolworths, etc.)

### 👥 Social Features
- **Friend Connections**: Connect with friends to access their gift preferences
- **Collections**: Create and share personal collections of interests and preferences
- **Profile Management**: Detailed user profiles with preferences and gift history
- **Friend Discovery**: Find and connect with friends through search functionality

### 📋 Gift Board Management
<img src="assets/mockups/gift_boards_mockup.png" alt="Gift Boards" height="300" align="left">

- **Custom Gift Boards**: Organize gift ideas by recipient, occasion, or category
- **Board Sharing**: Share gift boards with friends and family
- **Suggestion Saving**: Save favorite gift suggestions to boards for later reference
- **Visual Organization**: Image-rich boards for easy browsing

### 🔍 Advanced Search & Discovery
- **Real-time Search**: Find collections and gift boards with smart debounced search
- **Filter Integration**: Multiple filtering options for precise results
- **Smart Recommendations**: AI-driven suggestions based on user behavior and preferences

### 📱 User Experience Features
- **Onboarding Flow**: Guided setup for new users
- **Custom UI Components**: Consistent design system with custom headers, buttons, and forms
- **Loading Animations**: Engaging Lottie animations during AI processing
- **Success Feedback**: Visual confirmation of completed actions
- **Error Handling**: Graceful error recovery with retry mechanisms

### 🛡️ Security & Privacy
- **Firebase Authentication**: Secure user authentication with multiple providers
- **Data Encryption**: Secure storage of user data and preferences
- **Privacy Controls**: User control over data sharing and visibility

## User Testing

### Testing Overview
*This section will be populated with comprehensive user testing results, including:*

### Planned Testing Areas
- **Usability Testing**: Navigation flow, user interface intuitiveness, task completion rates
- **AI Suggestion Quality**: Relevance and accuracy of gift recommendations
- **Performance Testing**: App responsiveness, loading times, offline functionality
- **Accessibility Testing**: Screen reader compatibility, color contrast, font scaling
- **Cross-Platform Testing**: iOS and Android functionality parity

### Testing Methodology
*To be documented with:*
- User personas and testing scenarios
- A/B testing results for key features
- Quantitative metrics (task completion time, success rates)
- Qualitative feedback and user satisfaction scores
- Accessibility compliance testing results

### Results Summary
*Results and insights from user testing sessions will be documented here, including:*
- Key findings and user behavior patterns
- Identified pain points and areas for improvement
- Feature adoption rates and user engagement metrics
- Performance benchmarks and optimization outcomes

## Screenshots

### Core User Journey
<div align="center">
  <img src="assets/mockups/login_flow_mockup.png" alt="Login Flow" width="200" style="margin: 10px;">
  <img src="assets/mockups/onboarding_mockup.png" alt="Onboarding" width="200" style="margin: 10px;">
  <img src="assets/mockups/home_screen_mockup.png" alt="Home Screen" width="200" style="margin: 10px;">
  <img src="assets/mockups/profile_setup_mockup.png" alt="Profile Setup" width="200" style="margin: 10px;">
</div>

### Gift Suggestion Features
<div align="center">
  <img src="assets/mockups/quick_suggestions_mockup.png" alt="Quick Suggestions" width="200" style="margin: 10px;">
  <img src="assets/mockups/filter_screen_mockup.png" alt="Filter Options" width="200" style="margin: 10px;">
  <img src="assets/mockups/suggestion_results_mockup.png" alt="Suggestion Results" width="200" style="margin: 10px;">
  <img src="assets/mockups/suggestion_details_mockup.png" alt="Suggestion Details" width="200" style="margin: 10px;">
</div>

### Social Features
<div align="center">
  <img src="assets/mockups/friend_discovery_mockup.png" alt="Friend Discovery" width="200" style="margin: 10px;">
  <img src="assets/mockups/collections_mockup.png" alt="Collections" width="200" style="margin: 10px;">
  <img src="assets/mockups/friend_profile_mockup.png" alt="Friend Profile" width="200" style="margin: 10px;">
  <img src="assets/mockups/collection_details_mockup.png" alt="Collection Details" width="200" style="margin: 10px;">
</div>

## Development

### Architecture
Dunno follows Clean Architecture principles with clear separation of concerns:

```
lib/
├── core/                 # Core functionality and dependency injection
├── constants/           # App constants, themes, and routes
├── cubits/             # BLoC state management
├── models/             # Data models and entities
├── repositories/       # Data repositories and API clients
├── services/           # External service integrations
├── stores/             # Data storage abstractions
└── ui/                 # User interface components and screens
    ├── screens/        # App screens and pages
    └── widgets/        # Reusable UI components
```

### Key Technical Decisions
- **BLoC Pattern**: Chosen for predictable state management and testability
- **Repository Pattern**: Abstracts data sources for flexibility and testing
- **Dependency Injection**: Using Get It for clean, testable dependencies
- **Modular UI**: Custom widget library for consistent design system
- **Error Handling**: Comprehensive error states with user-friendly messages

### Code Quality
- Linting rules enforced with `flutter_lints`
- Consistent code formatting and documentation
- Comprehensive error handling and logging
- Memory management with proper disposal patterns

## Author

**Kayla Posthumus**
- Student ID: 231096
- Course: Interactive Development 300
- Institution: The Open Window
- Year: 2025

## Contact

- **GitHub**: [@KaylaPosthumusOW](https://github.com/KaylaPosthumusOW)
- **Email**: [231096@virtualwindow.co.za](mailto:231096@virtualwindow.co.za)
- **Project Link**: [https://github.com/KaylaPosthumusOW/dunno_app](https://github.com/KaylaPosthumusOW/dunno_app)

---

<p align="center">
  Made with ❤️ for gift-givers everywhere
</p>
- **CachedNetworkImage**: Image caching
- **Google Fonts**: Typography
- **FontAwesome**: Icon library
- **Frame Packages**: Custom packages for Frame functionality (see `pubspec.yaml`)