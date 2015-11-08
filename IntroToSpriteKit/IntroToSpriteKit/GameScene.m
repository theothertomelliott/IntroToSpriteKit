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
@property (nonatomic) SKLabelNode *scoreLabel;

@property (nonatomic) NSInteger score;

@property (nonatomic) SKSpriteNode *pacMan;

@property (nonatomic) NSMutableArray<SKSpriteNode *> *walls;

@end

@implementation GameScene

-(void)didMoveToView:(SKView *)view {
    
    self.physicsWorld.gravity = CGVectorMake(0.0, -2);
    self.physicsWorld.contactDelegate = self;
    
    self.startLabel = [SKLabelNode labelNodeWithFontNamed:@"Verdana"];
    self.startLabel.text = @"Tap to start";
    self.startLabel.fontSize = 45;
    self.startLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                   CGRectGetMidY(self.frame));
    
    [self addChild:self.startLabel];

    self.scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Verdana"];
    self.scoreLabel.text = @"Score: 0";
    self.scoreLabel.fontSize = 24;
    self.scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    self.scoreLabel.position = CGPointMake(20,
                                           CGRectGetHeight(self.frame) - 50);
    [self addChild:self.scoreLabel];
    
    SKAction *soundAction = [SKAction playSoundFileNamed:@"wakka.mp3" waitForCompletion:YES];
    
}

- (void) startGame {
    if(self.pacMan != nil){
        [self endGame];
    }
    
    self.walls = [NSMutableArray array];
    
    self.startLabel.hidden = YES;
    
    self.pacMan = [SKSpriteNode spriteNodeWithImageNamed:@"PacmanFrame2"];
    self.pacMan.position = CGPointMake(CGRectGetMidX(self.frame),
                                       CGRectGetMidY(self.frame));
    [self addChild:self.pacMan];
    
    self.pacMan.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.pacMan.size.width/2];
    self.pacMan.physicsBody.mass = 1.0;
    self.pacMan.physicsBody.collisionBitMask = 0;
    self.pacMan.physicsBody.contactTestBitMask = 3;
    
    SKAction *addWall = [SKAction runBlock:^{
        [self addWall];
    }];
    SKAction *pause = [SKAction waitForDuration:5];
    [self runAction:
        [SKAction repeatActionForever:
            [SKAction group:@[addWall, pause]]
        ] withKey:@"wallKey"];
}

- (void) endGame {
    self.score = 0;
    
    self.startLabel.hidden = NO;
    [self removeActionForKey:@"wallKey"];
    [self.pacMan removeFromParent];
    self.pacMan = nil;
    
    for (SKSpriteNode *wall in self.walls) {
        [wall removeFromParent];
    }
    self.walls = nil;
}

- (void) addWall {
    
    CGFloat separation = self.pacMan.size.height * 3;
    
    // Top wall
    SKSpriteNode *topWall = [SKSpriteNode spriteNodeWithImageNamed:@"Wall"];
    topWall.position = CGPointMake(0,
                                   (topWall.size.height/2 + separation/2));
    topWall.yScale = -1;
    
    topWall.physicsBody = [SKPhysicsBody bodyWithTexture:topWall.texture size:topWall.size];
    topWall.physicsBody.categoryBitMask = 1;
    topWall.physicsBody.affectedByGravity = NO;
    topWall.physicsBody.dynamic = NO;
    
    // Bottom wall
    SKSpriteNode *bottomWall = [SKSpriteNode spriteNodeWithImageNamed:@"Wall"];
    bottomWall.position = CGPointMake(0,
                                      -bottomWall.size.height/2 - separation/2);
    
    bottomWall.physicsBody = [topWall.physicsBody copy];
    
    // Score boundary
    SKSpriteNode *scoreBoundary = [SKSpriteNode spriteNodeWithColor:[UIColor clearColor] size:CGSizeMake(2,CGRectGetHeight(self.frame))];
    scoreBoundary.position = CGPointMake(topWall.size.width/2, 0);
    scoreBoundary.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:scoreBoundary.size];
    scoreBoundary.physicsBody.categoryBitMask = 2;
    scoreBoundary.physicsBody.affectedByGravity = NO;
    scoreBoundary.physicsBody.dynamic = NO;

    // Combined wall sprite
    SKSpriteNode *wall = [SKSpriteNode node];
    wall.position = CGPointMake(CGRectGetWidth(self.frame) + topWall.size.width/2, CGRectGetMidY(self.frame));
    [self addChild:wall];
    
    [wall addChild:topWall];
    [wall addChild:bottomWall];
    [wall addChild:scoreBoundary];
    
    [self.walls addObject:wall];
    SKAction *moveWall = [SKAction moveByX:-10 y:0 duration:0.1];
    [wall runAction:[SKAction repeatActionForever:moveWall]];
    
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
    if(contact.bodyA.categoryBitMask == 1){
        [self endGame];
    } else {
        self.score++;
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

- (void) setScore:(NSInteger)score {
    _score = score;
    [self.scoreLabel setText:[NSString stringWithFormat:@"Score: %lu", score]];
}

@end
