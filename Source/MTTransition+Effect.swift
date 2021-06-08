//
//  MTTransition+Effect.swift
//  MTTransitions
//
//  Created by xushuifeng on 2020/3/22.
//

import Foundation

extension MTTransition {
    
    /// A convenience way to apply transtions.
    /// If you want to configure parameters, you can use following code:
    ///
    /// let transition = MTTransition.Effect.bounce.transition
    /// transition.shadowHeight = 0.02
    public enum Effect: CaseIterable, CustomStringConvertible {
        /// none transition applied
        case none
        case angular
        case bounce
        case bowTieHorizontal
        case bowTieVertical
        case burn
        case butterflyWaveScrawler
        case cannabisleaf
        case circle
        case circleCrop
        case circleOpen
        case colorPhase
        case colourDistance
        case crazyParametricFun
        case crossHatch
        case crossWarp
        case crossZoom
        case cube
        case directional
        case directionalEasing
        case directionalWarp
        case directionalWipe
        case displacement
        case doomScreen
        case doorway
        case dreamy
        case fadeColor
        case fadegrayscale
        case fade
        case flyeye
        case glitchDisplace
        case glitchMemories
        case gridFlip
        case heart
        case hexagonalize
        case invertedPageCurl
        case kaleidoScope
        case leftRight
        case linearBlur
        case luma
        case luminanceMelt
        case morph
        case mosaic
        case multiplyBlend
        case perlin
        case pinwheel
        case pixelize
        case polarFunction
        case polkaDotsCurtain
        case radial
        case randomNoisex
        case randomSquares
        case ripple
        case rotate
        case rotateScaleFade
        case simpleZoom
        case squaresWire
        case squeeze
        case stereoViewer
        case swap
        case swirl
        case tangentMotionBlur
        case topBottom
        case tvStatic
        case undulatingBurnOut
        case waterDrop
        case windowSlice
        case windowBlinds
        case wind
        case wipeDown
        case wipeLeft
        case wipeRight
        case wipeUp
        case zoomInCircles
        
        public var transition: MTTransition {
            switch self {
            case .none: return MTNoneTransition()
            case .angular: return MTAngularTransition()
            case .bounce: return MTBounceTransition()
            case .bowTieHorizontal: return MTBowTieHorizontalTransition()
            case .bowTieVertical: return MTBowTieVerticalTransition()
            case .burn: return MTBurnTransition()
            case .butterflyWaveScrawler: return MTButterflyWaveScrawlerTransition()
            case .cannabisleaf: return MTCannabisleafTransition()
            case .circle: return MTCircleTransition()
            case .circleCrop: return MTCircleCropTransition()
            case .circleOpen: return MTCircleOpenTransition()
            case .colorPhase: return MTColorPhaseTransition()
            case .colourDistance: return MTColourDistanceTransition()
            case .crazyParametricFun: return MTCrazyParametricFunTransition()
            case .crossHatch: return MTCrossHatchTransition()
            case .crossWarp: return MTCrossWarpTransition()
            case .crossZoom: return MTCrossZoomTransition()
            case .cube: return MTCubeTransition()
            case .directional: return MTDirectionalTransition()
            case .directionalEasing: return MTDirectionalEasingTransition()
            case .directionalWarp: return MTDirectionalWarpTransition()
            case .directionalWipe: return MTDirectionalWipeTransition()
            case .displacement: return MTDisplacementTransition()
            case .doomScreen: return MTDoomScreenTransition()
            case .doorway: return MTDoorwayTransition()
            case .dreamy: return MTDreamyTransition()
            case .fadeColor: return MTFadeColorTransition()
            case .fadegrayscale: return MTFadegrayscaleTransition()
            case .fade: return MTFadeTransition()
            case .flyeye: return MTFlyeyeTransition()
            case .glitchDisplace: return MTGlitchDisplaceTransition()
            case .glitchMemories: return MTGlitchMemoriesTransition()
            case .gridFlip: return MTGridFlipTransition()
            case .heart: return MTHeartTransition()
            case .hexagonalize: return MTHexagonalizeTransition()
            case .invertedPageCurl: return MTInvertedPageCurlTransition()
            case .kaleidoScope: return MTKaleidoScopeTransition()
            case .leftRight: return MTLeftRightTransition()
            case .linearBlur: return MTLinearBlurTransition()
            case .luma: return MTLumaTransition()
            case .luminanceMelt: return MTLuminanceMeltTransition()
            case .morph: return MTMorphTransition()
            case .mosaic: return MTMosaicTransition()
            case .multiplyBlend: return MTMultiplyBlendTransition()
            case .perlin: return MTPerlinTransition()
            case .pinwheel: return MTPinwheelTransition()
            case .pixelize: return MTPixelizeTransition()
            case .polarFunction: return MTPolarFunctionTransition()
            case .polkaDotsCurtain: return MTPolkaDotsCurtainTransition()
            case .radial: return MTRadialTransition()
            case .randomNoisex: return MTRandomNoisexTransition()
            case .randomSquares: return MTRandomSquaresTransition()
            case .ripple: return MTRippleTransition()
            case .rotate: return MTRotateTransition()
            case .rotateScaleFade: return MTRotateScaleFadeTransition()
            case .simpleZoom: return MTSimpleZoomTransition()
            case .squaresWire: return MTSquaresWireTransition()
            case .squeeze: return MTSqueezeTransition()
            case .stereoViewer: return MTStereoViewerTransition()
            case .swap: return MTSwapTransition()
            case .swirl: return MTSwirlTransition()
            case .tangentMotionBlur: return MTTangentMotionBlurTransition()
            case .topBottom: return MTTopBottomTransition()
            case .tvStatic: return MTTVStaticTransition()
            case .undulatingBurnOut: return MTUndulatingBurnOutTransition()
            case .waterDrop: return MTWaterDropTransition()
            case .windowSlice: return MTWindowSliceTransition()
            case .windowBlinds: return MTWindowBlindsTransition()
            case .wind: return MTWindTransition()
            case .wipeDown: return MTWipeDownTransition()
            case .wipeLeft: return MTWipeLeftTransition()
            case .wipeRight: return MTWipeRightTransition()
            case .wipeUp: return MTWipeUpTransition()
            case .zoomInCircles: return MTZoomInCirclesTransition()
            }
        }
        
