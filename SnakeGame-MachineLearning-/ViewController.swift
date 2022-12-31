
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
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(button)
        view.addSubview(collectionView)
        view.backgroundColor = .white
        collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        collectionView.heightAnchor.constraint(equalTo: view.widthAnchor, constant: 20).isActive = true
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
}

extension ViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let viewWidth = view.frame.width
        let size = CGSize(width: (viewWidth/20), height: (viewWidth/20))
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 306
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomCell
        //        cell.data = self.data[indexPath.row]
        cell.backgroundColor = .white
        cell.tag = count
        cellCollection.append(cell)
        count += 1
        
        return cell
    }
}

// MARK: movement for the snake
extension ViewController {
    func moveSnake() {
        var movablePixel = false
        var randomMovement: Set<Int> = possibleMove()
        var movingDirection = 0
        while movablePixel == false {
            movingDirection = randomMovement.remove(randomMovement.randomElement()!)!
            //if snakeBodyPixel(movementNumber: movingDirection, tagNumber: snakeArr.last!.tag) {
                addToCurrentMovingPattern(movingDirection)
            if currentPattern.count >= 4 && failierPattern.contains(currentPattern) && !randomMovement.isEmpty {
                    print("patern changed")
                    continue
                } else {
                    movablePixel = true
                }
            }
        
        if movablePixel == true {
            if sponeRed >= 20 {
                cellCollection[(snakeArr[snakeArr.count - 1].tag) + (movingDirection)].backgroundColor = .blue
                snakeArr.last!.backgroundColor = .green
                snakeArr.append(cellCollection[(snakeArr[snakeArr.count - 1].tag) + (movingDirection)])
                sponeRed = 1
            } else {
                for (index, pixel) in snakeArr.enumerated() where cellCollection[(snakeArr[snakeArr.count - 1].tag) + (movingDirection)].backgroundColor != .red {
                    if index == 0 && snakeArr.count > 1 {
                        snakeArr[index].backgroundColor = .black
                        snakeArr[index] = snakeArr[index + 1]
                        snakeArr[index].backgroundColor = .green
                    } else if snakeArr.count == 1{
                        snakeArr[index].backgroundColor = .black
                        snakeArr[index] = cellCollection[(pixel.tag) + (movingDirection)]
                        snakeArr[index].backgroundColor = .green
                    } else if pixel != snakeArr.last {
                        snakeArr[index] = snakeArr[index + 1]
                        snakeArr[index].backgroundColor = .green
                    } else {
                        snakeArr[index] = cellCollection[(pixel.tag) + (movingDirection)]
                        snakeArr[index].backgroundColor = .blue
                    }
                }
            }
            sponeRed += 1
        }
  
//        print(failierPattern)
//        print(currentPattern)
//        print("===============================")
        
        if possibleMove().isEmpty {
            learn()
        }
    }
    
