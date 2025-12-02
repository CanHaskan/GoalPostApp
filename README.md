# GoalPost App

GoalPost is a simple and clean iOS app built with **Swift** and **Core
Data**, allowing users to create, track, update, and complete personal
goals.

------------------------------------------------------------------------

## 🚀 Features

-   Create short-term and long-term goals\
-   Set a completion target for each goal\
-   Increment progress with swipe actions\
-   Delete goals with a custom **UNDO Snackbar**\
-   Smooth custom transitions between screens\
-   Persistent storage using **Core Data**

------------------------------------------------------------------------

## 🧱 Technologies Used

-   Swift 5+
-   UIKit
-   Core Data
-   AutoLayout
-   CATransition animations

------------------------------------------------------------------------

## 📱 Screenshots

Add your screenshots inside a folder named `Screenshots/`

------------------------------------------------------------------------

## 📦 Installation

1.  Clone the repository:

``` bash
git clone https://github.com/YOUR_USERNAME/GoalPostApp.git
```

2.  Open the project:

``` bash
open GoalPostApp.xcodeproj
```

3.  Run the app on Simulator or device.

------------------------------------------------------------------------

## 🗂 Project Structure

    GoalPostApp
    │
    ├── Controllers
    │   ├── GoalsVC.swift
    │   ├── CreateGoalVC.swift
    │   └── FinishGoalVC.swift
    │
    ├── Model
    │   └── Goal+CoreData
    │
    ├── View
    │   ├── GoalCell.swift
    │   └── UI components
    │
    └── Resources
        └── Assets.xcassets

------------------------------------------------------------------------

## 📝 Undo Snackbar Logic

-   Custom red snackbar\
-   Slide-up animation\
-   Undo restores the deleted goal\
-   Delayed permanent deletion using `DispatchWorkItem`

------------------------------------------------------------------------

## 🧑‍💻 Author

**Can Haskan**

------------------------------------------------------------------------

## 📄 License

Free to use for learning purposes.
