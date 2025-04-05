//
//  SceneKitView.swift
//  CubeKunNurturing
//
//  Created by 永井涼 on 2025/04/04.
//

import SwiftUI
import SceneKit

struct SceneKitView: UIViewRepresentable {
    @Binding var isObjectThrown: Bool
    @Binding var cameraMode: Bool
    @Binding var cleaningMode: Bool
    @Binding var cubeSize: Double
    @State var sceneView = SCNView()
    var addCubeSize: () -> Void
    var addSatisfaction: () -> Void

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
        
        // 木の設定
        addTree(to: scene)
        
//        // 石の設定
        addStone(to: scene)
//
//        // 花の設定
//        addFlower(to: scene)
//
//        // ベンチの設定
//        addBench(to: scene)
        
        // きのこの設定
        addMash(to: scene)
        
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
            // カメラモードを終了したら初期位置にリセット
            resetCameraPosition(uiView)
        }
        
        if cleaningMode {
            // クリーニングモードなら投げたオブジェクトを削除
            removeThrownObjects(from: uiView)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.cleaningMode = false
            }
        }
    }
    
    // カメラの位置を初期位置にリセット
    private func resetCameraPosition(_ sceneView: SCNView) {
        guard let scene = sceneView.scene else { return }
        
        if let cameraNode = scene.rootNode.childNode(withName: "MainCamera", recursively: true) {
            cameraNode.position = SCNVector3(x: 0, y: 15, z: 20) // 初期位置に戻す
            cameraNode.eulerAngles = SCNVector3(-Float.pi / 6, 0, 0) // 角度もリセット
        }
    }

    // 投げたオブジェクトを削除する
    private func removeThrownObjects(from sceneView: SCNView) {
        guard let scene = sceneView.scene else { return }
        
        for node in scene.rootNode.childNodes {
            if node.geometry is SCNBox { // 投げたオブジェクトを特定
                node.removeFromParentNode() // 削除
            }
        }
    }

    // キューブを投げる
    private func createAndThrowObject(in sceneView: SCNView) {
        guard let scene = sceneView.scene else { return }
        
        let newBoxNode = create3DObject()
        scene.rootNode.addChildNode(newBoxNode)

        let randomX = Float.random(in: -1.0...1.0) // X軸のランダム方向
        let randomY = Float.random(in: -1.0...1.0) // Y軸のランダム方向
        let randomZ = Float.random(in: -1.0...1.0) // Z軸のランダム方向
        let force = SCNVector3(x: randomX, y: randomY, z: randomZ)
        newBoxNode.physicsBody?.applyForce(force, asImpulse: true)
        
        // キャラクターを検索し、取得
        if let character = scene.rootNode.childNode(withName: "robot_walk_idle", recursively: true) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
                moveCharacterToObject(character: character, objectNode: newBoxNode)
            }
        }
    }
    
    // 投げたキューブに移動して食べる
    func moveCharacterToObject(character: SCNNode, objectNode: SCNNode) {
        let moveAction = SCNAction.move(to: SCNVector3(x: objectNode.position.x,  y: -1, z: objectNode.position.z), duration: 2.0)
        character.runAction(moveAction) {
            Task { @MainActor in
            // 🥄 食べ物を削除
            objectNode.removeFromParentNode()
            
            // 満足度を上げる
            addSatisfaction()
                
            // 大きくする
            addCubeSize()
           
            let cubeSize = Float(cubeSize) / 10
            
            character.scale = .init(x: cubeSize, y: cubeSize, z: cubeSize)

            // 🍴 食べるアニメーション（仮）
//            let eatAnimation = SCNAction.scale(to: 0.1, duration: 0.3)
//            let resetScale = SCNAction.scale(to: 0.1, duration: 0.3)
//            let eatSequence = SCNAction.sequence([eatAnimation, resetScale])
//            character.runAction(eatSequence)
                
            }
        }
    }

    // キューブを生成
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
    
    private func addTree(to scene: SCNScene) {
        guard let treeScene = SCNScene(named: "tree.usdz") else {
            print("Failed to load character scene.")
            return
        }
        
        guard let treeNode = treeScene.rootNode.childNodes.first else {
            print("Failed to find the tree node.")
            return
        }
        
        treeNode.scale = SCNVector3(x: 0.5, y: 0.5, z: 0.5)
        treeNode.position = SCNVector3(x: 18, y: -1, z: -2)
        treeNode.rotation = SCNVector4(1, 0, 0, -Float.pi / 2)
        scene.rootNode.addChildNode(treeNode)
    }
    
    private func addBench(to scene: SCNScene) {
        guard let benchScene = SCNScene(named: "bench.usdz") else {
            print("Failed to load character scene.")
            return
        }
        
        guard let benchNode = benchScene.rootNode.childNodes.first else {
            print("Failed to find the bench node.")
            return
        }
        
        benchNode.scale = SCNVector3(x: 0.5, y: 0.5, z: 0.5)
        benchNode.position = SCNVector3(x: 18, y: -1, z: -2)
        benchNode.rotation = SCNVector4(1, 0, 0, -Float.pi / 2)
        scene.rootNode.addChildNode(benchNode)
    }
    
    private func addStone(to scene: SCNScene) {
        guard let stoneScene = SCNScene(named: "stone.usdz") else {
            print("Failed to load character scene.")
            return
        }
        
        guard let stoneNode = stoneScene.rootNode.childNodes.first else {
            print("Failed to find the stone node.")
            return
        }
        
        stoneNode.scale = SCNVector3(x: 0.5, y: 0.5, z: 0.5)
        stoneNode.position = SCNVector3(x: 0, y: -1, z: -2)
        stoneNode.rotation = SCNVector4(1, 0, 0, -Float.pi / 2)
        scene.rootNode.addChildNode(stoneNode)
    }
    
    private func addFlower(to scene: SCNScene) {
        guard let flowerScene = SCNScene(named: "flower.usdz") else {
            print("Failed to load character scene.")
            return
        }
        
        guard let flowerNode = flowerScene.rootNode.childNodes.first else {
            print("Failed to find the flower node.")
            return
        }
        
        flowerNode.scale = SCNVector3(x: 0.5, y: 0.5, z: 0.5)
        flowerNode.position = SCNVector3(x: 18, y: -1, z: -2)
        flowerNode.rotation = SCNVector4(1, 0, 0, -Float.pi / 2)
        scene.rootNode.addChildNode(flowerNode)
    }
    
    private func addMash(to scene: SCNScene) {
        guard let mashScene = SCNScene(named: "mash.usdz") else {
            print("Failed to load character scene.")
            return
        }
        
        guard let mashNode = mashScene.rootNode.childNodes.first else {
            print("Failed to find the tree node.")
            return
        }
        
        mashNode.scale = SCNVector3(x: 0.5, y: 0.5, z: 0.5)
        mashNode.position = SCNVector3(x: -2, y: -1, z: 1)
        mashNode.rotation = SCNVector4(1, 0, 0, -Float.pi / 2)
        scene.rootNode.addChildNode(mashNode)
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
        
        let cubeSize = Float(cubeSize) / 10
        
        characterNode.scale = SCNVector3(x: cubeSize, y: cubeSize, z: cubeSize)
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
