//
//  Colors.h
//  yizhong
//
//  Created by 张超 on 15/8/19.
//  Copyright (c) 2015年 feibo. All rights reserved.
//

#ifndef yizhong_Colors_h
#define yizhong_Colors_h

#define FB_RGBA(r, g, b, a) [UIColor colorWithRed:(r) / 255.0 \
                                            green:(g) / 255.0 \
                                             blue:(b) / 255.0 \
                                            alpha:(a)]

#define FB_RGB(r, g, b) FB_RGBA(r, g, b, 1.0)

#define FB_GRAY(c) FB_RGB(c, c, c)

#define kC1 FB_GRAY(0x00)
#define kC2 FB_RGB(0x39, 0x3b, 0x3b)
#define kC3 FB_RGB(0x7a, 0x80, 0x89)
#define kC4 FB_GRAY(0xd1)
#define kC5 FB_GRAY(0xe2)
#define kC6 FB_GRAY(0xf8)
#define kC7 FB_GRAY(0xff)
#define kC8 FB_RGB(0xae, 0x6e, 0x63)
#define kC23 FB_GRAY(0xad)
#define kC24 FB_GRAY(0xdb)
#define kC25 FB_RGB(0xce, 0xcc, 0xcc)
#define kC26 FB_GRAY(0xf4)
#define kC27 FB_GRAY(0x6e)

#endif
