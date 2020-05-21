//
//  ViewController.swift
//  Sample
//
//  Created by Eric JI on 2020/02/29.
//  Copyright © 2020 ericji. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate {
    
    let pageControl = PageControl()

    let scrollView = UIScrollView()
    let scrollSize: CGFloat = 300

    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        scrollView.frame = CGRect(x: 0, y: 0, width: scrollSize, height: scrollSize)
        scrollView.center = view.center
        scrollView.isPagingEnabled = true

        pageControl.config = Config(displayCount: 7, dotSize: 6, dotSpace: 4, smallDotSizeRatio: 0.5, mediumDotSizeRatio: 0.7)
        pageControl.center = CGPoint(x: scrollView.center.x, y: scrollView.frame.maxY + 16)

        view.addSubview(scrollView)
        view.addSubview(pageControl)

        setContent(numberOfPages: 100)
    }
    
    func setContent(numberOfPages: Int) {
        
        scrollView.subviews.forEach { $0.removeFromSuperview() }
        
        scrollView.contentSize = CGSize(width: scrollSize * CGFloat(numberOfPages), height: scrollSize)
        pageControl.numberOfPages = Int32(numberOfPages)
        
        for index in  0..<numberOfPages {
            
            let view = UIImageView(
                frame: .init(
                    x: CGFloat(index) * scrollSize,
                    y: 0,
                    width: scrollSize,
                    height: scrollSize
                )
            )
            let imageNamed = NSString(format: "image%02d.jpg", index % 10) as String
            view.image = UIImage(named: imageNamed)
            scrollView.addSubview(view)
        }

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setContent(numberOfPages: 10)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        pageControl.setProgress(scrollView.contentOffset.x, pageWidth: scrollView.bounds.width)
        let currentPage = Int(round(scrollView.contentOffset.x / scrollView.bounds.width))
        pageControl.currentPage = Int32(currentPage)
    }
}




