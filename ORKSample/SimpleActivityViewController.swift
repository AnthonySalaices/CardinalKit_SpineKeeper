//
//  SimpleActivityViewController.swift
//  ORKSample
//
//  Created by Muhammad Junaid Butt on 07/07/2020.
//  Copyright © 2020 Apple, Inc. All rights reserved.
//

import UIKit
import CareKit

class SimpleActivityViewController: OCKChecklistTaskViewController {
    
    override func didSelectTaskView(_ taskView: UIView & OCKTaskDisplayable, eventIndexPath: IndexPath) {
        guard let event = controller.eventFor(indexPath: eventIndexPath) else { return }
        guard let task = event.task as? OCKTask else { return }
        do {
            let detailsVC = try controller.initiateDetailsViewController(forIndexPath: eventIndexPath)
            detailsVC.navigationItem.rightBarButtonItem = nil
            if let asset = task.asset {
                detailsVC.detailView.imageView.contentMode = .scaleAspectFit
                detailsVC.detailView.imageView.image = UIImage(named: asset)
            }
            
            let attributedText = NSMutableAttributedString()
            attributedText.append(NSAttributedString(string: task.title!,
                                                     attributes: [.font : UIFont.systemFont(ofSize: 20, weight: .semibold)]))
            attributedText.append(NSAttributedString(string: "\n"))
            attributedText.append(NSAttributedString(string: event.scheduleEvent.element.text!,
                                                     attributes: [.font : UIFont.systemFont(ofSize: 16, weight: .light)]))
            detailsVC.detailView.titleLabel.attributedText = attributedText
            detailsVC.detailView.titleLabel.textAlignment = .center
            detailsVC.detailView.instructionsLabel.text = task.instructions
            self.navigationController?.pushViewController(detailsVC, animated: true)
        } catch {
            print(error.localizedDescription)
        }
    }
}
