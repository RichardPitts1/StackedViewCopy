//
//  StackElementViewController.swift
//  StackedViewPractice
//
//  Created by Richard E Pitts on 2/26/17.
//  Copyright © 2017 Richard E Pitts. All rights reserved.
//

import UIKit

class StackElementViewController: UIViewController {

    

    @IBOutlet weak var headerLabel: UILabel!
    
    @IBOutlet weak var topLabel: UITextView!

// NEW STUFF


    var topString: String? {
        didSet {
            configureView()
        }
    }
    
    func topView() {
        topLabel.text = topString
    }
    //END
    
    var headerString: String? {
        didSet {
            configureView()
        }
    }
    
    func configureView() {
        headerLabel.text = headerString
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    
    
}