    func learn() {
        gameTimer?.invalidate()
        failierPattern.insert(currentPattern)
        averageScore.append(currentPattern.count)
        currentPattern = []
        
        for cell in cellCollection {
            if cell.backgroundColor == .black {
                cellCount = 0
                count = 0
                snakeArr = []
                pixelSet = []
                print("+++++++++++")
                print("dead end")
                print("+++++++++++")
                gameTimer = Timer.scheduledTimer(timeInterval: 0.0005, target: self, selector: #selector(createBoard), userInfo: nil, repeats: true)
                return
            }
        }
        print("The snake was completed")
    }
    
    func possibleMove() -> Set<Int> {
        var number: Set<Int> = [1, -1, 17, -17]
        var result = Set<Int>()
        while !number.isEmpty {
            let randomNum = number.remove(number.randomElement()!)!
            if snakeBodyPixel(movementNumber: randomNum, tagNumber: snakeArr.last!.tag) {
                result.insert(randomNum)
            }
        }
        return result
    }
    
    func addToCurrentMovingPattern(_ movingDirection: Int) {
        if currentPattern.count < snakeArr.count * 2 {
            currentPattern.append(movingDirection)
            currentPattern.append(snakeArr[snakeArr.count - 1].tag)
        } else {
            for num in 0..<currentPattern.count - 1 where num < currentPattern.count - 2 {
                currentPattern[num] = currentPattern[num + 2]
            }
            currentPattern[currentPattern.count - 2] = movingDirection
            currentPattern[currentPattern.count - 1] = snakeArr[snakeArr.count - 1].tag
        }
    }
    
    func snakeBodyPixel(movementNumber: Int, tagNumber: Int) -> Bool {
        let number = movementNumber + tagNumber
        pixelSet = []
        for snakePixel in snakeArr {
            pixelSet.insert(snakePixel.tag)
        }
        if (movementNumber == 1 && !rightEdgeNumbers.contains(tagNumber)) && !pixelSet.contains(number) || (movementNumber == -1 && !leftEdgeNumber.contains(tagNumber)) && !pixelSet.contains(number) ||  (!topRowNumber.contains(tagNumber) && movementNumber == -17) && !pixelSet.contains(number) || (!bottomRowNumber.contains(tagNumber) && movementNumber == 17 && !pixelSet.contains(number)) {
            return true
        }
        
        return false
    }
    
    func sponeFood() {
        var emptySpots = Set(cellCollection)
        
        for _ in 0..<cellCollection.count {
            let pixel = emptySpots.remove(emptySpots.randomElement()!)
            if !pixelSet.contains(pixel!.tag) && pixel?.backgroundColor != .red {
                pixel?.backgroundColor = .red
                break
            }
        }
    }
}


/*
 [  0,   1,   2,   3,   4,   5,   6,   7,   8,   9,  10,  11,  12,  13,  14,  15,  16]
 [ 17,  18,  19,  20,  21,  22,  23,  24,  25,  26,  27,  28,  29,  30,  31,  32,  33]
 [ 34,  35,  36,  37,  38,  39,  40,  41,  42,  43,  44,  45,  46,  47,  48,  49,  50]
 [ 51,  52,  53,  54,  55,  56,  57,  58,  59,  60,  61,  62,  63,  64,  65,  66,  67]
 [ 68,  69,  70,  71,  72,  73,  74,  75,  76,  77,  78,  79,  80,  81,  82,  83,  84]
 [ 85,  86,  87,  88,  89,  90,  91,  92,  93,  94,  95,  96,  97,  98,  99, 100, 101]
 [102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118]
 [119, 120, 121, 122, 123, 124, 125, 126, 127, 128, 129, 130, 131, 132, 133, 134, 135]
 [136, 137, 138, 139, 140, 141, 142, 143, 144, 145, 146, 147, 148, 149, 150, 151, 152]
 [153, 154, 155, 156, 157, 158, 159, 160, 161, 162, 163, 164, 165, 166, 167, 168, 169]
 [170, 171, 172, 173, 174, 175, 176, 177, 178, 179, 180, 181, 182, 183, 184, 185, 186]
 [187, 188, 189, 190, 191, 192, 193, 194, 195, 196, 197, 198, 199, 200, 201, 202, 203]
 [204, 205, 206, 207, 208, 209, 210, 211, 212, 213, 214, 215, 216, 217, 218, 219, 220]
 [221, 222, 223, 224, 225, 226, 227, 228, 229, 230, 231, 232, 233, 234, 235, 236, 237]
 [238, 239, 240, 241, 242, 243, 244, 245, 246, 247, 248, 249, 250, 251, 252, 253, 254]
 [255, 256, 257, 258, 259, 260, 261, 262, 263, 264, 265, 266, 267, 268, 269, 270, 271]
 [272, 273, 274, 275, 276, 277, 278, 279, 280, 281, 282, 283, 284, 285, 286, 287, 288]
 [289, 290, 291, 292, 293, 294, 295, 296, 297, 298, 299, 300, 301, 302, 303, 304, 305]
 */