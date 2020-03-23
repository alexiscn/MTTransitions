//
//  MTVideoTransition+Compositors.swift
//  MTTransitions
//
//  Created by xushuifeng on 2020/3/23.
//

import Foundation

extension MTVideoTransition {
    
    class AngularCompositor: MTVideoCompositor {
        override var effect: MTTransition.Effect { return .angular }
    }
    
    class BounceCompositor: MTVideoCompositor {
        override var effect: MTTransition.Effect { return .bounce }
    }
    
    class BowTieHorizontalCompositor: MTVideoCompositor {
        override var effect: MTTransition.Effect { return .bowTieHorizontal }
    }
    
    class BowTieVerticalCompositor: MTVideoCompositor {
        override var effect: MTTransition.Effect { return .bowTieVertical }
    }
    
    class BurnCompositor: MTVideoCompositor {
        override var effect: MTTransition.Effect { return .burn }
    }
    
    class ButterflyWaveScrawlerCompositor: MTVideoCompositor {
        override var effect: MTTransition.Effect { return .butterflyWaveScrawler }
    }
     
    class CannabisleafCompositor: MTVideoCompositor {
        override var effect: MTTransition.Effect { return .cannabisleaf }
    }

    class CircleCompositor: MTVideoCompositor {
        override var effect: MTTransition.Effect { return .circle }
    }
    
    class CircleCropCompositor: MTVideoCompositor {
        override var effect: MTTransition.Effect { return .circleCrop }
    }
    
    class CircleOpenCompositor: MTVideoCompositor {
        override var effect: MTTransition.Effect { return .circleOpen }
    }
    
    class ColorPhaseCompositor: MTVideoCompositor {
        override var effect: MTTransition.Effect { return .colorPhase }
    }
    
    class ColourDistanceCompositor: MTVideoCompositor {
        override var effect: MTTransition.Effect { return .colourDistance }
    }
    
    class CrazyParametricFunCompositor: MTVideoCompositor {
        override var effect: MTTransition.Effect { return .crazyParametricFun }
    }
    
    class CrossHatchCompositor: MTVideoCompositor {
        override var effect: MTTransition.Effect { return .crossHatch }
    }
    
    class CrossWarpCompositor: MTVideoCompositor {
        override var effect: MTTransition.Effect { return .crossWarp }
    }
    
    class CrossZoomCompositor: MTVideoCompositor {
        override var effect: MTTransition.Effect { return .crossZoom }
    }
    
    class CubeCompositor: MTVideoCompositor {
        override var effect: MTTransition.Effect { return .cube }
    }
    
    class DirectionalCompositor: MTVideoCompositor {
        override var effect: MTTransition.Effect { return .directional }
    }
    
    class DirectionalWarpCompositor: MTVideoCompositor {
        override var effect: MTTransition.Effect { return .directionalWarp }
    }
    
    class DirectionalWipeCompositor: MTVideoCompositor {
        override var effect: MTTransition.Effect { return .directionalWipe }
    }
    
    class DisplacementCompositor: MTVideoCompositor {
        override var effect: MTTransition.Effect { return .displacement }
    }
    
    class DoomScreenCompositor: MTVideoCompositor {
        override var effect: MTTransition.Effect { return .doomScreen }
    }
    
    class DoorwayCompositor: MTVideoCompositor {
        override var effect: MTTransition.Effect { return .doorway }
    }
    
    class DreamyCompositor: MTVideoCompositor {
        override var effect: MTTransition.Effect { return .dreamy }
    }
    
    class FadeCompositor: MTVideoCompositor {
        override var effect: MTTransition.Effect { return .fade }
    }
    
    class FadeColorCompositor: MTVideoCompositor {
        override var effect: MTTransition.Effect { return .fadeColor }
    }
    
    class FadegrayscaleCompositor: MTVideoCompositor {
        override var effect: MTTransition.Effect { return .fadegrayscale }
    }
    
    class FlyeyeCompositor: MTVideoCompositor {
        override var effect: MTTransition.Effect { return .flyeye }
    }
    
    class GlitchDisplaceCompositor: MTVideoCompositor {
        override var effect: MTTransition.Effect { return .glitchDisplace }
    }
    
    class GlitchMemoriesCompositor: MTVideoCompositor {
        override var effect: MTTransition.Effect { return .glitchMemories }
    }
    
    class GridFlipCompositor: MTVideoCompositor {
        override var effect: MTTransition.Effect { return .gridFlip }
    }
    
    class HeartCompositor: MTVideoCompositor {
        override var effect: MTTransition.Effect { return .heart }
    }
    
