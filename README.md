<p align="center">
<img src='https://github.com/avijitmobi/EasyImageVideoPicker/blob/master/Example/ScreenShots/1.png' width="200" />
<img src='https://github.com/avijitmobi/EasyImageVideoPicker/blob/master/Example/ScreenShots/2.png' width="200" />
<img src='https://github.com/avijitmobi/EasyImageVideoPicker/blob/master/Example/ScreenShots/3.png' width="200" />
</p>


# EasyImageVideoPicker

[![CI Status](https://img.shields.io/travis/avijitmobi/EasyImageVideoPicker.svg?style=flat)](https://travis-ci.org/avijitmobi/EasyImageVideoPicker)
[![Version](https://img.shields.io/cocoapods/v/EasyImageVideoPicker.svg?style=flat)](https://cocoapods.org/pods/EasyImageVideoPicker)
[![License](https://img.shields.io/cocoapods/l/EasyImageVideoPicker.svg?style=flat)](https://cocoapods.org/pods/EasyImageVideoPicker)
[![Platform](https://img.shields.io/cocoapods/p/EasyImageVideoPicker.svg?style=flat)](https://cocoapods.org/pods/EasyImageVideoPicker)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

This will run on iOS 12.0 and above devices.

## Installation

EasyImageVideoPicker is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'EasyImageVideoPicker'
```

## Usage

Import this framework and initialize it first. Don't forget to set your UsageDescription in your info.plist

```ruby
var imgPicker : EasyImageVideoPicker?
```

Set an object to that from your view controller and also set delegate for

```ruby
imgPicker = EasyImageVideoPicker(presentationController: self, delegate: self)
```

Show alert or options from your button action

```ruby
@IBAction func pickImage(_ sender : UIButton){
    imgPicker?.present(from: sender, mediaType: .images, onViewController: self)
}
```

Now pick image and video url from that delegate protocol.

```ruby
extension ViewController : EasyImageVideoPickerDelegate{

    func didSelect(image: UIImage?, video: URL?, fileName: String?) {
        //For image picker
        img.image = image
        //For video picker
        print("This is my video name" + (fileName ?? ""))
        print("This is my video url" + (video?.description ?? ""))
    }
    
}

```

## Author

Avijit Babu, avijitmobi@gmail.com

## License

EasyImageVideoPicker is available under the MIT license. See the LICENSE file for more info.
