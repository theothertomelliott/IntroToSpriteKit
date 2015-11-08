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
    self.pacMan.xScale = 1.5;
    self.pacMan.yScale = 1.5;
    
    self.physicsWorld.gravity = CGVectorMake(0.0, -1.0);

    self.pacMan.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.pacMan.size.width/2];
    self.pacMan.physicsBody.mass = 1.0;
    self.pacMan.physicsBody.dynamic = YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
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
