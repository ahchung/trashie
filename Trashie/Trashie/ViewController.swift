//
//  ViewController.swift
//  Trashie
//
//  Created by Alisha Sonawalla on 4/26/19.
//  Copyright © 2019 nyu.edu. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/GameScene.scn")!
        
        // Set the scene to the view
        sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        // Object detection
        configuration.detectionObjects = ARReferenceObject.referenceObjects(inGroupNamed: "TrashObjects", bundle: Bundle.main)!

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
        
        if let objectAnchor = anchor as? ARObjectAnchor,
            let objectName = objectAnchor.referenceObject.name {
            
            let plane = SCNPlane(width: CGFloat(objectAnchor.referenceObject.extent.x*0.6), height: CGFloat(objectAnchor.referenceObject.extent.y*0.6))
            
                plane.cornerRadius = plane.width / 8
            
                var spriteKitScene = SKScene(fileNamed: "messageBlobRecycle")
            
                if (objectName == "banana"){
                    spriteKitScene = SKScene(fileNamed: "messageBlobCompost")
                } else if (objectName == "cup"){
                    spriteKitScene = SKScene(fileNamed: "messageBlobLandfill")
                } else if (objectName == "peep" || objectName == "rosewater" || objectName == "Advil"){
                    spriteKitScene = SKScene(fileNamed: "messageBlobRecycle")
                }

                plane.firstMaterial?.diffuse.contents = spriteKitScene
                plane.firstMaterial?.isDoubleSided = true
                plane.firstMaterial?.diffuse.contentsTransform = SCNMatrix4Translate(SCNMatrix4MakeScale(1, -1, 1), 0, 1, 0)
        
            
                let planeNode = SCNNode(geometry: plane)
                planeNode.position = SCNVector3Make(objectAnchor.referenceObject.center.x, objectAnchor.referenceObject.center.y + 0.1, objectAnchor.referenceObject.center.z)
                planeNode.eulerAngles.y = -.pi / 9
            node.addChildNode(planeNode)
        }
    
        return node;
    }
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
