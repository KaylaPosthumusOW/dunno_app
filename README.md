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
   <a href="https://drive.google.com/drive/folders/1SViE4FkCVLL8Ane5yUorKsZnZ7ifUdI8?usp=sharing">View Demo</a>
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
Dunno is an innovative AI-powered gift suggestion application that eliminates the guesswork from gift-giving. Whether you're shopping for a close friend, family member, or colleague, Dunno leverages artificial intelligence to generate personalised gift recommendations based on detailed profiles, preferences, and occasions.

The app features a sophisticated social component where users can connect with friends, create and share collections of their interests, and receive gift suggestions based on their personal preferences. With integrated AI technology powered by OpenAI, Dunno provides contextual, budget-aware, and location-specific gift recommendations.

## Built With
- **Flutter 3.9+**: Cross-platform UI toolkit for native mobile applications
- **Dart**: Modern programming language optimised for Flutter development
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
  - `cached_network_image`: Optimised image loading and caching
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
  <img src="assets/mockup/onboarding.png" alt="Onboarding Flow" style="height: 300px; min-width: 200px; object-fit: contain;">
</div>

**1. Guided setup for new users** - Seamless introduction to Dunno with explanations of collection creation, finding and connecting with friends, and using quick suggestions.

---

### Homepage & Dashboard
<div align="center">
  <img src="assets/mockup/homepage.png" alt="Homepage Dashboard" style="height: 300px; min-width: 200px; object-fit: contain;">
</div>

**1. Personalised home experience** - Central hub featuring quick access to gift suggestions, upcoming events, friend activity, and personalised recommendations based on your connections and preferences.

**2. Never miss an occasion** - Smart calendar that tracks important dates, birthdays, and events for your friends and family with integrated gift reminder notifications.

---

### QR Code Connect
<div align="center">
  <img src="assets/mockup/QR Code Scanner.png" alt="QR Code Scanner" style="height: 300px; min-width: 200px; object-fit: contain;">
</div>

**1. Instant friend connections** - Quick and easy way to connect with friends by scanning QR codes from their profiles, making the social aspect seamless and immediate.

---

### Collections Management

<div align="center">
  <img src="assets/mockup/manage_collections.png" alt="Create Collection" style="height: 300px; min-width: 200px; object-fit: contain;">
</div>

**1. Express your interests** - Create personalised collections of your favorite things, brands, hobbies, and preferences to help friends find the perfect gifts for you.

**2. Keep preferences current** - Easily update and modify your collections as your interests evolve, ensuring friends always have up-to-date gift guidance.

---


### Gift Board Management
<div align="center">
  <img src="assets/mockup/gift_boards.png" alt="Gift Board Management" style="height: 300px; min-width: 200px; object-fit: contain;">
</div>

**1. Complete gift organisation system** - Comprehensive gift board management with full CRUD functionality for organising and tracking your gift ideas.

---

### Friend Gift Suggestions Flow
<div align="center">
  <img src="assets/mockup/find_friends.png" alt="Friend Discovery" style="height: 300px; min-width: 200px; object-fit: contain;">
</div>

**1. Discover your network** - Search and connect with friends through various methods including username search, contact integration, and mutual friend suggestions.

**2. View their profiles & Collections** - View detailed friend profiles showcasing their collections.

**3. Add Your Preferences** - Filter your gift suggestion by adding your preferences, and amount of suggestions you would like to receive.

**4. Receive Gift suggestions** - Receive your gift suggestions, based on the friends collection and your preferences.

**5. Refine Suggestions** - You are able to refine your suggestions afterwards as well

---

### Quick Gift Suggestions Flow
<div align="center">
  <img src="assets/mockup/quick_suggestions.png" alt="Quick Profile Input" style="height: 300px; min-width: 200px; object-fit: contain;">
</div>

**1. Fast recipient profiling** - Quickly input basic information about the gift recipient including age, gender, interests, and occasion for instant suggestions.

**2. Immediate results** - Get instant AI-generated gift ideas without needing friend connections, perfect for last-minute shopping or distant acquaintances.

---


