//
//  GameManager.m
//  JumpGolf
//
//  Created by Joel Herber on 22/11/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GameManager.h"
#import "cocos2d.h"
#import "JumpingScene.h"

@implementation GameManager
static GameManager* _sharedGameManager = nil;    
@synthesize isMusicON;
@synthesize isSoundEffectsON;

+(GameManager*)sharedGameManager {
    @synchronized([GameManager class])                             // 2
    {
        if(!_sharedGameManager)                                    // 3
            [[self alloc] init]; 
        return _sharedGameManager;                                 // 4
    }
    return nil; 
}

+(id)alloc 
{
    @synchronized ([GameManager class])                            // 5
    {
        NSAssert(_sharedGameManager == nil,
                 @"Attempted to allocated a second instance of the Game Manager singleton");                                          // 6
        _sharedGameManager = [super alloc];
        return _sharedGameManager;                                 // 7
    }
    return nil;  
}

-(CGSize)getDimensionsOfCurrentScene {
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    CGSize levelSize;
    switch (currentScene) {
        case kNoSceneLoaded: 
        case kJumpTest:
            levelSize = CGSizeMake(screenSize.width * 4.0f, screenSize.height * 2.0f);
            break;
            
        default:
            CCLOG(@"Unknown Scene ID, returning default size");
            levelSize = screenSize;
            break;
    }
    return levelSize;
}

- (id)init
{
    self = [super init];
    if (self) {
        CCLOG(@"Game Manager Singleton, init");
        isMusicON = YES;
        isSoundEffectsON = YES;
        currentScene = kNoSceneLoaded;
    }
    
    return self;
}

-(void)runSceneWithID:(SceneType)sceneID{
    SceneType oldScene = currentScene;
    currentScene = sceneID;
    id sceneToRun = nil;
    switch (sceneID) {
        case kJumpTest:
            sceneToRun = [JumpingScene node];
            break;
            
    default:
            CCLOG(@"Unknown ID, cannot switch scenes");
            return;
            break;
    }
    
    if (sceneToRun == nil) {
        // Revert back, since no new scene was found
        currentScene = oldScene;
        return;
    }
    
    if ([[CCDirector sharedDirector] runningScene] == nil) {
        [[CCDirector sharedDirector] runWithScene:sceneToRun];
        
    } else {
        
        [[CCDirector sharedDirector] replaceScene:sceneToRun];
    }  
    
}



@end
