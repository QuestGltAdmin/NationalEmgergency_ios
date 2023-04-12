

import UIKit

class IntroSliderVC: UIViewController, UIScrollViewDelegate {
     
    @IBOutlet weak var btnSkip1: UIButton!
    @IBOutlet weak var btnSkip2: UIButton!
    @IBOutlet weak var downPageContraint: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!{
        didSet{
            scrollView.delegate = self
        }
    }
    
    @IBOutlet weak var pageControl: CustomImagePageControl!
    var checkClick  = ""
    
    var slides:[UIView] = [];
    
    override func viewDidLoad() {
        super.viewDidLoad()
       if  kIS_IPHONE_SE ||  kIS_IPHONE_4_OR_LESS || kIS_IPHONE_5 || kIS_IPHONE_5S
       {
         downPageContraint.constant = 10
       }else if kIS_IPHONE_6
       {
         downPageContraint.constant = 40
       }else{
            downPageContraint.constant = 10
       }
        slides = createSlides()
        setupSlideScrollView(slides: slides)
        pageControl.numberOfPages = slides.count
        pageControl.currentPage = 0
        view.bringSubviewToFront(pageControl)
        pageControl.activeImage = UIImage.init(named: "UnFillWhiteDot")!
        pageControl.inactiveImage = UIImage.init(named: "FillWhiteDot")!
        pageControl.updateDots()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        pageControl.activeImage = UIImage.init(named: "UnFillWhiteDot")!
        pageControl.inactiveImage = UIImage.init(named: "FillWhiteDot")!
        pageControl.updateDots()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        pageControl.activeImage = UIImage.init(named: "UnFillWhiteDot")!
        pageControl.inactiveImage = UIImage.init(named: "FillWhiteDot")!
        pageControl.updateDots()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func createSlides() -> [UIView] {
        btnSkip1.isHidden = false
        btnSkip2.isHidden = true
        
        let slide1:Slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! Slide
        slide1.imageView.image = UIImage(named: "intro1")
        slide1.labelTitle.text = "GET HELP"
        slide1.labelDesc.text = "So I want to create a function to dismiss all the view controllers, regardless of whether it is pushed"
        
        let slide2:Slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! Slide
        slide2.imageView.image = UIImage(named: "intro2")
        slide2.labelTitle.text = "STAY CONNECTED"
        slide2.labelDesc.text = "So I want to create a function to dismiss all the view controllers, regardless of whether it is pushed"
        
        let slide3:Slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! Slide
        slide3.imageView.image = UIImage(named: "intro3")
        slide3.labelTitle.text = "GET NOTIFIED"
        slide3.labelDesc.text = "So I want to create a function to dismiss all the view controllers, regardless of whether it is pushed"
        
        return [slide1, slide2, slide3]
    }
    @objc func signInClicked() {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "SignInVC") as! SignInVC
        VC.PageManage = ""
        self.navigationController?.pushViewController(VC, animated: true)
    }
   
    func setupSlideScrollView(slides : [UIView]) {
        scrollView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        scrollView.contentSize = CGSize(width: view.frame.width * CGFloat(slides.count), height: view.frame.height)
        scrollView.isPagingEnabled = true
        
        for i in 0 ..< slides.count {
            slides[i].frame = CGRect(x: view.frame.width * CGFloat(i), y: 0, width: view.frame.width, height: view.frame.height)
            scrollView.addSubview(slides[i])
        }
    }
    @objc func moveToNextPage (){
        
        let pageWidth:CGFloat = self.scrollView.frame.width
        let maxWidth:CGFloat = pageWidth * CGFloat(slides.count)
        let contentOffset:CGFloat = self.scrollView.contentOffset.x
        
        var slideToX = contentOffset + pageWidth
        
        if  contentOffset + pageWidth == maxWidth
        {
            slideToX = 0
        }
        self.scrollView.scrollRectToVisible(CGRect(x:slideToX, y:0, width:pageWidth, height:self.scrollView.frame.height), animated: true)
        print(pageControl.currentPage)
    }
    
