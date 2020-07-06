//
//  ViewController.swift
//  RulerAr
//
//  Created by Cryton Sibanda on 2020/07/06.
//  Copyright © 2020 Cryton Sibanda. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    var pointArrayNode = [SCNNode]()
    var textNode = SCNNode()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //check the number of points
        if pointArrayNode.count >= 2 {
            for point in pointArrayNode {
                point.removeFromParentNode()
            }
            pointArrayNode = [SCNNode]()
        }
        //Plot the points
        
        if let locationTapped = touches.first?.location(in: sceneView){
            let hitTestResult = sceneView.hitTest(locationTapped, types: .featurePoint)
            if let hitTest = hitTestResult.first {
                addPoint(at: hitTest)
            }
        }
    }
    
    func addPoint(at hitTest: ARHitTestResult) {
        let pointGeometry = SCNSphere(radius: 0.07)
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.yellow
        pointGeometry.materials = [material]
        
        let pointNode = SCNNode()
        pointNode.geometry = pointGeometry
        pointNode.position = SCNVector3(
            hitTest.worldTransform.columns.3.x,
            hitTest.worldTransform.columns.3.y,
            hitTest.worldTransform.columns.3.z)
        sceneView.scene.rootNode.addChildNode(pointNode)
        pointArrayNode.append(pointNode)
        if pointArrayNode.count >= 2{
            calculateDistance()
        }
    }
    func calculateDistance() {
        let x = pointArrayNode[0]
        let y = pointArrayNode[1]
        
        let a  = y.position.x - x.position.x
        let b  = y.position.y - x.position.y
        let c  = y.position.z - x.position.z
        
        let distance = sqrt(pow(a, 2) + pow(b, 2)  + pow(c, 2))
        let actaulDis = abs(distance)
        
        setupText(text: "\(actaulDis)", position: y.position)
    }
    
    func setupText(text: String, position: SCNVector3) {
        textNode.removeFromParentNode()
        let textGeometry = SCNText(string: text, extrusionDepth: 1.0)
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.green
        
        textNode = SCNNode()
        textNode.geometry = textGeometry
        textNode.position = SCNVector3(x: position.x, y: position.y+0.01, z: position.z)
        textNode.scale = SCNVector3(x: 0.03, y: 0.03, z: 0.03)
        
        sceneView.scene.rootNode.addChildNode(textNode)
    }
    
    
    
}
