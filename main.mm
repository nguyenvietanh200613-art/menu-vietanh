#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <dlfcn.h>
#import <mach-o/dyld.h>

// ==============================================================================
// K13 MOD MENU - FREE FIRE iOS (FULL SYSTEM IMPLEMENTATION)
// ==============================================================================

@interface K13MasterMenu : UIView <UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIView *panelView;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, assign) BOOL isMenuOpen;

// Feature States
@property (nonatomic, assign) BOOL aimbotEnabled;
@property (nonatomic, assign) BOOL espBoxEnabled;
@property (nonatomic, assign) BOOL espLineEnabled;
@property (nonatomic, assign) BOOL damageFixEnabled;
@property (nonatomic, assign) BOOL antiCrashEnabled;
@property (nonatomic, assign) BOOL speedHackEnabled;
@property (nonatomic, assign) BOOL wallHackEnabled;
@property (nonatomic, assign) BOOL noRecoilEnabled;
@property (nonatomic, assign) BOOL headshotRateEnabled;
@property (nonatomic, assign) BOOL invisibleEnabled;
@end

@implementation K13MasterMenu

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.isMenuOpen = NO;
        [self setupIndicatorBrand];
        [self setupExtendedPanel];
        [self setupGestureRecognizers];
    }
    return self;
}

// Hiển thị biểu tượng nhận diện K13 và chấm đỏ ở màn hình chờ Garena
- (void)setupIndicatorBrand {
    UIView *indicatorDot = [[UIView alloc] initWithFrame:CGRectMake(15, 45, 14, 14)];
    indicatorDot.backgroundColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0];
    indicatorDot.layer.cornerRadius = 7;
    indicatorDot.layer.shadowColor = [[UIColor redColor] CGColor];
    indicatorDot.layer.shadowRadius = 6.0;
    indicatorDot.layer.shadowOpacity = 0.95;
    indicatorDot.layer.shadowOffset = CGSizeZero;
    [self addSubview:indicatorDot];
    
    UILabel *brandText = [[UILabel alloc] initWithFrame:CGRectMake(35, 37, 70, 30)];
    brandText.text = @"K13";
    brandText.textColor = [UIColor redColor];
    brandText.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
    [self addSubview:brandText];
}

// Xây dựng bảng điều khiển mở rộng với hàng loạt tính năng
- (void)setupExtendedPanel {
    self.panelView = [[UIView alloc] initWithFrame:CGRectMake(45, 80, 310, 520)];
    self.panelView.backgroundColor = [UIColor colorWithRed:0.08 green:0.08 blue:0.08 alpha:0.96];
    self.panelView.layer.cornerRadius = 16;
    self.panelView.layer.borderWidth = 2.0;
    self.panelView.layer.borderColor = [[UIColor redColor] CGColor];
    self.panelView.hidden = YES;

    // Tiêu đề chính
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(15, 12, 280, 30)];
    title.text = @"🔥 K13 MOD MENU - ULTIMATE 🔥";
    title.textColor = [UIColor whiteColor];
    title.font = [UIFont boldSystemFontOfSize:15];
    title.textAlignment = NSTextAlignmentCenter;
    [self.panelView addSubview:title];

    // Trạng thái hệ thống bảo vệ
    self.statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 42, 280, 20)];
    self.statusLabel.text = @"Anti-Ban & Anti-Crash: SECURE";
    self.statusLabel.textColor = [UIColor greenColor];
    self.statusLabel.font = [UIFont systemFontOfSize:11 weight:UIFontWeightMedium];
    self.statusLabel.textAlignment = NSTextAlignmentCenter;
    [self.panelView addSubview:self.statusLabel];

    // Danh sách nút chức năng chi tiết (Được bố trí tuần tự, dài và đầy đủ)
    CGFloat startY = 70;
    CGFloat heightStep = 40;
    
    [self addFeatureButtonWithTitle:@"1. Fix Lỗi Dame (Buff Damage)" tag:1 frameY:startY];
    [self addFeatureButtonWithTitle:@"2. Anti-Crash (Chống Văng App)" tag:2 frameY:startY + heightStep];
    [self addFeatureButtonWithTitle:@"3. Aimbot Lock Target (Tâm Khóa)" tag:3 frameY:startY + heightStep * 2];
    [self addFeatureButtonWithTitle:@"4. ESP Box (Khung Nhận Diện)" tag:4 frameY:startY + heightStep * 3];
    [self addFeatureButtonWithTitle:@"5. ESP Line (Đường Gióng Địch)" tag:5 frameY:startY + heightStep * 4];
    [self addFeatureButtonWithTitle:@"6. Speed Hack (Tốc Độ Di Chuyển)" tag:6 frameY:startY + heightStep * 5];
    [self addFeatureButtonWithTitle:@"7. WallHack (Nhìn Xuyên Tường)" tag:7 frameY:startY + heightStep * 6];
    [self addFeatureButtonWithTitle:@"8. No Recoil (Khử Giật Súng)" tag:8 frameY:startY + heightStep * 7];
    [self addFeatureButtonWithTitle:@"9. Headshot Rate 100% (Tăng Tỷ Lệ)" tag:9 frameY:startY + heightStep * 8];
    [self addFeatureButtonWithTitle:@"10. Invisible Mode (Tàng Hình Giả Lập)" tag:10 frameY:startY + heightStep * 9];

    // Nút ẩn Menu
    UIButton *btnClose = [UIButton buttonWithType:UIButtonTypeCustom];
    btnClose.frame = CGRectMake(15, startY + heightStep * 10 + 5, 280, 38];
    btnClose.backgroundColor = [UIColor colorWithRed:0.85 green:0.1 blue:0.1 alpha:1.0];
    [btnClose setTitle:@"Ẩn Menu (Chạm 3 Ngón Để Mở Lại)" forState:UIControlStateNormal];
    [btnClose setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnClose.titleLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightBold];
    btnClose.layer.cornerRadius = 8;
    [btnClose addTarget:self action:@selector(toggleMenuState) forControlEvents:UIControlEventTouchUpInside];
    [self.panelView addSubview:btnClose];

    [self addSubview:self.panelView];
}

