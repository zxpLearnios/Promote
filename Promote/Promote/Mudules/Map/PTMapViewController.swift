//
//  PTMapViewController.swift
//  Promote
//
//  Created by bava on 2020/9/15.
//

import UIKit
import MapKit
import SnapKit


class PTMapViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.gray
        
        let mapView = MKMapView()
        mapView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.left.right.equalTo(0)
        }
        
        view.addSubview(mapView)
        
        
        
    }
    


}
