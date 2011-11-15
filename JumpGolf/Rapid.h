//
//  Rapid.h
//  JumpGolf
//
//  Created by Joel Herber on 11/11/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Box2DSprite.h"
#import "Constants.h"




@interface Rapid : Box2DSprite {
    b2World *world;
}

- (id)initWithWorld:(b2World *)world atLocation:(CGPoint)location;

@end
