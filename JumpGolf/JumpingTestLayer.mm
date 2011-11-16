//
//  JumpingTestLayer.m
//  JumpGolf
//
//  Created by Joel Herber on 11/11/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "JumpingTestLayer.h"
#import "Box2DSprite.h"
#import "Rapid.h"
#import "SimpleQueryCallback.h"


@implementation JumpingTestLayer

-(void)dealloc {
    if(world) {
        delete world;
        world = NULL;
    }
    [super dealloc];
    
}

- (void)setupWorld {    
    b2Vec2 gravity = b2Vec2(0.0f, -10.0f);
    bool doSleep = true;
    world = new b2World(gravity, doSleep);            
}


-(void)setupDebugDraw {
    debugDraw = new GLESDebugDraw(PTM_RATIO *[[CCDirector sharedDirector] contentScaleFactor]);
    world->SetDebugDraw(debugDraw);
    debugDraw->SetFlags(b2DebugDraw::e_shapeBit);
}

-(void)createGround {
 CGSize winSize = [[CCDirector sharedDirector] winSize];
 float32 margin = 10.0f;
 b2Vec2 lowerLeft = b2Vec2(margin/PTM_RATIO, margin/PTM_RATIO);
 b2Vec2 lowerRight = b2Vec2((winSize.width-margin) /PTM_RATIO, margin/PTM_RATIO);
 b2Vec2 upperRight = b2Vec2((winSize.width-margin) /PTM_RATIO, (winSize.height-margin)/  PTM_RATIO);
 b2Vec2 upperLeft = b2Vec2((margin/PTM_RATIO), (winSize.height-margin) / PTM_RATIO);
 
 b2BodyDef groundBodyDef;
 groundBodyDef.type = b2_staticBody;
 groundBodyDef.position.Set(0,0);
 groundBody = world->CreateBody(&groundBodyDef);
 
 b2PolygonShape groundShape;
 b2FixtureDef groundFixtureDef;
 groundFixtureDef.shape = &groundShape;
 groundFixtureDef.density = 0.0;
 
 groundShape.SetAsEdge(lowerLeft, lowerRight);
 groundBody->CreateFixture(&groundFixtureDef);
 groundShape.SetAsEdge(lowerRight, upperRight);
 groundBody->CreateFixture(&groundFixtureDef);
 groundShape.SetAsEdge(lowerLeft, upperLeft);
 groundBody->CreateFixture(&groundFixtureDef);
 groundShape.SetAsEdge(upperLeft, upperRight);
 groundBody->CreateFixture(&groundFixtureDef);
 
 
 }
 

-(void)initWorld {
    b2Vec2 gravity = b2Vec2(0.0f, -10.0f);
    world = new b2World(gravity, true);
}

-(void)update:(ccTime)dt {    
    int32 velocityIterations = 3;
    int32 positionIterations = 2;
    world->Step(dt, velocityIterations, positionIterations);
    
    for(b2Body *b=world->GetBodyList(); b!=NULL; b=b->GetNext()) {    
        if (b->GetUserData() != NULL) {
            Box2DSprite *sprite = (Box2DSprite *) b->GetUserData();
            sprite.position = ccp(b->GetPosition().x * PTM_RATIO, 
                                  b->GetPosition().y * PTM_RATIO);
           // sprite.rotation = 
           // CC_RADIANS_TO_DEGREES(b->GetAngle() * -1);
        }        
    }
     
    
    CCArray *listOfGameObjects = [sceneSpriteBatchNode children]; 
    for (GameCharacter *tempChar in listOfGameObjects) { 
        [tempChar updateStateWithDeltaTime:dt 
                      andListOfGameObjects:listOfGameObjects]; 
    } 
   
}

- (void)createCharAtLocation:(CGPoint)location {
    rapid = [[[Rapid alloc] 
             initWithWorld:world atLocation:location] autorelease];
    [sceneSpriteBatchNode addChild:rapid z:1 tag:kRapidType];
}

