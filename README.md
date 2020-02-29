# FlexiblePageControl(Objective-C)

A flexible UIPageControl like Instagram.
[Link](https://github.com/shima11/FlexiblePageControl)

# Update ✨✨

* Name: **InsPageControl**
* Language: Objective-c

**Purpose**: Objective-C project also can use it


# OverView

![](demo.gif)

# Install


### CocoaPods

For installing with CocoaPods, add it to your `Podfile`.

```
pod "InsPageControl"

```

# Usage

````
let pageControl = PageControl()
pageControl.numberOfPages = 10
view.addSubview(pageControl)
````

### Customize

````
pageControl.config = Config(displayCount: 7, dotSize: 6, dotSpace: 4, smallDotSizeRatio: 0.5, mediumDotSizeRatio: 0.7)

````

### Update page

````
func scrollViewDidScroll(_ scrollView: UIScrollView) {
    pageControl.setProgress(contentOffsetX: scrollView.contentOffset.x, pageWidth: scrollView.bounds.width)
}
````

# Licence

Licence MIT

