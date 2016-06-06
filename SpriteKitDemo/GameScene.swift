//
//  GameScene.swift
//  SpriteKitDemo
//
//  Created by HackerU on 06/06/2016.
//  Copyright (c) 2016 HackerU. All rights reserved.
//

import SpriteKit

let CatBlock:UInt32 = 2
let CatPaddle:UInt32 = 4
let CatBall:UInt32 = 8
let CatBorder:UInt32 = 16

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
        addPaddle()
        addBricks()
        addCollisions()
    }
    
    func addCollisions(){
        let ball = childNodeWithName("ball")!
        let paddle = childNodeWithName("paddle")
        
        ball.physicsBody?.categoryBitMask = CatBall
        paddle?.physicsBody?.categoryBitMask = CatPaddle
        
        //also added brick.physicsBody?.categoryBitMask = CatBlock (in addBricks Method)
        
        //get notification between block and ball
        ball.physicsBody?.contactTestBitMask = CatBlock
        
        //also added: borderBody.categoryBitMask = CatBorder
        
        physicsWorld.contactDelegate = self
    }
    
    
    func addBricks(){
        let numBlocks = 8
        let block = SKSpriteNode(imageNamed: "block")
        let w = block.frame.width
        let h = block.frame.height
        
        var xOffset = (view!.frame.width - CGFloat(numBlocks) * (w + 0.5))/2
        
        
        for _ in 0..<numBlocks{
            let brick = SKSpriteNode(imageNamed: "block")
            brick.name = "block"
            brick.position.x = xOffset
            brick.position.y = frame.height - h
            brick.zPosition = 2
            xOffset += w + 0.5
            
            brick.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: w, height: h))
            brick.physicsBody?.dynamic = false
            brick.physicsBody?.categoryBitMask = CatBlock
            addChild(brick)
        }
        
    }
    func addPaddle(){
        let paddle = SKSpriteNode(imageNamed: "paddle")
        paddle.name = "paddle"
        paddle.position.x = midX
        paddle.position.y = paddle.frame.height
        paddle.zPosition = 2
        
        let paddleBody = SKPhysicsBody(rectangleOfSize:paddle.frame.size)
        paddleBody.dynamic = false
        paddleBody.affectedByGravity = false
        
        paddle.physicsBody = paddleBody
        
        addChild(paddle)
    }
    
    func removeGravityAndApplyImpulse(){
        physicsWorld.gravity = CGVectorMake(0, 0)
        let ball = childNodeWithName("ball")!
        ball.physicsBody?.applyImpulse(CGVectorMake(3, 3))
    }
    func addBorder(){
        let borderBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
        borderBody.affectedByGravity = false
        borderBody.friction = 0
        borderBody.dynamic = false
        borderBody.categoryBitMask = CatBorder
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
    
    var isFingerOnPaddle = false
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first!.locationInNode(self)
        let paddle = childNodeWithName("paddle")!
        
        if CGRectContainsPoint(paddle.frame, touch){
            print("Hooha")
            isFingerOnPaddle = true
        }
    }
   
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if isFingerOnPaddle{
            let touch = touches.first!.locationInNode(self)
            //let prev = touches.first!.previousLocationInNode(self)
            
            let paddle = childNodeWithName("paddle")!
            
            paddle.position.x  = touch.x
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        isFingerOnPaddle = false
    }
    
    
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}


extension GameScene : SKPhysicsContactDelegate{
    func didBeginContact(contact: SKPhysicsContact) {
        var block:SKPhysicsBody?
        
        if contact.bodyA.categoryBitMask == CatBlock{
            block = contact.bodyA
        }
        else if contact.bodyB.categoryBitMask == CatBlock{
             block = contact.bodyB
        }
        
        if block == nil { return }
        
        
        let emitter = SKEmitterNode(fileNamed: "BreakBallEmitter")
        emitter?.position = block!.node!.position
        emitter?.zPosition = 3
        
        let delayAction = SKAction.waitForDuration(0.5)
        let removeAction = SKAction.removeFromParent()
        let sequence = SKAction.sequence([delayAction, removeAction])
        emitter?.runAction(sequence)
        
        
        addChild(emitter!)
        
        
        block?.node?.removeFromParent()
        
    }
}