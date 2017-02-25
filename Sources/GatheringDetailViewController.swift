//
//  GatheringDetailViewController.swift
//  Marco_beta_v1.0
//
//  Created by 서석인 on 2/18/17.
//  Copyright © 2017 marco. All rights reserved.
//

import UIKit
import Toucan

class GatheringDetailViewController: UITableViewController {

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var gatheringNameLabel: UILabel!
    @IBOutlet weak var gatheringImageView: UIImageView!
    @IBOutlet weak var gatheringStatusLabel: UILabel!
    @IBOutlet weak var gatheringDateLabel: UILabel!
    @IBOutlet weak var gatheringLocationLabel: UILabel!
    
    @IBOutlet weak var particiNumLabel: UILabel!
    @IBOutlet weak var commentNum: UILabel!
    
    @IBOutlet weak var floatingButton: UIButton!
    
    @IBOutlet weak var withPeopleView: UIView!
    
    var detail: gathering!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let pstyle = NSMutableParagraphStyle()
        pstyle.lineSpacing = 1.25
        pstyle.lineHeightMultiple = 1.25
        
        gatheringImageView.image = detail.image
        gatheringNameLabel.text = detail.name
        descriptionLabel.numberOfLines = 0
        
        let descriptionText = NSMutableAttributedString(string: detail.description)
        descriptionText.addAttribute(NSParagraphStyleAttributeName, value: pstyle, range: NSMakeRange(0, descriptionText.length))
        
        descriptionLabel.attributedText = descriptionText
        gatheringDateLabel.text = detail.dateString
        gatheringLocationLabel.text = detail.locationString
        particiNumLabel.text = "\(detail.numOfMembers)명"
        commentNum.text = "\(detail.numOfComments)"
        
        if detail.isClosed {
            gatheringStatusLabel.text = "모집마감"
            gatheringStatusLabel.textColor = .untReddishOrange
            floatingButton.setTitle("모집마감", for: .normal)
            floatingButton.isEnabled = false
            floatingButton.backgroundColor = UIColor.untBluegrey50
        } else {
            gatheringStatusLabel.text = "모집중"
            gatheringStatusLabel.textColor = .untWarmBlue
        }
        
        for i in 0...detail.numOfMembers-1 {
            if i > 4 {
                let peopleImageView = UIImageView(frame: CGRect(x: 60*i, y: 0, width: 50, height: 50))
                peopleImageView.image = Toucan(image: (detail.members[i].image?.circleMasked!)! ).resize(CGSize(width: 50, height: 50)).image
                withPeopleView.addSubview(peopleImageView)
            }
            
            let peopleImageView = UIImageView(frame: CGRect(x: 60*i, y: 0, width: 50, height: 50))
            peopleImageView.image = Toucan(image: (detail.members[i].image?.circleMasked!)! ).resize(CGSize(width: 50, height: 50)).image
            withPeopleView.addSubview(peopleImageView)
        }
        // Do any additional setup after loading the view.
        
    }

    @IBAction func floatButtonClicked(_ sender: Any) {
        let alertAppear = UIAlertController(title: "참여 요청을 보냈습니다.", message: "", preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        alertAppear.addAction(OKAction)
        self.present(alertAppear, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if detail.numOfComments == 0 {
            return 1
        }
        else {
            return detail.numOfComments
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if detail.numOfComments == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "emptyCommentCell", for: indexPath) as! emptyCommentCell
            
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Comment Cell", for: indexPath) as! CommentTableViewCell
            let comment = detail.comments[ indexPath.row ]
            
            cell.commentView.layer.cornerRadius = 10.0
            cell.dateString.text = comment.dateString
            cell.commentDescriptionLabel.text = comment.description
            
            let newImageView = UIImageView(frame: CGRect(x:0,y:0,width:40,height:40))
            newImageView.image = //comment.writer.image.circleMasked
                Toucan(image: comment.writer.image.circleMasked! ).resize(CGSize(width: 40, height: 40)).image
            cell.profileView.addSubview(newImageView)
            //cell.imageView?.addSubview(newImageView)
            
            cell.writerNameLabel.text = comment.writer.name
            
            return cell
        }
        
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
