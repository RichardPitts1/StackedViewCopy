//
//  ViewController.swift
//  StackedViewPractice
//
//  Created by Richard E Pitts on 2/26/17.
//  Copyright © 2017 Richard E Pitts. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollisionBehaviorDelegate {
    
    /* ULTIMATE GOALS:
            I NEED TO FIGURE OUT HOW TO MANIPULATE WHAT IS IN THE TEXT FIELDS AND HOW TO HAVE DIFFERENT VIEWS HAVE DIFFERENT BUTTONS, ETC.  FROM THERE I CAN START FINISHING OFF THE COMPONENTS OF THE PROJECT AND THEN ULTIMATELY START WORKING ON THE WORKOUTS PORTION OF THE APPLICATION.  THAT PART TAKES THE MOST THINKING EVEN THOUGH ALL I REALLY HAVE TO DO IS GROUP THE SETS FOR A GIVEN MUSCLE IN UNITS OF 4 SETS/EXERCISE THEN HAVE A RANDOM GENERATOR TO FIGHT NATURE WITH HER OWN FORCES 
 
                */
    
    
    @IBOutlet weak var myImageView: UIImageView!
    
    let data = ["a bunch of nonsense", "a lot more nonsense", "Nonsense too", "Another TextField", "Extras"]
    
    let data2 = ["Tidftleasd1"]
    
    
    var views = [UIView]()
    var animator:UIDynamicAnimator!
    var gravity:UIGravityBehavior!
    var snap:UISnapBehavior!
    var previousTouchPoint:CGPoint!
    var viewDragging = false
    var viewPinned = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        animator = UIDynamicAnimator(referenceView: self.view)
        gravity = UIGravityBehavior()
        
        animator.addBehavior(gravity)
        gravity.magnitude = 1
        
        // This mediates the height of the files, a value below 200 puts them far too low on the screen, 400 too high...
        var offset:CGFloat = 250
        
        // This mediates the number of child view controllers you have, you add to the array referenced to add more...
                    // Offset is the space between the files.  A value of 50 is pretty standard.  75 makes a lil too much space
        for i in 0 ... data2.count - 1 {
            if let view = addViewController(atOffset: offset, dataForVC: data2[i] as AnyObject?) {
                views.append(view)
                offset -= 66
              
            }
        }
        
    }
    // THE SOLUTION HAS TO LIE WITHIN HERE, THIS IS THE ONLY PLACE STACKELEMENTVIEWCONTROLLER IS REFERENCED...
    func addViewController (atOffset offset:CGFloat, dataForVC data:AnyObject?) -> UIView? {
        let frameForView = self.view.bounds.offsetBy(dx: 0, dy: self.view.bounds.size.height - offset)
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let stackElementVC = sb.instantiateViewController(withIdentifier: "StackElement") as! StackElementViewController
        
        //Well this is obviously just shadow coloring...
        if let view = stackElementVC.view {
            view.frame = frameForView
            view.layer.cornerRadius = 34
            //You need to consider these 4 adjustments to create a drop shadow
            view.layer.shadowOffset = CGSize(width: -9, height: -3)
            view.layer.shadowColor = UIColor.black.cgColor
            view.layer.shadowRadius = 22
            view.layer.shadowOpacity = 1
        
            
            
            if let headerStr = data as? String {
                stackElementVC.headerString = headerStr
            }
            if let topStr = data as? String {
                stackElementVC.topString = topStr
            }
            self.addChildViewController(stackElementVC)
            self.view.addSubview(view)
            stackElementVC.didMove(toParentViewController: self)
            
            let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(ViewController.handlePan(gestureRecognizer:)))
            view.addGestureRecognizer(panGestureRecognizer)
            
            
            
            let collision = UICollisionBehavior(items: [view])
            collision.collisionDelegate = self
            animator.addBehavior(collision)
 
            
            
            // lower boundary
            let boundary = view.frame.origin.y + view.frame.size.height
            var boundaryStart = CGPoint(x: 0, y: boundary)
            var boundaryEnd = CGPoint(x: self.view.bounds.size.width + 100, y: boundary)
            collision.addBoundary(withIdentifier: 1 as NSCopying, from: boundaryStart, to: boundaryEnd)
            
            // upper boundary
            boundaryStart = CGPoint(x: 0, y: 0)
            boundaryEnd = CGPoint(x: self.view.bounds.size.width, y: 0)
            collision.addBoundary(withIdentifier: 2 as NSCopying, from: boundaryStart, to: boundaryEnd)
            
            gravity.addItem(view)
            
            let itemBehavior = UIDynamicItemBehavior(items: [view])
            animator.addBehavior(itemBehavior)
            
            return view
        }
        return nil
        
    }
    
    func handlePan(gestureRecognizer: UIPanGestureRecognizer) {
        
        let touchPoint = gestureRecognizer.location(in: self.view)
        let draggedView = gestureRecognizer.view!
        
        if gestureRecognizer.state == .began {
            let dragStartPoint = gestureRecognizer.location(in: draggedView)
            
            if dragStartPoint.y < 500 {
                viewDragging = true
                previousTouchPoint = touchPoint
            }
        } else if gestureRecognizer.state == .changed && viewDragging {
            let yOffset = previousTouchPoint.y - touchPoint.y
            
            draggedView.center = CGPoint(x: draggedView.center.x, y: draggedView.center.y - yOffset)
            previousTouchPoint = touchPoint
        } else if gestureRecognizer.state == .ended && viewDragging {
            
            pin(view: draggedView)
            
           addVelocity(toView: draggedView, fromGestureRecognizer: gestureRecognizer)
            
            animator.updateItem(usingCurrentState: draggedView)
            viewDragging = false
        }
        
        
    }
    
    func pin (view: UIView) {
        
        //This value below reflects how much the view will shoot up to the pin location.  100 is standard.
        let viewHasReachedPinLocation = view.frame.origin.y < 200
        if viewHasReachedPinLocation {
            if !viewPinned {
                var snapPosition = self.view.center
                // The Value below adjusts how high up the folders go.  A bigger value makes it lock at a lower position.
                snapPosition.y += 150
                
                snap = UISnapBehavior(item: view, snapTo: snapPosition)
                animator.addBehavior(snap)
                
                //setOpacity
                
                viewPinned = true
            }
        }else{
            if viewPinned {
                animator.removeBehavior(snap)
                setVisibility(view: view, alpha: 1)
                viewPinned = false
            }
        }
        
    }
    
    // Doesnt Mean Shit...
    func setVisibility(view:UIView, alpha:CGFloat) {
        for aView in views {
            if aView != view {
                aView.alpha = alpha
            }
        }
    }
    
    //This adds velocity to the views when they are tossed up
    func addVelocity(toView view:UIView, fromGestureRecognizer panGesture:UIPanGestureRecognizer) {
        var velocity = panGesture.velocity(in: self.view)
        
        //IMPORTANT :  Negative = The view floats to the left...Positive it floats to the right.  Default is 0
        velocity.x = 0
        
        if let behavior = itemBehavior(forView: view) {
            behavior.addLinearVelocity(velocity, for: view)
            
            //Maybe you could create a if statement that corrects any velocity left or right?
        }}
        
    
    
    
    func itemBehavior (forView view:UIView) -> UIDynamicItemBehavior? {
        for behavior in animator.behaviors {
            if let itemBehavior = behavior as? UIDynamicItemBehavior {
                if let possibleView = itemBehavior.items.first as? UIView, possibleView == view {
                    return itemBehavior
                }
            }
        }
        
        return nil
    }
    
    func collisionBehavior(_ behavior: UICollisionBehavior, beganContactFor item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?, at p: CGPoint) {
        
        
        if NSNumber(integerLiteral: 0).isEqual(identifier) {
            let view = item as! UIView
            pin(view: view)
        }}
        
    /*     applyMotionEffect(toView: myImageView, magnitude: 6)
    }
    

    
    func applyMotionEffect (toView view: UIView, magnitude:Float) {
        let xMotion = UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
        xMotion.minimumRelativeValue = -magnitude
        xMotion.maximumRelativeValue = magnitude
        
        let yMotion = UIInterpolatingMotionEffect(keyPath: "center.y", type: .tiltAlongVerticalAxis)
        yMotion.minimumRelativeValue = -magnitude
        yMotion.maximumRelativeValue = magnitude
        
        let group = UIMotionEffectGroup()
        group.motionEffects = [xMotion, yMotion]
        
        view.addMotionEffect(group)
    }
    
        
        
  */
    
    
    
    
}


