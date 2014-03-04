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

// Output resolution for images
// Images of larger size than necessary will be resized to optimize the resulting PDF file size
float imageDpi = 150;

UIFont *currentFont = nil;

- (void) createDocument:(CDVInvokedUrlCommand*) command
{
	NSString* pdfFileName = [command.arguments objectAtIndex:0];
	
	UIGraphicsBeginPDFContextToFile(pdfFileName, CGRectZero, nil);
	
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
	
	float redNorm = [self normalizeColorComponent:red];
	float greenNorm = [self normalizeColorComponent:green];
	float blueNorm = [self normalizeColorComponent:blue];
	
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

- (float) normalizeColorComponent:(int) colorComponent
{
	if(colorComponent < 0) { return 0; }
	if(colorComponent > 255) { return 1; }
	return colorComponent / 255.f;
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
	NSString* alignment = [command.arguments objectAtIndex:5];
	
	enum NSTextAlignment textAlign = NSTextAlignmentLeft;
	if(alignment != (id)[NSNull null]) {
		if([alignment isEqualToString:@"center"]) { textAlign = NSTextAlignmentCenter; }
		if([alignment isEqualToString:@"right"]) { textAlign = NSTextAlignmentRight; }
	}
	
	CGRect stringRect = CGRectMake(left, top, width, height);
	
	[text drawInRect:stringRect withFont:currentFont lineBreakMode:NSLineBreakByTruncatingTail alignment:textAlign];
	
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
	if(capStyleString != (id)[NSNull null]) {
		if([capStyleString isEqualToString:@"round"]) { capStyle = kCGLineCapRound; }
		if([capStyleString isEqualToString:@"square"]) { capStyle = kCGLineCapSquare; }
	}
	
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
	
	enum CGLineJoin cornerStyle = kCGLineJoinMiter;
	if(cornerStyleString != (id)[NSNull null]) {
		if([cornerStyleString isEqualToString:@"bevel"]) { cornerStyle = kCGLineJoinRound; }
		if([cornerStyleString isEqualToString:@"round"]) { cornerStyle = kCGLineJoinRound; }
	}
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetLineWidth(context, lineWidth);
	CGContextSetLineJoin(context, cornerStyle);
	
	CGRect rect = CGRectMake(left, top, width, height);
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
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetLineJoin(context, kCGLineJoinBevel);
	CGContextSetLineWidth(context, lineWidth);
	
	CGContextAddArc(context, left + radius, top + radius, radius, M_PI, 1.5 * M_PI, 0);
	CGContextAddArc(context, left + width - radius, top + radius, radius, 1.5 * M_PI, 2 * M_PI, 0);
	CGContextAddArc(context, left + width - radius, top + height - radius, radius, 0, M_PI / 2, 0);
	CGContextAddArc(context, left + radius, top + height - radius, radius, M_PI / 2, M_PI, 0);
	CGContextClosePath(context);
	CGContextStrokePath(context);
	if(isFilled) {
		CGContextAddArc(context, left + radius, top + radius, radius, M_PI, 1.5 * M_PI, 0);
		CGContextAddArc(context, left + width - radius, top + radius, radius, 1.5 * M_PI, 2 * M_PI, 0);
		CGContextAddArc(context, left + width - radius, top + height - radius, radius, 0, M_PI / 2, 0);
		CGContextAddArc(context, left + radius, top + height - radius, radius, M_PI / 2, M_PI, 0);
		CGContextClosePath(context);
		CGContextFillPath(context);
	}
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
	float widthInches  = [[command.arguments objectAtIndex:3] floatValue];
	float heightInches = [[command.arguments objectAtIndex:4] floatValue];
	
	UIImage* inputImage = [UIImage imageWithContentsOfFile:imagePath];
	float imageResolutionX = widthInches * imageDpi;
	float imageResolutionY = heightInches * imageDpi;
	if(inputImage.size.width > imageResolutionX && inputImage.size.height > imageResolutionY) {
		// if our input image is too big, resize it down to keep the PDF file
		// from being bigger than necessary
		CGSize newSize = CGSizeMake(imageResolutionX, imageResolutionY);
		UIGraphicsBeginImageContext(newSize);
		[inputImage drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
		inputImage = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
	}
	
	float drawWidth  = widthInches * dpi;
	float drawHeight = heightInches * dpi;
	CGRect imageRect = CGRectMake(left, top, drawWidth, drawHeight);
	[inputImage drawInRect:imageRect];
	
	CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
	[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

@end
