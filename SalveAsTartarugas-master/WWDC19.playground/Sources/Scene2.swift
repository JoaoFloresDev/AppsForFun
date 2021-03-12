import SpriteKit

class Scene2: SKScene {
    
    var btNext: SKSpriteNode!
    override func didMove(to view: SKView) {
        
        self.btNext = self.childNode(withName: "btNext") as? SKSpriteNode
        
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
        
        if let scene = Scene3(fileNamed: "Scene3") {
            // Set the scale mode to scale to fit the window
            scene.scaleMode = .aspectFit
 

            // Present the scene
            self.view?.presentScene(scene)
        }
        
    }
    
}