        public var description: String {
            switch self {
            case .none: return "None"
            case .angular: return "Angular"
            case .bounce: return "Bounce"
            case .bowTieHorizontal: return "BowTieHorizontal"
            case .bowTieVertical: return "BowTieVertical"
            case .burn: return "Burn"
            case .butterflyWaveScrawler: return "ButterflyWaveScrawler"
            case .cannabisleaf: return "Cannabisleaf"
            case .circle: return "Circle"
            case .circleCrop: return "CircleCrop"
            case .circleOpen: return "CircleOpen"
            case .colorPhase: return "ColorPhase"
            case .colourDistance: return "ColourDistance"
            case .crazyParametricFun: return "CrazyParametricFun"
            case .crossHatch: return "CrossHatch"
            case .crossWarp: return "CrossWarp"
            case .crossZoom: return "CrossZoom"
            case .cube: return "Cube"
            case .directional: return "Directional"
            case .directionalEasing: return "DirectionalEasing"
            case .directionalWarp: return "DirectionalWarp"
            case .directionalWipe: return "DirectionalWipe"
            case .displacement: return "Displacement"
            case .doomScreen: return "DoomScreen"
            case .doorway: return "Doorway"
            case .dreamy: return "Dreamy"
            case .fadeColor: return "FadeColor"
            case .fadegrayscale: return "Fadegrayscale"
            case .fade: return "Fade"
            case .flyeye: return "Flyeye"
            case .glitchDisplace: return "GlitchDisplace"
            case .glitchMemories: return "GlitchMemories"
            case .gridFlip: return "GridFlip"
            case .heart: return "Heart"
            case .hexagonalize: return "Hexagonalize"
            case .invertedPageCurl: return "InvertedPageCurl"
            case .kaleidoScope: return "KaleidoScope"
            case .leftRight: return "LeftRight"
            case .linearBlur: return "LinearBlur"
            case .luma: return "Luma"
            case .luminanceMelt: return "LuminanceMelt"
            case .morph: return "Morph"
            case .mosaic: return "Mosaic"
            case .multiplyBlend: return "MultiplyBlend"
            case .perlin: return "Perlin"
            case .pinwheel: return "Pinwheel"
            case .pixelize: return "Pixelize"
            case .polarFunction: return "PolarFunction"
            case .polkaDotsCurtain: return "PolkaDotsCurtain"
            case .radial: return "Radial"
            case .randomNoisex: return "RandomNoisex"
            case .randomSquares: return "RandomSquares"
            case .ripple: return "Ripple"
            case .rotate: return "Rotate"
            case .rotateScaleFade: return "RotateScaleFade"
            case .simpleZoom: return "SimpleZoom"
            case .squaresWire: return "SquaresWire"
            case .squeeze: return "Squeeze"
            case .stereoViewer: return "StereoViewer"
            case .swap: return "Swap"
            case .swirl: return "Swirl"
            case .tangentMotionBlur: return "TangentMotionBlur"
            case .topBottom: return "TopBottom"
            case .tvStatic: return "TVStatic"
            case .undulatingBurnOut: return "UndulatingBurnOut"
            case .waterDrop: return "WaterDrop"
            case .windowSlice: return "WindowSlice"
            case .windowBlinds: return "WindowBlinds"
            case .wind: return "Wind"
            case .wipeDown: return "WipeDown"
            case .wipeLeft: return "WipeLeft"
            case .wipeRight: return "WipeRight"
            case .wipeUp: return "WipeUp"
            case .zoomInCircles: return "ZoomInCircles"
            }
        }
    }
}
