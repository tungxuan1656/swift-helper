//
//  TToast.swift
//  animation
//
//  Created by Tùng Xuân on 8/16/20.
//  Copyright © 2020 Tung Xuan. All rights reserved.
//

import UIKit

class TToast: UIViewController {
    
    @IBOutlet weak var viewTToastBottom: UIView!
    @IBOutlet weak var viewTToastTop: UIView!
    @IBOutlet weak var viewTToastCenter: UIView!
    @IBOutlet weak var labelTToastBottom: UILabel!
    @IBOutlet weak var labelTToastTop: UILabel!
    @IBOutlet weak var labelTToastCenter: UILabel!
    
    var style: TStyle = TStyle()
    var message = ""
    var timer: Timer? = nil
    var tTop = CGAffineTransform.identity
    var tCenter = CGAffineTransform.identity
    var tBottom = CGAffineTransform.identity
    var location: TLocation = .bottom
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setupUI()
        self.setupAnimation()
    }

    @IBAction func onClickButtonDismiss(_ sender: Any) {
        self.stopAnimation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.startAnimation()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func setupUI() {
        self.labelTToastBottom.text = self.message
        self.labelTToastTop.text = self.message
        self.labelTToastCenter.text = self.message
        
        self.viewTToastTop.layer.cornerRadius = style.cornerRadius
        self.viewTToastBottom.layer.cornerRadius = style.cornerRadius
        self.viewTToastCenter.layer.cornerRadius = style.cornerRadius
        self.viewTToastTop.backgroundColor = style.bgColor
        self.viewTToastCenter.backgroundColor = style.bgColor
        self.viewTToastBottom.backgroundColor = style.bgColor
        self.labelTToastTop.textColor = style.textColor
        self.labelTToastCenter.textColor = style.textColor
        self.labelTToastBottom.textColor = style.textColor
        self.labelTToastTop.font = style.fontTToast
        self.labelTToastCenter.font = style.fontTToast
        self.labelTToastBottom.font = style.fontTToast
        
        self.viewTToastCenter.isHidden = self.location != .center
        self.viewTToastTop.isHidden = self.location != .top
        self.viewTToastBottom.isHidden = self.location != .bottom
    }
    
    func setupAnimation() {
        if self.location == .top {
            self.tTop = self.tTop.translatedBy(x: 0, y: -120 - self.self.viewTToastCenter.frame.height)
            self.tTop = self.tTop.scaledBy(x: 0.5, y: 0.5)
        }
        if self.location == .center {
            self.tCenter = self.tCenter.scaledBy(x: 0.001, y: 0.001)
        }
        if self.location == .bottom {
            self.tBottom = self.tBottom.translatedBy(x: 0, y: 120 + self.viewTToastBottom.frame.height)
            self.tBottom = self.tBottom.scaledBy(x: 0.5, y: 0.5)
        }
        
        self.viewTToastCenter.transform = self.tCenter
        self.viewTToastBottom.transform = self.tBottom
        self.viewTToastTop.transform = self.tTop
    }
    
    func startAnimation() {
        UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.1, options: [], animations: {
            if self.location == .bottom {
                self.viewTToastBottom.transform = .identity
            }
            if self.location == .center {
                self.viewTToastCenter.transform = .identity
            }
            if self.location == .top {
                self.viewTToastTop.transform = .identity
            }
        }) { (b) in
            self.timer = Timer.scheduledTimer(withTimeInterval: self.style.duration - 0.5, repeats: false, block: { (timer) in
                self.stopAnimation()
            })
        }
    }
    
    func stopAnimation() {
        self.dismiss(animated: true, completion: nil)
        if let timer = self.timer {
            timer.invalidate()
        }
        self.timer = nil
        UIView.animate(withDuration: 0.25) {
            if self.location == .bottom {
                self.viewTToastBottom.transform = self.tBottom
            }
            if self.location == .center  {
                self.viewTToastCenter.transform = self.tCenter
            }
            if self.location == .top {
                self.viewTToastTop.transform = self.tTop
            }
        }
    }
    
    static func show(_ viewController: UIViewController, message: String, location: TLocation = .center, style: TStyle = TStyle()) {
        let toast = TToast(nibName: "TToast", bundle: nil)
        toast.modalPresentationStyle = .overFullScreen
        toast.modalTransitionStyle = .crossDissolve
        toast.message = message
        toast.location = location
        toast.style = style
        viewController.present(toast, animated: true, completion: nil)
    }
    
    static func show(_ viewController: UIViewController, message: String, location: TLocation) {
        let toast = TToast(nibName: "TToast", bundle: nil)
        toast.modalPresentationStyle = .overFullScreen
        toast.modalTransitionStyle = .crossDissolve
        toast.message = message
        toast.location = location
        toast.style = TStyle()
        viewController.present(toast, animated: true, completion: nil)
    }
    
    enum TLocation {
        case center
        case bottom
        case top
    }

    struct TStyle {
        var fontTToast: UIFont = .systemFont(ofSize: 14, weight: .medium)
        var textColor: UIColor = UIColor(red: 66/255, green: 85/255, blue: 102/255, alpha: 1.0)
        var bgColor: UIColor = UIColor.white
        var cornerRadius: CGFloat = 18
        var duration: TimeInterval = 2
    }

}

