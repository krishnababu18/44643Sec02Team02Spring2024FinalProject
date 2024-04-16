//
//  CustomTableView.swift
//  EventsAndWeatherGuide
//
//  Created by Gali Krishna Babu on 01/04/2024.
//

import Foundation
import UIKit

class CustomTableView: UITableView {
    
    
    override var intrinsicContentSize: CGSize {
      self.layoutIfNeeded()
      return self.contentSize
    }

    override var contentSize: CGSize {
      didSet{
        self.invalidateIntrinsicContentSize()
      }
    }

    override func reloadData() {
      super.reloadData()
      self.invalidateIntrinsicContentSize()
    }
  }
