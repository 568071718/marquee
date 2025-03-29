// MIT License
//
// Copyright (c) 2024 - o.o.c.
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

import UIKit

@objcMembers @objc(__private_yx_marquee_view__)
public class Marquee: UIView {
    public enum Mode {
        case cycle(force: Bool)
        case single(isReverse: Bool, isRepeat: Bool)
    }

    @objc(YXMarqueeDirection)
    public enum Direction: Int {
        case left
        case right
    }

    @objc(YXMarqueeContentAlignment)
    public enum Alignment: Int {
        case center
        case top
        case bottom
        case left
        case right
    }

    public var content: UIView? {
        didSet { setNeedsLayout() }
    }

    public var autoSizeContent = true {
        didSet { setNeedsLayout() }
    }

    public var pause = false {
        didSet { setPause(pause: pause) }
    }

    public var speed = 60.0 {
        didSet { setNeedsLayout() }
    }

    public var mode = Mode.cycle(force: false) {
        didSet { setNeedsLayout() }
    }

    public var direction = Direction.left {
        didSet { setNeedsLayout() }
    }

    public var contentAlignment = Alignment.left {
        didSet { setNeedsLayout() }
    }

    public var contentVerticalAlignment = Alignment.center {
        didSet { setNeedsLayout() }
    }

    public var contentSpacing = 20.0 {
        didSet { setNeedsLayout() }
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
    }

    deinit {
        clear()
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        clear()

        if autoSizeContent { content?.sizeToFit() }

        switch mode {
        case .single(let isReverse, let isRepeat):
            singleMode(isReverse: isReverse, isRepeat: isRepeat)
        case .cycle(let force):
            cycleMode(force: force)
        }
    }

    // MARK: -

    private var contentViews: [UIView] = []
    private func clear() {
        for (index, view) in contentViews.enumerated().reversed() {
            view.removeFromSuperview()
            view.layer.removeAllAnimations()
            contentViews.remove(at: index)
        }
    }

    private func getContentX() -> CGFloat {
        guard let content = content else { return 0 }
        switch contentAlignment {
        case .center, .top, .bottom:
            return (frame.width - content.frame.width) * 0.5
        case .left:
            return 0.0
        case .right:
            return frame.width - content.frame.width
        }
    }

    private func getContentY() -> CGFloat {
        guard let content = content else { return 0 }
        switch contentVerticalAlignment {
        case .center, .left, .right:
            return (frame.height - content.frame.height) * 0.5
        case .top:
            return 0
        case .bottom:
            return frame.height - content.frame.height
        }
    }

    private func cloneContent(content: UIView) -> UIView {
        let data = NSKeyedArchiver.archivedData(withRootObject: content)
        return NSKeyedUnarchiver.unarchiveObject(with: data) as! UIView
    }
}

private extension Marquee {
    func setPause(pause: Bool) {
        if pause {
            let pausedTime = layer.convertTime(CACurrentMediaTime(), from: nil)
            layer.speed = 0
            layer.timeOffset = pausedTime
        } else {
            let pausedTime = layer.timeOffset
            layer.speed = 1.0
            layer.timeOffset = 0.0
            layer.beginTime = 0.0
            let timeSincePause = layer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
            layer.beginTime = timeSincePause
        }
    }
}

private extension Marquee {
    func singleMode(isReverse: Bool, isRepeat: Bool) {
        guard let content = content else { return }

        let view = cloneContent(content: content)
        addSubview(view)
        contentViews.append(view)

        if content.frame.width <= self.frame.width {
            var frame = view.frame
            frame.origin.x = getContentX()
            frame.origin.y = getContentY()
            view.frame = frame
            return
        }

        var frame = view.frame
        frame.origin.y = getContentY()
        frame.origin.x = 0
        if direction == .right {
            frame.origin.x = self.frame.width - view.frame.width
        }
        view.frame = frame

        let distance = content.frame.width - self.frame.width
        let startPosX = content.frame.minX + content.frame.width * 0.5
        var endPosX = startPosX - distance
        if direction == .right {
            endPosX = startPosX + distance
        }
        let anim = CAKeyframeAnimation(keyPath: "position.x")
        anim.values = [startPosX, endPosX]
        anim.duration = distance / speed
        anim.autoreverses = isReverse
        if isRepeat {
            anim.repeatCount = .infinity
        } else {
            anim.fillMode = .forwards
            anim.isRemovedOnCompletion = false
        }
        view.layer.add(anim, forKey: nil)
    }
}

private extension Marquee {
    func cycleMode(force: Bool) {
        guard let content = content else { return }

        if force == false, content.frame.width <= frame.width {
            addSubview(content)
            contentViews.append(content)
            var frame = content.frame
            frame.origin.x = getContentX()
            frame.origin.y = getContentY()
            content.frame = frame
            return
        }

        var width = 0.0
        while width < frame.width + content.frame.width + contentSpacing {
            let view = cloneContent(content: content)
            var frame = view.frame
            frame.origin.x = width + (contentViews.count >= 1 ? contentSpacing : 0.0)
            frame.origin.y = getContentY()
            view.frame = frame
            addSubview(view)
            contentViews.append(view)
            width = frame.maxX
        }

        for view in contentViews {
            let distance = view.frame.width + contentSpacing
            var startPosX = view.frame.minX + view.frame.width * 0.5
            var endPosX = startPosX - distance
            if direction == .right {
                startPosX = view.frame.minX + view.frame.width * 0.5 - (width - frame.width)
                endPosX = startPosX + distance
            }
            let anim = CAKeyframeAnimation(keyPath: "position.x")
            anim.values = [startPosX, endPosX]
            anim.duration = distance / speed
            anim.repeatCount = .infinity
            view.layer.add(anim, forKey: nil)
        }
    }
}
