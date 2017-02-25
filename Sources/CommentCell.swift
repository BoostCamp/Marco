//
//  CommentCell.swift
//  Marco
//
//  Created by 서석인 on 2/25/17.
//  Copyright © 2017 marco. All rights reserved.
//

import UIKit

class emptyCommentCell: UITableViewCell {
    
}

class CommentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var commentView: UIView!
    @IBOutlet weak var commentDescriptionLabel: UILabel!
    @IBOutlet weak var dateString: UILabel!
    @IBOutlet weak var writerNameLabel: UILabel!
}
