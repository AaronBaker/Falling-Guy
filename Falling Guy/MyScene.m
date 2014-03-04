//
//  MyScene.m
//  Falling Guy
//
//  Created by Aaron Baker on 3/4/14.
//  Copyright (c) 2014 Aaron Baker. All rights reserved.
//

#import "MyScene.h"

@interface MyScene ()
@property SKSpriteNode *box;
@end

static const uint32_t boxCategory =  0x1 << 0;
static const uint32_t obstacleCategory =  0x1 << 1;
static const uint32_t otherCategory =  0x1 << 2;

@implementation MyScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        NSArray *columnXvalues = @[@32.0,@96.0,@160.0,@224.0,@288.0];
        
        
        NSArray *ObstacleColumnXvalues = @[@32.0,@96.0,@160.0,@224.0,@288.0];
        
        
        NSArray *playerColumnValues = @[@0.0,@64.0,@128.0,@192.0,@256.0,@320.0];
        
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        
        _box = [SKSpriteNode spriteNodeWithColor:[UIColor greenColor] size:CGSizeMake(64.0, 64.0)];
        _box.position = CGPointMake(128.0, screenRect.size.height - 100);
        
        self.physicsWorld.gravity = CGVectorMake(0.0, 0.0);
        
        _box.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:_box.size];
        _box.physicsBody.categoryBitMask = boxCategory;
        
        
        
        
        for (NSNumber *xValue in columnXvalues) {
            SKSpriteNode *column = [SKSpriteNode spriteNodeWithColor:[UIColor redColor] size:CGSizeMake(64.0, screenRect.size.height)];
            
            column.position = CGPointMake([xValue floatValue], screenRect.size.height/2);
            [self addChild:column];
            
        }
        
        [self addChild:_box];
        
        
        SKAction *sendObstacle = [SKAction runBlock:^{
        
            [self addObstacle];
            
        }];
        
        
        SKAction *wait = [SKAction waitForDuration:1.5];
        SKAction *repeatObstacles = [SKAction sequence:@[sendObstacle,wait]];
        
        [self runAction:[SKAction repeatActionForever:repeatObstacles]];
        
        
        
    }
    return self;
}

-(void)addObstacle {
    
    static NSInteger count = 0;
    
    count++;
    
    NSLog(@"count: %d",count);

    CGFloat randomWidth = (arc4random() % 8) * 32.0;
    
    CGFloat randomXposition = (arc4random() % 8) * 64.0;
    
//    NSLog(@"Random Width: %f",randomWidth);
//    NSLog(@"Random X Position: %f",randomXposition);
    
    SKSpriteNode *obstacle = [SKSpriteNode spriteNodeWithColor:[UIColor blackColor] size:CGSizeMake(randomWidth, 32.0)];
    obstacle.position = CGPointMake(randomXposition, 0.0);
    
    SKAction *moveToTop = [SKAction moveToY:570.0 duration:6.0];
    
    obstacle.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:obstacle.size];
    
    [self addChild:obstacle];
    [obstacle runAction:moveToTop completion:^{
    
        [obstacle removeFromParent];
    }];
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        
        SKNode *column = [self nodeAtPoint:location];
        
        CGPoint newPosition = _box.position;

        

        
        if (location.x > _box.position.x) {
            newPosition.x = _box.position.x + 64;
        }
        if (location.x < _box.position.x) {
            newPosition.x = _box.position.x - 64;
        }

        SKAction *moveToPosition = [SKAction moveToX:newPosition.x duration:0.1];

        
        if (![_box actionForKey:@"moveToPosition"]) {
            [_box runAction:moveToPosition withKey:@"moveToPosition"];
        }
        
        
        
        
        
        

    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
