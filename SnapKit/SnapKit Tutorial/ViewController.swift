//
//  ViewController.swift
//  SnapKit Tutorial
//
//  Created by Malek T. on 7/9/15.
//  Copyright (c) 2015 Medigarage Studios LTD. All rights reserved.
//

import UIKit
import SnapKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //1 : Here you just made three views with some background color to better visualise their frames when running the project, and you add them as subviews to the root view.
        let topView = UIView()
        let bottomLeftView = UIView()
        let bottomRightView = UIView()
        
        self.view.addSubview(topView)
        self.view.addSubview(bottomLeftView)
        self.view.addSubview(bottomRightView)
        
        //2 : Starting by the top view, you basically asked SnapKit to set its top, left and right spacing to 0 so that the view will always stick to the top of the screen and never cross the left and right boundaries of the screen.
        // Also, you set up an equality relation between the height of the top view and the height of the root view (the screen). This relation imposes that the height of the top view will always be the half of the root view height. This way, you will ensure the top view is always filling exactly 50% of the screen, regardless of the screen size and orientation.
        topView.snp_makeConstraints { (make) in
            make.top.left.right.equalTo(0)
            make.height.equalTo(self.view.snp_height).multipliedBy(0.5)
        }
        //3 : For the bottomLeftView, you set its left and bottom spacing constraints to 0, and its height and width to be calculated as the half of the root view. This way, the bottomLeftView will always fill the 25% of the screen located in the bottom left
        bottomLeftView.snp_makeConstraints { (make) in
            make.left.bottom.equalTo(0)
            make.height.equalTo(self.view.snp_height).multipliedBy(0.5) // why not just use * for multiplication?
            make.width.equalTo(self.view.snp_width).multipliedBy(0.5)
        }
        //4 : This is basically the same logic as for the previous bottomLeftView, except that you set the constraints to align it on the bottom right 25% of the screen.
        bottomRightView.snp_makeConstraints { (make) in
            make.bottom.right.equalTo(0)
            make.height.equalTo(self.view.snp_height).multipliedBy(0.5)
            make.width.equalTo(self.view.snp_width).multipliedBy(0.5)
        }
        
        let logo = UIImageView(image: UIImage(named: "logo"))
        topView.addSubview(logo)
        logo.snp_makeConstraints { (make) in
            make.center.equalTo(topView.center)
            make.width.equalTo(100)
            make.height.equalTo(110)
        }
        
        let tutorialsButton = UIButton()
        styleButton(tutorialsButton, title: "Tutorials")
        bottomLeftView.addSubview(tutorialsButton)
        
        tutorialsButton.snp_makeConstraints { (make) in
            make.center.equalTo(bottomLeftView.center)
            make.width.equalTo(100)
            make.height.equalTo(25)
        }
        
        let quizButton = UIButton()
        styleButton(quizButton, title: "Quiz")
        bottomRightView.addSubview(quizButton)
        quizButton.snp_makeConstraints { (make) in
            make.center.equalTo(bottomRightView.center)
            make.width.equalTo(100)
            make.height.equalTo(25)
        }
    }
    
    func styleButton(button: UIButton, title:String) {
        button.setTitle(title, forState: UIControlState.Normal)
        button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        button.backgroundColor = UIColor.redColor()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

