//
//  GameScene.m
//  IntroToSpriteKit
//
//  Created by Thomas Elliott on 11/7/15.
//  Copyright (c) 2015 Tom Elliott. All rights reserved.
//

#import "GameScene.h"

@interface GameScene ()

@property (nonatomic) SKSpriteNode *pacMan;

@end

@implementation GameScene

-(void)didMoveToView:(SKView *)view {
    
    self.pacMan = [SKSpriteNode spriteNodeWithImageNamed:@"PacmanFrame2"];
    self.pacMan.position = CGPointMake(CGRectGetMidX(self.frame),
                                  CGRectGetMidY(self.frame));
    [self addChild:self.pacMan];
    self.pacMan.xScale = 2;
    self.pacMan.yScale = 2;
    
    self.physicsWorld.gravity = CGVectorMake(0.0, -1.0);

    self.pacMan.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.pacMan.size.width/2];
    self.pacMan.physicsBody.mass = 1.0;
    self.pacMan.physicsBody.dynamic = YES;
    
    [self addWall];
}

- (void) addWall {
    SKSpriteNode *topWall = [SKSpriteNode spriteNodeWithImageNamed:@"Topwall"];
    topWall.xScale = 3;
    topWall.yScale = 3;
    topWall.position = CGPointMake(CGRectGetWidth(self.frame),
                                   CGRectGetHeight(self.frame)-topWall.texture.size.height*1.5);
    [self addChild:topWall];
    
    SKAction *moveWall = [SKAction moveByX:-10 y:0 duration:0.1];
    [topWall runAction:[SKAction repeatActionForever:moveWall]];
    
    SKSpriteNode *bottomWall = [SKSpriteNode spriteNodeWithImageNamed:@"Bottomwall"];
    bottomWall.xScale = 3;
    bottomWall.yScale = 3;
    bottomWall.position = CGPointMake(CGRectGetWidth(self.frame),bottomWall.texture.size.height*1.5);
    [self addChild:bottomWall];
    
    [bottomWall runAction:[SKAction repeatActionForever:moveWall]];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        NSLog(@"%f,%f",location.x, location.y);
    }
    
    SKTexture *frame1 = [SKTexture textureWithImageNamed:@"PacmanFrame1"];
    SKTexture *frame2 = [SKTexture textureWithImageNamed:@"PacmanFrame2"];
    SKTexture *frame3 = [SKTexture textureWithImageNamed:@"PacmanFrame3"];
    
    SKAction *animation = [SKAction animateWithTextures:@[frame1,frame2,frame3,frame2] timePerFrame:0.1];
    [self.pacMan runAction:animation];
    
    [self.pacMan.physicsBody applyImpulse:CGVectorMake(0.0, -self.pacMan.physicsBody.velocity.dy + 150)];
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
