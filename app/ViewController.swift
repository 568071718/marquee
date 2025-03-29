//
//  ViewController.swift
//  app
//
//  Created by ooc on 2025/3/23.
//

import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        demo1()
        demo2()
        demo3()
        demo4()
        demo5()
        demo6()
        
        let label = UILabel()
        label.text = "Pause / Resume"
        view.addSubview(label)
        label.sizeToFit()
        
        var frame = label.frame
        frame.origin.y = 450
        frame.origin.x = (view.frame.width - frame.width) * 0.5
        label.frame = frame
    }
    
    func demo1() {
        let label = UILabel()
        label.text = "🚀 This is a marquee text"
        
        let marquee = Marquee(frame: CGRect(x: 0, y: 100, width: view.frame.width, height: 44.0))
        marquee.backgroundColor = .brown
        marquee.content = label
        view.addSubview(marquee)
    }
    
    func demo2() {
        let label = UILabel()
        label.text = "🚀 This is a marquee text"
        
        let marquee = Marquee(frame: CGRect(x: 0, y: 150, width: view.frame.width, height: 44.0))
        marquee.backgroundColor = .brown
        marquee.content = label
        marquee.contentAlignment = .center
        view.addSubview(marquee)
    }
    
    func demo3() {
        let label = UILabel()
        label.text = "🚀 This is a marquee text"
        
        let marquee = Marquee(frame: CGRect(x: 0, y: 200, width: view.frame.width, height: 44.0))
        marquee.content = label
        marquee.mode = .cycle(force: true)
        marquee.backgroundColor = .brown
        view.addSubview(marquee)
    }
    
    func demo4() {
        let label = UILabel()
        label.text = "🚀 This is a marquee text"
        
        let marquee = Marquee(frame: CGRect(x: 0, y: 250, width: view.frame.width, height: 44.0))
        marquee.content = label
        marquee.mode = .cycle(force: true)
        marquee.direction = .right
        marquee.backgroundColor = .brown
        view.addSubview(marquee)
    }
    
    func demo5() {
        let label = UILabel()
        label.text = "🚀 A custom UIView that implements a marquee effect. This is a marquee text."
        
        let marquee = Marquee(frame: CGRect(x: 0, y: 300, width: view.frame.width, height: 44.0))
        marquee.content = label
        marquee.mode = .cycle(force: false)
        marquee.backgroundColor = .brown
        view.addSubview(marquee)
    }
    
    func demo6() {
        let label = UILabel()
        label.text = "🚀 A custom UIView that implements a marquee effect. This is a marquee text."
        
        let marquee = Marquee(frame: CGRect(x: 0, y: 350, width: view.frame.width, height: 44.0))
        marquee.content = label
        marquee.mode = .single(isReverse: true, isRepeat: true)
//        marquee.mode = .single(isReverse: true, isRepeat: false)
//        marquee.mode = .single(isReverse: false, isRepeat: false)
        marquee.backgroundColor = .brown
        view.addSubview(marquee)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for view in view.subviews {
            if let marquee = view as? Marquee {
                marquee.pause = !marquee.pause
            }
        }
    }
}
