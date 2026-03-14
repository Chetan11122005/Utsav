# 🎊 Utsav (उत्सव)
### Celebrate the Spirit of India

**Utsav** is a high-end iOS application built with **SwiftUI** designed to bring the vibrant heritage of Indian festivals to your fingertips. The app features a modern, immersive UI with fluid "Hero" transitions and a focus on cultural storytelling.

---

## ✨ Key Features

* **Immersive Hero Transitions**: Seamlessly transition from a discovery list to a detailed festival view using the `matchedGeometryEffect`.
* **Glassmorphism UI**: High-fidelity design utilizing `ultraThinMaterial` for navigation and controls, ensuring a premium feel.
* **Dynamic Theming**: The app's color palette and gradients adapt dynamically based on the festival’s unique cultural "vibe."
* **Curated Rituals**: A dedicated section for "Key Rituals" with custom iconography and interactive layouts.
* **Optimized for iOS 17+**: Utilizing the latest SwiftUI features for smooth performance and modern aesthetics.

---

## 📸 Preview

| Home Discovery | Expanded View | Hero Animation |
| :--- | :--- | :--- |
| ![Home](https://via.placeholder.com/200x400?text=Discovery+Feed) | ![Detail](https://via.placeholder.com/200x400?text=Holi+Detail) | ![UI](https://via.placeholder.com/200x400?text=Smooth+Transition) |



---

## 🛠 Tech Stack & Implementation

- **Framework**: SwiftUI
- **Language**: Swift 5.10
- **UI Techniques**:
  - `Namespace`: Orchestrates the shared element transition.
  - `LinearGradients`: Carefully layered to ensure text readability over bright festival imagery.
  - `ZStack Alignment`: Precision positioning of typography to overlap hero images elegantly.
  - `Spring Animations`: Tuned with `.spring(response: 0.6, dampingFraction: 0.8)` for a natural, tactile feel.

---

## 🚀 Installation

1.  **Clone the Repo**
    ```bash
    git clone [https://github.com/yourusername/utsav-app.git](https://github.com/yourusername/utsav-app.git)
    ```
2.  **Open in Xcode**
    Open `Utsav.xcodeproj` and ensure your target is set to **iOS 17.0** or later.
3.  **Add Assets**
    Ensure your `Assets.xcassets` contains images named in lowercase (e.g., `holi`, `diwali`) to match the data model.
4.  **Run**
    Press `Cmd + R` to run on your favorite simulator.

---

## 📖 Code Highlight: The Hero Logic

The seamless expansion is handled by linking the card and the detail view through a shared `Namespace`:

```swift
// In HomeView Card
.matchedGeometryEffect(id: "image\(festival.id)", in: animation)

// In ExpandedHeroView
.matchedGeometryEffect(id: "image\(festival.id)", in: animation)
