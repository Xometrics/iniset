
//
//  ViewController.swift
//  SnakeGame-MachineLearning-
//
//  Created by Edward O'Neill on 12/9/19.
//  Copyright © 2019 Edward O'Neill. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var cellCollection = [CustomCell]()
    var count = 0
    var cellCount = 0
    var averageScore = [Int]()
    var sponeRed = 1
    var gameTimer: Timer?
    var snakeArr = [CustomCell]()
    var pixelSet: Set<Int> = []
    var rightEdgeNumbers: Set<Int> = [16, 33, 50, 67, 84, 101, 118, 135, 152, 169, 186, 203, 220, 237, 254, 271, 288, 305]
    var leftEdgeNumber: Set<Int> = [0, 17, 34, 51, 68, 85, 102, 119, 136, 153, 170, 187, 204, 221, 238, 255, 272, 289]
    var topRowNumber: Set<Int> =  [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16]
    var bottomRowNumber: Set<Int> = [289, 290, 291, 292, 293, 294, 295, 296, 297, 298, 299, 300, 301, 302, 303, 304, 305]
    var failierPattern: Set<[Int]> = LearningData.data
    var currentPattern = [Int]()
    
    fileprivate let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0.5
        layout.minimumInteritemSpacing = 0.5
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(CustomCell.self, forCellWithReuseIdentifier: "cell")
        return cv
    }()
    
    let button: UIButton = {
        let frame = CGRect(x: 140, y: 500, width: 100, height: 50)
        let button = UIButton(type: .system)
        button.frame = frame
        button.setTitle("Start", for: .normal)
        button.addTarget(self, action: #selector(startGame), for: .touchUpInside)
        
        return button
    }()
    
    @objc func startGame(sender : UIButton) {
        //cellCollection = cellCollection.sorted(by: { $0.tag > $1.tag })
        if button.titleLabel?.text == "Start" {
            count = 0
            button.setTitle("Reset", for: .normal)
            gameTimer = Timer.scheduledTimer(timeInterval: 0.00001, target: self, selector: #selector(createBoard), userInfo: nil, repeats: true)
        } else {
            for pixel in cellCollection {
                pixel.backgroundColor = .white
            }
            snakeArr = []
            cellCount = 0
            print(averageScore.reduce(0, +) / averageScore.count)
            print(averageScore)
            button.setTitle("Start", for: .normal)
            gameTimer?.invalidate()
        }
        
    }
    
    @objc func createBoard() {
        
        cellCollection[cellCount].backgroundColor = .black
        cellCount += 1
        
        if cellCount == 306 {
            gameTimer?.invalidate()
//            for _ in 0..<10 {
//                cellCollection.randomElement()?.backgroundColor = .red
//            }
            let startingPoint = cellCollection.randomElement()!
            startingPoint.backgroundColor = .green
            snakeArr.append(startingPoint)
            gameTimer = Timer.scheduledTimer(timeInterval: 0.025, target: self, selector: #selector(startMoving), userInfo: nil, repeats: true)
        }
    }
    
    @objc func startMoving() {
        moveSnake()