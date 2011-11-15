//  GameObject.h

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Constants.h"

@interface GameObject : CCSprite {
    BOOL isActive;
    BOOL reactsToScreenBoundaries;
    CGSize screenSize;
    GameObjectType gameObjectType;
}
@property (readwrite) BOOL isActive;
@property (readwrite) BOOL reactsToScreenBoundaries;
@property (readwrite) CGSize screenSize;
@property (readwrite) GameObjectType gameObjectType;
-(void)changeState:(CharStates)newState; 
-(void)updateStateWithDeltaTime:(ccTime)deltaTime andListOfGameObjects:(CCArray*)listOfGameObjects; 
-(CGRect)adjustedBoundingBox;
-(CCAnimation*)loadPlistForAnimationWithName:(NSString*)animationName andClassName:(NSString*)className;
@end

