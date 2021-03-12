import Foundation
import SpriteKit
import AVFoundation

var shrimp = SKTexture(imageNamed: "shrimp")
var cup = SKTexture(imageNamed: "cup")
var straw = SKTexture(imageNamed: "straw")
var bag = SKTexture(imageNamed: "bag")
var bottle = SKTexture(imageNamed: "bottle")
var playerTexture = SKTexture(imageNamed: "Player")

public func gameView(startingLives: Int = 7, newOrbEvery: TimeInterval = 0.3, gameSpeed: Double = 0.3) -> SKView {
    let sceneView = SKView(frame: CGRect(x:0 , y:0, width: 400, height: 600))
    let scene = AccessibleGameScene(size: CGSize(width: 400, height: 600))
    
    // Set variables chosen (as seen in Part 3)
    scene.shrimpTexture = shrimp
    scene.strawTexture = straw
    scene.cupTexture = cup
    scene.bagTexture = bag
    scene.bottleTexture = bottle
    
    scene.startingLives = startingLives
    scene.newOrbEvery = newOrbEvery
    scene.gameSpeed = gameSpeed
    sceneView.presentScene(scene)
    
    return sceneView
}

//  timer
var stopwatch = 0.0

public func getstopwatch() -> Double {
    return stopwatch
}

class AccessibleGameScene: SKScene, SKPhysicsContactDelegate {
    
    var shrimpTexture: SKTexture?
    var strawTexture: SKTexture?
    var cupTexture:SKTexture?
    var bagTexture:SKTexture?
    var bottleTexture:SKTexture?
    
    var points = 0
    var startingLives = 0 // This variable helps when restarting the game
    var lives = 7
    let livesLabel = SKLabelNode(text: "Lives: 0")
    let pointsLabel = SKLabelNode(text: "Points: 0")
    let Time = SKLabelNode(text: "Time: 0.0")
    let status = SKLabelNode(text: "😁")
    
    // Game mechanic variables
    var newOrbEvery: TimeInterval = 0.3
    var gameSpeed: Double = 3 // This is essentially the gravity of the orbs
    // Game State Veriables
    var lastFrame: TimeInterval = 0.0
    var gameover = false
    var timeSinceLastOrb: TimeInterval = 0.0
    var timer : Timer!
    var timer2 : Timer!
    
    
    var player = SKSpriteNode(texture: playerTexture)
    
