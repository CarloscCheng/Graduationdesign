//
//  Font.h
//  yizhong
//
//  Created by 张超 on 15/8/19.
//  Copyright (c) 2015年 feibo. All rights reserved.
//

#ifndef yizhong_Font_h
#define yizhong_Font_h

#define kFIX_FONT_SIZE(size) kSCREEN_WIDTH < 375 ? (size / 2.0) :  kSCREEN_WIDTH == 375 ? ((size + 4.0) / 2.0) : ((size + 8.0) / 2.0)
#define YZFont(size) [UIFont systemFontOfSize:kFIX_FONT_SIZE(size)]

#define YZSpecialFontName @"FZQKBYSJW--GB1-0"
#define YZSpecialFont(whichFont) [UIFont fontWithName:YZSpecialFontName size:[whichFont pointSize]]

#define LineSpacing_Attribute(spacing) \
({ \
NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init]; \
style.lineSpacing = spacing; \
style; \
})

#define kS1 YZFont(34.0)
#define kS2 YZFont(30.0)
#define kS3 YZFont(28.0)
#define kS4 YZFont(26.0)
#define kS5 YZFont(22.0)
#define kS6 YZFont(20.0)
#define kS7 YZFont(18.0)
#define kS8 YZFont(14.0)
#define kS9 YZFont(38.0)
#define kS10 YZFont(50.0)
#define kS11 YZFont(24.0)
#define kS22 YZFont(32.0)

#define kS3_line_spacing LineSpacing_Attribute(kFIX_FONT_SIZE(9.0))
#define kS4_line_spacing LineSpacing_Attribute(kFIX_FONT_SIZE(8.0))
#define kS6_line_spacing LineSpacing_Attribute(kFIX_FONT_SIZE(8.0))
#define kS9_line_spacing LineSpacing_Attribute(kFIX_FONT_SIZE(7.0))
#define kS11_line_spacing LineSpacing_Attribute(kFIX_FONT_SIZE(1.0))
#define kS22_line_spacing LineSpacing_Attribute(kFIX_FONT_SIZE(7.0))

#define kS3_Attributes @{NSFontAttributeName : kS3, NSParagraphStyleAttributeName : kS3_line_spacing}
#define kS4_Attributes @{NSFontAttributeName : kS4, NSParagraphStyleAttributeName : kS4_line_spacing}
#define kS9_Attributes @{NSFontAttributeName : kS9, NSParagraphStyleAttributeName : kS9_line_spacing}
#define kS11_Attributes @{NSFontAttributeName : kS11, NSParagraphStyleAttributeName : kS11_line_spacing}
#define kS22_Attributes @{NSFontAttributeName : kS22, NSParagraphStyleAttributeName : kS22_line_spacing}

#define kYZ_RIGHT_BAR_BTN_ITEM_FONT @{NSFontAttributeName : kS4, NSForegroundColorAttributeName : kC2}


#define kS3_C7_Attributes @{NSFontAttributeName : kS3, NSParagraphStyleAttributeName : kS3_line_spacing, NSForegroundColorAttributeName : kC7}
#define kS6_C7_Attributes @{NSFontAttributeName : kS6, NSParagraphStyleAttributeName : kS6_line_spacing, NSForegroundColorAttributeName : kC7}

#define kS2_C2_Attributes @{NSFontAttributeName : kS2, NSForegroundColorAttributeName : kC2}
#define kS2_C8_Attributes @{NSFontAttributeName : kS2, NSForegroundColorAttributeName : kC8}

#endif
