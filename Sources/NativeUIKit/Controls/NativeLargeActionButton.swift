// The MIT License (MIT)
// Copyright © 2021 Ivan Vorobei (hello@ivanvorobei.by)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

#if canImport(UIKit) && (os(iOS))
import UIKit
import SparrowKit

/**
 NativeUIKit: Large action button.
 Usually using at bottom of screen.
 */
open class NativeLargeActionButton: SPDimmedButton {
    
    // MARK: - Data
    
    /**
     NativeUIKit: Higlight style when button pressing.
     
     If set content, only label and image change opacity.
     If choosed background, area of button will change opacity.
     */
    open var higlightStyle = HiglightStyle.default
    
    // MARK: - Init
    
    open override func commonInit() {
        super.commonInit()
        titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline, addPoints: 1)
        titleLabel?.numberOfLines = 1
        highlightOpacity = NativeAppearance.actionable_element_highlight_opacity
        titleImageInset = 6
        contentEdgeInsets = .init(horizontal: 10, vertical: 14)
    }
    
    // MARK: - Public
    
    /**
     NativeUIKit: Wrapper of set content and color of button.
     
     - parameter title: Text which using like title.
     - parameter icon: Object of `UIImage`, using like icon.
     - parameter colorise: Color of button in default state.
     */
    public func set(title: String, icon: UIImage?, colorise: SPDimmedButton.Colorise) {
        setTitle(title)
        if let icon = icon {
            setImage(icon.alwaysTemplate)
        }
        applyDefaultAppearance(with: colorise)
    }
    
    // MARK: - Layout
    
    /**
     NativeUIKit: Layout wrapper. Native way for layout button.
     */
    open func layout(y: CGFloat) {
        guard let superview = self.superview else { return }
        sizeToFit()
        let width = min(superview.readableWidth, NativeLayout.Sizes.actionable_area_maximum_width)
        frame.setWidth(width)
        superview.setXCenter()
        frame.origin.y = y
    }
    
    /**
     NativeUIKit: Layout wrapper. Native way for layout button.
     */
    open func layout(maxY: CGFloat) {
        guard let superview = self.superview else { return }
        sizeToFit()
        let width = min(superview.readableWidth, NativeLayout.Sizes.actionable_area_maximum_width)
        frame.setWidth(width)
        superview.setXCenter()
        frame.setMaxY(maxY)
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        roundCorners(radius: NativeAppearance.Corners.readable_area)
    }
    
    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        let superSize = super.sizeThatFits(size)
        let width = superSize.width
        
        var height = superSize.height
        if let titleLabel = titleLabel, let imageView = imageView, let _ = imageView.image {
            if titleLabel.frame.height > .zero && imageView.frame.height > .zero {
                let imageCorrection = imageView.frame.height - titleLabel.frame.height
                height -= imageCorrection
            }
        }
        
        return CGSize(width: width, height: height)
    }
    
    // MARK: - Ovveride
    
    open override var isHighlighted: Bool {
        didSet {
            switch higlightStyle {
            case .content:
                for view in [imageView, titleLabel] { view?.alpha = isHighlighted ? highlightOpacity : 1 }
            case .background:
                let color = backgroundColor
                backgroundColor = color?.withAlphaComponent(isHighlighted ? highlightOpacity : 1)
            }
        }
    }
    
    // MARK: - Models
    
    public enum HiglightStyle {
        
        case content
        case background
        
        static var `default`: HiglightStyle {
            return .background
        }
    }
}
#endif
