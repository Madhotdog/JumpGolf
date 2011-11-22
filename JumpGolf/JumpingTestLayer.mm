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
#import "GameManager.h"


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

/*-(void)createGround {
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
  */

-(void)initWorld {
    b2Vec2 gravity = b2Vec2(0.0f, -10.0f);
    world = new b2World(gravity, true);
}

-(void)followCharacter{
    CGSize winSize = [CCDirector sharedDirector].winSize;
    CGSize levelSize = [[GameManager sharedGameManager] getDimensionsOfCurrentScene];
    float fixedPosition = winSize.width/4;
    float newX = fixedPosition - rapid.position.x;
    //Mininum
    if(newX > 0) {
        newX = 0;
    }
    //Maximum
    if (newX < -levelSize.width+winSize.width) {
        newX = -levelSize.width+winSize.width;
    }
    CGPoint newPos = ccp(newX, self.position.y);
    [self setPosition:newPos];   
    
    
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
    [self followCharacter];
   
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

-(void)createGround {
    b2BodyDef groundBodyDef;
    groundBodyDef.type = b2_staticBody;
    groundBodyDef.position.Set(0,0);
    groundBody = world->CreateBody(&groundBodyDef);
} 

- (void)createGroundEdgesWithVerts:(b2Vec2 *)verts numVerts:(int)num 
                   spriteFrameName:(NSString *)spriteFrameName {
    
    CCSprite *ground = [CCSprite spriteWithFile:spriteFrameName];
    ground.position = ccp(self.contentSize.width/2, 
                          self.contentSize.height/2);
    [self addChild:ground];

    
    b2PolygonShape groundShape;      
    b2FixtureDef groundFixtureDef;
    groundFixtureDef.shape = &groundShape;
    groundFixtureDef.density = 0.0;
    
    for(int i = 0; i < num - 1; ++i) {
        b2Vec2 offset = b2Vec2(self.contentSize.width/2/PTM_RATIO, 
                               self.contentSize.height/2/PTM_RATIO);
        b2Vec2 left = verts[i] + offset;
        b2Vec2 right = verts[i+1] + offset;
        groundShape.SetAsEdge(left, right);
        groundBody->CreateFixture(&groundFixtureDef);    
    }
    
    
    
    //CGSize winSize = [[CCDirector sharedDirector] winSize];
    CGSize levelSize = [[GameManager sharedGameManager] getDimensionsOfCurrentScene];
    float32 margin = 1.0f;
    b2Vec2 lowerLeft = b2Vec2(margin/PTM_RATIO, margin/PTM_RATIO);
    b2Vec2 lowerRight = b2Vec2((levelSize.width-margin) /PTM_RATIO, margin/PTM_RATIO);
    b2Vec2 upperRight = b2Vec2((levelSize.width-margin) /PTM_RATIO, (levelSize.height-margin)/  PTM_RATIO);
    b2Vec2 upperLeft = b2Vec2((margin/PTM_RATIO), (levelSize.height-margin) / PTM_RATIO);
    
    //screen boundaries
    
    groundShape.SetAsEdge(lowerRight, upperRight);
    groundBody->CreateFixture(&groundFixtureDef);
    groundShape.SetAsEdge(lowerLeft, upperLeft);
    groundBody->CreateFixture(&groundFixtureDef);
    groundShape.SetAsEdge(upperLeft, upperRight);
    groundBody->CreateFixture(&groundFixtureDef);
    groundShape.SetAsEdge(lowerLeft, lowerRight);
    groundBody->CreateFixture(&groundFixtureDef);

    
}

- (void)createGroundLevel {

    //row 1, col 1
    int num = 16;
    b2Vec2 verts[] = {
        b2Vec2(-238.6f / PTM_RATIO, -55.3f / PTM_RATIO),
        b2Vec2(-166.2f / PTM_RATIO, -51.8f / PTM_RATIO),
        b2Vec2(-150.6f / PTM_RATIO, -70.2f / PTM_RATIO),
        b2Vec2(-146.7f / PTM_RATIO, -103.1f / PTM_RATIO),
        b2Vec2(-58.7f / PTM_RATIO, -104.1f / PTM_RATIO),
        b2Vec2(-17.7f / PTM_RATIO, -9.0f / PTM_RATIO),
        b2Vec2(28.6f / PTM_RATIO, 45.4f / PTM_RATIO),
        b2Vec2(54.1f / PTM_RATIO, 47.9f / PTM_RATIO),
        b2Vec2(54.1f / PTM_RATIO, 35.9f / PTM_RATIO),
        b2Vec2(59.4f / PTM_RATIO, 29.2f / PTM_RATIO),
        b2Vec2(67.5f / PTM_RATIO, 35.5f / PTM_RATIO),
        b2Vec2(67.9f / PTM_RATIO, 47.9f / PTM_RATIO),
        b2Vec2(93.0f / PTM_RATIO, 47.6f / PTM_RATIO),
        b2Vec2(129.4f / PTM_RATIO, -27.4f / PTM_RATIO),
        b2Vec2(195.2f / PTM_RATIO, -24.2f / PTM_RATIO),
        b2Vec2(239.0f / PTM_RATIO, -80.8f / PTM_RATIO)
    };

    [self createGroundEdgesWithVerts:verts 
                            numVerts:num spriteFrameName:@"Level1Ground.png"];   
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
        [self createGroundLevel];
        self.isTouchEnabled = YES; 
        
        [[CCSpriteFrameCache sharedSpriteFrameCache] 
         addSpriteFramesWithFile:@"rapidSpriteSheetiPhone.plist"];          // 1
        sceneSpriteBatchNode = 
        [CCSpriteBatchNode batchNodeWithFile:@"rapidSpriteSheetiPhone.png"];// 2
        [self addChild:sceneSpriteBatchNode z:0];                // 3
        
        
        //levelSize = [[GameManager sharedGameManager] getDimensionsOfCurrentScene];
        
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
