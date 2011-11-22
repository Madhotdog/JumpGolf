//
//  Constants.h
//  JumpGolf
//
//  Created by Joel Herber on 11/11/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#define PTM_RATIO ((UI_USER_INTERFACE_IDIOM() ==  UIUserInterfaceIdiomPad) ? 100.0 : 50.0)

typedef enum {
    kObjectTypeNone,
    kRapidType,
    kGroundType,
    kFlagType,
    kHoleType,
} GameObjectType;

typedef enum {
    kLanding,
    kJumping,
    kSpinning,
    kStanding,
} CharStates;

typedef enum {
    kNoSceneLoaded = 0,
    kJumpTest = 10,
} SceneType;


