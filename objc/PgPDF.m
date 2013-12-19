/* Copyright 2013 Matthew Martin
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "PgPDF.h"

@implementation PgPDF

float dpi = 72; // Only 72 dpi for now, but should look into ways to support higher resolution
UIFont *currentFont = nil;

- (void) createDocument:(CDVInvokedUrlCommand*) command
{
    NSString* pdfFileName = [command.arguments objectAtIndex:0];
    float width  = [[command.arguments objectAtIndex:1] floatValue] * dpi;
    float height = [[command.arguments objectAtIndex:2] floatValue] * dpi;
    
    UIGraphicsBeginPDFContextToFile(pdfFileName, CGRectZero, nil);
    UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, width, height), nil);
    
    if(currentFont == nil) { currentFont = [UIFont systemFontOfSize:12]; }

    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:pdfFileName];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) addPage:(CDVInvokedUrlCommand*) command
{
    float width  = [[command.arguments objectAtIndex:0] floatValue] * dpi;
    float height = [[command.arguments objectAtIndex:1] floatValue] * dpi;
    
    UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, width, height), nil);
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) closeDocument:(CDVInvokedUrlCommand*) command {
    UIGraphicsEndPDFContext();
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) setStrokeColor:(CDVInvokedUrlCommand*) command
{
    int red     = [[command.arguments objectAtIndex:0] intValue];
    int green   = [[command.arguments objectAtIndex:1] intValue];
    int blue    = [[command.arguments objectAtIndex:2] intValue];
    float alpha = [[command.arguments objectAtIndex:3] floatValue];
    
    float redNorm = red / 255.0;
    float greenNorm = green / 255.0;
    float blueNorm = blue / 255.0;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    CGFloat components[] = { redNorm, greenNorm, blueNorm, alpha };
    CGColorRef color = CGColorCreate(colorspace, components);
    CGContextSetStrokeColorWithColor(context, color);
    CGColorSpaceRelease(colorspace);
    CGColorRelease(color);
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) setFillColor:(CDVInvokedUrlCommand*) command
{
    int red     = [[command.arguments objectAtIndex:0] intValue];
    int green   = [[command.arguments objectAtIndex:1] intValue];
    int blue    = [[command.arguments objectAtIndex:2] intValue];
    float alpha = [[command.arguments objectAtIndex:3] floatValue];
    
    float redNorm = red / 255.0;
    float greenNorm = green / 255.0;
    float blueNorm = blue / 255.0;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    CGFloat components[] = { redNorm, greenNorm, blueNorm, alpha };
    CGColorRef color = CGColorCreate(colorspace, components);
    CGContextSetFillColorWithColor(context, color);
    CGColorSpaceRelease(colorspace);
    CGColorRelease(color);
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) setTextFont:(CDVInvokedUrlCommand*) command
{
    NSString *fontName = [command.arguments objectAtIndex:0];
    
    currentFont = [UIFont fontWithName:fontName size:currentFont.pointSize];
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) setTextSize:(CDVInvokedUrlCommand*) command
{
    float pointSize = [[command.arguments objectAtIndex:0] floatValue];
    
    currentFont = [UIFont fontWithName:currentFont.fontName size:pointSize];
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) drawTextInBox:(CDVInvokedUrlCommand*) command
{
    NSString* text = [command.arguments objectAtIndex:0];
    float left = [[command.arguments objectAtIndex:1] floatValue] * dpi;
    float top  = [[command.arguments objectAtIndex:2] floatValue] * dpi;
    float width  = [[command.arguments objectAtIndex:3] floatValue] * dpi;
    float height = [[command.arguments objectAtIndex:4] floatValue] * dpi;
    bool overflowBox = [[command.arguments objectAtIndex:5] boolValue];
    
    CGSize maxSize = CGSizeMake(width, height);
    
    enum NSLineBreakMode lineBreakMode = (overflowBox) ? NSLineBreakByWordWrapping : NSLineBreakByClipping;
    
    CGSize pageStringSize = [text sizeWithFont:currentFont constrainedToSize:maxSize lineBreakMode:lineBreakMode];
    CGRect stringRect = CGRectMake(left, top, pageStringSize.width, pageStringSize.height);
    
    [text drawInRect:stringRect withFont:currentFont];
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) drawLine:(CDVInvokedUrlCommand*) command
{
    float startX = [[command.arguments objectAtIndex:0] floatValue] * dpi;
    float startY = [[command.arguments objectAtIndex:1] floatValue] * dpi;
    float endX = [[command.arguments objectAtIndex:2] floatValue] * dpi;
    float endY = [[command.arguments objectAtIndex:3] floatValue] * dpi;
    float width = [[command.arguments objectAtIndex:4] floatValue]; // width in points, not inches
    NSString* capStyleString = [command.arguments objectAtIndex:5];
    
    enum CGLineCap capStyle = kCGLineCapButt;
    if([capStyleString isEqualToString:@"round"]) { capStyle = kCGLineCapRound; }
    if([capStyleString isEqualToString:@"square"]) { capStyle = kCGLineCapSquare; }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineCap(context, capStyle);
    CGContextSetLineWidth(context, width);
    CGContextMoveToPoint(context, startX, startY);
    CGContextAddLineToPoint(context, endX, endY);
    CGContextStrokePath(context);
}

- (void) drawRect:(CDVInvokedUrlCommand*) command
{
    float left = [[command.arguments objectAtIndex:0] floatValue] * dpi;
    float top  = [[command.arguments objectAtIndex:1] floatValue] * dpi;
    float width  = [[command.arguments objectAtIndex:2] floatValue] * dpi;
    float height = [[command.arguments objectAtIndex:3] floatValue] * dpi;
    float lineWidth = [[command.arguments objectAtIndex:4] floatValue]; // width in points, not inches
    bool  isFilled  = [[command.arguments objectAtIndex:5] boolValue];
    NSString* cornerStyleString = [command.arguments objectAtIndex:6];
    
    enum CGLineJoin cornerStyle = kCGLineJoinBevel;
    if([cornerStyleString isEqualToString:@"round"]) { cornerStyle = kCGLineJoinRound; }
    if([cornerStyleString isEqualToString:@"miter"]) { cornerStyle = kCGLineJoinMiter; }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect rect = CGRectMake(left, top, width, height);
    CGContextSetLineWidth(context, lineWidth);
    CGContextSetLineJoin(context, cornerStyle);
    if(isFilled) { CGContextFillRect(context, rect); }
    CGContextStrokeRect(context, rect);
}

- (void) drawRoundRect:(CDVInvokedUrlCommand*) command
{
    float left = [[command.arguments objectAtIndex:0] floatValue] * dpi;
    float top  = [[command.arguments objectAtIndex:1] floatValue] * dpi;
    float width  = [[command.arguments objectAtIndex:2] floatValue] * dpi;
    float height = [[command.arguments objectAtIndex:3] floatValue] * dpi;
    float radius = [[command.arguments objectAtIndex:4] floatValue] * dpi;
    float lineWidth = [[command.arguments objectAtIndex:5] floatValue]; // width in points, not inches
    bool  isFilled  = [[command.arguments objectAtIndex:6] boolValue];
    NSString* cornerStyleString = [command.arguments objectAtIndex:6];

    enum CGLineJoin cornerStyle = kCGLineJoinBevel;
    if([cornerStyleString isEqualToString:@"round"]) { cornerStyle = kCGLineJoinRound; }
    if([cornerStyleString isEqualToString:@"miter"]) { cornerStyle = kCGLineJoinMiter; }

    // TODO: Rounded rectangle implementation
}

- (void) drawEllipseInRect:(CDVInvokedUrlCommand*) command
{
    float left = [[command.arguments objectAtIndex:0] floatValue] * dpi;
    float top  = [[command.arguments objectAtIndex:1] floatValue] * dpi;
    float width  = [[command.arguments objectAtIndex:2] floatValue] * dpi;
    float height = [[command.arguments objectAtIndex:3] floatValue] * dpi;
    float lineWidth = [[command.arguments objectAtIndex:4] floatValue]; // width in points, not inches
    bool  isFilled  = [[command.arguments objectAtIndex:5] boolValue];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect rect = CGRectMake(left, top, width, height);
    CGContextSetLineWidth(context, lineWidth);
    if(isFilled) { CGContextFillEllipseInRect(context, rect); }
    CGContextStrokeEllipseInRect(context, rect);
}

- (void) drawImage:(CDVInvokedUrlCommand*) command
{
    NSString* imagePath = [command.arguments objectAtIndex:0];
    float left = [[command.arguments objectAtIndex:1] floatValue] * dpi;
    float top  = [[command.arguments objectAtIndex:2] floatValue] * dpi;
    float width  = [[command.arguments objectAtIndex:3] floatValue] * dpi;
    float height = [[command.arguments objectAtIndex:4] floatValue] * dpi;
    
    UIImage *inputImage = [UIImage imageWithContentsOfFile:imagePath];

    CGRect imageRect = CGRectMake(left, top, width, height);
    [inputImage drawInRect:imageRect];
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

@end
