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

@objc(YXMarqueeView)
public class __private_yx_marquee_view_objc__: Marquee {
    @objc(YXMarqueeMode)
    public enum Mode: Int {
        case single
        case singleReverse
        case singleRepeat
        case singleRepeatAndReverse

        case cycle
        case cycleForce
    }

    @objc(mode)
    public var _mode = Mode.cycle {
        didSet {
            switch _mode {
            case .single:
                mode = .single(isReverse: false, isRepeat: false)
            case .singleReverse:
                mode = .single(isReverse: true, isRepeat: false)
            case .singleRepeat:
                mode = .single(isReverse: false, isRepeat: true)
            case .singleRepeatAndReverse:
                mode = .single(isReverse: true, isRepeat: true)
            case .cycle:
                mode = .cycle(force: false)
            case .cycleForce:
                mode = .cycle(force: true)
            }
        }
    }
}
