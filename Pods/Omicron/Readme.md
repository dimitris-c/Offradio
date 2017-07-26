## Omicron

[![Platforms](https://img.shields.io/cocoapods/p/Omicron.svg)](https://cocoapods.org/pods/Omicron)

[![Swift Package Manager](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg)](https://github.com/apple/swift-package-manager)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![CocoaPods compatible](https://img.shields.io/cocoapods/v/Omicron.svg)](https://cocoapods.org/pods/Omicron)

[![BuddyBuild](https://dashboard.buddybuild.com/api/statusImage?appID=5970b02e4299640001ac399f&branch=master&build=latest)](https://dashboard.buddybuild.com/apps/5970b02e4299640001ac399f/build/latest?branch=master)
[![JetpackSwift](https://img.shields.io/badge/JetpackSwift-framework-red.svg)](http://github.com/JetpackSwift/FrameworkTemplate)

A tiny API Service framework

- [Requirements](#requirements)
- [Installation](#installation)
- [Usage](#usage)
- [License](#license)

## Requirements

- iOS 8.0+ / Mac OS X 10.10+ / tvOS 9.0+ / watchOS 2.0+
- Xcode 8.0+

## Installation

### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

> CocoaPods 1.1.0+ is required to build Omicron 0.0.1+.

To integrate Omicron into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'
use_frameworks!

pod 'Omicron', '~> 0.1'
pod 'Omicron/RxSwift', '~> 0.1'
```

Then, run the following command:

```bash
$ pod install
```

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that automates the process of adding frameworks to your Cocoa application.

You can install Carthage with [Homebrew](http://brew.sh/) using the following command:

```bash
$ brew update
$ brew install carthage
```

To integrate Omicron into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "Omicron/Omicron" ~> 0.1
```
### Swift Package Manager

To use Omicron as a [Swift Package Manager](https://swift.org/package-manager/) package just add the following in your Package.swift file.

``` swift
import PackageDescription

let package = Package(
    name: "HelloOmicron",
    dependencies: [
        .Package(url: "https://github.com/dimtris-c/Omicron.git", "0.1")
    ]
)
```

### Manually

If you prefer not to use either of the aforementioned dependency managers, you can integrate Omicron into your project manually.

#### Git Submodules

- Open up Terminal, `cd` into your top-level project directory, and run the following command "if" your project is not initialized as a git repository:

```bash
$ git init
```

- Add Omicron as a git [submodule](http://git-scm.com/docs/git-submodule) by running the following command:

```bash
$ git submodule add https://github.com/dimitris-c/Omicron.git
$ git submodule update --init --recursive
```

- Open the new `Omicron` folder, and drag the `Omicron.xcodeproj` into the Project Navigator of your application's Xcode project.

    > It should appear nested underneath your application's blue project icon. Whether it is above or below all the other Xcode groups does not matter.

- Select the `Omicron.xcodeproj` in the Project Navigator and verify the deployment target matches that of your application target.
- Next, select your application project in the Project Navigator (blue project icon) to navigate to the target configuration window and select the application target under the "Targets" heading in the sidebar.
- In the tab bar at the top of that window, open the "General" panel.
- Click on the `+` button under the "Embedded Binaries" section.
- You will see two different `Omicron.xcodeproj` folders each with two different versions of the `Omicron.framework` nested inside a `Products` folder.

    > It does not matter which `Products` folder you choose from.

- Select the `Omicron.framework`.

- And that's it!

> The `Omicron.framework` is automagically added as a target dependency, linked framework and embedded framework in a copy files build phase which is all you need to build on the simulator and a device.

#### Embeded Binaries

- Download the latest release from https://github.com/dimitris-c/Omicron/releases
- Next, select your application project in the Project Navigator (blue project icon) to navigate to the target configuration window and select the application target under the "Targets" heading in the sidebar.
- In the tab bar at the top of that window, open the "General" panel.
- Click on the `+` button under the "Embedded Binaries" section.
- Add the downloaded `Omicron.framework`.
- And that's it!

## Usage
Initial setup for a Service.
```swift
enum GithubService {
    case user(name: String)
}

extension GithubService: Service {
    
    var baseURL: URL { return URL(string: "https://api.github.com")! }
    
    var path: String {
        switch self {
        case .user(let name): return "/users/\(name)"
        }
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var params: RequestParameters {
        return RequestParameters.default
    }
    
}
```

Typical usage would be 
```swift
let service = APIService<GithubService>()

service.callJSON(with: .user(name: "dimitris-c")) { (success, result, response) in
    if let json = result.value, success {
        print(json)
    }
}
```

To cancel a request, every method that calls an API returns an Alamofire request.
```swift
let service = APIService<GithubService>()

let request = service.callJSON(with: .user(name: "dimitris-c")) { (success, result, response) in
    if let json = result.value, success {
        print(json)
    }
}

//later on...
request.cancel()
```

Using RxSwift

```swift
let service = RxAPIService<GithubService>()

_ = service.callJSON(with: .user(name: "dimitris-c")).subscribe(onNext: { json in
    print(json)
})
```

#### Custom parsing to typed objects

One of the nice things that Omicron has is that you may define a custom Parser for a request that returns a specific model. We already provide a JSONResponse which just outputs the raw JSON from server.

```swift
struct GithubUser {
    let id: String
    let user: String
    let name: String
    
    init(with json: JSON) {
        self.id = json["id"].stringValue
        self.user = json["user"].stringValue
        self.name = json["name"].stringValue
    }
}

class GithubUserResponse: APIResponse<GithubUser> {
    override func toData(rawData data: JSON) -> GithubUser {
        return GithubUser(with: data)
    }
}

let service = ApiService<GithubService>()
var user: GithubUser?
service.call(with: .user(name: "dimitris-c"), parse: GithubUserResponse(), { (success, result, response) in
        if success {
            user = result.value 
        }
})

```


## License

Omicron is released under the MIT license. See [LICENSE](https://github.com/dimitris-c/Omicron/blob/master/LICENSE) for details.
