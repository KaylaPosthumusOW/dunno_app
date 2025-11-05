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
   <img src="assets/mockup/app_icon.png" alt="Dunno Logo" height="70">
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
<img src="assets/mockup/homepage_with_hand.png" alt="Dunno Homepage" height="400" align="center">

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

### Easy Onboarding
<div align="center">
  <img src="assets/mockups/onboarding_flow_placeholder.png" alt="Onboarding Flow" style="height: 300px; min-width: 200px; object-fit: contain;">
</div>

**Guided setup for new users** - Seamless introduction to Dunno with step-by-step profile creation, preference setting, and feature walkthrough to get users started quickly.

---

### Homepage & Dashboard
<div align="center">
  <img src="assets/mockups/homepage_placeholder.png" alt="Homepage Dashboard" style="height: 300px; min-width: 200px; object-fit: contain;">
</div>

**Personalized home experience** - Central hub featuring quick access to gift suggestions, upcoming events, friend activity, and personalized recommendations based on your connections and preferences.

---

### Calendar Integration
<div align="center">
  <img src="assets/mockups/calendar_placeholder.png" alt="Calendar Integration" style="height: 300px; min-width: 200px; object-fit: contain;">
</div>

**Never miss an occasion** - Smart calendar that tracks important dates, birthdays, and events for your friends and family with integrated gift reminder notifications.

---

### QR Code Scanner
<div align="center">
  <img src="assets/mockups/qr_scanner_placeholder.png" alt="QR Code Scanner" style="height: 300px; min-width: 200px; object-fit: contain;">
</div>

**Instant friend connections** - Quick and easy way to connect with friends by scanning QR codes from their profiles, making the social aspect seamless and immediate.

---

### Find & Connect with Friends
<div align="center">
  <img src="assets/mockups/friend_discovery_placeholder.png" alt="Friend Discovery" style="height: 300px; min-width: 200px; object-fit: contain;">
</div>

**Discover your network** - Search and connect with friends through various methods including username search, contact integration, and mutual friend suggestions.

---

### Friend Profile Viewing
<div align="center">
  <img src="assets/mockups/friend_profile_placeholder.png" alt="Friend Profile" style="height: 300px; min-width: 200px; object-fit: contain;">
</div>

**Understand their preferences** - View detailed friend profiles showcasing their collections, interests, preferred brands, and gift history to make informed gift decisions.

---

### Collections Management

#### Create Collections
<div align="center">
  <img src="assets/mockups/create_collection_placeholder.png" alt="Create Collection" style="height: 300px; min-width: 200px; object-fit: contain;">
</div>

**Express your interests** - Create personalized collections of your favorite things, brands, hobbies, and preferences to help friends find the perfect gifts for you.

#### View Collections
<div align="center">
  <img src="assets/mockups/view_collections_placeholder.png" alt="View Collections" style="height: 300px; min-width: 200px; object-fit: contain;">
</div>

**Browse and explore** - Discover collections from friends and family, exploring their interests and getting inspiration for gift ideas.

#### Edit Collections
<div align="center">
  <img src="assets/mockups/edit_collection_placeholder.png" alt="Edit Collection" style="height: 300px; min-width: 200px; object-fit: contain;">
</div>

**Keep preferences current** - Easily update and modify your collections as your interests evolve, ensuring friends always have up-to-date gift guidance.

---

### Friend Gift Suggestions Flow

#### Select Friend & Collection
<div align="center">
  <img src="assets/mockups/friend_selection_placeholder.png" alt="Friend Selection" style="height: 300px; min-width: 200px; object-fit: contain;">
</div>

**Choose your recipient** - Select a friend and explore their collections to understand their preferences before generating personalized gift suggestions.

#### Apply Filters
<div align="center">
  <img src="assets/mockups/gift_filters_placeholder.png" alt="Gift Filters" style="height: 300px; min-width: 200px; object-fit: contain;">
</div>

**Refine your search** - Apply advanced filters including budget range, category, relationship type, occasion, and preferred retailers for targeted suggestions.

