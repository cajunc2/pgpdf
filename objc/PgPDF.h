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

#import <Cordova/CDV.h>

@interface PgPDF : CDVPlugin

@property (readonly) int dpi;

- (void) createDocument:(CDVInvokedUrlCommand*) command;
- (void) closeDocument:(CDVInvokedUrlCommand*) command;
- (void) setStrokeColor:(CDVInvokedUrlCommand*) command;
- (void) setFillColor:(CDVInvokedUrlCommand*) command;
- (void) drawTextInBox:(CDVInvokedUrlCommand*) command;
- (void) drawLine:(CDVInvokedUrlCommand*) command;
- (void) drawRect:(CDVInvokedUrlCommand*) command;
- (void) drawEllipseInRect:(CDVInvokedUrlCommand*) command;
- (void) drawImage:(CDVInvokedUrlCommand*) command;

@end