    override func didMove(to: SKView) {
        
        self.physicsWorld.contactDelegate = self
        self.backgroundColor = .black
        lives = startingLives
        
        // Background
        let bg = SKSpriteNode(texture: SKTexture(imageNamed: "Background"))
        var bgDinamicY = (self.size.height)
        bg.position = CGPoint(x: self.size.width / 2, y: bgDinamicY / 2)
        self.addChild(bg)
        
        // Status turtle
        status.fontSize = 25
        status.position = CGPoint(x: 110, y: self.size.height - 30)
        status.zPosition = 1
        self.addChild(status)
        
        // Points and Lives labels
        livesLabel.fontSize = 20
        livesLabel.fontColor = .black
        livesLabel.fontName = "HelveticaNeue-BoldItalic"
        livesLabel.position = CGPoint(x: 10, y: self.size.height - 30)
        livesLabel.horizontalAlignmentMode = .left
        livesLabel.zPosition = 1
        self.addChild(livesLabel)

        pointsLabel.fontSize = 20
        pointsLabel.fontColor = .black
        pointsLabel.fontName = "HelveticaNeue-BoldItalic"
        pointsLabel.position = CGPoint(x: 10, y: self.size.height - 60)
        pointsLabel.horizontalAlignmentMode = .left
        pointsLabel.zPosition = 1
        self.addChild(pointsLabel)
        
        Time.fontSize = 20
        Time.fontColor = .black
        Time.fontName = "HelveticaNeue-BoldItalic"
        Time.position = CGPoint(x: 10, y: self.size.height - 90)
        Time.horizontalAlignmentMode = .left
        Time.zPosition = 1
        self.addChild(Time)
        
        // Creating our player
        player.name = "player"
        player.position = CGPoint(x: self.size.width * 0.1, y: self.size.height * 0.2)
        player.xScale = 0.25
        player.yScale = 0.25
        player.physicsBody = SKPhysicsBody(circleOfRadius: 50)
        player.physicsBody!.affectedByGravity = false // Player doesn't fall
        player.physicsBody!.isDynamic = false // and doesn't move when hit
        player.physicsBody!.collisionBitMask = 0x0001 // 0b00000001
        player.physicsBody!.categoryBitMask = 0x0000 // 0b00000000
        player.physicsBody!.contactTestBitMask = 0x0001 // 0b00000001
        player.physicsBody?.restitution = 0
        self.addChild(player)
        
        //Creating an out of frame ground to remove fallen orbs
        let oob = SKShapeNode(rectOf: CGSize(width: self.size.width, height: 100))
        oob.name = "oob"
        oob.position = CGPoint(x: self.size.width / 2, y: -100)
        oob.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.size.width, height: 100))
        oob.physicsBody!.affectedByGravity = false
        oob.physicsBody!.isDynamic = false
        oob.physicsBody!.collisionBitMask = 0x0001 // 0b00000001
        oob.physicsBody!.categoryBitMask = 0x0002 // 0b00000010
        oob.physicsBody!.contactTestBitMask = 0x0001 // 0b00000001
        oob.physicsBody?.restitution = 0
        self.addChild(oob)
        
        // Gravity is definted by the negated absolute value of gameSpeed
        self.physicsWorld.gravity = CGVector(dx: 0.0, dy: gameSpeed.magnitude * -1)
        
        // timers of stopwatch and background in motion
        self.timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true
            , block: { (timer) in
                stopwatch += 0.5
                self.Time.text = "Time: \(stopwatch)"
        })
        
        self.timer2 = Timer.scheduledTimer(withTimeInterval: 0.000000001, repeats: true
            , block: { (timer2) in
                if(bgDinamicY == 0)
                {bgDinamicY = (self.size.height)}
                
                if(!self.gameover)
                {
                    bgDinamicY -= 4
                    bg.position = CGPoint(x: self.size.width / 2, y: bgDinamicY)
                
                }
        })
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            // If the game is over, start scenes
            if(gameover) {
                loadLiveView(time: stopwatch)
            }
            
                // Otherwise, move the player
                
                // Left
                if t.location(in: self).x < self.size.width * 0.5 {
                    if(player.position.x > self.size.width * 0.2)
                    {
                        player.run(SKAction.moveBy(x: (self.size.width * -0.2), y: 0, duration: 0.2))
                    }
                }
                    // Right
                else {
                    if(player.position.x < self.size.width * 0.7)
                    {
                        player.run(SKAction.moveBy(x: (self.size.width * 0.2), y: 0, duration: 0.2))
                    }
                }
            
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        // Player and objects in contact
        if (contact.bodyB.node?.name == "shrimp" || contact.bodyB.node?.name == "bag" ||
            contact.bodyB.node?.name == "straw" || contact.bodyB.node?.name == "bottle" ||
            contact.bodyB.node?.name == "cup") &&
            contact.bodyA.node?.name == "player" {
            // Powerup
            if(contact.bodyB.node?.name == "shrimp") {
                points += 100
            }
                // Powerdown
            else {
                lives -= 1
                //self.run(loseSound)
            }
            contact.bodyB.node?.removeFromParent()
            
        }
            // object and off screen ground contact
        else if (contact.bodyB.node?.name == "shrimp" || contact.bodyB.node?.name == "bag" ||
            contact.bodyB.node?.name == "straw" || contact.bodyB.node?.name == "bottle" ||
            contact.bodyB.node?.name == "cup") &&
            contact.bodyA.node?.name == "oob" {
            contact.bodyB.node?.removeFromParent()
            
        }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        
        
        // Called before each frame is rendered
        // Check for game over, if so, stop physics and draw labels
        if((lives <= 0 || points == 1000) && !gameover){
            gameover = true
            timer.invalidate()
            timer2.invalidate()
            self.physicsWorld.speed = 0.0
            if(points == 1000)
            {
                // "Game Over" label
                let gameOverLabel = SKLabelNode(text: "You Win!")
                gameOverLabel.fontColor = .black
                gameOverLabel.fontSize = 50
                gameOverLabel.fontName = "HelveticaNeue-BoldItalic"
                gameOverLabel.position = CGPoint(x: self.size.width / 2, y: 400)
                gameOverLabel.horizontalAlignmentMode = .center
                gameOverLabel.name = "goLabel"
                self.addChild(gameOverLabel)
                
                
            }
            else
            {
            // "Game Over" label
            let gameOverLabel = SKLabelNode(text: "Game Over")
            gameOverLabel.fontColor = .black
            gameOverLabel.fontSize = 50
            gameOverLabel.fontName = "HelveticaNeue-BoldItalic"
            gameOverLabel.position = CGPoint(x: self.size.width / 2, y: 400)
            gameOverLabel.horizontalAlignmentMode = .center
            gameOverLabel.name = "goLabel"
            self.addChild(gameOverLabel)
            }
            // "Score:" heading label
            let scoreLabelLabel = SKLabelNode(text: "Score:")
            scoreLabelLabel.fontColor = .black
            scoreLabelLabel.fontSize = 50
            scoreLabelLabel.fontName = "HelveticaNeue-BoldItalic"
            scoreLabelLabel.position = CGPoint(x: self.size.width / 2, y: 350)
            scoreLabelLabel.horizontalAlignmentMode = .center
            scoreLabelLabel.name = "goLabel"
            self.addChild(scoreLabelLabel)
            
            // The actual score label
            let scoreLabel = SKLabelNode(text: "\(points)")
            scoreLabel.fontColor = .black
            scoreLabel.fontSize = 70
            scoreLabel.fontName = "HelveticaNeue-BoldItalic"
            scoreLabel.position = CGPoint(x: self.size.width / 2, y: 290)
            scoreLabel.horizontalAlignmentMode = .center
            scoreLabel.name = "goLabel"
            self.addChild(scoreLabel)
            
            // "Score:" heading label
            let scoreLabelLabel2 = SKLabelNode(text: "Tap to continue!")
            scoreLabelLabel2.fontColor = .black
            scoreLabelLabel2.fontSize = 20
            scoreLabelLabel2.fontName = "HelveticaNeue-BoldItalic"
            scoreLabelLabel2.position = CGPoint(x: self.size.width / 2, y: 200)
            scoreLabelLabel2.horizontalAlignmentMode = .center
            scoreLabelLabel2.name = "goLabel"
            self.addChild(scoreLabelLabel2)
            
            let nodes = self.children
            for node in nodes {
                if(node.name == "shrimp" || node.name == "bag" ||
                    node.name == "straw" || node.name == "bottle" ||
                    node.name == "cup"){
                    node.removeFromParent()
                }
            }
            
            self.run(SKAction.playSoundFileNamed("lose.m4a", waitForCompletion: true))
        }
            // Otherwise, do gameplay updates
        else {
            // Update labels
            
            
            switch (lives) {
            case 0: status.text = "😵"
                
            case 1: status.text = "😭"
                
            case 2: status.text = "🥺"
                
            case 3: status.text = "😨"
                
            case 4: status.text = "😥"
                
            case 5: status.text = "😕"
                
            case 6: status.text = "😌"
                
            case 7: status.text = "😁"
                
            default: break
            }
            livesLabel.text = "Lives: \(lives)"
            
            pointsLabel.text = "Points: \(points)"
            
            Time.text = "Time: \(stopwatch)"
            
            // update time since the last orb spawned
            timeSinceLastOrb += (currentTime - lastFrame)
            
            // and spawn a new orb if enough time has passed
            if(timeSinceLastOrb >= newOrbEvery) {
                let randomLane = arc4random_uniform(5) // in any lane
                let randomOrb = arc4random_uniform(5) // of any type
                var orbTexture: SKTexture!
                var orbName: String
                
                // choose type based on randomOrb
                switch randomOrb {
                    
                case 0:
                    orbTexture = strawTexture
                    orbName = "straw"
                    
                case 1:
                    orbTexture = shrimpTexture
                    orbName = "shrimp"
                    
                case 2:
                    orbTexture = cupTexture
                    orbName = "cup"
                    
                case 3:
                    orbTexture = bagTexture
                    orbName = "bag"
                    
                case 4:
                    orbTexture = bottleTexture
                    orbName = "bottle"
                    
                default:
                    orbTexture = bagTexture
                    orbName = "bag"
                    
                }
                
                // and lane based on randomLane
                switch randomLane {
                case 0:
                    self.addChild(createOrb(orbTexture,
                                            position: CGPoint(x: (self.size.width * 0.1), y: self.size.height + 50),
                                            name: orbName))
                case 1:
                    self.addChild(createOrb(orbTexture,
                                            position: CGPoint(x: (self.size.width * 0.3), y: self.size.height + 50),
                                            name: orbName))
                case 2:
                    self.addChild(createOrb(orbTexture,
                                            position: CGPoint(x: (self.size.width * 0.5), y: self.size.height + 50),
                                            name: orbName))
                    
                case 3:
                    self.addChild(createOrb(orbTexture,
                                            position: CGPoint(x: (self.size.width * 0.7), y: self.size.height + 50),
                                            name: orbName))
                    
                case 4:
                    self.addChild(createOrb(orbTexture,
                                            position: CGPoint(x: (self.size.width * 0.9), y: self.size.height + 50),
                                            name: orbName))
                    
                default:
                    self.addChild(createOrb(orbTexture,
                                            position: CGPoint(x: (self.size.width * 0.9), y: self.size.height + 50),
                                            name: orbName))
                    
                }
                
                
                timeSinceLastOrb = 0
            }
        }
        // update what the last frame was
        lastFrame = currentTime
    }
    
    // Create a new object
    // name, position, and texture are passed in as the object could be a
    // powerup or powerdown, and be in any of the three lanes we have.
    func createOrb(_ texture: SKTexture?, position: CGPoint, name: String) -> SKSpriteNode {
        let powerup = SKSpriteNode(texture: texture!)
        powerup.name = name
        powerup.position = position
        powerup.xScale = 0.75
        powerup.yScale = 0.75
        powerup.physicsBody = SKPhysicsBody(circleOfRadius: powerup.size.width / 2)
        powerup.physicsBody!.collisionBitMask = 0x0000 // 0b00000000
        powerup.physicsBody!.categoryBitMask = 0x0003 // 0b00000011
        powerup.physicsBody!.restitution = 0
        powerup.physicsBody!.contactTestBitMask = 0x0003 // 0b00000011
        return powerup
    }
}


