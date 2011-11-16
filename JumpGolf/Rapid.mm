//
//  Rapid.m
//  JumpGolf
//
//  Created by Joel Herber on 11/11/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Rapid.h"

@implementation Rapid
@synthesize jumpingAnim;
@synthesize spinningAnim;
@synthesize landingAnim;

-(void)dealloc {
    [jumpingAnim release];
    [spinningAnim release];
    [landingAnim release];
    [super dealloc];
    
}

- (void)createBodyAtLocation:(CGPoint)location {
    b2BodyDef bodyDef;
    bodyDef.type = b2_dynamicBody;
    bodyDef.position = 
    b2Vec2(location.x/PTM_RATIO, location.y/PTM_RATIO);
    //stop rotations
    bodyDef.fixedRotation = TRUE;
    body = world->CreateBody(&bodyDef);
    body->SetUserData(self);
    
    b2FixtureDef fixtureDef;
/*  b2PolygonShape shape;
    // divided by 2 to compensate for scaling TEMP FIX
     shape.SetAsBox(self.contentSize.width/2/PTM_RATIO/4, 
     self.contentSize.height/2/PTM_RATIO/4);  
*/
    b2CircleShape shape;
    shape.m_radius =self.contentSize.width/2/PTM_RATIO/4,
    fixtureDef.shape = &shape;
    

    

    
    fixtureDef.shape = &shape;
    
    fixtureDef.density = 1.0;
    fixtureDef.friction = 0.2;
    fixtureDef.restitution = 0.5;
    
    body->CreateFixture(&fixtureDef);  
    
}

-(void)changeState:(CharStates)newState{
    [self stopAllActions];
    id action = nil;
    [self setCharState:newState];
    
    switch (newState) {
        case kStanding:
            [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]
                                  spriteFrameByName:@"rapid_anim1.png"]];
            //CCLOG(@"State changed to:%@",newState);
            break;            
        case kJumping:
            action = [CCAnimate actionWithAnimation:jumpingAnim restoreOriginalFrame:NO];
            //CCLOG(@"State changed to:%@",newState);
            break;
            
        case kSpinning:
            action = [CCAnimate actionWithAnimation:spinningAnim restoreOriginalFrame:NO];
            //CCLOG(@"State changed to:%@",newState);
            break;
            
        case kLanding:
            action = [CCAnimate actionWithAnimation:landingAnim restoreOriginalFrame:NO];
            //CCLOG(@"State changed to:%@",newState);
            break;
            
            
    }
    
    if (action != nil) {
        [self runAction:action];
    }
    
    
}

-(void)updateStateWithDeltaTime:(ccTime)deltaTime andListOfGameObjects:(CCArray*)listOfGameObjects {
    //Let JumpingAnim finish
    if ((self.charState == kJumping) && 
        ([self numberOfRunningActions] > 0)) {
        return;
    }
    
    /*for (GameCharacter *character in listOfGameObjects) {
        // This is Ole the rapid himself
        // No need to check collision with one's self
        if ([character tag] == kRapidType) 
            continue;
    } */
        
        if((self.charState == kLanding) || (self.charState ==kJumping) || 
           (self.charState == kSpinning) || (self.charState == kStanding)) {
            
            // if rapid is standing and is awake 
            if ((body->IsAwake() == TRUE) && charState == kStanding){
                [self changeState:kJumping];
               }
            else if (self.charState == kJumping) {
                [self changeState:kSpinning];
                return;
            }
            else if ((body->IsAwake() == FALSE) && charState == kSpinning){
                [self changeState:kStanding];
            }
            else if (body->IsAwake() == TRUE && [self numberOfRunningActions] == 0){
                [self changeState:kSpinning];
            }
                        
                    
               
        }

    
    
}

-(void)initAnimations {
    [self setJumpingAnim:[self loadPlistForAnimationWithName:@"jumpingAnim" 
                                                andClassName:NSStringFromClass([self class])]];
    [self setLandingAnim:[self loadPlistForAnimationWithName:@"landingAnim" 
                                                andClassName:NSStringFromClass([self class])]];
    [self setSpinningAnim:[self loadPlistForAnimationWithName:@"spinningAnim" 
                                                 andClassName:NSStringFromClass([self class])]];
}



- (id)initWithWorld:(b2World *)theWorld atLocation:(CGPoint)location {
    if ((self = [super init])) {
        world = theWorld;
        [self setDisplayFrame:[[CCSpriteFrameCache 
                                sharedSpriteFrameCache] spriteFrameByName:@"rapid_anim1.png"]];
        self.scale = 0.25;
        self.flipX = YES;
        charState = kStanding;
        
        //need to init animation
        [self initAnimations];
        [self createBodyAtLocation:location];
    }
    
    return self;
}




@end
