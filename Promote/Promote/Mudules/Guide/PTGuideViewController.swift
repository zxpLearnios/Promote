//
//  PTGuideViewController
//  引导图只加载一次图片

import UIKit

class PTGuideViewController: PTBaseViewController {

    let totalCount = 3

    
    var scrollView: UIScrollView = {
        let scroller = UIScrollView()
        scroller.frame = view.bounds
        scroller.backgroundColor = UIColor.yellow
        scroller.contentSize = CGSize(width: kwidth*CGFloat(totalCount), height: 0)
        scroller.delegate = self
        scroller.isPagingEnabled = true
        scroller.bounces = false
        scroller.bouncesZoom = false
        scroller.showsVerticalScrollIndicator = false
        scroller.showsHorizontalScrollIndicator = false
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addScroller()
        
    }

    
    fileprivate func addScroller()  {
        
        view.addSubview(scrollView)
        
        for i in 1...totalCount {
            
            let imgName = String.init(format: "/guideImage%d", i) // /Resource
            let path = kbundlePath + imgName //    /Resource/GuideImage
            
            let imageView = UIImageView.init(frame: CGRect(x: kwidth*(CGFloat(Float(i))-1), y: 0, width: kwidth, height: kheight))
            // 此法只加载一次图片，故引导图用之
            imageView.image = UIImage.init(contentsOfFile: path)
            scrollView.addSubview(imageView)
            
            if i == totalCount {
                imageView.isUserInteractionEnabled = true
                let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapAction))
                imageView.addGestureRecognizer(tap)
            }
        }
    }
    
    @objc private func tapAction(){
        doMissAnimate()
    }
    
    private func doMissAnimate(){
        UIView.animate(withDuration: 0.8, animations: {
            self.view.alpha = 0.3
        }, completion: { (Bool) in
            self.perform(#selector(self.convertedToRootController), with: nil)
        }) 
    }
    
    @objc private func convertedToRootController() {
        
    }

   
}

extension PTGuideViewController: UIScrollViewDelegate {
    // MARK: UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //        debugPrint("滚动距离\(scrollView.contentOffset.x)")
    }

}
