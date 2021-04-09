# MTTransitions

Transitions ports from [GL-Transitions](https://gl-transitions.com/) to Metal.

![](Assets/2.gif)


## Features

- [x] Up to 76 transitions
- [x] Image Transitions
- [x] UIView Transitions
- [x] UIViewController Push Transtions
- [x] UIViewController Present Transitions
- [x] Video Merge Transitions
- [x] Create video from images with transitions 
- [x] Create video from images with transitions and background music

## Requirements

* iOS 10.0 +
* Xcode 11.0 +
* Swift 5.0 +

## Transitions

Support Following Transitions:

- [x] MTAngularTransition
- [x] MTBounceTransition
- [x] MTBowTieHorizontalTransition
- [x] MTBowTieVerticalTransition
- [x] MTBurnTransition
- [x] MTButterflyWaveScrawlerTransition
- [x] MTCannabisleafTransition
- [x] MTCircleCropTransition
- [x] MTCircleTransition
- [x] MTCircleOpenTransition
- [x] MTColorPhaseTransition
- [x] MTColourDistanceTransition
- [x] MTCrazyParametricFunTransition
- [x] MTCrossZoomTransition
- [x] MTCrossHatchTransition
- [x] MTCrossWarpTransition
- [x] MTCubeTransition
- [x] MTDirectionalTransition
- [x] MTDirectionalWarpTransition
- [x] MTDirectionalWipeTransition
- [x] MTDisplacementTransition
- [x] MTDoomScreenTransition
- [x] MTDoorwayTransition
- [x] MTDreamyTransition
- [x] MTDreamyZoomTransition
- [x] MTFadeTransition
- [x] MTFadeColorTransition
- [x] MTFadegrayscaleTransition
- [x] MTFlyeyeTransition
- [x] MTGlitchDisplaceTransition
- [x] MTGlitchMemoriesTransition
- [x] MTGridFlipTransition
- [x] MTHeartTransition
- [x] MTHexagonalizeTransition
- [x] MTInvertedPageCurlTransition
- [x] MTKaleidoScopeTransition
- [x] MTLinearBlurTransition
- [x] MTLumaTransition
- [x] MTLuminanceMeltTransition
- [x] MTMorphTransition
- [x] MTMosaicTransition
- [x] MTMultiplyBlendTransition
- [x] MTPerlinTransition
- [x] MTPinwheelTransition
- [x] MTPixelizeTransition
- [x] MTPolarFunctionTransition
- [x] MTPolkaDotsCurtainTransition
- [x] MTRadialTransition
- [x] MTRandomSquaresTransition
- [x] MTRippleTransition
- [x] MTRotateScaleFadeTransition
- [x] MTSimpleZoomTransition
- [x] MTSquaresWireTransition
- [x] MTSqueezeTransition
- [x] MTStereoViewerTransition
- [x] MTSwapTransition
- [x] MTSwirlTransition
- [x] MTTangentMotionBlurTransition
- [x] MTTVStaticTransition
- [x] MTUndulatingBurnOutTransition
- [x] MTWaterDropTransition
- [x] MTWindTransition
- [x] MTWindowBlindsTransition
- [x] MTWindowSliceTransition
- [x] MTWipeDownTransition
- [x] MTWipeLeftTransition
- [x] MTWipeRightTransition
- [x] MTWipeUpTransition
- [x] MTZoomInCirclesTransition

## Installation

MTTransitions is available through CocoaPods. To install it, simply add the following line to your Podfile:

```sh
pod MTTransitions
```

## Get Started

Each transition requires two input `MTIImage`. Image should be `.oriented(.downMirrored)`.

```swift
import MTTransitions

let transition = MTBounceTransition()
transition.inputImage = <from Image>
transition.destImage = <to Image>

// animate progress from 0.0 to 1.0

imageView.image = transition.outputImage

```

### UIView Transition

```swift
let effect = MTPerlinTransition()

MTTransition.transition(with: view, effect: effect, animations: {
    // Do your animation to your view
}) { (_) in
    // Transition completed
}
```

### UIViewController Push Transition

```swift

class PushAViewController: UIViewController {

    private let transition = MTViewControllerTransition(transition: MTBurnTransition())
    
    // ...
}

extension PushAViewController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if operation == .push {
            return transition
        }
        return nil
    }
}
```

### UIViewController Present Transition

```swift

class PresentAViewController: UIViewController {

    // ...
    
    let vc = PresentBViewController()
    vc.modalPresentationStyle = .fullScreen
    vc.transitioningDelegate = self
    present(vc, animated: true, completion: nil)
}

extension PresentAViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return transtion
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return transtion
    }
}
```

### Video Transition

`MTTransitions` also support merging videos with transitions. 

* Support merge multiple video files
* Support multiple transition effects
* Support different multiple render size.
* Support passthrough transition.

```swift
// pick one transtion effect
let effect = MTTransition.Effect.wipeLeft
let duration = CMTimeMakeWithSeconds(2.0, preferredTimescale: 1000)
try? videoTransition.merge(clips,
                           effect: effect,
                           transitionDuration: duration) { [weak self] result in

    guard let self = self else { return }
    let playerItem = AVPlayerItem(asset: result.composition)
    playerItem.videoComposition = result.videoComposition
    
    self.player.seek(to: .zero)
    self.player.replaceCurrentItem(with: playerItem)
    self.player.play()
}
```

Please refer `VideoTransitionSampleViewController` and `MultipleVideoTransitionsViewController` for more details.


### Create Video From Images

`MTMovieMaker` support create video from a sequence images with transitions. You can also pass a local audio file url to `MTMovieMaker` to create background music. 

```swift
let fileURL = URL(fileURLWithPath: path)
movieMaker = MTMovieMaker(outputURL: fileURL)
do {
    try MTMovieMaker?.createVideo(with: images, effects: effects) { result in
        switch result {
        case .success(let url):
            print(url)
        case .failure(let error):
            print(error)
        }
    }
} catch {
    print(error)
}
```
