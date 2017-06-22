//
//  JobCompleteVC.swift
//  Scott
//
//  Created by Raiden Honda on 27/10/16.
//  Copyright © 2016 Beloved Robot. All rights reserved.
//

import UIKit

class JobCompleteVC: UIViewController {

    //top view
    @IBOutlet weak var jobNameLbl: UILabel!
    @IBOutlet weak var jobIdLbl: UILabel! {
        didSet {
            makeRoundIdLabel(view: jobIdLbl)
        }
    }
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var locationlbl: UILabel!
    
    //other views
    @IBOutlet weak var checkListLbl1: UILabel!
    @IBOutlet weak var checkListLbl2: UILabel!
    @IBOutlet weak var checkListLbl3: UILabel!
    
    @IBOutlet weak var jobNotesTxtView: UITextView!
    
    @IBOutlet weak var approvalBtn: UIButton! {didSet {makeRoundBtn(view: approvalBtn)}}
    
    var ticket : Ticket = Ticket()
    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addNavigationImage()
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
        
        jobNotesTxtView.text = ticket.workDescription
        
    }
    
    // MARK: - Button Actions
    
    @IBAction func goBack(_ sender: AnyObject) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func approvalAction(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goSignatureSegue", sender: self)
    }
    
    @IBAction func noteBtnAction(_ sender: UIButton) {
        
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goSignatureSegue" {
            let vc = segue.destination as! SignatureViewController
            vc.ticket = self.ticket
        }
    }

}
