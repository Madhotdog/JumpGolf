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

-(void)createParralaxLayers {
    //CGSize screenSize = [[CCDirector sharedDirector] winSize];
    CGSize levelSize = [[GameManager sharedGameManager] 
                        getDimensionsOfCurrentScene];
    
    
    tileMapNode = [CCTMXTiledMap tiledMapWithTMXFile:@"BackgroundParralax.tmx"];
    
    
    CCTMXLayer * hillsForeground = [tileMapNode layerNamed:@"HillsForeground"];
    
    CCTMXLayer * hillsBackground = [tileMapNode layerNamed:@"HillsBackground"];
    
    parallaxNode = [CCParallaxNode node];
    [parallaxNode 
     setPosition:ccp(levelSize.width/2.0f,levelSize.height/2.0f)];
    
    [hillsForeground retain];
    [hillsForeground removeFromParentAndCleanup:NO];
    [hillsForeground setAnchorPoint:CGPointMake(0.5f,0.5f)];
    [parallaxNode addChild:hillsForeground z:10 parallaxRatio:ccp(0.5f,0.1f) 
            positionOffset:ccp(levelSize.width/2 * 0.5f,hillsForeground.contentSize.height/2 * 0.7f)];
    [hillsForeground release];
    
    [hillsBackground retain];
    [hillsBackground removeFromParentAndCleanup:NO];
    [hillsBackground setAnchorPoint:CGPointMake(0.5f,0.5f)];
    [parallaxNode addChild:hillsBackground z:5 parallaxRatio:ccp(0.2f,0.05f) 
            positionOffset:ccp(levelSize.width/2.0f * 0.8f,hillsBackground.contentSize.height/2 * 0.8f)];
    [hillsBackground release];
    
    [self addChild:parallaxNode z:1];
}

-(void)initWorld {
    b2Vec2 gravity = b2Vec2(0.0f, -10.0f);
    world = new b2World(gravity, true);
}

