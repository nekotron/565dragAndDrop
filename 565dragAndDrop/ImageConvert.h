//
//  imageConvert.h
//  565dragAndDrop
//
//  Created by ジャスティン on 09/27/25.
//

#import <Foundation/Foundation.h>

#ifndef imageConvert_h
#define imageConvert_h
@interface ImageConvert : NSObject

- (int) parseOptions:(int) heightIn withWidth: (int) widthIn hasDirectory: (bool) hasOutputDirectoryIn withDirectory: (NSString *) outputDirectoryIn hasDebugOn: (bool) debugIn hasInterpolation: (bool) interpolateIn hasNegative: (bool) negativeIn hasPpmPreview: (bool) ppmPreviewIn;
- (int) imageConverter: (int) argc arguments: (NSArray<NSString*>*) argv;

@end
#endif /* imageConvert_h */
