# MTTransitions

Transitions ports from [GL-Transitions](https://gl-transitions.com/)


- [x] MTAngularTransition
- [x] MTBounceTransition
- [x] MTBowTieHorizontalTransition
- [x] MTBowTieVerticalTransition
- [x] MTBurnTransition
- [x] MTButterflyWaveScrawlerTransition
- [x] MTCannabisleafTransition
- [x] MTCircleCropTransition
- [x] MTCircleTransition
- [x] MTCircleopenTransition
- [x] MTColorphaseTransition
- [x] MTColourDistanceTransition
- [x] MTCrazyParametricFunTransition
- [ ] MTCrossZoomTransition
- [x] MTCrosshatchTransition
- [x] MTCrosswarpTransition
- [ ] MTCubeTransition
- [x] MTDirectionalTransition
- [x] MTDirectionalWarpTransition
- [x] MTDirectionalwipeTransition
- [x] MTDisplacementTransition
- [x] MTDoomScreenTransition
- [ ] MTDoorwayTransition
- [x] MTDreamyTransition
- [x] MTDreamyZoomTransition
- [x] MTFadeTransition
- [x] MTFadecolorTransition
- [x] MTFadegrayscaleTransition
- [x] MTFlyeyeTransition
- [ ] MTGlitchDisplaceTransition
- [x] MTGlitchMemoriesTransition
- [x] MTGridFlipTransition
- [x] MTHeartTransition
- [x] MTHexagonalizeTransition
- [ ] MTInvertedPageCurlTransition
- [x]  MTKaleidoscopeTransition
- [x] MTLinearBlurTransition
- [ ] MTLumaTransition
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
- [x] MTRandomsquaresTransition
- [x] MTRippleTransition
- [x] MTRotateScaleFadeTransition
- [x] MTSimpleZoomTransition
- [x] MTSquaresWireTransition
- [x] MTSqueezeTransition
- [ ] MTStereoViewerTransition
- [x] MTSwapTransition
- [ ] MTSwirlTransition
- [ ] MTUndulatingBurnOutTransition
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
