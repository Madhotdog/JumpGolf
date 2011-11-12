//
//  JumpingTestLayer.m
//  JumpGolf
//
//  Created by Joel Herber on 11/11/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "JumpingTestLayer.h"

@implementation JumpingTestLayer

-(void)dealloc {
    if(world) {
        delete world;
        world = NULL;
    }
    [super dealloc];
    
}

+ (id)scene {
    CCScene *scene = [CCScene node];
    JumpingTestLayer *layer = [self node];
    [scene addChild:layer];
    return scene;
}

-(void)initWorld {
    b2Vec2 gravity = b2Vec2(0.0f, -10.0f);
    world = new b2World(gravity, true);
}

- (id)init
{
    self = [super init];
    if (self) {
        CGSize screenSize = [CCDirector sharedDirector].winSize; 
        // enable touches
        self.isTouchEnabled = YES; 
        
        [[CCSpriteFrameCache sharedSpriteFrameCache] 
         addSpriteFramesWithFile:@"JumpSceneSpriteSheet.plist"];          // 1
        sceneSpriteBatchNode = 
        [CCSpriteBatchNode batchNodeWithFile:@"JumpSceneSpriteSheet.png"];// 2
        [self addChild:sceneSpriteBatchNode z:0];                // 3
        
        
        CCSprite *rapid = [CCSprite spriteWithFile:@"rapid_anim1.png"];
                           [rapid setPosition:ccp(screenSize.width/2,screenSize.height/2)];

         [self addChild:rapid];
        
        CCAnimation *rapidStanding = [CCAnimation animation];
        [rapidStanding addFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"rapid_anim1.png"]];
        
        CCAnimation *rapidBeginJump = [CCAnimation animation];
        
        [rapidBeginJump addFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"rapid_anim2.png"]];
        [rapidBeginJump addFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"rapid_anim3.png"]];
        
        CCAnimation *rapidSpin = [CCAnimation animation];
        [rapidSpin addFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"rapid_anim4.png"]];
        [rapidSpin addFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"rapid_anim5.png"]];
        
        id standing = [CCAnimate actionWithDuration:0.1f animation:rapidStanding restoreOriginalFrame:NO];
        id jumpAnim = [CCAnimate actionWithDuration:0.1f animation:rapidBeginJump restoreOriginalFrame:NO];
        id spinAnim = [CCAnimate actionWithDuration:0.1f animation:rapidSpin restoreOriginalFrame:NO];
        CCDelayTime *delay = [CCDelayTime actionWithDuration:0.5];
        sequence = [CCSequence actions:standing, delay, jumpAnim, spinAnim, spinAnim,spinAnim, spinAnim, 
                                spinAnim, spinAnim,spinAnim, spinAnim,spinAnim,spinAnim, 
                                spinAnim,spinAnim,spinAnim, spinAnim, nil];
        id repeatAnim = [CCRepeatForever actionWithAction:sequence];
        
        
        [rapid runAction:repeatAnim];
         
    }
    
    return self;
}

@end
