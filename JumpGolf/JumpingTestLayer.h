//
//  JumpingTestLayer.h
//  JumpGolf
//
//  Created by Joel Herber on 11/11/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GLES-Render.h"
#import "Constants.h"
#import "Box2D.h"

@class Rapid;


@interface JumpingTestLayer : CCLayer {
    b2World * world;
    GLESDebugDraw * debugDraw;
    CCSpriteBatchNode *sceneSpriteBatchNode;
    b2Body * groundBody;
    Rapid *rapid;
    b2MouseJoint * mouseJoint;

    
}



@end