#### AI-Generated Suggestions
<div align="center">
  <img src="assets/mockups/friend_suggestions_placeholder.png" alt="Friend Gift Suggestions" style="height: 300px; min-width: 200px; object-fit: contain;">
</div>

**Personalized recommendations** - Receive AI-powered gift suggestions based on your friend's collection data, filtered preferences, and local store availability.

---

### Quick Gift Suggestions Flow

#### Quick Profile Input
<div align="center">
  <img src="assets/mockups/quick_profile_placeholder.png" alt="Quick Profile Input" style="height: 300px; min-width: 200px; object-fit: contain;">
</div>

**Fast recipient profiling** - Quickly input basic information about the gift recipient including age, gender, interests, and occasion for instant suggestions.

#### Instant AI Suggestions
<div align="center">
  <img src="assets/mockups/quick_suggestions_placeholder.png" alt="Quick Suggestions" style="height: 300px; min-width: 200px; object-fit: contain;">
</div>

**Immediate results** - Get instant AI-generated gift ideas without needing friend connections, perfect for last-minute shopping or distant acquaintances.

---

### Gift Board Management
<div align="center">
  <img src="assets/mockups/gift_board_management_placeholder.png" alt="Gift Board Management" style="height: 300px; min-width: 200px; object-fit: contain;">
</div>

**Complete gift organization system** - Comprehensive gift board management with full CRUD functionality for organizing and tracking your gift ideas.

**Key Features:**
- **Create Gift Boards**: Design custom gift boards for different people, occasions, or categories to keep your gift planning organized and accessible
- **View Gift Boards**: Browse your entire collection with visual organization and easy navigation to find stored suggestions quickly
- **Edit Gift Boards**: Update board details, reorganize saved suggestions, and modify settings to keep your planning current and relevant
- **Save Suggestions**: Capture any AI-generated gift suggestions to your boards for future reference and organized gift planning
- **Board Categories**: Organize by recipient, occasion, budget range, or custom categories for maximum flexibility
- **Visual Organization**: Image-rich boards with thumbnails and previews for easy browsing and quick identification

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

## Challenges & Solutions

Throughout the development of Dunno, several significant challenges were encountered and overcome, each providing valuable learning experiences and technical growth.

**Challenges:**
- Data consistency between calendar events and collections
- Profile image upload blocking entire interface 
- Inconsistent UI styling across screens
- Documentation lacking logical structure and visual appeal
- QR code implementation requiring specialized knowledge
- AI integration while maintaining performance
- Gathering actionable feedback from diverse user groups

**Solutions:**
- Implemented cascade update system using Firebase batch operations
- Removed blocking dialogs and added contextual loading feedback
- Standardized components with consistent styling patterns
- Restructured documentation with user flow-based approach
- Collaborated with experienced developers for technical expertise
- Used smart caching, error handling, and AI assistance for optimization
- Conducted comprehensive testing sessions with iterative improvements

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

## Acknowledgements

I would like to extend my sincere gratitude to the following individuals and resources who made this project possible:

### Development Support
- **Herman Potgieter** - For invaluable assistance with QR code implementation and technical guidance
- **Donovin de Kock** - For contributing expertise and support with QR code functionality and integration

### AI Assistance
- **OpenAI & ChatGPT** - For providing AI-powered development assistance, code suggestions, and problem-solving support throughout the development process
- **GitHub Copilot** - For intelligent code completion and development acceleration

### Academic Guidance
- **Course Lecturer** - For providing essential feedback, insights on AI integration, and academic direction that shaped the project's development and learning outcomes

### User Experience
- **User Testers** - For their valuable feedback, suggestions, and real-world testing that helped identify issues and improve the overall app experience and usability

Their contributions, feedback, and support have been instrumental in bringing Dunno to life and ensuring its quality and functionality.

## Contact

- **GitHub**: [@KaylaPosthumusOW](https://github.com/KaylaPosthumusOW)
- **Email**: [231096@virtualwindow.co.za](mailto:231096@virtualwindow.co.za)
- **Project Link**: [https://github.com/KaylaPosthumusOW/dunno_app](https://github.com/KaylaPosthumusOW/dunno_app)
