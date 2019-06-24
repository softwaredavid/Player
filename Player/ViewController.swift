//
//  ViewController.swift
//  Player
//
//  Created by MAc on 2019/6/10.
//  Copyright © 2019年 MAc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let btn = UIButton(type: .custom)
        btn.frame = CGRect(x: 100, y: 100, width: 50, height: 50)
        btn.backgroundColor = UIColor.red
        btn.addTarget(self, action: #selector(btnC), for: .touchUpInside)
        view.addSubview(btn)
    }

    @objc func btnC() {
        let vc = ZFCustomControlViewViewController()
        present(vc, animated: true, completion: nil)
    }
}