-(void)followCharacter{
    CGSize winSize = [CCDirector sharedDirector].winSize;
    CGSize levelSize = [[GameManager sharedGameManager] getDimensionsOfCurrentScene];
    float fixedPositionX = winSize.width/3;
    float newX = fixedPositionX - rapid.position.x;
    
    float fixedPositionY = winSize.height/2;
    float newY = fixedPositionY - rapid.position.y;
    //Mininum
    if(newX >= 0) {
        newX = 0;
    }
    if(newY >= 0) {
        newY = 0;
    }
    //Maximum
    if (newX <= -levelSize.width+winSize.width) {
        newX = -levelSize.width+winSize.width;
    }
    if (newY <= -levelSize.height+winSize.height) {
        newY = -levelSize.height+winSize.height;
    }
    CGPoint newPos = ccp(newX, newY);
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
    [sceneSpriteBatchNode addChild:rapid z:50 tag:kRapidType];
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
    
    
    
    tileMapNode = [CCTMXTiledMap tiledMapWithTMXFile:spriteFrameName];
    
    
    CCTMXLayer * ground = [tileMapNode layerNamed:@"Tile Layer 1"];
    
    //NEEDS CHANGING
    //Give bad transparencys 
    //[CCTexture2D setDefaultAlphaPixelFormat:
    // kCCTexture2DPixelFormat_RGB5A1];
    //CCSprite *ground = [CCSprite spriteWithFile:spriteFrameName];
    CGSize levelSize = [[GameManager sharedGameManager] getDimensionsOfCurrentScene];
    //ground.position = ccp((levelSize.width/2)-2, 
    //                      ground.contentSize.height/2);
    
    [ground retain];
    [ground removeFromParentAndCleanup:NO];
    [ground setAnchorPoint:CGPointMake(0.5f,0.5f)];
    [ground setPosition:ccp(ground.contentSize.width/2, ground.contentSize.height/2)];
    [self addChild:ground z:30];
    [ground release];
    
    
    //[self addChild:ground z:30];
    
    
    b2PolygonShape groundShape;      
    b2FixtureDef groundFixtureDef;
    groundFixtureDef.shape = &groundShape;
    groundFixtureDef.density = 0.0;
    
    for(int i = 0; i < num - 1; ++i) {
        b2Vec2 offset = b2Vec2(ground.contentSize.width/2/PTM_RATIO, 
                               ground.contentSize.height/2/PTM_RATIO);
        b2Vec2 left = verts[i] + offset;
        b2Vec2 right = verts[i+1] + offset;
        groundShape.SetAsEdge(left, right);
        groundBody->CreateFixture(&groundFixtureDef);    
    }
    
    
    
    //CGSize winSize = [[CCDirector sharedDirector] winSize];
    //CGSize levelSize = [[GameManager sharedGameManager] getDimensionsOfCurrentScene];
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
    int num = 17;
    b2Vec2 verts[] = {
        b2Vec2(-956.0f / 100.0, -225.6f / 100.0),
        b2Vec2(-660.4f / 100.0, -205.8f / 100.0),
        b2Vec2(-589.7f / 100.0, -297.7f / 100.0),
        b2Vec2(-578.4f / 100.0, -416.5f / 100.0),
        b2Vec2(-229.1f / 100.0, -417.9f / 100.0),
        b2Vec2(-62.2f / 100.0, -27.6f / 100.0),
        b2Vec2(125.9f / 100.0, 180.3f / 100.0),
        b2Vec2(199.4f / 100.0, 181.7f / 100.0),
        b2Vec2(213.5f / 100.0, 112.4f / 100.0),
        b2Vec2(251.7f / 100.0, 98.3f / 100.0),
        b2Vec2(281.4f / 100.0, 108.2f / 100.0),
        b2Vec2(289.9f / 100.0, 142.1f / 100.0),
        b2Vec2(295.6f / 100.0, 190.2f / 100.0),
        b2Vec2(379.0f / 100.0, 186.0f / 100.0),
        b2Vec2(514.8f / 100.0, -111.0f / 100.0),
        b2Vec2(780.6f / 100.0, -99.7f / 100.0),
        b2Vec2(954.6f / 100.0, -326.0f / 100.0)
    };
    


    
    
    [self createGroundEdgesWithVerts:verts 
                            numVerts:num spriteFrameName:@"Level1TileMap.tmx"];   
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
        [self createParralaxLayers];
        [self createGround];
        [self createGroundLevel];
        
        self.isTouchEnabled = YES; 
        
        [[CCSpriteFrameCache sharedSpriteFrameCache] 
         addSpriteFramesWithFile:@"rapidSpriteSheetiPhone.plist"];          
        sceneSpriteBatchNode = 
        [CCSpriteBatchNode batchNodeWithFile:@"rapidSpriteSheetiPhone.png"];
        
        [self addChild:sceneSpriteBatchNode z:2];                
        
        [self createCharAtLocation:
         ccp(winSize.width/4, winSize.height*0.9)];
        
        
        
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
    
    //get the touch location 
    CGPoint touchLocation = [touch locationInView:[touch view]];
    touchLocation = [[CCDirector sharedDirector] 
                     convertToGL:touchLocation];
    touchLocation = [self convertToNodeSpace:touchLocation];
    //and store it for later calculations
    touchStart = touchLocation;
    
    //Debug mouse dragging
    
    if(DEBUG_INPUT_FLAG == 1){
        

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
            
        }
    }
    
    
    //[rapid jump];
    
    return TRUE;
    
}

-(void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
    if(DEBUG_INPUT_FLAG == 1){
        CGPoint touchLocation = [touch locationInView:[touch view]];
        touchLocation = [[CCDirector sharedDirector] convertToGL:touchLocation];
        touchLocation = [self convertToNodeSpace:touchLocation];
        b2Vec2 locationWorld = b2Vec2(touchLocation.x/PTM_RATIO, touchLocation.y/PTM_RATIO);
        if(mouseJoint) {
            mouseJoint->SetTarget(locationWorld);
        }
    }
}

-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchLocation = [touch locationInView:[touch view]];
    touchLocation = [[CCDirector sharedDirector] convertToGL:touchLocation];
    touchLocation = [self convertToNodeSpace:touchLocation];
    
    float xComponent = touchLocation.x - touchStart.x;
    float yComponent = touchLocation.y - touchStart.y;
    
    [rapid jump:xComponent withYComponent:yComponent];
    
    if(mouseJoint){
        world->DestroyJoint(mouseJoint);
        mouseJoint = NULL;
    }
    
    
}



@end
