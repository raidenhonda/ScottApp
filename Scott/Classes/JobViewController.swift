//
//  JobViewController.swift
//  Scott
//
//  Created by Raiden Honda on 25/10/16.
//  Copyright © 2016 Beloved Robot. All rights reserved.
//

import UIKit
import Foundation

class JobViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var headerview: UIView!
    
    //top view
    @IBOutlet weak var jobNameLbl: UILabel!
    @IBOutlet weak var jobIdLbl: UILabel! {
        didSet {
            makeRoundIdLabel(view: jobIdLbl)
        }
    }
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var locationlbl: UILabel!
    @IBOutlet weak var mapBtn: UIButton! {didSet {makeRoundBtn(view: mapBtn)}}
    @IBOutlet weak var pastJobBtn: UIButton! {didSet {makeRoundBtn(view: pastJobBtn)}}
    
    //job time & customer details view
    @IBOutlet weak var timerLbl: UILabel!
    @IBOutlet weak var startBtn: UIButton! {didSet {makeRoundBtn(view: startBtn)}}
    @IBOutlet weak var stopBtn: UIButton! {didSet {makeRoundBtn(view: stopBtn)}}
    @IBOutlet weak var contactLbl: UILabel!
    @IBOutlet weak var phoneLbl: UILabel!
    @IBOutlet weak var poLbl: UILabel!
    
    //dispatch notes & work performed
    @IBOutlet weak var dispatchNoteTxtView: UITextView!
    @IBOutlet weak var workPerformedTxtView: UITextView!
    
    //add photos
    @IBOutlet weak var photoScrollView: UIScrollView!
    
    @IBOutlet weak var prepareQuoteBtn: UIButton! {didSet {makeRoundBtn(view: prepareQuoteBtn)}}
    @IBOutlet weak var workCompletBtn: UIButton! {didSet {makeRoundBtn(view: workCompletBtn)}}
    
    var photoCount: Int!
    let imagePicker = UIImagePickerController()
    var currentTag: Int!
    
    var jobTimer: Timer!
    var workingTimeInteval: Int!
    
    var ticket : Ticket = Ticket()
//    var ticketId : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        addNavigationImage()
        styleUIElements()
        
        imagePicker.delegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        styleUIElements()
    }
    
    func styleUIElements() {
        
        //add photos view
        photoCount = 0
        addPhotoView()
        
        //TODO here setup contents
        print("current ticket = \(ticket.customerName)")
        jobNameLbl.text = ticket.customerName
        jobIdLbl.text = " #" + ticket.poNumber + " "
        addressLbl.text = ""
        locationlbl.text = ""
        
        let currentTech = User.getCurrentTechnician()
        contactLbl.text = currentTech?.name
        phoneLbl.text = ""
        poLbl.text = ticket.poNumber
        
        dispatchNoteTxtView.text = ticket.workDescription
        workPerformedTxtView.text = ticket.workCompleted
        
    }
    
    func addNavigationImage() {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 26, height: 33))
        imageView.image = UIImage(named: "nav_symbol")
        self.navigationItem.titleView = imageView
    }
   
    @IBAction func goBack(_ sender: AnyObject) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func addPhotoView() {
        let photoView = UIImageView()
        let p_x = photoCount * 158
        photoView.frame = CGRect(x: p_x, y: 0, width: 148, height: 92)
        photoView.image = UIImage(named: "btn_plus")
        photoView.contentMode = .scaleAspectFill
        photoView.isUserInteractionEnabled = true
        photoView.tag = photoCount + 100
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapPlusPhoto))
        photoView.addGestureRecognizer(tapGesture)
        
        photoScrollView.addSubview(photoView)
        
        photoScrollView.contentSize = CGSize(width: photoView.frame.origin.x + 148, height: 92)
    }
    
    func tapPlusPhoto(_ sender: UITapGestureRecognizer) {
        currentTag = sender.view?.tag
        
        let alertView = UIAlertController(title: "Add Photo", message: "", preferredStyle: .actionSheet)
        
        let photoLibary = UIAlertAction(title: "Photo Library", style: .default, handler: { (_) in
            self.imagePicker.allowsEditing = false
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true, completion: nil)
        })
        alertView.addAction(photoLibary)
        
        let camera = UIAlertAction(title: "Take a Photo", style: .default, handler: { (_) in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
                self.imagePicker.sourceType = .camera
            } else {
                self.imagePicker.sourceType = .photoLibrary
            }
            self.present(self.imagePicker, animated: true, completion: nil)
        })
        alertView.addAction(camera)
        
        if let popoverController = alertView.popoverPresentationController {
            popoverController.sourceView = sender.view
            popoverController.sourceRect = CGRect(x: (sender.view?.bounds.size.width)! / 2.0, y: (sender.view?.bounds.size.height)! / 2.0, width: 1.0, height: 1.0)
        }
        
        self.present(alertView, animated: true, completion: nil)
        
    }
    
    // MARK: - Image picker controller delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            let foundView = view.viewWithTag(currentTag) as! UIImageView
            foundView.image = pickedImage
            
            if foundView.tag < 1000 {
                photoCount = photoCount + 1
                addPhotoView()
            }
            
            foundView.tag = foundView.tag + 1000
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Button Actions
    
    @IBAction func mapAction(_ sender: UIButton) {
        //Map button action
    }
    
    @IBAction func pastJobAction(_ sender: UIButton) {
        //Past Jobs button action
    }
    
    @IBAction func startAction(_ sender: UIButton) {
        workingTimeInteval = 0
        
        let day = DayTime()
        day.date = Date().localDate().toShortDateString()
        let now = Date()
        day.startUtc = now.toISOString()
        self.ticket.workDays.append(day)
        
        startBtn.setTitle(self.getTimeStamp(date: now), for: .normal)
        
        jobTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(runTimedCode), userInfo: nil, repeats: true)
    }
    
    @IBAction func stopAction(_ sender: UIButton) {
        jobTimer.invalidate()
        
        stopBtn.setTitle(self.getTimeStamp(date: Date()), for: .normal)
    }
    
    func runTimedCode() {
        workingTimeInteval = workingTimeInteval + 1
        let mm: Int = workingTimeInteval / 60
        let ss: Int = workingTimeInteval % 60
        timerLbl.text = String(format:"%02d:%02d", mm, ss)
    }
    
    @IBAction func prepareQuoteAction(_ sender: UIButton) {
//        self.performSegue(withIdentifier: "goSignatureSegue", sender: self)
    }
    
    @IBAction func workCompleteAction(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goJobCompleteSegue", sender: self)
    }
    
    @IBAction func noteBtnAction(_ sender: UIButton) {
        
    }
    
    // TODO: Replace with date utilities
    func getTimeStamp(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        return formatter.string(from: date as Date)
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goJobCompleteSegue" {
            let vc = segue.destination as! JobCompleteVC
            vc.ticket = self.ticket
        }
    }

}
