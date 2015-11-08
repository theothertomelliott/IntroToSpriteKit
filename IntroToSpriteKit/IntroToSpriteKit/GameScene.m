//
//  GameScene.m
//  IntroToSpriteKit
//
//  Created by Thomas Elliott on 11/7/15.
//  Copyright (c) 2015 Tom Elliott. All rights reserved.
//

#import "GameScene.h"

@interface GameScene ()

@property (nonatomic) SKLabelNode *startLabel;
@property (nonatomic) SKSpriteNode *pacMan;

@end

@implementation GameScene

-(void)didMoveToView:(SKView *)view {
    
    self.startLabel = [SKLabelNode labelNodeWithFontNamed:@"Verdana"];
    self.startLabel.text = @"Tap to start";
    self.startLabel.fontSize = 45;
    self.startLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                   CGRectGetMidY(self.frame));
    
    [self addChild:self.startLabel];

}

- (void) startGame {
    if(self.pacMan != nil){
        [self.pacMan removeFromParent];
        self.pacMan = nil;
    }
    
    self.startLabel.hidden = YES;
    
    self.pacMan = [SKSpriteNode spriteNodeWithImageNamed:@"PacmanFrame2"];
    self.pacMan.position = CGPointMake(CGRectGetMidX(self.frame),
                                       CGRectGetMidY(self.frame));
    [self addChild:self.pacMan];
    
    self.physicsWorld.gravity = CGVectorMake(0.0, -1.0);
    
    self.pacMan.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.pacMan.size.width/2];
    self.pacMan.physicsBody.mass = 1.0;
    self.pacMan.physicsBody.dynamic = YES;
    
    [self addWall];
}

- (void) addWall {
    
    CGFloat separation = self.pacMan.size.height * 3;
    
    SKSpriteNode *topWall = [SKSpriteNode spriteNodeWithImageNamed:@"Wall"];
    topWall.yScale = -1;
    topWall.position = CGPointMake(CGRectGetWidth(self.frame),
                                   CGRectGetHeight(self.frame)+separation/2);
    [self addChild:topWall];
    
    SKAction *moveWall = [SKAction moveByX:-10 y:0 duration:0.1];
    [topWall runAction:[SKAction repeatActionForever:moveWall]];
    
    SKSpriteNode *bottomWall = [SKSpriteNode spriteNodeWithImageNamed:@"Wall"];
    bottomWall.position = CGPointMake(CGRectGetWidth(self.frame),
                                      -separation/2);;
    [self addChild:bottomWall];
    
    [bottomWall runAction:[SKAction repeatActionForever:moveWall]];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if(self.pacMan == nil){
        [self startGame];
        return;
    }
    
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
