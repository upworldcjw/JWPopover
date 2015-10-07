//
//  JWPopupViewController.m
//  JWPopViewController
//
//  Created by jianwei.chen on 15/10/7.
//  Copyright © 2015年 jianwei.chen. All rights reserved.
//

#import "JWPopupViewController.h"
#import "JWPopoverController.h"

@interface NBPopupTableViewCell : UITableViewCell
@property(nonatomic,strong) UILabel *contentLabel;
@property(nonatomic,strong) UIView  *hLineView;
@end
@implementation NBPopupTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentLabel = [UILabel new];
        [self.contentLabel setFont:[UIFont systemFontOfSize:15]];
        [self.contentLabel setTextColor:[UIColor whiteColor]];
        [self.contentLabel setHighlightedTextColor:[UIColor lightGrayColor]];
//        self.contentLabel.userInteractionEnabled = YES;
        self.contentLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.contentLabel];
        
        self.hLineView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chatlist_rightBtn_line"]];
        self.hLineView.backgroundColor = [UIColor colorWithWhite:.5 alpha:.5];
        [self.contentView addSubview:self.hLineView];
        
//        [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.center.equalTo(self);
//        }];
//
//        [self.hLineView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(10);
//            make.right.equalTo(-10);
//            make.height.equalTo(1/[UIScreen mainScreen].scale);
//            make.bottom.equalTo(self);
//        }];
    }
    return self;
}

-(void)layoutSubviews{
    [self.contentLabel setFrame:self.bounds];
    self.contentLabel.center = CGPointMake(self.frame.size.width/2.0, self.frame.size.height/2.0);
    CGFloat lineHeight = 1/[UIScreen mainScreen].scale;
    self.hLineView.frame = CGRectMake(10, self.frame.size.height - lineHeight, self.frame.size.width - 2*10, lineHeight);
}

@end


@interface JWPopupViewController(){
   __weak JWPopoverController *_popController; //import weak。否则会循环引用
}

@end

@implementation JWPopupViewController

-(void)dealloc{
    
}

-(instancetype)initWithStyle:(UITableViewStyle)style{
    if (self = [super initWithStyle:style]) {
        self.modelPresent = YES;
        [self.view setBackgroundColor:self.popContentColor?self.popContentColor:[UIColor clearColor]];
        self.tableView.rowHeight = 44;
        self.maxPopContentSize = CGSizeMake(100, 200);
        self.tableView.dataSource = self;
        self.tableView.delegate =self;
        self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        self.tableView.separatorColor = [UIColor colorWithWhite:.5 alpha:.5];
        [self.view addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:(void *)self];
    }
    return self;
}

-(void)autoSizeFrame{
    [self.tableView reloadData];

    CGFloat needHeight = [self.dataSource count] * self.tableView.rowHeight;
    if (needHeight > self.maxPopContentSize.height) {
        self.tableView.scrollEnabled = YES;
        [self.view setFrame:(CGRect){{0,0},_maxPopContentSize}];
    }else{
        self.tableView.scrollEnabled = NO;
        [self.view setFrame:(CGRect){{0,0},{self.maxPopContentSize.width,needHeight}}];
    }
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if (context == (__bridge void *)self) {
        if (object == self.view) {
            
            CGFloat needHeight = [self.dataSource count] * self.tableView.rowHeight;
            if(self.view.frame.size.height < needHeight){//view frame过小
                self.tableView.scrollEnabled = YES;
            }else{
                self.tableView.scrollEnabled = NO;
            };
            return;
        }
    }
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}



-(void)showAtRect:(CGRect)rect{
    [self showAtRect:rect onView:nil];
}

-(void)showAtRect:(CGRect)rect onView:(UIView *)view{
    [self autoSizeFrame];
    JWPopoverController *popoverController = [[JWPopoverController alloc] initWithContentViewController:self];
    popoverController.modelPresent = self.modelPresent;
    
    if (self.hasArrow) {
        popoverController.arrowWidth = 0;
        popoverController.arrowHeight = 0;
    }else{
        popoverController.arrowWidth = 14;
        popoverController.arrowHeight = 8;
    }
    if ([self.popTitle length]) {
        popoverController.innerCornerRadius = 5;
        popoverController.outterCornerRadius = 8;
    }else{
        popoverController.innerCornerRadius = 5;
        popoverController.outterCornerRadius = 0;
    }
    popoverController.titleText = self.popTitle;

    popoverController.popoverBaseColor = self.popBgColor? self.popBgColor:[UIColor colorWithRed:0x66/(CGFloat)0xff green:0x66/(CGFloat)0xff blue:(CGFloat)0x66/0xff alpha:1];
    
    [popoverController showPopoverWithRect:CGRectOffset(rect, 0, 0) onView:view];
    
    _popController = popoverController;
}

- (void)dismissCustomedPopoverAnimatd:(BOOL)animated{
    [_popController dismissPopoverAnimatd:YES];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_dataSource count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *const identifier = @"UITableViewCell";
    NBPopupTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[NBPopupTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        [cell setBackgroundColor:[UIColor clearColor]];
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        cell.selectedBackgroundView = [UIView new];
    }
    cell.contentLabel.text = (NSString *)[self.dataSource objectAtIndex:indexPath.row];
    cell.contentLabel.textColor = [UIColor whiteColor];
    if(indexPath.row == [_dataSource count] -1){
        cell.hLineView.hidden = YES;
    }else{
        cell.hLineView.hidden = NO;
    }
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    NBPopupTableViewCell *cell = (NBPopupTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self.delegate respondsToSelector:@selector(popUpViewSelectedIndex:)]) {
        [self.delegate popUpViewSelectedIndex:indexPath.row];
    }
    [_popController dismissPopoverAnimatd:YES];
}

@end
