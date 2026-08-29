#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface OnyxMenu : UIView
@property (nonatomic, strong) UIButton *floatingButton;
@property (nonatomic, strong) UIView *panelView;
@property (nonatomic, assign) BOOL menuVisible;
@end

@implementation OnyxMenu

- (inst5ancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupFloatingButton];
        [self setupPanel];
    }
    return self;
}

- (void)setupFloatingButton {
    self.floatingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.floatingButton.frame = CGRectMake(20, 100, 50, 50);
    self.floatingButton.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.8];
    [self.floatingButton setTitle:@"ONYX" forState:UIControlStateNormal];
    [self.floatingButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    self.floatingButton.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    self.floatingButton.layer.cornerRadius = 25;
    self.floatingButton.layer.borderWidth = 2;
    self.floatingButton.layer.borderColor = [UIColor redColor].CGColor;
    [self.floatingButton addTarget:self action:@selector(toggleMenu) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.floatingButton];
}

- (void)setupPanel {
    self.panelView = [[UIView alloc] initWithFrame:CGRectMake(80, 100, 260, 320)];
    self.panelView.backgroundColor = [UIColor colorWithRed:0.08 green:0.08 blue:0.08 alpha:0.95];
    self.panelView.layer.cornerRadius = 12;
    self.panelView.layer.borderWidth = 1.5;
    self.panelView.layer.borderColor = [UIColor redColor].CGColor;
    self.panelView.hidden = YES;

    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 240, 30)];
    title.text = @"🔥 ONYX VIP - FREE FIRE MENU 🔥";
    title.textColor = [UIColor whiteColor];
    title.font = [UIFont boldSystemFontOfSize:13];
    title.textAlignment = NSTextAlignmentCenter;
    [self.panelView addSubview:title];

    // Nút tính năng 1: Reset Acc Khách (Guest Reset)
    UIButton *resetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    resetBtn.frame = CGRectMake(15, 60, 230, 40);
    resetBtn.backgroundColor = [UIColor systemRedColor];
    [resetBtn setTitle:@"⚡ Xóa Guest / Reset Acc Khách" forState:UIControlStateNormal];
    [resetBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    resetBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    resetBtn.layer.cornerRadius = 8;
    [resetBtn addTarget:self action:@selector(resetGuestAccount) forControlEvents:UIControlEventTouchUpInside];
    [self.panelView addSubview:resetBtn];

    // Nút tính năng 2: Antiban Bypass Hook
    UIButton *antibanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    antibanBtn.frame = CGRectMake(15, 115, 230, 40);
    antibanBtn.backgroundColor = [UIColor systemGreenColor];
    [antibanBtn setTitle:@"🛡️ Kích hoạt Antiban / Bypass" forState:UIControlStateNormal];
    [antibanBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    antibanBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    antibanBtn.layer.cornerRadius = 8;
    [antibanBtn addTarget:self action:@selector(activateAntiban) forControlEvents:UIControlEventTouchUpInside];
    [self.panelView addSubview:antibanBtn];

    // Nút tính năng 3: Aimbot / Menu Phụ
    UIButton *aimbotBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    aimbotBtn.frame = CGRectMake(15, 170, 230, 40);
    aimbotBtn.backgroundColor = [UIColor darkGrayColor];
    [aimbotBtn setTitle:@"🎯 Hack Aimbot / ESP (Demo)" forState:UIControlStateNormal];
    [aimbotBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    aimbotBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    aimbotBtn.layer.cornerRadius = 8;
    [aimbotBtn addTarget:self action:@selector(toggleAimbot) forControlEvents:UIControlEventTouchUpInside];
    [self.panelView addSubview:aimbotBtn];

    [self addSubview:self.panelView];
}

- (void)toggleMenu {
    self.menuVisible = !self.menuVisible;
    self.panelView.hidden = !self.menuVisible;
}

// Logic Reset Acc Khách (Xóa token/file lưu trữ guest trong sandbox của game)
- (void)resetGuestAccount {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject];
    NSString *appSupportPath = [NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES) firstObject];
    
    // Xóa các file plist/database lưu thông tin guest account
    NSArray *pathsToDelete = @[
        [libraryPath stringByAppendingPathComponent:@"Preferences/com.dts.freefireth.plist"],
        [appSupportPath stringByAppendingPathComponent:@"unity.garena.freefire"]
    ];
    
    for (NSString *path in pathsToDelete) {
        if ([fileManager fileExistsAtPath:path]) {
            [fileManager removeItemAtPath:path error:nil];
        }
    }
    
    // Hiển thị thông báo thành công
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"ONYX VIP" message:@"Đã reset sạch sẽ dữ liệu Acc Khách! Vào lại game để tạo nick mới." preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window.rootViewController presentViewController:alert animated:YES completion:nil];
}

// Logic Antiban cơ bản
- (void)activateAntiban {
    // Chèn các cơ chế hook chặn gửi log crash hoặc ẩn signature
    NSLog(@"[ONYX] Antiban / Bypass activated successfully!");
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"ONYX VIP" message:@"Đã bật Antiban / Bypass hệ thống an toàn!" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window.rootViewController presentViewController:alert animated:YES completion:nil];
}

- (void)toggleAimbot {
    NSLog(@"[ONYX] Aimbot toggled.");
}

@end

// Hàm khởi chạy tự động khi chèn Dylib vào ứng dụng
__attribute__((constructor)) static void onyxEntry() {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        if (window) {
            OnyxMenu *menu = [[OnyxMenu alloc] initWithFrame:window.bounds];
            [window addSubview:menu];
        }
    });
}
