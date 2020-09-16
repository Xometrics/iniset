# SnakeGame-MachineLearning-

## Description
A conceptual take on the classic game, Snake, that incorporates a custom AI growing mechanism that will move the snake randomly and continuously learn how to improve chances of survival over time.
- Deployed using Swift in order to create a self-sustaining AI system capable of machine learning.
- Created a custom animation by coding a timer to keep the snake moving  seamlessly.
- The MachineLearning method I wrote will track the current length of the snake and will store the data when the snake dies(gets trapped)
- Not like the actual game the snake will increes it's size by one every 10 movement until it can't move anymore

![SnakeGame-MachineLearningGIF](https://user-images.githubusercontent.com/42211866/71905634-8a821f80-3136-11ea-8792-7896339eda18.gif)

## Challenges
- The most challenging part of this project was to build a method to learn from it's mistake and not take the same move from the next time.
- the code below is mostly about the possible movement for the snake but moving the body to the direction the head moved was pretty challenging as well

```swift
    func moveSnake() {
        var movablePixel = false
        var randomMovement: Set<Int> = possibleMove()
        var movingDirection = 0
        while movablePixel == false {
            movingDirection = randomMovement.remove(randomMovement.randomElement()!)!
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