//
//  StackElementViewController2.swift
//  StackedViewPracticeImportant
//
//  Created by Richard E Pitts on 3/9/17.
//  Copyright © 2017 Richard E Pitts. All rights reserved.
//

import UIKit

class StackElementViewController2: UIViewController {
    
    
    // IS THIS REFERENCING SOMETHING FROM ANOTHER SOURCE CODE FILE??!!
    @IBOutlet weak var headerLabel: UILabel!
    
    @IBOutlet weak var topLabel: UITextView!
    
    // NEW STUFF
    
    
    var topString2: String? {
        didSet {
            configureView()
        }
    }
    
    func topView() {
        topLabel.text = topString2
    }
    //END
    
    var headerString2: String? {
        didSet {
            configureView()
        }
    }
    
    func configureView() {
        headerLabel.text = headerString2
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    
    
    
}
