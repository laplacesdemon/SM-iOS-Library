//
//  AsyncImageView.m
//  Whasta
//
//  SMUtilities is a compilation of useful utilities for iOS
//  Copyright (C) 2011 Suleyman Melikoglu suleyman@melikoglu.info
//  https://github.com/laplacesdemon/SMUtilities
//
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


#import "SMAsyncImageView.h"

//NSString * const ERROR_STR_CONNECTION = @"Error, Tap to reload";
//NSString * const ERROR_STR_NOT_FOUND = @"Not Found";

@interface SMAsyncImageView (PrivateMethods)
- (void)removeSubViews;
- (void)insertErrorMessage:(NSString*)message;
- (void)prepareUI;
@end

@implementation SMAsyncImageView
@synthesize errorMessageNotFound = _errorMessageNotFound;
@synthesize errorMessageConnection = _errorMessageConnection;
@synthesize indicatorView = _indicatorView;

#pragma mark - class methods

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setErrorMessageConnection:ERROR_STR_CONNECTION];
        [self setErrorMessageNotFound:ERROR_STR_NOT_FOUND];
        [self prepareUI];
    }
    return self;
}

- (id)initWithConnectionErrorMessage:(NSString*)theConnectionMessage notFoundMessage:(NSString*)theNotFoundMessage {
    self = [super init];
    if (self) {
        [self setErrorMessageConnection:theConnectionMessage];
        [self setErrorMessageNotFound:theNotFoundMessage];
        [self prepareUI];
    }
    return self;
}

// init from interface builder
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setErrorMessageConnection:ERROR_STR_CONNECTION];
        [self setErrorMessageNotFound:ERROR_STR_NOT_FOUND];
        [self prepareUI];
    }
    return self;
}

- (void)loadImageFromUrl:(NSURL*)url {
    _url = [url retain];
    _connection = [[SMCacheConnection alloc] initWithURL:url andDelegate:self];
    
    // clear sub views if there is any
    [self removeSubViews];
    
    [_connection execute];
    
    [self sendActionsForControlEvents:UIControlEventEditingDidBegin];
}

- (void)reset {
    [self removeSubViews];
    
    if (_url) {
        SMCacheConnection* conn = [[SMCacheConnection alloc] initWithURL:_url andDelegate:self];
        [conn clearCache];
        [conn release];
    }
}

#pragma mark - memory managements

- (void)dealloc {
    [_url release];
    [_errorMessageConnection release];
    [_errorMessageNotFound release];
    [_indicatorView release];
    [super dealloc];
}

#pragma mark - private methods

- (void)removeSubViews {
    if ([[self subviews] count] > 0) {
        for (UIView* v in [self subviews]) {
            [v removeFromSuperview];
        }
    }
}

- (void)insertErrorMessage:(NSString*)message {
    UIButton* _errorButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    //[_errorButton setCenter:self.center];
    [_errorButton setTitle:message forState:UIControlStateNormal];
    [_errorButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_errorButton setBackgroundColor:[UIColor clearColor]];
    [[_errorButton titleLabel] setAdjustsFontSizeToFitWidth:YES];
    [[_errorButton titleLabel] setFont:[UIFont fontWithName:@"Arial" size:12]];
    [[_errorButton titleLabel] setNumberOfLines:2];
    [_errorButton addTarget:self action:@selector(onLoadAgain) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_errorButton];
    [_errorButton release];
}

- (void)prepareUI {
    CGRect rect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    self.indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:rect];
    [self.indicatorView setHidesWhenStopped:YES];
    [self.indicatorView stopAnimating];
    [self.indicatorView setTag:99];
    [self.indicatorView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [self.indicatorView setBackgroundColor:[UIColor whiteColor]];
}

#pragma mark - connection delegate

- (void) connectionDidStart:(SMConnection*)connection {
    [self.indicatorView startAnimating];
    [self addSubview:self.indicatorView];
}

- (void) connectionDidFinish:(SMConnection*)connection {
    // remove the indicator
    if ([[self subviews] count]>0) {
        [[[self subviews] objectAtIndex:0] removeFromSuperview];
    }
    
    // get the image from data, if the image is nil then the data is not an image
    UIImage* img = [UIImage imageWithData:connection.receivedData];
    if (img == nil) {
        [self insertErrorMessage:self.errorMessageNotFound];
        return;
    }
    
    // Resize, crop the image to make sure it is square and renders
    // well on Retina display
    float ratio;
    float delta;
    float px = 40; // Double the pixels of the UIImageView (to render on Retina)
    CGPoint offset;
    CGSize size = img.size;
    if (size.width > size.height) {
        ratio = px / size.width;
        delta = (ratio*size.width - ratio*size.height);
        offset = CGPointMake(delta/2, 0);
    } else {
        ratio = px / size.height;
        delta = (ratio*size.height - ratio*size.width);
        offset = CGPointMake(0, delta/2);
    }
    CGRect clipRect = CGRectMake(-offset.x, -offset.y,
                                 (ratio * size.width) + delta,
                                 (ratio * size.height) + delta);
    UIGraphicsBeginImageContext(CGSizeMake(px, px));
    UIRectClip(clipRect);
    [img drawInRect:clipRect];
    UIImage *imgThumb =   UIGraphicsGetImageFromCurrentImageContext();
    
    
    // create the image view
    UIImageView* imageView = [[UIImageView alloc] initWithImage:imgThumb];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    imageView.tag = 31;
    
    [self addSubview:imageView];
    [imageView release];
    [_connection release];
    
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    [self sendActionsForControlEvents:UIControlEventEditingDidEnd];
}

- (void) connectionDidFail:(SMConnection*)connection {
    // remove the indicator
    if ([[self subviews] count]>0) {
        [[[self subviews] objectAtIndex:0] removeFromSuperview];
    }
    
    [self insertErrorMessage:self.errorMessageConnection];
    
    [_connection release];
    
    [self sendActionsForControlEvents:UIControlEventEditingDidEnd];
}

- (void) onLoadAgain {
    // remove the error button
    [self reset];
    
    [self loadImageFromUrl:_url];
}

@end
