//
//  Box2DSprite.h
//  JumpGolf
//
//  Created by Joel Herber on 14/11/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "Box2D.h"
#import "GameCharacter.h"



@interface Box2DSprite : GameCharacter{
    b2Body *body;
}


@property (assign) b2Body *body;

-(BOOL)mouseJointBegan;

@end
