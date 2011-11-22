//
//  JumpingBackground.m
//  JumpGolf
//
//  Created by Joel Herber on 17/11/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "JumpingBackground.h"

@implementation JumpingBackground

- (id)init
{
    self = [super init];
    if (self) {
        CCSprite *background = [CCSprite spriteWithFile:@"placeholderBackgroundiPhone.png"];
        background.position = ccp(self.contentSize.width/2, 
                              self.contentSize.height/2);
        [self addChild:background];
    }
    
    return self;
}

@end
