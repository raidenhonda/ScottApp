//
//  DashboardViewController.swift
//  Scott
//
//  Created by Raiden Honda on 22/10/16.
//  Copyright © 2016 Beloved Robot. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableview: UITableView!
    
    //top view
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var jobsLbl: UILabel!
    @IBOutlet weak var hoursLbl: UILabel!
    @IBOutlet weak var monthLbl: UILabel!
    @IBOutlet weak var dayLbl: UILabel!
    
    var selectedIndex: IndexPath!
    // Data
    var tickets : [Ticket] = []
    var completedTickets : Int = 0
    var todaysTickets: [Ticket] = []
    var upcomingTickets: [Ticket] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addNavigationImage()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Get technician's tickets from stash
        self.tickets = []
        self.todaysTickets = []
        self.upcomingTickets = []
        
        DataStore.sharedDataStore.queryDocumentStore(parameters: ("docType", "ticket")) { jsonArray in
            for ticketJson in jsonArray {
                let ticket = Ticket()
                ticket.fromJSON(json: ticketJson.rawString()!)
                self.tickets.append(ticket)
                print("customerId = \(ticket.customerId)")
                print("customerName = \(ticket.customerName)")
                print("poNumber = \(ticket.poNumber)")
                print("docType = \(ticket.docType)")
                print("woNumber = \(ticket.woNumber)")
                print("status = \(ticket.status)")
                print("workDescription = \(ticket.workDescription)")
                print("technicalNote = \(ticket.technicalNote)")
                print("workCompleted = \(ticket.workCompleted)")
                print("signatureName = \(ticket.signatureName)")
                print("signatureImageUrl = \(ticket.signatureImageUrl)")
                print("technicians = \(ticket.technicians)")
                print("materialList = \(ticket.materialList)")
                print("checkList = \(ticket.checkList)")
                print("====================================")
                
                if self.isTicketScheduledForToday(ticket: ticket) {
                    self.todaysTickets.append(ticket)
                } else {
                    self.upcomingTickets.append(ticket)
                }
            }
        }
        
        // Get the current technician
        let currentTech = User.getCurrentTechnician()
        print("serviceLocation = \(currentTech?.serviceLocation)")
        print("email = \(currentTech?.email)")
        nameLbl.text = currentTech?.name
        locationLbl.text = currentTech?.role
        jobsLbl.text = "\(tickets.count)"
        hoursLbl.text = "0"
        
        let dateFormatter = DateFormatter()
        // Format to get Month from Date
        dateFormatter.dateFormat = "MMMM"
        let wholeMonthString = dateFormatter.string(from: Date().localDate())
        // Cut down to abriviated version
        monthLbl.text = (wholeMonthString as NSString) .substring(to: 3)
        dateFormatter.dateFormat = "d"
        dayLbl.text = dateFormatter.string(from: Date().localDate())
        
        // Get the completed tickets
        self.completedTickets = Globals.weeklyCompletedTickets
        print("completedTickets = \(completedTickets)")
        self.tableview.reloadData()
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
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var sectionName: String!
        if section == 0 {
            sectionName = "TODAY'S JOBS"
        } else {
            sectionName = "SCHEDULED TICKETS"
        }
        
        return sectionName
    }
    
    // MARK: - UITableView delegate methods
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = Globals.sColorYellowText
        header.contentView.backgroundColor = Globals.sColorNavBg
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            if todaysTickets.count == 0 {
                return 60
            } else {
                return 108
            }
            
        } else {
            if upcomingTickets.count == 0 {
                return 60
            } else {
                return 84
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return todaysTickets.count == 0 ? 1 : todaysTickets.count
        } else {
            return upcomingTickets.count == 0 ? 1 : upcomingTickets.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            if todaysTickets.count == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "NoTicketCell", for: indexPath) as! NoTicketCell
                cell.title.text = "NO JOB ASSIGNED FOR TODAY"
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "JobCell", for: indexPath) as! JobCell
                cell.numberLbl.text = String(format:"%02d", indexPath.row + 1)
                cell.jobTitleLbl.text =  todaysTickets[indexPath.row].customerName
                cell.jobIdLbl.text = " #" + todaysTickets[indexPath.row].poNumber + " "
                cell.locationLbl.text = ""
                cell.addressLbl.text  = ""
                cell.dispatchNoteLbl.text = todaysTickets[indexPath.row].workDescription
                
                cell.selectionStyle = .none
                return cell
            }
            
            
        } else {
            if upcomingTickets.count == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "NoTicketCell", for: indexPath) as! NoTicketCell
                cell.title.text = "NO SCHEDULED JOBS"
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleCell", for: indexPath) as! ScheduleCell
                cell.titleLbl.text = upcomingTickets[indexPath.row].customerName
                cell.schIdLbl.text = " #" + upcomingTickets[indexPath.row].poNumber + " "
                cell.locationLbl.text = ""
                cell.addressLbl.text  = ""
                
                let startDateStr = upcomingTickets[indexPath.row].jobStart
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "YYYY-MM-dd"
                let startDate = dateFormatter.date(from: startDateStr)
                // Format to get Month from Date
                dateFormatter.dateFormat = "MMMM"
                let wholeMonthString = dateFormatter.string(from: (startDate?.localDate())!)
                // Cut down to abriviated version
                cell.monthLbl.text = (wholeMonthString as NSString) .substring(to: 3)
                dateFormatter.dateFormat = "d"
                cell.dayLbl.text = dateFormatter.string(from: (startDate?.localDate())!)
                
                cell.selectionStyle = .none
                return cell
            }
           
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("cell = \(indexPath.section) \(indexPath.row)")
        selectedIndex = indexPath
        if indexPath.section == 0  && todaysTickets.count != 0 {
            self.performSegue(withIdentifier: "goJobSegueId", sender: self)
        } else if indexPath.section == 1  && upcomingTickets.count != 0 {
            self.performSegue(withIdentifier: "goJobSegueId", sender: self)
        }
        
        
//        tableView.deselectRow(at: indexPath, animated: false)
    }
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let headerView = UIView()
//        headerView.frame = CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 40)
//        headerView.backgroundColor = UIColor.clear
//        return headerView
//    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goJobSegueId" {
            let vc = segue.destination as! JobViewController
                if selectedIndex.section == 0 {
                    vc.ticket = self.todaysTickets[selectedIndex.row]
                } else {
                    vc.ticket = self.upcomingTickets[selectedIndex.row]
                }
        }
    }
    

    // MARK: Helper Methods
    func isTicketScheduledForToday(ticket: Ticket) -> Bool {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "YYYY-MM-dd"
        
        let today = Date().localDate()
        let todayString = dateformatter.string(from: today as Date)
        
        if todayString == ticket.jobStart {
            return true
        }
        
        if let startDate: Date = dateformatter.date(from: ticket.jobStart) as Date? {
            if let endDate: Date = dateformatter.date(from: ticket.jobEnd) as Date? {
                if (today.isBetweeen(date: startDate, andDate: endDate.endOfDay())) {
                    return true
                }
            }
        }
        
        return false
    }
}
