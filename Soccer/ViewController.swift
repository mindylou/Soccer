//
//  ViewController.swift
//  Soccer
//
//  Created by Mindy Lou on 11/21/16.
//  Copyright © 2016 Mindy Lou. All rights reserved.
//

import UIKit
import QuartzCore

enum state {
    case notYet
    case start
    case playing
    case over
}

class ViewController: UIViewController {
    var ball: UIButton!
    var updater: CADisplayLink!
    var xSpeed: CGFloat!
    var ySpeed: CGFloat!
    var gameState: state!
    var score: Int!
    var scoreTitleLabel: UILabel!
    var scoreNumberLabel: UILabel!
    var highScore: Int!
    var highScoreTitleLabel: UILabel!
    var highScoreNumberLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        gameState = .notYet
        
        view.backgroundColor = .white
        
        addSubviews()
        
    }
    
    func addSubviews() {
        updater = CADisplayLink(target: self, selector: #selector(update))
        updater.add(to: .current, forMode: .defaultRunLoopMode)
        
        xSpeed = 2
        ySpeed = 25
        
        score = 0
        scoreTitleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
        scoreTitleLabel.center.x = view.center.x
        scoreTitleLabel.center.y = scoreTitleLabel.frame.height * 4
        scoreTitleLabel.textAlignment = .center
        scoreTitleLabel.text = "Score"
        scoreTitleLabel.font = UIFont(name: "Helvetica Neue", size: 20)
        scoreTitleLabel.textColor = .gray
        
        view.addSubview(scoreTitleLabel)
        
        scoreNumberLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 70, height: 60))
        scoreNumberLabel.center.x = view.center.x
        scoreNumberLabel.center.y = scoreTitleLabel.center.y + 50
        scoreNumberLabel.textAlignment = .center
        scoreNumberLabel.text = String(score)
        scoreNumberLabel.textColor = .black
        scoreNumberLabel.font = UIFont(name: "Helvetica Neue", size: 60)
        
        view.addSubview(scoreNumberLabel)
        
        highScore = 0
        highScoreTitleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 80, height: 40))
        highScoreTitleLabel.center.x = view.frame.maxX - highScoreTitleLabel.frame.width/1.5
        highScoreTitleLabel.center.y = highScoreTitleLabel.frame.height
        highScoreTitleLabel.textAlignment = .center
        highScoreTitleLabel.text = "High Score"
        highScoreTitleLabel.font = UIFont(name: "Helvetica Neue", size: 15)
        highScoreTitleLabel.textColor = .gray
        
        view.addSubview(highScoreTitleLabel)
        
        highScoreNumberLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 70, height: 25))
        highScoreNumberLabel.center.x = highScoreTitleLabel.center.x
        highScoreNumberLabel.center.y = highScoreTitleLabel.center.y + highScoreNumberLabel.frame.height
        highScoreNumberLabel.textAlignment = .center
        highScoreNumberLabel.textColor = .black
        highScoreNumberLabel.text = String(highScore)
        highScoreNumberLabel.font = UIFont(name: "Helvetica Neue", size: 24)
        
        view.addSubview(highScoreNumberLabel)
        
        ball = UIButton(frame: CGRect(x: 0, y: 0, width: 70, height: 70))
        ball.center.x = view.center.x
        ball.center.y = view.frame.height - ball.frame.height
        ball.backgroundColor = UIColor.clear
        ball.setBackgroundImage(#imageLiteral(resourceName: "ball"), for: .normal)
        ball.clipsToBounds = true
        ball.layer.cornerRadius = 35
        ball.addTarget(self, action: #selector(ballTapped), for: .touchUpInside)
        
        view.addSubview(ball)
        
    }

    func update() {
        if gameState == .over {
            updater.isPaused = true
        }
        if gameState == .start {
            move()
            bounce()
            fall()
        }
    }
    
    func move() {
        ball.center.x = ball.center.x + xSpeed
        ball.center.y = ball.center.y + ySpeed
    }
    
    func fall() {
        // falling down
        ySpeed = ySpeed + 1
    }
    
    func bounce() {
        // bounce horizontally
        if (ball.center.x - ball.frame.width/2.0 < 0 || ball.center.x + ball.frame.width/2.0 > view.frame.width) {
            xSpeed = xSpeed * -1
        }
        // bounce vertically
        else if ball.center.y - ball.frame.width/2.0 < 0{
            ySpeed = ySpeed * -1
        }
        // stop bouncing if it touches the bottom
        else if ball.center.y + ball.frame.width/2.0 > view.frame.height {
            gameState = .over
            resetBall()
            setHighScore()
        }
    }
    
    func ballTapped() {
        if gameState == .over {
            resetSpeeds()
            updater.isPaused = false
            scoreNumberLabel.text = "0"
            score = 0
        }
        gameState = .start
        ySpeed = ySpeed * -1
        if xSpeed > 0 {
            xSpeed = CGFloat(arc4random_uniform(5))
        } else {
            xSpeed = -1 * CGFloat(arc4random_uniform(5))
        }
        
        self.score = score + 1
        self.scoreNumberLabel.text = String(self.score)

    }
    
    func resetSpeeds() {
        xSpeed = 2
        ySpeed = 25
    }
    
    func setHighScore() {
        if (score > highScore) {
            highScore = score
            highScoreNumberLabel.text = String(highScore)
        }
    }
    
    func resetBall() {
        UIView.animate(withDuration: 0.7) { 
            self.ball.center.x = self.view.center.x
            self.ball.center.y = self.view.frame.height - self.ball.frame.height
        }
    }
    
}

