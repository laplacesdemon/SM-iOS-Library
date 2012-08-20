//
//  AsyncImageView.h
//  Whasta
//
//  SMUtilities is a compilation of useful utilities for iOS
//  Copyright (C) 2011 Suleyman Melikoglu suleyman@melikoglu.info
//  https://github.com/laplacesdemon/SMUtilities
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
// 
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
// 
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <http://www.gnu.org/licenses/>.
// 


#import <UIKit/UIKit.h>
#import "SMCacheConnection.h"

//#define ERROR_STR_CONNECTION @"Error, Tap to reload"
//#define ERROR_STR_NOT_FOUND @"Not Found"

@interface SMAsyncImageView : UIControl <SMConnectionDelegate> {
    SMCacheConnection* _connection;
    NSURL* _url;
}

@property (nonatomic, retain) NSString* errorMessageConnection;
@property (nonatomic, retain) NSString* errorMessageNotFound;
@property (nonatomic, retain) UIActivityIndicatorView* indicatorView;
@property (nonatomic) BOOL disableResizing;
@property (nonatomic) BOOL resizeWidthBased;

- (id)initWithConnectionErrorMessage:(NSString*)theConnectionMessage notFoundMessage:(NSString*)theNotFoundMessage;
- (void) loadImageFromUrl:(NSURL*)url;
- (void) onLoadAgain;
- (void) reset;

@end
