//
//  ViewController.swift
//  swift-helper
//
//  Created by Tung Xuan on 3/23/21.
//

import UIKit

class ViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		let vc = CameraViewController(nibName: "CameraViewController", bundle: nil)
		vc.modalPresentationStyle = .fullScreen
		self.present(vc, animated: true, completion: nil)
	}
}

