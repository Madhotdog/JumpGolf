//
//  GameManager.h
//  JumpGolf
//
//  Created by Joel Herber on 22/11/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

@interface GameManager : NSObject{
    BOOL isMusicON;
    BOOL isSoundEffectsON;
//    BOOL hasPlayerDied;
    SceneType currentScene;
}

@property (readwrite) BOOL isMusicON;
@property (readwrite) BOOL isSoundEffectsON;
// @property (readwrite) BOOL hasPlayerDied;


-(CGSize)getDimensionsOfCurrentScene;
+(GameManager*)sharedGameManager;                                  
-(void)runSceneWithID:(SceneType)sceneID;                         

@end
