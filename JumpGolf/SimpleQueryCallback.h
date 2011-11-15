//
//  SimpleQueryCallback.h
//  SpaceViking
//
//  Created by Joel Herber on 08/11/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Box2D.h"

class SimpleQueryCallback : public b2QueryCallback
{
public:
    b2Vec2 pointToTest;
    b2Fixture * fixtureFound;
    
    SimpleQueryCallback(const b2Vec2& point) {
        pointToTest = point;
        fixtureFound = NULL;
    }
    
    bool ReportFixture(b2Fixture* fixture) {
        b2Body* body = fixture->GetBody();
        if (body->GetType() == b2_dynamicBody) {
            if (fixture->TestPoint(pointToTest)) {
                fixtureFound = fixture;
                return false;
            }
        }        
        return true;
    }        
};

