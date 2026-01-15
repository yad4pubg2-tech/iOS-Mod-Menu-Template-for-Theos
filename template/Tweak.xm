#import <UIKit/UIKit.h>
#import <substrate.h>
#import <mach-o/dyld.h>

// تعريف الدالة البديلة (تعادل RET)
void new_sub_376A0(void) {
    return;
}

// دالة التشغيل عند فتح اللعبة
__attribute__((constructor))
static void initialize() {
    uintptr_t anogs_base = 0;
    
    // البحث عن عنوان ملف anogs في الذاكرة
    for (uint32_t i = 0; i < _dyld_image_count(); i++) {
        const char *name = _dyld_get_image_name(i);
        if (name && strstr(name, "anogs.framework/anogs")) {
            anogs_base = (uintptr_t)_dyld_get_image_header(i);
            break;
        }
    }

    if (anogs_base != 0) {
        // تطبيق التعديل على الأوفست الذي استخرجته 0x376A0
        MSHookFunction((void *)(anogs_base + 0x376A0), (void *)&new_sub_376A0, NULL);
        
        // إظهار رسالة تأكيد على الشاشة
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Gemini Patch" 
                                                                           message:@"تم الحقن بنجاح وتعطيل الحماية!" 
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
        });
    }
}
