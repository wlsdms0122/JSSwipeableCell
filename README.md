# JSSwipeableCell
![Support](https://img.shields.io/badge/support-iOS%2010.0+-blue)
![CocoaPods](https://img.shields.io/badge/cocoaPods-available-red)
![SPM](https://img.shields.io/badge/spm-available-gren)

Simple & manually configurable swipe action on `UICollectionViewCell`.

# Installation
### Cocoapods
```
pod 'JSSwipeableCell'
```

### Swift Package Manager
```swift
let package = Package(
    ...
    dependencies: [
        .package(url: "https://github.com/wlsdms0122/JSSwipeableCell", from: "1.1.0")
    ],
    targets: [
        .target(
            name: "Your target",
            dependencies: ["JSSwipeableCell"]
        ),
    ]
    ...
)
```

# Usage
You can swipe action just inherit `JSSwipeableCollectionViewCell`.
```swift
class CustomCollectionViewCell: JSSwipeableCollectionViewCell { }
```

You can only `left`, `right` swipe action now. you can add any `UIView` in swipe action view.
```swift
let deleteButton: UIButton = {
    let view = UIButton()
    view.backgroundColor = .red
    view.setTitle("Delete", for: .normal)
    return view
}

init(frame: CGRect) {
    super.init(frame: frame)
    
    // If you use `SnapKit`, set swipe action view like this.
    [deleteButton].forEach { rightActionView.addSubview($0) }
    deleteButton.snp.makeConstraints { make in
        make.edges.equalToSuperview()
        make.width.equalTo(80)
    }
}
```
Then you can see your cell swipe to left and visible delete button.

Swipe action based on `leftActionView` and `RightActionView`'s size. So you have to set these view can calculate size.

### Additinal Feature
Serve several properties and methods.
```swift
// MARK: properties
var speed: Double = 0.3 // Auto swipe animation speed.
var isSwipeThreshold: Bool = true // Swipe can only action view's bounds

// MARK: methods
func willSwipe(able cell: JSSwipeableCollectionViewCell)
func didSwipe(able cell: JSSwipeableCollectionViewCell, translation: CGPoint, direction: Direction)
func endSwipe(able cell: JSSwipeableCollectionViewCell, translation: CGPoint, direction: Direction)
```
If you want more powerful transition, animation, etc... override these properties and methods.

Demo app should be help you to get more informations.

# Contribution
Any ideas, issues, opinions are welcome.

# License
`JSSwipeableCell` is available under the MIT license.
