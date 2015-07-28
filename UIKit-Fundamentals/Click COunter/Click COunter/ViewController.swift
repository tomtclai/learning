//
//  ViewController.swift
//  Click Counter
//
//  Created by Tom Lai on 7/28/15.
//  Copyright (c) 2015 Tom. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var count = 0
    @IBOutlet var label:UILabel! // ! means optional, can be nil at compile time

    override func viewDidLoad() {
        super.viewDidLoad()

        /*
        // Label
        var label = UILabel()
        label.frame = CGRectMake(150, 150, 60, 60)
        label.text = "0"

        self.view.addSubview(label)
        self.label = label

        // addButton
        var addButton = UIButton()
        addButton.frame = CGRectMake(150, 250, 60, 60)
        addButton.setTitle("+", forState: .Normal)
        addButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
        self.view.addSubview(addButton)

        addButton.addTarget(self, action: "incrementCount", forControlEvents: UIControlEvents.TouchUpInside)


        // minusButton
        var minusButton = UIButton()
        minusButton.frame = CGRectMake(220, 250, 60, 60)
        minusButton.setTitle("-", forState: .Normal)
        minusButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
        self.view.addSubview(minusButton)

        minusButton.addTarget(self, action: "decrementCount", forControlEvents: UIControlEvents.TouchUpInside)
        */
    }

    func incrementCount() {
        self.count++
        updateLabel()
        setRandomBackgroundColor()
    }

    func decrementCount() {
        self.count--
        updateLabel()
        setRandomBackgroundColor()
    }
    
    func updateLabel() {
        self.label.text = "\(self.count)"
    }
    
    func setRandomBackgroundColor() {
        self.view.backgroundColor = getRandomColor()
    }
    
    func getRandomColor() -> UIColor {
        var randomR:CGFloat = CGFloat(drand48())
        var randomG:CGFloat = CGFloat(drand48())
        var randomB:CGFloat = CGFloat(drand48())
        
        return UIColor(red: randomB, green: randomG, blue: randomB, alpha: 1.0)
    }

}
