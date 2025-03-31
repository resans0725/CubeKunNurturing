//
//  ContentView.swift
//  CubeKunNurturing
//
//  Created by 永井涼 on 2025/03/31.
//

import SwiftUI
import SceneKit

struct ContentView: View {
    @State private var isObjectThrown = false
    @State private var cameraMode = false

    var body: some View {
        VStack {
            SceneKitView(
                isObjectThrown: $isObjectThrown,
                cameraMode: $cameraMode
            )
            .edgesIgnoringSafeArea(.all)
            .overlay(alignment: .bottom) {
                    
                    HStack {
                        Button("ごはん") {
                            isObjectThrown.toggle()
                        }
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        
                        Button(cameraMode ? "飼育モード": "観察モード") {
                            cameraMode.toggle()
                        }
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    
                }
        }
    }
}

struct SceneKitView: UIViewRepresentable {
    @Binding var isObjectThrown: Bool
    @Binding var cameraMode: Bool
    @State private var sceneView = SCNView()
    
    func makeUIView(context: Context) -> SCNView {
        let sceneView = SCNView()
        let scene = SCNScene()

        // シーンの設定
        sceneView.scene = scene
        sceneView.allowsCameraControl = cameraMode
        sceneView.showsStatistics = false

        // カメラの設定
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: 0, y: 15, z: 20) // 近づける
        cameraNode.eulerAngles = SCNVector3(-Float.pi / 6, 0, 0) // 斜め下を向く
        scene.rootNode.addChildNode(cameraNode)
        
        // ライトの設定
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light?.type = .omni
        lightNode.position = SCNVector3(x: 10, y: 10, z: 10)
        scene.rootNode.addChildNode(lightNode)
        
        // 地面の設定
        addGround(to: scene)
        
        // 背景の設定
        scene.background.contents = UIColor.green.withAlphaComponent(0.5)
        
        // 重力の設定
        scene.physicsWorld.gravity = SCNVector3(0, -9.8, 0)
        
        // キャラクターを追加
        addCharacter(to: scene, cameraNode: cameraNode)
        
        return sceneView
    }

    func updateUIView(_ uiView: SCNView, context: Context) {
        if isObjectThrown {
            DispatchQueue.main.async {
                self.createAndThrowObject(in: uiView)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.isObjectThrown = false
            }
        }
        
        uiView.allowsCameraControl = cameraMode
        
        if !cameraMode {
            
        }
    }

    private func createAndThrowObject(in sceneView: SCNView) {
        guard let scene = sceneView.scene else { return }
        
        let newBoxNode = create3DObject()
        scene.rootNode.addChildNode(newBoxNode)

        let force = SCNVector3(x: 0, y: 0, z: -1)
        newBoxNode.physicsBody?.applyForce(force, asImpulse: true)
    }

    private func create3DObject() -> SCNNode {
        let box = SCNBox(width: 1.0, height: 1.0, length: 1.0, chamferRadius: 0)
        let boxNode = SCNNode(geometry: box)
        
        let boxPhysicsShape = SCNPhysicsShape(geometry: box, options: nil)
        boxNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape: boxPhysicsShape)
        boxNode.physicsBody?.mass = 1.0
        
        boxNode.position = SCNVector3(1, 5, 0)
        
        return boxNode
    }

    private func addGround(to scene: SCNScene) {
        let ground = SCNPlane(width: 10, height: 10)
        let groundNode = SCNNode(geometry: ground)
        groundNode.position = SCNVector3(x: 0, y: -1, z: 0)
        groundNode.rotation = SCNVector4(1, 0, 0, -Float.pi / 2)
        
        let grassMaterial = SCNMaterial()
        grassMaterial.diffuse.contents = UIColor.green
        ground.materials = [grassMaterial]
        
        groundNode.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
        
        scene.rootNode.addChildNode(groundNode)
    }

    private func addCharacter(to scene: SCNScene, cameraNode: SCNNode) {
        guard let characterScene = SCNScene(named: "robot_walk_idle.usdz") else {
            print("Failed to load character scene.")
            return
        }
        
        guard let characterNode = characterScene.rootNode.childNode(withName: "robot_walk_idle", recursively: true) else {
            print("Failed to find the character node.")
            return
        }
        
        characterNode.scale = SCNVector3(x: 0.1, y: 0.1, z: 0.1)
        characterNode.position = SCNVector3(x: 0, y: -1, z: 0)
        
        scene.rootNode.addChildNode(characterNode)
        
        startWalkingMovement(for: characterNode)
        
        // カメラがキャラクターを追い続ける処理
        //followCharacter(cameraNode: cameraNode, targetNode: characterNode)
    }

    private func startWalkingMovement(for characterNode: SCNNode) {
        let movementRange: Float = 5.0
        
        Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { _ in
            let randomX = Float.random(in: -movementRange...movementRange)
            let randomZ = Float.random(in: -movementRange...movementRange)
            
            let targetX = characterNode.position.x + randomX
            let targetZ = characterNode.position.z + randomZ
            
            if abs(targetX) <= movementRange && abs(targetZ) <= movementRange {
                let moveAction = SCNAction.moveBy(x: CGFloat(randomX), y: 0, z: CGFloat(randomZ), duration: 3.0)
                let targetPosition = SCNVector3(x: targetX, y: characterNode.position.y, z: targetZ)
                
                let lookAtAction = SCNAction.run { node in
                    let direction = vectorSubtract(lhs: targetPosition, rhs: node.position)
                    let angle = atan2(direction.z, direction.x)
                    node.rotation = SCNVector4(x: 0, y: 1, z: 0, w: angle)
                }
                
                let sequence = SCNAction.sequence([lookAtAction, moveAction])
                characterNode.runAction(sequence)
            }
        }
    }

    private func followCharacter(cameraNode: SCNNode, targetNode: SCNNode) {
        // カメラをターゲットに追従させる
        Timer.scheduledTimer(withTimeInterval: 0.016, repeats: true) { _ in
            let targetPosition = targetNode.position
            let offset = SCNVector3(x: 0, y: 5, z: -5)  // カメラのオフセット（ターゲットの前）
            cameraNode.position = SCNVector3(x: targetPosition.x + offset.x, y: targetPosition.y + offset.y, z: targetPosition.z + offset.z)
            cameraNode.look(at: targetNode.position)  // カメラが常にターゲットを向くようにする
        }
    }
    
    private func vectorSubtract(lhs: SCNVector3, rhs: SCNVector3) -> SCNVector3 {
        return SCNVector3(x: lhs.x - rhs.x, y: lhs.y - rhs.y, z: lhs.z - rhs.z)
    }
}
