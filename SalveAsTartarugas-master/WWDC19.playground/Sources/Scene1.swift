import SpriteKit

class Scene1: SKScene {
    
    var btNext: SKSpriteNode!
    var scoreLabel: SKLabelNode!
    var scoreLabel2: SKLabelNode!
    override func didMove(to view: SKView) {
        
        self.btNext = self.childNode(withName: "btNext") as? SKSpriteNode
        self.scoreLabel = self.childNode(withName: "scoreLabel") as? SKLabelNode
        self.scoreLabel2 = self.childNode(withName: "scoreLabel2") as? SKLabelNode
        
        self.scoreLabel.text = "\(getstopwatch()) seconds"
        self.scoreLabel2.text = "\(getstopwatch()*10352) Kg"
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            
            let location = touch.location(in:self)
            
            if self.btNext.contains(location) {
                self.loadNext()
            }
            
        }
    }
    
    func loadNext() {
        
        if let scene = Scene2(fileNamed: "Scene2") {
            // Set the scale mode to scale to fit the window
            scene.scaleMode = .aspectFit
 

            // Present the scene
            self.view?.presentScene(scene)
        }
        
    }
    
}

