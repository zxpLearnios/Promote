//
//  PTTestPushOrPresentViewController.swift
//  Promote
//
//  Created by 张净南 on 2018/7/25.
//  要想在任何地方弹出、退出

import UIKit

class PTTestPushOrPresentViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let label = PTTapLabel(with: .black, fontSize: 20)
        label.text = "测试回调"
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if responds(to: #selector(dismiss(animated:completion:))) {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    

}
