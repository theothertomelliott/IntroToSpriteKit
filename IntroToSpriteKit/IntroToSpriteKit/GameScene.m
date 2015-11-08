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
    
    self.physicsWorld.gravity = CGVectorMake(0.0, -1.0);
    self.physicsWorld.contactDelegate = self;
    
    self.startLabel = [SKLabelNode labelNodeWithFontNamed:@"Verdana"];
    self.startLabel.text = @"Tap to start";
    self.startLabel.fontSize = 45;
    self.startLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                   CGRectGetMidY(self.frame));
    
    [self addChild:self.startLabel];

}

- (void) startGame {
    if(self.pacMan != nil){
        [self endGame];
    }
    
    self.startLabel.hidden = YES;
    
    self.pacMan = [SKSpriteNode spriteNodeWithImageNamed:@"PacmanFrame2"];
    self.pacMan.position = CGPointMake(CGRectGetMidX(self.frame),
                                       CGRectGetMidY(self.frame));
    [self addChild:self.pacMan];
    
    self.pacMan.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.pacMan.size.width/2];
    self.pacMan.physicsBody.mass = 1.0;
    
    self.pacMan.physicsBody.contactTestBitMask = 1;
    
    SKAction *addWall = [SKAction runBlock:^{
        [self addWall];
    }];
    SKAction *pause = [SKAction waitForDuration:5];
    SKAction *addAndPause = [SKAction group:@[addWall, pause]];
    
    [self runAction:[SKAction repeatActionForever:addAndPause] withKey:@"wallKey"];
}

- (void) endGame {
    self.startLabel.hidden = NO;
    [self removeActionForKey:@"wallKey"];
    [self.pacMan removeFromParent];
    self.pacMan = nil;
}

- (void) addWall {
    
    CGFloat separation = self.pacMan.size.height * 3;
    
    SKSpriteNode *topWall = [SKSpriteNode spriteNodeWithImageNamed:@"Wall"];
    topWall.yScale = -1;
    topWall.position = CGPointMake(CGRectGetWidth(self.frame),
                                   CGRectGetHeight(self.frame)+separation/2);
    
    topWall.physicsBody = [SKPhysicsBody bodyWithTexture:topWall.texture size:topWall.size];
    topWall.physicsBody.categoryBitMask = 1;
    topWall.physicsBody.affectedByGravity = NO;
    topWall.physicsBody.dynamic = NO;
    
    [self addChild:topWall];
    
    SKAction *moveWall = [SKAction moveByX:-10 y:0 duration:0.1];
    [topWall runAction:[SKAction repeatActionForever:moveWall]];
    
    SKSpriteNode *bottomWall = [SKSpriteNode spriteNodeWithImageNamed:@"Wall"];
    bottomWall.position = CGPointMake(CGRectGetWidth(self.frame),
                                      -separation/2);;
    [self addChild:bottomWall];
    
    bottomWall.physicsBody = [SKPhysicsBody bodyWithTexture:bottomWall.texture size:bottomWall.size];
    bottomWall.physicsBody.categoryBitMask = 1;
    bottomWall.physicsBody.affectedByGravity = NO;
    bottomWall.physicsBody.dynamic = NO;
    
    [bottomWall runAction:[SKAction repeatActionForever:moveWall]];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if(self.pacMan == nil){
        [self startGame];
        return;
    }
    
    [self runAction:[SKAction playSoundFileNamed:@"wakka.mp3" waitForCompletion:YES]];
    
    SKTexture *frame1 = [SKTexture textureWithImageNamed:@"PacmanFrame1"];
    SKTexture *frame2 = [SKTexture textureWithImageNamed:@"PacmanFrame2"];
    SKTexture *frame3 = [SKTexture textureWithImageNamed:@"PacmanFrame3"];
    
    SKAction *animation = [SKAction animateWithTextures:@[frame1,frame2,frame3,frame2] timePerFrame:0.1];
    [self.pacMan runAction:animation];
    
    [self.pacMan.physicsBody applyImpulse:CGVectorMake(0.0, -self.pacMan.physicsBody.velocity.dy + 150)];
}

- (void)didBeginContact:(SKPhysicsContact *)contact {
    [self endGame];
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