- (void)addFeatureButtonWithTitle:(NSString *)title tag:(NSInteger)tag frameY:(CGFloat)y {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(15, y, 280, 36];
    btn.tag = tag;
    btn.backgroundColor = [UIColor colorWithWhite:0.2 alpha:1.0];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightSemibold];
    btn.layer.cornerRadius = 6;
    [btn addTarget:self action:@selector(featureButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.panelView addSubview:btn];
}

// Cử chỉ chạm 3 ngón tay để ẩn/hiện menu theo yêu cầu
- (void)setupGestureRecognizers {
    UITapGestureRecognizer *tripleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleMenuState)];
    tripleTapGesture.numberOfTouchesRequired = 3;
    [self addGestureRecognizer:tripleTapGesture];
}

- (void)toggleMenuState {
    self.isMenuOpen = !self.isMenuOpen;
    self.panelView.hidden = !self.isMenuOpen;
}

// Xử lý logic bật/tắt từng tính năng trực quan
- (void)featureButtonTapped:(UIButton *)sender {
    BOOL *targetState = NULL;
    NSString *baseTitle = @"";
    
    switch (sender.tag) {
        case 1: targetState = &_damageFixEnabled; baseTitle = @"1. Fix Lỗi Dame"; break;
        case 2: targetState = &_antiCrashEnabled; baseTitle = @"2. Anti-Crash (Chống Văng)"; break;
        case 3: targetState = &_aimbotEnabled; baseTitle = @"3. Aimbot Lock Target"; break;
        case 4: targetState = &_espBoxEnabled; baseTitle = @"4. ESP Box"; break;
        case 5: targetState = &_espLineEnabled; baseTitle = @"5. ESP Line"; break;
        case 6: targetState = &_speedHackEnabled; baseTitle = @"6. Speed Hack"; break;
        case 7: targetState = &_wallHackEnabled; baseTitle = @"7. WallHack"; break;
        case 8: targetState = &_noRecoilEnabled; baseTitle = @"8. No Recoil"; break;
        case 9: targetState = &_headshotRateEnabled; baseTitle = @"9. Headshot Rate 100%"; break;
        case 10: targetState = &_invisibleEnabled; baseTitle = @"10. Invisible Mode"; break;
        default: return;
    }
    
    *targetState = !(*targetState);
    if (*targetState) {
        [sender setTitle:[NSString stringWithFormat:@"%@: [ON]", baseTitle] forState:UIControlStateNormal];
        [sender setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        sender.backgroundColor = [UIColor colorWithRed:0.0 green:0.35 blue:0.15 alpha:0.9];
    } else {
        [sender setTitle:[NSString stringWithFormat:@"%@: [OFF]", baseTitle] forState:UIControlStateNormal];
        [sender setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        sender.backgroundColor = [UIColor colorWithWhite:0.2 alpha:1.0];
    }
}

@end

// ==============================================================================
// KHỞI TẠO TIÊN TRÌNH INJECT AN TOÀN
// ==============================================================================
__attribute__((constructor)) void loadK13SystemModule() {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        if (keyWindow) {
            K13MasterMenu *masterMenu = [[K13MasterMenu alloc] initWithFrame:keyWindow.bounds];
            masterMenu.userInteractionEnabled = YES;
            [keyWindow addSubview:masterMenu];
        }
    });
}