    class HexagonalizeCompositor: MTVideoCompositor {
        override var effect: MTTransition.Effect { return .hexagonalize }
    }
    
    class InvertedPageCurlCompositor: MTVideoCompositor {
        override var effect: MTTransition.Effect { return .invertedPageCurl }
    }
    
    class KaleidoScopeCompositor: MTVideoCompositor {
        override var effect: MTTransition.Effect { return .kaleidoScope }
    }
    
    class LinearBlurCompositor: MTVideoCompositor {
        override var effect: MTTransition.Effect { return .linearBlur }
    }
    
    class LumaCompositor: MTVideoCompositor {
        override var effect: MTTransition.Effect { return .luma }
    }
    
    class LuminanceMeltCompositor: MTVideoCompositor {
        override var effect: MTTransition.Effect { return .luminanceMelt }
    }
    
    class MorphCompositor: MTVideoCompositor {
        override var effect: MTTransition.Effect { return .morph }
    }
    
    class MosaicCompositor: MTVideoCompositor {
        override var effect: MTTransition.Effect { return .mosaic }
    }
    
    class MultiplyBlendCompositor: MTVideoCompositor {
        override var effect: MTTransition.Effect { return .multiplyBlend }
    }
    
    class PerlinCompositor: MTVideoCompositor {
        override var effect: MTTransition.Effect { return .perlin }
    }
    
    class PinwheelCompositor: MTVideoCompositor {
        override var effect: MTTransition.Effect { return .pinwheel }
    }
    
    class PixelizeCompositor: MTVideoCompositor {
        override var effect: MTTransition.Effect { return .pixelize }
    }
    
    class PolarFunctionCompositor: MTVideoCompositor {
        override var effect: MTTransition.Effect { return .polarFunction }
    }
    
    class PolkaDotsCurtainCompositor: MTVideoCompositor {
        override var effect: MTTransition.Effect { return .polkaDotsCurtain }
    }
    
    class RadialCompositor: MTVideoCompositor {
        override var effect: MTTransition.Effect { return .radial }
    }
    
    class RandomSquaresCompositor: MTVideoCompositor {
        override var effect: MTTransition.Effect { return .randomSquares }
    }
    
    class RippleCompositor: MTVideoCompositor {
        override var effect: MTTransition.Effect { return .ripple }
    }
    
    class RotateScaleFadeCompositor: MTVideoCompositor {
        override var effect: MTTransition.Effect { return .rotateScaleFade }
    }
    
    class SimpleZoomCompositor: MTVideoCompositor {
        override var effect: MTTransition.Effect { return .simpleZoom }
    }
    
    class SqueezeCompositor: MTVideoCompositor {
        override var effect: MTTransition.Effect { return .squeeze }
    }
    
    class StereoViewerCompositor: MTVideoCompositor {
        override var effect: MTTransition.Effect { return .stereoViewer }
    }
    
    class SwapCompositor: MTVideoCompositor {
        override var effect: MTTransition.Effect { return .swap }
    }
    
    class SwirlCompositor: MTVideoCompositor {
        override var effect: MTTransition.Effect { return .swirl }
    }
    
    class UndulatingBurnOutCompositor: MTVideoCompositor {
        override var effect: MTTransition.Effect { return .undulatingBurnOut }
    }
    
    class WaterDropCompositor: MTVideoCompositor {
        override var effect: MTTransition.Effect { return .waterDrop }
    }
    
    class WindCompositor: MTVideoCompositor {
        override var effect: MTTransition.Effect { return .wind }
    }
    
    class WindowBlindsCompositor: MTVideoCompositor {
        override var effect: MTTransition.Effect { return .windowBlinds }
    }
    
    class WindowSliceCompositor: MTVideoCompositor {
        override var effect: MTTransition.Effect { return .windowSlice }
    }
    
    class WipeDownCompositor: MTVideoCompositor {
        override var effect: MTTransition.Effect { return .wipeDown }
    }
    
    class WipeLeftCompositor: MTVideoCompositor {
        override var effect: MTTransition.Effect { return .wipeLeft }
    }
    
    class WipeRightCompositor: MTVideoCompositor {
        override var effect: MTTransition.Effect { return .wipeRight }
    }
    
    class WipeUpCompositor: MTVideoCompositor {
        override var effect: MTTransition.Effect { return .wipeUp }
    }
    
    class ZoomInCirclesCompositor: MTVideoCompositor {
        override var effect: MTTransition.Effect { return .zoomInCircles }
    }
}
