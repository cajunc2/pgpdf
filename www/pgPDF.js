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

var pgPDF = {

	/**
	 * Creates a new PDF document and adds the first page. Defualts to
	 * 8.5" x 11" in portrait orientation. The PDF will be written to a file
	 * at the given loaction
	 *
	 * @param fileLocation The target filename for the PDF file on the filesystem
	 * @param width  The page width for the first page (default 8.5 inches)
	 * @param height The page height for the first page (default 11 inches)
	 */
	createDocument: function(fileLocation, width, height) {
		width  = width || 8.5;
		height = height || 11;
		cordova.exec(
			function(retVal) { console.log(retVal); },
			function(err) { console.log(err); },
			"PgPDF",
			"createDocument",
			[ fileLocation, width, height ]
		);
	},

	/**
	 * Adds a page to the PDF document. Defaults to 8.5" x 11" in portrait orientation
	 *
	 * @param width The width of the new page in inches
	 * @param height The height of the new page in inches
	 */
	addPage: function(width, height) {
		width  = width || 8.5;
		height = height || 11;
		cordova.exec(
			function(retVal) { console.log(retVal); },
			function(err) { console.log(err); },
			"PgPDF",
			"addPage",
			[ width, height ]
		);
	},

	/**
	 * Closes the document, updating the file with the drawn contents
	 */
	closeDocument: function(fileLocation) {
		cordova.exec(
			function(retVal) { console.log(retVal); },
			function(err) { console.log(err); },
			"PgPDF",
			"closeDocument",
			[ ]
		);
	},

	/**
	 * Sets the working color for line strokes
	 *
	 * @param red   The red component of the color (0-255)
	 * @param green The green component of the color (0-255)
	 * @param blue  The blue component of the color (0-255)
	 * @param alpha The opacity (alpha channel) of the color (0.0-1.0)
	 */
	setStrokeColor: function(red, green, blue, alpha) {
		alpha = alpha || 1;

		cordova.exec(
			function(retVal) { console.log(retVal); },
			function(err) { console.log(err); },
			"PgPDF",
			"setStrokeColor",
			[ red, green, blue, alpha ]
		);
	},

	/**
	 * Sets the working color for shape fill or text drawing
	 *
	 * @param red   The red component of the color (0-255)
	 * @param green The green component of the color (0-255)
	 * @param blue  The blue component of the color (0-255)
	 * @param alpha The opacity (alpha channel) of the color (0.0-1.0)
	 */
	setFillColor: function(red, green, blue, alpha) {
		alpha = alpha || 1;
		
		cordova.exec(
			function(retVal) { console.log(retVal); },
			function(err) { console.log(err); },
			"PgPDF",
			"setFillColor",
			[ red, green, blue, alpha ]
		);
	},

	/**
	 * Changes the font used for text drawing
	 *
	 * @param fontName The name of the font to use
	 */
	setTextFont: function(fontName) {
		cordova.exec(
			function(retVal) { console.log(retVal); },
			function(err) { console.log(err); },
			"PgPDF",
			"setTextFont",
			[ fontName ]
		);
	},

	/**
	 * Changes the font size used for text drawing
	 *
	 * @param pointSize The size of the font to use (in points)
	 */
	setTextSize: function(pointSize) {
		cordova.exec(
			function(retVal) { console.log(retVal); },
			function(err) { console.log(err); },
			"PgPDF",
			"setTextSize",
			[ pointSize ]
		);
	},

	/**
	 * Draw a rectangle with optional fill and varied join styles supported
	 *
	 * @param x1 The x-coordinate of the upper-left corner of the rect in inches
	 * @param y1 The y-coordinate of the upper-left corner of the rect in inches
	 * @param width The width of the rect in inches
	 * @param width The height of the rect in inches
	 * @param strokeWidth The width of the line stroke around the rect in points
	 * @param filled Whether to fill the rectangle (use setFillColor to set a color)
	 * @param joinStyle The style of box corners ("bevel", "round", "miter")
	 */
	drawRect: function(x1, y1, width, height, strokeWidth, filled, joinStyle) {
		cordova.exec(
			function(retVal) { console.log(retVal); },
			function(err) { console.log(err); },
			"PgPDF",
			"drawRect",
			[ x1, y1, width, height, strokeWidth, filled, joinStyle ]
		);
	},

	/**
	 * Draw a rectangle with rounded corners and optional fill
	 *
	 * @param x1 The x-coordinate of the upper-left corner of the rect in inches
	 * @param y1 The y-coordinate of the upper-left corner of the rect in inches
	 * @param width The width of the rect in inches
	 * @param width The height of the rect in inches
	 * @param strokeWidth The width of the line stroke around the rect in points
	 * @param filled Whether to fill the rectangle (use setFillColor to set a color)
	 * @param joinStyle The style of box corners ("bevel", "round", "miter")
	 */
	drawRoundRect: function(x1, y1, width, height, radius, strokeWidth, filled) {
		cordova.exec(
			function(retVal) { console.log(retVal); },
			function(err) { console.log(err); },
			"PgPDF",
			"drawRoundRect",
			[ x1, y1, width, height, radius, strokeWidth, filled ]
		);
	},

	/**
	 * Draw an ellipse bounded by the specified coordinates with optional fill
	 *
	 * The function defines a rectangle and then draws an ellipse that inscribes
	 * that rectangle
	 *
	 * This method should be replaced by a method to draw an ellispe at any angle
	 * in the future
	 *
	 * @param x1 The x-coordinate of the upper-left corner of the rect in inches
	 * @param y1 The y-coordinate of the upper-left corner of the rect in inches
	 * @param width The width of the rect in inches
	 * @param width The height of the rect in inches
	 * @param strokeWidth The width of the line stroke around the ellipse in points
	 * @param filled Whether to fill the ellipse (use setFillColor to set a color)
	 */
	drawEllipseInRect: function(x1, y1, width, height, strokeWidth, filled) {
		cordova.exec(
			function(retVal) { console.log(retVal); },
			function(err) { console.log(err); },
			"PgPDF",
			"drawEllipseInRect",
			[ x1, y1, width, height, strokeWidth, filled ]
		);
	},

	/**
	 * Draw a straight line segment between two points
	 *
	 * @param startX X-coordinate of the starting point in inches
	 * @param startY Y-coordinate of the starting point in inches
	 * @param endX X-coordinate of the ending point in inches
	 * @param endY Y-coordinate of the ending point in inches
	 * @param width Width of the line stroke in points
	 * @param capStyle The style for the end of the line ("butt", "square", "round")
	 */
	drawLine: function(startX, startY, endX, endY, width, capStyle) {
		cordova.exec(
			function(retVal) { console.log(retVal); },
			function(err) { console.log(err); },
			"PgPDF",
			"drawLine",
			[ startX, startY, endX, endY, width, capStyle ]
		);
	},

	/**
	 * Draw an image with the specified dimensions
	 *
	 * @param imagePath The file location of the image on the filesystem
	 * @param left X-coordinate of the upper-left corner of the image in inches
	 * @param top Y-coordinate of the upper-left corner of the image in inches
	 * @param width width of the image in inches
	 * @param height height of the image in inches
	 */
	drawImage: function(imagePath, left, top, width, height) {
		cordova.exec(
			function(retVal) { console.log(retVal); },
			function(err) { console.log(err); },
			"PgPDF",
			"drawImage",
			[ imagePath, left, top, width, height ]
		);
	},

	/**
	 * Draw some text in a box of the specified dimensions
	 *
	 * @param text The text to draw
	 * @param left x1
	 * @param top  y1
	 * @param width  x2
	 * @param height y2
	 * @param overflow Whether the text should overflow the box
	 */
	drawTextInBox: function(text, left, top, width, height, overflow) {
		cordova.exec(
			function(retVal) { console.log(retVal); },
			function(err) { console.log(err); },
			"PgPDF",
			"drawTextInBox",
			[ text, left, top, width, height, overflow ]
		);
	}
};