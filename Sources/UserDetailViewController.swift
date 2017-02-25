//
//  UserDetailViewController.swift
//  Marco_beta_v1.0
//
//  Created by 서석인 on 2/19/17.
//  Copyright © 2017 marco. All rights reserved.
//

import UIKit
import Toucan

class UserDetailViewController: UITableViewController {

    @IBOutlet weak var UserImageView: UIImageView!
    @IBOutlet weak var UserPostNumButton: UIButton!
    @IBOutlet weak var UserStatusMsgLabel: UILabel!
    @IBOutlet weak var UserSegmentdControl: UISegmentedControl!
    
    @IBAction func scValueChanged(_ sender: Any) {
       //tableView.beginUpdates()
        tableView.reloadData()
    }
    
    var detail: profile!
    
    @IBAction func requestWitMe(_ sender: Any) {
        let alertAppear = UIAlertController(title: detail.name + "님에게 동행 요청을 보냈습니다.", message: "", preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        alertAppear.addAction(OKAction)
        self.present(alertAppear, animated: true, completion: nil)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        //self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationItem.title = detail.name
        
        let pstyle = NSMutableParagraphStyle()
        pstyle.lineSpacing = 1.25
        pstyle.lineHeightMultiple = 1.25
        
        let descriptionText = NSMutableAttributedString(string: detail.description)
        descriptionText.addAttribute(NSParagraphStyleAttributeName, value: pstyle, range: NSMakeRange(0, descriptionText.length))
        
        UserImageView.image = Toucan( image: ( detail.image.circleMasked)! )
            .resize(CGSize(width: 80, height: 80), fitMode: Toucan.Resize.FitMode.clip).image
        
        
        UserStatusMsgLabel.attributedText = descriptionText
        UserStatusMsgLabel.textAlignment = .center
        
        //UserStatusMsgLabel.text = detail.description
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if UserSegmentdControl.selectedSegmentIndex == 0 {
            if detail.postnum == 0 {
                return 1
            }
            else {
                return detail.postnum
            }
        }
        else {
            if detail.likenum == 0 {
                return 1
            }
            else {
                return detail.likenum
            }
        }
//        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if UserSegmentdControl.selectedSegmentIndex == 0 {
            if detail.postnum == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "emptyTimelineCell", for: indexPath) as! emptyTimelineCell
                return cell
            }
            else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "Timeline Cell", for: indexPath) as! timelineTableViewCell
                cell.dateLabel.text = detail.posts[(indexPath as NSIndexPath).row].dateString
                
                let pstyle = NSMutableParagraphStyle()

                pstyle.lineSpacing = 1.25
                pstyle.lineHeightMultiple = 1.25
                let descriptionText = NSMutableAttributedString(string: detail.posts[(indexPath as NSIndexPath).row].description )
                descriptionText.addAttribute(NSParagraphStyleAttributeName, value: pstyle, range: NSMakeRange(0, descriptionText.length))
                
                cell.descriptionLabel.attributedText = descriptionText
                
                let path = UIBezierPath()
                path.move(to: CGPoint(x:10.0 ,y:0.0) )
                path.addLine(to: CGPoint(x: 250.0, y: 0.0) )
                
                let shapeLayer = CAShapeLayer()
                shapeLayer.path = path.cgPath
                shapeLayer.strokeColor = UIColor.untPaleGrey.cgColor
                
                shapeLayer.fillColor = UIColor.clear.cgColor
                
                cell.lineView.layer.addSublayer(shapeLayer)
                
                return cell
            }
        }
        else {
            if detail.likenum == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "emptyReviewCell", for: indexPath) as! emptyReviewCell
                return cell
            }
            else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "Review Cell", for: indexPath) as! reviewTableViewCell
                let review = detail.reviews[ (indexPath as NSIndexPath).row]
                
                cell.dateLabel.text = review.dateString
                cell.descriptionLabel.text = review.description
                cell.descriptionLabel.sizeToFit()
                
                let newImageView = UIImageView(frame: CGRect(x:0,y:0,width:45,height:45))
                newImageView.image = //comment.writer.image.circleMasked
                    Toucan(image: review.writer.image.circleMasked! ).resize(CGSize(width: 45, height: 45)).image
                cell.profileView.addSubview(newImageView)
                
                let path = UIBezierPath()
                path.move(to: CGPoint(x:5.0 ,y:30.0) )
                path.addLine(to: CGPoint(x: 260.0, y: 30.0) )
                
                let shapeLayer = CAShapeLayer()
                shapeLayer.path = path.cgPath
                shapeLayer.strokeColor = UIColor.untPaleGrey.cgColor
                shapeLayer.fillColor = UIColor.clear.cgColor
                
                cell.lineView.layer.addSublayer(shapeLayer)
                cell.descriptionContainerView.layer.cornerRadius = 10
                
                //cell.descriptionContainerView.frame.size.height = cell.descriptionLabel.frame.size.height + 300
                
                let boldText = review.writer.name
                let attrs = [NSFontAttributeName : UIFont.boldSystemFont(ofSize: 12)]
                let attributedString = NSMutableAttributedString(string:boldText, attributes:attrs)
                
                let normalText = "님이 동행 리뷰를 남겼어요!"
                let normalString = NSMutableAttributedString(string:normalText)
            
                attributedString.append( normalString )
                
                cell.titleLabel.attributedText =  attributedString
            
                return cell
            }
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "emptyTimelineCell", for: indexPath) as! emptyTimelineCell
        return cell
        
    }

}