    @objc func moveToFirst (){
        
        let pageWidth:CGFloat = self.scrollView.frame.width
        self.scrollView.scrollRectToVisible(CGRect(x:0, y:0, width:pageWidth, height:self.scrollView.frame.height), animated: true)
        print(pageControl.currentPage)
    }
    /*
     * default function called when view is scolled. In order to enable callback
     * when scrollview is scrolled, the below code needs to be called:
     * slideScrollView.delegate = self or
     */
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x/view.frame.width)
        
        pageControl.currentPage = Int(pageIndex)
        //        if pageIndex == 3
        //        {
        //            AppDelegate.sharedAppDelegateInterface.GetFirstPageVC()
        //        }
        print(Int(pageIndex))
        let maximumHorizontalOffset: CGFloat = scrollView.contentSize.width - scrollView.frame.width
        let currentHorizontalOffset: CGFloat = scrollView.contentOffset.x
        
        // vertical
        let maximumVerticalOffset: CGFloat = scrollView.contentSize.height - scrollView.frame.height
        let currentVerticalOffset: CGFloat = scrollView.contentOffset.y
        
        let percentageHorizontalOffset: CGFloat = currentHorizontalOffset / maximumHorizontalOffset
        let percentageVerticalOffset: CGFloat = currentVerticalOffset / maximumVerticalOffset
        /*
         * below code changes the background color of view on paging the scrollview
         */
        //        self.scrollView(scrollView, didScrollToPercentageOffset: percentageHorizontalOffset)
        /*
         * below code scales the imageview on paging the scrollview
         */
        let percentOffset: CGPoint = CGPoint(x: percentageHorizontalOffset, y: percentageVerticalOffset)
       
        if(percentOffset.x > 0 && percentOffset.x <= 0.25) {
            btnSkip1.isHidden = false
            btnSkip2.isHidden = true
        } else if(percentOffset.x > 0.25 && percentOffset.x <= 0.50) {
           btnSkip1.isHidden = false
           btnSkip2.isHidden = true
        } else if(percentOffset.x > 0.50 && percentOffset.x <= 0.75) {
            btnSkip1.isHidden = true
            btnSkip2.isHidden = false
        } else if(percentOffset.x > 0.75 && percentOffset.x <= 1) {
       
            
     
        }
        pageControl.activeImage = UIImage.init(named: "UnFillWhiteDot")!
        pageControl.inactiveImage = UIImage.init(named: "FillWhiteDot")!
        pageControl.updateDots()
        print("\(checkClick): \(pageControl.currentPage)")
        checkClick = ""
    }
    
    override func viewDidLayoutSubviews() {
        pageControl.subviews.forEach {
            $0.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        }
    }
    
  
    func scrollView(_ scrollView: UIScrollView, didScrollToPercentageOffset percentageHorizontalOffset: CGFloat) {
        
        if(pageControl.currentPage == 0) {
            //Change background color to toRed: 103/255, fromGreen: 58/255, fromBlue: 183/255, fromAlpha: 1
            //Change pageControl selected color to toRed: 103/255, toGreen: 58/255, toBlue: 183/255, fromAlpha: 0.2
            //Change pageControl unselected color to toRed: 255/255, toGreen: 255/255, toBlue: 255/255, fromAlpha: 1
          
            let pageUnselectedColor: UIColor = fade(fromRed: 255/255, fromGreen: 255/255, fromBlue: 255/255, fromAlpha: 1, toRed: 103/255, toGreen: 58/255, toBlue: 183/255, toAlpha: 1, withPercentage: percentageHorizontalOffset * 3)
            pageControl.pageIndicatorTintColor = pageUnselectedColor
            
            
            let bgColor: UIColor = fade(fromRed: 103/255, fromGreen: 58/255, fromBlue: 183/255, fromAlpha: 1, toRed: 255/255, toGreen: 255/255, toBlue: 255/255, toAlpha: 1, withPercentage: percentageHorizontalOffset * 3)
            slides[pageControl.currentPage].backgroundColor = bgColor
            
            let pageSelectedColor: UIColor = fade(fromRed: 81/255, fromGreen: 36/255, fromBlue: 152/255, fromAlpha: 1, toRed: 103/255, toGreen: 58/255, toBlue: 183/255, toAlpha: 1, withPercentage: percentageHorizontalOffset * 3)
            pageControl.currentPageIndicatorTintColor = pageSelectedColor
        }
    }
    
    
    func fade(fromRed: CGFloat,
              fromGreen: CGFloat,
              fromBlue: CGFloat,
              fromAlpha: CGFloat,
              toRed: CGFloat,
              toGreen: CGFloat,
              toBlue: CGFloat,
              toAlpha: CGFloat,
              withPercentage percentage: CGFloat) -> UIColor {
        
        let red: CGFloat = (toRed - fromRed) * percentage + fromRed
        let green: CGFloat = (toGreen - fromGreen) * percentage + fromGreen
        let blue: CGFloat = (toBlue - fromBlue) * percentage + fromBlue
        let alpha: CGFloat = (toAlpha - fromAlpha) * percentage + fromAlpha
        
        // return the fade colour
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    @IBAction func SkipButton1(_ sender: Any) {
            AppDelegate.sharedAppDelegateInterface.GetFirstPageVC()
    }
    @IBAction func SkipButton2(_ sender: Any) {
          AppDelegate.sharedAppDelegateInterface.GetFirstPageVC()
    }
}

extension UIButton {
    func underlineButton(text: String) {
        let titleFont = [NSAttributedString.Key.font: UIFont(name: "OpenSans-Bold", size: 9)!,NSAttributedString.Key.kern:0.48] as [NSAttributedString.Key : Any]
         
        let titleString = NSMutableAttributedString(string: text, attributes: titleFont)
        titleString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0, text.count))
         self.setAttributedTitle(titleString, for: .normal)
    }
    
    func withOutUnderlineButton(text: String) {
         let titleFont = [NSAttributedString.Key.font: UIFont(name: "OpenSans-Bold", size: 12)!,NSAttributedString.Key.kern:0.48] as [NSAttributedString.Key : Any]
          let titleString = NSMutableAttributedString(string: text, attributes: titleFont)
          self.setAttributedTitle(titleString, for: .normal)
       }
}
