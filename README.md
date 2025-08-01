# DeviceModels

DeviceModels is a simple package that helps you identify the model name and type of an iOS device. It reads data from a JSON that I regularly update and is hosted on [GitHub](https://confuseious.github.io/DeviceModels/data.json), which means your app is always aware of the latest device models without your having to update it.

## Installation

### Swift Package Manager
Add the following to your `Package.swift` file:

```swift
.package(url: "https://github.com/ConfuseIous/DeviceModels.git", from: "1.0.0")
```

## Usage

```swift
import DeviceModels

let details = UIDevice.current.getDeviceDetails()
print(details.modelName) // Eg: iPhone 11 Pro
print(details.modelType) // Eg: iPhoneX
```

modelName refers to the name of the device as is displayed in the Settings app.

modelType refers to the type of device and is one of the following:
- iPhone (for all iPhones)
- iPhoneX (for all iPhones with a notch)
- iPhonePill (for all iPhones with a Dynamic Island)
- iPad (for all iPads)
- iPadX (for all iPads without a home button)
- vision.pro (for Apple Vision Pro)

Since the data is read from a remote JSON, you should cache the fetched Device Details (in UserDefaults, for example) for offline retrieval. However, you should refresh them periodically, as device details can sometimes change (such as when the user migrates to a new device and chooses to transfer data from their previous device).

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

To add a new device, simply modify data.json and add the device name and type to the list. Please make sure that the device name is exactly the same as the one displayed in the Settings app.
