//
//  Rapid.m
//  JumpGolf
//
//  Created by Joel Herber on 11/11/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Rapid.h"

@implementation Rapid

- (void)createBodyAtLocation:(CGPoint)location {
    b2BodyDef bodyDef;
    bodyDef.type = b2_dynamicBody;
    bodyDef.position = 
    b2Vec2(location.x/PTM_RATIO, location.y/PTM_RATIO);
    body = world->CreateBody(&bodyDef);
    body->SetUserData(self);
    
    b2FixtureDef fixtureDef;
    b2PolygonShape shape;
    // divided by 2 to compensate for scaling TEMP FIX
     shape.SetAsBox(self.contentSize.width/2/PTM_RATIO/2, 
     self.contentSize.height/2/PTM_RATIO/2);  
    

    
    fixtureDef.shape = &shape;
    
    fixtureDef.density = 1.0;
    fixtureDef.friction = 0.5;
    fixtureDef.restitution = 0.5;
    
    body->CreateFixture(&fixtureDef);  
    
}



- (id)initWithWorld:(b2World *)theWorld atLocation:(CGPoint)location {
    if ((self = [super init])) {
        world = theWorld;
        [self setDisplayFrame:[[CCSpriteFrameCache 
                                sharedSpriteFrameCache] spriteFrameByName:@"rapid_anim1.png"]];
        self.scale = 0.5;
        self.flipX = YES;
        
        //need to init animation

        [self createBodyAtLocation:location];
    }
    
    return self;
}


@end
