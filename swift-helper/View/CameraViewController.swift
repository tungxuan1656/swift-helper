//
//  CameraViewController.swift
//  swift-helper
//
//  Created by Tung Xuan on 3/25/21.
//

import UIKit

class CameraViewController: UIViewController {

	@IBOutlet weak var viewPreview: UIView!
	
	let cameraManager = CameraManager.init()
	
	override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		self.cameraManager.addPreviewLayerToView(self.viewPreview)
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

	@IBAction func onClickButtonRecord(_ sender: Any) {
		self.cameraManager.startRecordingVideo { (error) in
			print(error as Any)
		}
	}
	
	@IBAction func onClickButtonStopRecord(_ sender: Any) {
		self.cameraManager.stopRecordingVideo { (url) in
			if let url = url {
				print(url)
				self.presentVideo(url: url)
			}
		}
	}
	
	@IBAction func onClickButtonCapture(_ sender: Any) {
		self.cameraManager.capturePictureWithCompletion { (result) in
			switch result {
			case .failure(let error):
				print(error)
			case .success(content: let content):
				let image = content.asImage
				print(image?.size)
			}
		}
	}
}
