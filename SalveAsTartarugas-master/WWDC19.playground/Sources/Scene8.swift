import SpriteKit
 import PlaygroundSupport

class Scene8: SKScene {
    
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
        //loadLiveView()
        PlaygroundPage.current.liveView = gameView()
        }
        
    }


