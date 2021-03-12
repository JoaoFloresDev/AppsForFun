import PlaygroundSupport
import SpriteKit


public func loadLiveView(time: Double)
{
    let sceneView = SKView(frame: CGRect(x:0 , y:0, width: 400, height: 600))
    
    
    // Load the SKScene from 'IntroScene.sks'
    if let scene = Scene1(fileNamed: "Scene1") {
        // Set the scale mode to scale to fit the window
        scene.scaleMode = .aspectFit
        
        // Present the scene
        sceneView.presentScene(scene)
    }
    
    sceneView.ignoresSiblingOrder = false
    
    PlaygroundSupport.PlaygroundPage.current.liveView = sceneView
}
