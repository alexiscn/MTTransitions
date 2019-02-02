# MTTransitions

Transitions ports from [GL-Transitions](https://gl-transitions.com/)

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
- [ ] MTInvertedPageCurlTransition
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

# Installation

MTTransitions is available through CocoaPods. To install it, simply add the following line to your Podfile:

```sh
pod MTTransitions
```

# Usage

Each transition requires two input `MTIImage`.

```swift
import MTTransitions

let transition = MTBounceTransition()
transition.inputImage = <from Image>
transition.destImage = <to Image>

// animate progress from 0.0 to 1.0

imageView.image = transition.outputImage

```
