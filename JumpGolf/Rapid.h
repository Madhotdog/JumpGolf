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
    
    CCAnimation * jumpingAnim;
    CCAnimation * spinningAnim;
    CCAnimation * landingAnim;
}

- (id)initWithWorld:(b2World *)world atLocation:(CGPoint)location;
@property (nonatomic, retain) CCAnimation *jumpingAnim;
@property (nonatomic, retain) CCAnimation *spinningAnim;
@property (nonatomic, retain) CCAnimation *landingAnim;

@end
