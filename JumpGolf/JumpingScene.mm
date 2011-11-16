//
//  JumpingScene.m
//  JumpGolf
//
//  Created by Joel Herber on 15/11/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "JumpingScene.h"
#import "JumpingTestLayer.h"

@implementation JumpingScene

- (id)init
{
    self = [super init];
    if (self) {
        JumpingTestLayer *layer = [JumpingTestLayer node];
        [self addChild:layer];
    }
    
    return self;
}

@end