- (void)registerWithTouchDispatcher {
    [[CCTouchDispatcher sharedDispatcher] 
     addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

- (id)init
{
    self = [super init];
    if (self) {
        CGSize winSize = [CCDirector sharedDirector].winSize; 
        // enable touches
        [self setupWorld];
        [self setupDebugDraw]; 
        [self scheduleUpdate];
        [self createGround];
        self.isTouchEnabled = YES; 
        
        [[CCSpriteFrameCache sharedSpriteFrameCache] 
         addSpriteFramesWithFile:@"JumpSceneSpriteSheet.plist"];          // 1
        sceneSpriteBatchNode = 
        [CCSpriteBatchNode batchNodeWithFile:@"JumpSceneSpriteSheet.png"];// 2
        [self addChild:sceneSpriteBatchNode z:0];                // 3
        
        /*
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
        CCSequence *sequence = [CCSequence actions:standing, delay, jumpAnim, spinAnim, spinAnim,spinAnim, spinAnim, 
                                spinAnim, spinAnim,spinAnim, spinAnim,spinAnim,spinAnim, 
                                spinAnim,spinAnim,spinAnim, spinAnim, nil];
        id repeatAnim = [CCRepeatForever actionWithAction:sequence];
        
        
        [rapid runAction:repeatAnim];
         */
        

        [self createCharAtLocation:
         ccp(winSize.width/4, winSize.width*0.3)];

         
    }
    
    return self;
}

-(void) draw {   
    glDisable(GL_TEXTURE_2D);
    glDisableClientState(GL_COLOR_ARRAY);
    glDisableClientState(GL_TEXTURE_COORD_ARRAY);
    
    if (world) {
        world->DrawDebugData();
    }
    
    glEnable(GL_TEXTURE_2D);
    glEnableClientState(GL_COLOR_ARRAY);
    glEnableClientState(GL_TEXTURE_COORD_ARRAY);	
}

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    
    CGPoint touchLocation = [touch locationInView:[touch view]];
    touchLocation = [[CCDirector sharedDirector] 
                     convertToGL:touchLocation];
    touchLocation = [self convertToNodeSpace:touchLocation];
    b2Vec2 locationWorld = 
    b2Vec2(touchLocation.x/PTM_RATIO, touchLocation.y/PTM_RATIO);
    
    //    [self createBoxAtLocation:touchLocation 
    //                     withSize:CGSizeMake(50, 50)];
    //  
    
    
    b2AABB aabb;
    b2Vec2 delta = b2Vec2(1.0/PTM_RATIO, 1.0/PTM_RATIO);
    aabb.lowerBound = locationWorld - delta;
    aabb.upperBound = locationWorld + delta;
    SimpleQueryCallback callback(locationWorld);
    world->QueryAABB(&callback, aabb);
    
    if (callback.fixtureFound) {
        
        b2Body *body = callback.fixtureFound->GetBody();
        
        Box2DSprite *sprite = (Box2DSprite *) body->GetUserData();
        if (sprite == NULL) return FALSE;
        if([sprite mouseJointBegan] == FALSE) {
            return FALSE;
        } else {
            
            b2MouseJointDef mouseJointDef;
            mouseJointDef.bodyA = groundBody;
            mouseJointDef.bodyB = body;
            mouseJointDef.target = locationWorld;
            mouseJointDef.maxForce = 100 * body->GetMass();
            mouseJointDef.collideConnected = true;
            
            mouseJoint = (b2MouseJoint *) world->CreateJoint(&mouseJointDef);
            body->SetAwake(true);
            return YES;
        }
        
    } else {        
        //        [self createBoxAtLocation:touchLocation 
        //                         withSize:CGSizeMake(50, 50)];
    }
    return TRUE;
    
}

-(void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchLocation = [touch locationInView:[touch view]];
    touchLocation = [[CCDirector sharedDirector] convertToGL:touchLocation];
    touchLocation = [self convertToNodeSpace:touchLocation];
    b2Vec2 locationWorld = b2Vec2(touchLocation.x/PTM_RATIO, touchLocation.y/PTM_RATIO);
    if(mouseJoint) {
        mouseJoint->SetTarget(locationWorld);
    }
}

-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    if(mouseJoint){
        world->DestroyJoint(mouseJoint);
        mouseJoint = NULL;
    }
}



@end
