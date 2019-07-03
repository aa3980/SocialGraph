//
//  ViewController.swift
//  WeightedGraph
//
//  Created by Ajit Akole on 6/12/19.
//  Copyright © 2019 Ajit Akole. All rights reserved.
//

import UIKit
import SwiftGraph
import FBSDKLoginKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let loginButton = FBLoginButton(frame: CGRect(x : 0, y : 0, width:  self.view.bounds.size.width / 4, height : self.view.bounds.size.height / 10))
        loginButton.center = CGPoint(x:self.view.center.x, y:self.view.center.y/2);
        loginButton.permissions = ["public_profile", "email"]
        
        let background = UIImageView(frame: CGRect(x:0,y:0,width:self.view.bounds.size.width, height:self.view.bounds.size.height))
        background.image = UIImage(contentsOfFile: "example.png")
        self.view.addSubview(background);
        self.view.addSubview(loginButton);
        if ((AccessToken.current) != nil) {
            background.removeFromSuperview();
            let graph = createGraph()
            drawGraph(for: graph)
        }
    }

    func createGraph() -> WeightedGraph<String, Int>{
        let cityGraph: WeightedGraph<String, Int> = WeightedGraph<String, Int>(vertices: ["Seattle", "San Francisco", "Los Angeles", "Denver", "Kansas City", "Chicago", "Boston", "New York", "Dallas"])
        cityGraph.addEdge(from: "Seattle", to:"Chicago", weight:2097)
        cityGraph.addEdge(from: "Seattle", to:"Boston", weight:2500)
        cityGraph.addEdge(from: "Seattle", to: "Denver", weight:1331)
        cityGraph.addEdge(from: "Seattle", to: "San Francisco", weight:807)
        cityGraph.addEdge(from: "Seattle", to: "Dallas", weight:1267)
        cityGraph.addEdge(from: "Seattle", to: "Los Angeles", weight:1100)
        cityGraph.addEdge(from: "Seattle", to: "New York", weight:3000)
        cityGraph.addEdge(from: "Seattle", to: "Kansas City", weight:1800)
        return cityGraph
    }
    
    func drawGraph(for graph: WeightedGraph<String, Int>) {
        var center = graph[0]
        let vheight = Int(self.view.bounds.height)
        let vwidth = Int(self.view.bounds.width)
        
       
        let degreeIncrement = 360 / graph.vertexCount
        var startDegree = 0;
        let centerX = vwidth / 2;
        let centerY = vheight / 2
        for i in (1 ..< graph.edgeCount / 2 + 1).shuffled() {
            let tempFrame = CGRect(x : 0, y : 0, width: vwidth / 10, height : vwidth / 10)
            let aLabel = UILabel(frame: tempFrame)
            aLabel.center = CGPoint.init(x:Int(Double(graph.edges[i][0].weight) / 15 * cos(Double(startDegree))) + centerX, y:centerY - Int(Double(graph.edges[i][0].weight) / 10 * sin(Double(startDegree))))
            aLabel.backgroundColor = UIColor.red
            aLabel.layer.cornerRadius = aLabel.frame.width / 2
            aLabel.layer.masksToBounds = true
            aLabel.text = graph.vertices[graph.edges[i][0].u]
            self.view.addSubview(aLabel)
            startDegree = startDegree + degreeIncrement
            addLine(fromPoint: CGPoint(x: centerX, y: centerY), toPoint: aLabel.center)
        }
        let tempFrame = CGRect(x : 0, y : 0, width: vwidth / 7, height : vwidth / 7)
        let aLabel = UILabel(frame: tempFrame)
        aLabel.center = CGPoint.init(x:Int(Double(centerX)), y:centerY )
        aLabel.backgroundColor = UIColor.blue
        aLabel.layer.cornerRadius = aLabel.frame.width / 2
        aLabel.layer.masksToBounds = true
        aLabel.text = graph.vertices[0]
        self.view.addSubview(aLabel)
    }
    
    func addLine(fromPoint start: CGPoint, toPoint end:CGPoint) {
        let line = CAShapeLayer()
        let linePath = UIBezierPath()
        linePath.move(to: start)
        linePath.addLine(to: end)
        line.path = linePath.cgPath
        line.strokeColor = UIColor.red.cgColor
        line.lineWidth = 1
        line.lineJoin = CAShapeLayerLineJoin.round
        self.view.layer.addSublayer(line)
    }
    

}

