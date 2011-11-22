//
//  JumpingScene.m
//  JumpGolf
//
//  Created by Joel Herber on 15/11/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "JumpingScene.h"
#import "JumpingTestLayer.h"
#import "JumpingBackground.h"

@implementation JumpingScene

- (id)init
{
    self = [super init];
    if (self) {
        JumpingBackground *backgroundLayer = [JumpingBackground node];
        [self addChild:backgroundLayer];
        JumpingTestLayer *layer = [JumpingTestLayer node];
        [self addChild:layer];
        //[layer setScale:0.2f];
    }
    
    return self;
}

@end
