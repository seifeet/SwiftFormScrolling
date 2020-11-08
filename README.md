It is fairly easy to use UIScrollView with the AutoLayout on iOS 12+ but only if one follows the following steps:
1. Add UIScrollView and pin it 0,0,0,0 to superview (or your desired size)
2. Add UIView in ScrollView, pin it 0,0,0,0 to all 4 sides and center it horizontally and vertically.
3. Center contentView X and Y and set Y's priority to low. Set contentView height to greaterThanOrEqualTo it's parent height.
4. Add all views that you need into this view. Don't forget to set the bottom constraint on the lowest view.



[UIScrollView with Swift and AutoLayout](https://monkey.work/blog/2020/11/08/uiscrollview/)
