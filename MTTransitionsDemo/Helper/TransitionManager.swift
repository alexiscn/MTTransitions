//
//  TransitionManager.swift
//  MTTransitionsDemo
//
//  Created by xu.shuifeng on 2019/2/2.
//  Copyright © 2019 xu.shuifeng. All rights reserved.
//

import Foundation
import MTTransitions

class TransitionManager {
    
    static let shared = TransitionManager()
    
    var allTransitions: [MTTransition] = []
    
    private init() {
        allTransitions.append(MTAngularTransition())
        allTransitions.append(MTBounceTransition())
        allTransitions.append(MTBowTieHorizontalTransition())
        allTransitions.append(MTBowTieVerticalTransition())
        allTransitions.append(MTBurnTransition())
        allTransitions.append(MTButterflyWaveScrawlerTransition())
        allTransitions.append(MTCannabisleafTransition())
        allTransitions.append(MTCircleCropTransition())
        allTransitions.append(MTCircleTransition())
        allTransitions.append(MTCircleOpenTransition())
        allTransitions.append(MTColorPhaseTransition())
        allTransitions.append(MTColourDistanceTransition())
        allTransitions.append(MTCrazyParametricFunTransition())
        allTransitions.append(MTCrossZoomTransition())
        allTransitions.append(MTCrossHatchTransition())
        allTransitions.append(MTCrossWarpTransition())
        allTransitions.append(MTCubeTransition())
        allTransitions.append(MTDirectionalTransition())
        allTransitions.append(MTDirectionalWarpTransition())
        allTransitions.append(MTDirectionalWipeTransition())
        allTransitions.append(MTDisplacementTransition())
        allTransitions.append(MTDoomScreenTransition())
        allTransitions.append(MTDoorwayTransition())
        allTransitions.append(MTDreamyTransition())
        allTransitions.append(MTDreamyZoomTransition())
        allTransitions.append(MTFadeTransition())
        allTransitions.append(MTFadeColorTransition())
        allTransitions.append(MTFadegrayscaleTransition())
        allTransitions.append(MTFlyeyeTransition())
        allTransitions.append(MTGlitchDisplaceTransition())
        allTransitions.append(MTGlitchMemoriesTransition())
        allTransitions.append(MTGridFlipTransition())
        allTransitions.append(MTHeartTransition())
        allTransitions.append(MTHexagonalizeTransition())
        allTransitions.append(MTInvertedPageCurlTransition())
        allTransitions.append(MTKaleidoScopeTransition())
        allTransitions.append(MTLinearBlurTransition())
        allTransitions.append(MTLumaTransition())
        allTransitions.append(MTLuminanceMeltTransition())
        allTransitions.append(MTMorphTransition())
        allTransitions.append(MTMosaicTransition())
        allTransitions.append(MTMultiplyBlendTransition())
        allTransitions.append(MTPerlinTransition())
        allTransitions.append(MTPinwheelTransition())
        allTransitions.append(MTPixelizeTransition())
        allTransitions.append(MTPolarFunctionTransition())
        allTransitions.append(MTPolkaDotsCurtainTransition())
        allTransitions.append(MTRadialTransition())
        allTransitions.append(MTRandomSquaresTransition())
        allTransitions.append(MTRippleTransition())
        allTransitions.append(MTRotateScaleFadeTransition())
        allTransitions.append(MTSimpleZoomTransition())
        allTransitions.append(MTSquaresWireTransition())
        allTransitions.append(MTSqueezeTransition())
        allTransitions.append(MTStereoViewerTransition())
        allTransitions.append(MTSwapTransition())
        allTransitions.append(MTSwirlTransition())
        allTransitions.append(MTUndulatingBurnOutTransition())
        allTransitions.append(MTWaterDropTransition())
        allTransitions.append(MTWindTransition())
        allTransitions.append(MTWindowBlindsTransition())
        allTransitions.append(MTWindowSliceTransition())
        allTransitions.append(MTWipeDownTransition())
        allTransitions.append(MTWipeLeftTransition())
        allTransitions.append(MTWipeRightTransition())
        allTransitions.append(MTWipeUpTransition())
        allTransitions.append(MTZoomInCirclesTransition())
    }
    
}
