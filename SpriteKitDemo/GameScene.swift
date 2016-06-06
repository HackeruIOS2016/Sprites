//
//  GameScene.swift
//  SpriteKitDemo
//
//  Created by HackerU on 06/06/2016.
//  Copyright (c) 2016 HackerU. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    var midX = CGFloat()
    var midY = CGFloat()
    
    //view did Apear:
    override func didMoveToView(view: SKView) {
        midX = CGRectGetMidX(self.frame)
        midY = CGRectGetMidY(self.frame)
        addBackground()
        addBall()
        addBorder()
        removeGravityAndApplyImpulse()
        
    }
    
    func removeGravityAndApplyImpulse(){
        physicsWorld.gravity = CGVectorMake(0, 0)
        let ball = childNodeWithName("ball")!
        ball.physicsBody?.applyImpulse(CGVectorMake(2, 2))
    }
    func addBorder(){
        let borderBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
        borderBody.affectedByGravity = false
        borderBody.friction = 0
        borderBody.dynamic = false
        
        scene?.physicsBody = borderBody
    }
    
    func addBall(){
        let ball = SKSpriteNode(imageNamed: "ball")
        ball.name = "ball"
        ball.position = CGPoint(x: midX, y: self.frame.size.height - 50)
        ball.zPosition = 2
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2)

        ball.physicsBody?.friction = 0
        ball.physicsBody?.restitution = 1
        ball.physicsBody?.angularDamping = 0
        ball.physicsBody?.linearDamping = 0
        ball.physicsBody?.allowsRotation = false
        addChild(ball)
    }
    
    func addBackground(){
        let background = SKSpriteNode(imageNamed: "bg")
        background.zPosition = 1
        background.position = CGPoint(x: midX, y: midY)
        background.size = view!.frame.size
        addChild(background)
    }
    
    func addLabel(){
        /* Setup your scene here */
        let myLabel = SKLabelNode(fontNamed:"Chalkduster")
        myLabel.text = "Hello, World!"
        myLabel.fontSize = 45
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
        
        self.addChild(myLabel)
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
//       /* Called when a touch begins */
//        
//        for touch in touches {
//            let location = touch.locationInNode(self)
//            
//            let sprite = SKSpriteNode(imageNamed:"Spaceship")
//            
//       //     sprite.xScale = 0.5
//       //     sprite.yScale = 0.5
//            sprite.position = location
//            
//           // let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
//            
//          //  sprite.runAction(SKAction.repeatActionForever(action))
//            
//            self.addChild(sprite)
//        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
