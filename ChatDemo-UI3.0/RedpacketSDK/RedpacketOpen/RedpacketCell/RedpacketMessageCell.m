//
//  RedpacketMessageCell.m
//  ChatDemo-UI3.0
//
//  Created by Mr.Yang on 16/2/28.
//


#import "RedpacketMessageCell.h"
#import "RedpacketOpenConst.h"
#import "EaseMob.h"
#import "RedpacketMessageModel.h"


@interface RedpacketMessageCell ()

@property (nonatomic, assign)   IBOutlet UILabel *titleLabel;
@property (nonatomic, assign)   IBOutlet UIImageView *icon;
@property (nonatomic, assign)   IBOutlet UIView *backView;

@property (nonatomic, assign)   IBOutlet NSLayoutConstraint *widthContraint;

@end

@implementation RedpacketMessageCell

- (void)awakeFromNib {
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.titleLabel.textColor = rp_hexColor(rp_textColorGray);
    
    self.backView.layer.cornerRadius = 3.0f;
    self.backView.layer.masksToBounds = YES;
    
    [self.icon setImage:[UIImage imageNamed:@"RedpacketCellResource.bundle/redpacket_smallIcon"]];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backViewTaped)];
    [self.backView addGestureRecognizer:tap];
    
    self.backView.backgroundColor = rp_hexColor(rp_backGroundColorGray);
}

- (void)setModel:(id<IMessageModel>)model
{
    _model = model;
    
    /*-------为了兼容红包2.0版本--------*/
    NSString *text = model.text;
    if (model.bodyType == eMessageBodyType_Text &&
        model.message.messageType == eMessageTypeChat) {
        
        NSDictionary *dict = model.message.ext;
        NSString *currentUserId = [[[[EaseMob sharedInstance] chatManager] loginInfo] objectForKey:kSDKUsername];
        NSString *receiverId = [dict valueForKey:RedpacketKeyRedpacketReceiverId];
        
        BOOL isReceiver = [receiverId isEqualToString:currentUserId];
        if (isReceiver) {
            NSString *sender = [dict valueForKey:RedpacketKeyRedpacketSenderNickname];
            if (sender.length == 0) {
                sender = [dict valueForKey:RedpacketKeyRedpacketSenderId];
            }
            text = [NSString stringWithFormat:@"你领取了%@的红包", sender];
        }else {
            NSString *receiver = [dict valueForKey:RedpacketKeyRedpacketReceiverNickname];
            if (receiver.length == 0) {
                receiver = [dict valueForKey:RedpacketKeyRedpacketReceiverId];
            }
            text = [NSString stringWithFormat:@"%@领取了你的红包", receiver];
        }
    }
    
    /*-------------------------------------------*/
    
    self.titleLabel.text = text;
    CGSize size = [self.titleLabel sizeThatFits:CGSizeMake(200, 20)];
    self.widthContraint.constant = size.width + 30;
    [self.backView updateConstraintsIfNeeded];
}

- (void)backViewTaped
{
    if (_redpacketMesageCellTaped) {
        _redpacketMesageCellTaped(_model);
    }
}

@end