**Key Features:**
- **Create Gift Boards**: Design custom gift boards for different people, occasions, or categories to keep your gift planning organised and accessible
- **View Gift Boards**: Browse your entire collection with visual organisation and easy navigation to find stored suggestions quickly
- **Edit Gift Boards**: Update board details, reorganise saved suggestions, and modify settings to keep your planning current and relevant
- **Save Suggestions**: Capture any AI-generated gift suggestions to your boards for future reference and organised gift planning
- **Board Categories**: Organise by recipient, occasion, budget range, or custom categories for maximum flexibility
- **Visual Organisation**: Image-rich boards with thumbnails and previews for easy browsing and quick identification

## User Testing

### Testing Overview
User testing was conducted through hands-on walkthrough sessions where participants were guided through the app's core functionality. This approach provided valuable insights into user experience, interface design, and feature usability.

### Testing Methodology
- **Format**: Interactive walkthrough sessions with real users
- **Approach**: Users were guided through key app features and workflows
- **Focus Areas**: User interface design, color scheme effectiveness, feature functionality, and user workflow preferences
- **Feedback Collection**: Direct observation and verbal feedback during app usage

### Key User Feedback & Implemented Changes

#### Visual Design Improvements
**Feedback Received**: Users suggested improving text readability by making bold text more prominent against the colorful background to prevent visual overcrowding.

**Implementation**: Enhanced text hierarchy and contrast to ensure important information stands out while maintaining the vibrant design aesthetic.

#### Color-Coded Feature Organization
**Feedback Received**: Users recommended implementing a color-coding system to help distinguish between different app features and contexts.

**Implementation**: Developed a strategic color palette system:
- **Yellow**: Personal features and user-specific content
- **Bright Pink**: Friend-related features and social interactions  
- **Orange**: Quick suggestion features and instant recommendations

This color coding helps users quickly identify and navigate between different functional areas of the app.

#### Gift Board Functionality
**Feedback Received**: A key user insight led to the development of the gift board feature. Users expressed the need to save specific individual suggestions to boards of their choosing, rather than saving all suggestions at once or having limited organization options.

**Implementation**: Created a comprehensive gift board system allowing users to:
- Create custom boards for different recipients or occasions
- Selectively save individual suggestions to specific boards
- Organize saved suggestions across multiple boards
- Manage and edit board contents as needed

### Results Summary
The user testing sessions provided actionable feedback that directly influenced the app's visual design and core functionality. The implementation of user suggestions resulted in:
- Improved visual hierarchy and readability
- Intuitive color-coded navigation system
- Enhanced user control over saving and organizing gift suggestions
- Better overall user experience and feature discoverability

These insights demonstrate the value of direct user engagement in refining app functionality and ensuring the final product meets real user needs and preferences.

## Mock Ups

<div align="center">
  <img src="assets/mockup/iPhone 14 Pro Mockup 10.png" alt="Mockup 1" style="height: 400px; min-width: 200px; object-fit: contain;">
</div>
<div align="center">
  <img src="assets/mockup/iPhone 14 Pro Mockup 5.png" alt="Mock up 2" style="height: 400px; min-width: 200px; object-fit: contain;">
</div>


## Challenges & Solutions

Throughout the development of Dunno, several significant challenges were encountered and overcome, each providing valuable learning experiences and technical growth.

**Challenges:**
- Data consistency between calendar events and collections
- Inconsistent UI styling across screens
- QR code implementation requiring specialised knowledge
- AI integration while maintaining performance
- Gathering actionable feedback from diverse user groups

**Solutions:**
- Implemented cascade update system using Firebase batch operations
- Standardised components with consistent styling patterns
- Collaborated with experienced developers for technical expertise
- Used smart caching, error handling, and AI assistance for optimisation
- Conducted comprehensive testing sessions with iterative improvements

### Key Technical Decisions
- **BLoC Pattern**: Chosen for predictable state management and testability
- **Repository Pattern**: Abstracts data sources for flexibility and testing
- **Dependency Injection**: Using Get It for clean, testable dependencies
- **Modular UI**: Custom widget library for consistent design system
- **Error Handling**: Comprehensive error states with user-friendly messages

## Author

**Kayla Posthumus**
- Student Number: 231096
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
