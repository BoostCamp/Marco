//
//  TimelineCell.swift
//  Marco_beta_v1.0
//
//  Created by 서석인 on 2/17/17.
//  Copyright © 2017 marco. All rights reserved.
//

import UIKit

//class timelineHeaderTableViewCell: UITableViewCell
//{
//    @IBOutlet weak var profileImageView: UIImageView!
//    @IBOutlet weak var listnum: UIButton!
//    @IBOutlet weak var likenum: UIButton!
//    @IBOutlet weak var profileDescription: UILabel!
//    @IBOutlet weak var profileSegmentedControl: UISegmentedControl!
//}

class timelineTableViewCell: UITableViewCell
{
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var descriptionLabel: UITextView!
    
}

class reviewTableViewCell: UITableViewCell
{
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var enjoyButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var descriptionContainerView: UIView!
}

class emptyTimelineCell: UITableViewCell
{
    
}

class emptyReviewCell : UITableViewCell
{
    
}
