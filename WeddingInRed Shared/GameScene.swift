import SpriteKit
import AVFoundation
import SwiftUI

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    
    
    let playButton = SKSpriteNode(imageNamed: "Married_in_red_title_screen.pdf.jpg")
    // called when scene loads
    override func didMove(to view: SKView){
        playButton.name = "NewGame"
        playButton.position = CGPoint (x: frame.midX, y: frame.midY)
        setUpScene()
    }
    
    
    
    fileprivate var label : SKLabelNode?
    fileprivate var spinnyNode : SKShapeNode?
    
//        Variable to create the player's body as a SKSprite, and a titleMap as a SKTitleMap.
//        var player: SKSpriteNode
//        var titleMap: SKTitleMapNode!
    
    
    class func newGameScene() -> GameScene {

        guard let scene = SKScene(fileNamed: "GameScene") as? GameScene else {
            print("Failed to load GameScene.sks")
            abort()
        }
        
        scene.scaleMode = .aspectFill
        
        return scene
    }
    
    func setUpScene() {
        // Get label node from scene and store it for use later
        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
        if let label = self.label {
            label.alpha = 0.0
            label.run(SKAction.fadeIn(withDuration: 2.0))
        }
        
        // Create shape node to use during mouse interaction
        let w = (self.size.width + self.size.height) * 0.05
        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
        
        if let spinnyNode = self.spinnyNode {
            spinnyNode.lineWidth = 4.0
            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
                                              SKAction.fadeOut(withDuration: 0.5),
                                              SKAction.removeFromParent()]))
            
        }
        func didMove(to view: SKView){
            physicsWorld.contactDelegate = self
            physicsWorld.gravity = .zero
            //            This connects to a titleSet, that right now, doesn't have a name ->
            //            if let titleSet = SKTitleSet(named: ""){
            //            titleMap = SKTitleMapNode(titleSet: titleSet, columns: 20, rows: 20, titleSize: CGSize(width: 64, height: 64))
        }
        
        let pos = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        let cameraNode = SKCameraNode()
        cameraNode.position = pos
        self.addChild(cameraNode)
        self.camera = cameraNode
        
        print("setup scene called")
    }
    
    func createTextLabel(with label: String) -> SKLabelNode{
        
        let textLabel = SKLabelNode(text: label)
        
        textLabel.fontSize = 65
        
        textLabel.fontColor = .red
        
        textLabel.fontName = "AvenirNext-Bold"
        textLabel.verticalAlignmentMode = .center
        textLabel.horizontalAlignmentMode = .center
        
        return textLabel
    }
    
//    if ("Paragraph" == fade out) {
//        
//    }
    
    
    let Invitation = SKLabelNode(fontNamed: "You recieve a wedding invitiation, from...Myeong-hoon. ")
    
    
    func makeSpinny(at pos: CGPoint, color: SKColor) {
        if let spinny = self.spinnyNode?.copy() as! SKShapeNode? {
            spinny.position = pos
            spinny.strokeColor = color
            self.addChild(spinny)
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
       
    }
}

#if os(iOS) || os(tvOS)
// Touch-based event handling
extension GameScene {

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let label = self.label {
            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        }
        
        for t in touches {
            self.makeSpinny(at: t.location(in: self), color: SKColor.green)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            self.makeSpinny(at: t.location(in: self), color: SKColor.blue)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            self.makeSpinny(at: t.location(in: self), color: SKColor.red)
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            self.makeSpinny(at: t.location(in: self), color: SKColor.red)
        }
    }
    
   
}
#endif

#if os(OSX)
// Mouse-based event handling
extension GameScene {

    override func mouseDown(with event: NSEvent) {
        if let label = self.label {
            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        }
        self.makeSpinny(at: event.location(in: self), color: SKColor.green)
    }
    
    override func mouseDragged(with event: NSEvent) {
        self.makeSpinny(at: event.location(in: self), color: SKColor.blue)
    }
    
    override func mouseUp(with event: NSEvent) {
        self.makeSpinny(at: event.location(in: self), color: SKColor.red)
    }

}
#endif

