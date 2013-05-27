

#import <Foundation/Foundation.h>
#import <math.h>

@interface WebMercatorUtil : NSObject {

}
+ (double)toWebMercatorY:(double)latitude;
+ (double)toWebMercatorX:(double)longitude;
@end
