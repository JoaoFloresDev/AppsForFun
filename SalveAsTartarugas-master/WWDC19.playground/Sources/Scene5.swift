import SpriteKit

class Scene5: SKScene {
    
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
        
        if let scene = Scene6(fileNamed: "Scene6") {
            // Set the scale mode to scale to fit the window
            scene.scaleMode = .aspectFit
 

            // Present the scene
            self.view?.presentScene(scene)
        }
        
    }
    
}

