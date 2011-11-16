//
//  GameCharacter.h
//  JumpGolf
//
//  Created by Joel Herber on 15/11/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GameObject.h"

@interface GameCharacter : GameObject{
        CharStates charState;
}

@property (readwrite) CharStates charState; 

@end
