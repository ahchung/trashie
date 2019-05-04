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
    
    @IBOutlet var optionsButtons: [UIButton]! //scan and map buttons
    
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
    
    @IBAction func optionsClicked(_ sender: UIButton) { //clicked on Options button
        optionsButtons.forEach { (button) in
            UIView.animate(withDuration: 0.3, animations: {
                button.isHidden = !button.isHidden
            })
        }
    }
    
    enum Choices: String {
        case scan = "Scan Items"
        case map = "Map"
    }
    
    @IBAction func optionsTapped(_ sender: UIButton) { //chose choices
        guard let title = sender.currentTitle, let choice = Choices(rawValue: title) else {
            return
        }
        switch choice {
        case .scan:
            print("pressed Scan Items")
        case .map:
            print("pressed Map")
//            self.performSegue(withIdentifier: "clickedMap", sender: self) //TERMINATES WITH UNCAUGHT EXCEPTION
        //default: //keep default as scan
            //print("Scan screen")
        }
    }
    

    // MARK: - ARSCNViewDelegate
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
        
        if let objectAnchor = anchor as? ARObjectAnchor{
            
            let plane = SCNPlane(width: CGFloat(objectAnchor.referenceObject.extent.x*0.8), height: CGFloat(objectAnchor.referenceObject.extent.y*0.5))
            
                plane.cornerRadius = plane.width / 8
            
                let spriteKitScene = SKScene(fileNamed: "messageBlob")

                plane.firstMaterial?.diffuse.contents = spriteKitScene
                //plane.firstMaterial?.isDoubleSided = true
                plane.firstMaterial?.diffuse.contentsTransform = SCNMatrix4Translate(SCNMatrix4MakeScale(1, -1, 1), 0, 1, 0)
            
                let planeNode = SCNNode(geometry: plane)
            planeNode.position = SCNVector3Make(objectAnchor.referenceObject.center.x, objectAnchor.referenceObject.center.y + 0.1, objectAnchor.referenceObject.center.z)
            
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