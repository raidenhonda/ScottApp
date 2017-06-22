//
//  SignatureViewController.swift
//  Scott
//
//  Created by Raiden Honda on 27/10/16.
//  Copyright © 2016 Beloved Robot. All rights reserved.
//

import UIKit

class SignatureViewController: UIViewController {

    
    @IBOutlet weak var jobNameLbl: UILabel!
    @IBOutlet weak var jobIdLbl: UILabel! {
        didSet {
            makeRoundIdLabel(view: jobIdLbl)
        }
    }
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var locationlbl: UILabel!
    
    @IBOutlet weak var servicePerformTxtView: UITextView!
    
    @IBOutlet weak var captureStampBtn: UIButton! {didSet {makeRoundBtn(view: captureStampBtn)}}
    
    //sign view
    @IBOutlet weak var signHereLbl: UILabel!
    @IBOutlet weak var signView: UIView!
    @IBOutlet weak var signatureView: PPSSignatureView!
    @IBOutlet weak var signatureImgView: UIImageView!
    
    var ticket : Ticket = Ticket()
    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addNavigationImage()
        signatureImgView.isHidden = true
        styleUIElements()
    }

    func addNavigationImage() {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 26, height: 33))
        imageView.image = UIImage(named: "nav_symbol")
        self.navigationItem.titleView = imageView
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func styleUIElements() {
        jobNameLbl.text = ticket.customerName
        jobIdLbl.text = " #" + ticket.poNumber + " "
        addressLbl.text = ""
        locationlbl.text = ""
        
        servicePerformTxtView.text = ""
        
    }
    
    // MARK: - Button Actions
    
    @IBAction func goBack(_ sender: AnyObject) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func captureStampAction(_ sender: UIButton) {
        
    }
    
    @IBAction func noteBtnAction(_ sender: UIButton) {
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
