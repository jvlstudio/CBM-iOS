//
//  NewsCell.h
//  CBM
//
//  Created by Felipe Ricieri on 28/05/13.
//  Copyright (c) 2013 ikomm Digital Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIImageView *imgViewBg;
@property (nonatomic, strong) IBOutlet UIImageView *imgViewPicture;
@property (nonatomic, strong) IBOutlet UILabel *labelTitle;
@property (nonatomic, strong) IBOutlet UILabel *labelDescription;
@property (nonatomic, strong) IBOutlet UILabel *labelDateDay;
@property (nonatomic, strong) IBOutlet UILabel *labelDateMonth;

@end