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

/**
 * @private
 * @namespace
 */
var pgPDF = {

	createDocument: function(fileLocation) {
		cordova.exec(
			function(retVal) { console.log(retVal); },
			function(err) { console.log(err); },
			"PgPDF",
			"createDocument",
			[ fileLocation ]
		);
	},

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

	closeDocument: function() {
		cordova.exec(
			function(retVal) { console.log(retVal); },
			function(err) { console.log(err); },
			"PgPDF",
			"closeDocument",
			[ ]
		);
	},

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

	setTextFont: function(fontName) {
		cordova.exec(
			function(retVal) { console.log(retVal); },
			function(err) { console.log(err); },
			"PgPDF",
			"setTextFont",
			[ fontName ]
		);
	},

	setTextSize: function(pointSize) {
		cordova.exec(
			function(retVal) { console.log(retVal); },
			function(err) { console.log(err); },
			"PgPDF",
			"setTextSize",
			[ pointSize ]
		);
	},

	drawRect: function(x1, y1, width, height, strokeWidth, filled, joinStyle) {
		filled = !!filled; // sets to false if not specified
		cordova.exec(
			function(retVal) { console.log(retVal); },
			function(err) { console.log(err); },
			"PgPDF",
			"drawRect",
			[ x1, y1, width, height, strokeWidth, filled, joinStyle ]
		);
	},

	drawRoundRect: function(x1, y1, width, height, radius, strokeWidth, filled) {
		filled = !!filled; // sets to false if not specified
		cordova.exec(
			function(retVal) { console.log(retVal); },
			function(err) { console.log(err); },
			"PgPDF",
			"drawRoundRect",
			[ x1, y1, width, height, radius, strokeWidth, filled ]
		);
	},

	drawEllipseInRect: function(x1, y1, width, height, strokeWidth, filled) {
		filled = !!filled; // sets to false if not specified
		cordova.exec(
			function(retVal) { console.log(retVal); },
			function(err) { console.log(err); },
			"PgPDF",
			"drawEllipseInRect",
			[ x1, y1, width, height, strokeWidth, filled ]
		);
	},

	drawLine: function(startX, startY, endX, endY, width, capStyle) {
		cordova.exec(
			function(retVal) { console.log(retVal); },
			function(err) { console.log(err); },
			"PgPDF",
			"drawLine",
			[ startX, startY, endX, endY, width, capStyle ]
		);
	},

	drawImage: function(imagePath, left, top, width, height) {
		cordova.exec(
			function(retVal) { console.log(retVal); },
			function(err) { console.log(err); },
			"PgPDF",
			"drawImage",
			[ imagePath, left, top, width, height ]
		);
	},

	drawTextInBox: function(text, left, top, width, height, overflow, alignment) {
		overflow = overflow || false;
		alignment = alignment || "left";
		cordova.exec(
			function(retVal) { console.log(retVal); },
			function(err) { console.log(err); },
			"PgPDF",
			"drawTextInBox",
			[ text, left, top, width, height, overflow, alignment ]
		);
	}
};

/**
 * Represents a whole PDF document with one or more pages.
 * @class
 */
var pgPdfDocument = function() {
	this.documentPages = [];
};

/**
 * Represents a page within a PDF document.
 * @class
 */
var pgPdfPage = function(width, height) {
	this.drawingElements = [];
	this.width  = width || 8.5;
	this.height = height || 11;
};

/**
 * Adds a page to the PDF document. Defaults to 8.5" x 11" in portrait
 * orientation
 *
 * @param {number} [width=8.5] The width of the new page in inches
 * @param {number} [height=11] The height of the new page in inches
 * @returns {pgPdfPage} The pgPdfPage added to the document
 */
pgPdfDocument.prototype.addPage = function(width, height) {
	var p = new pgPdfPage(width, height);
	this.documentPages.push(p);
	return p;
};

/**
 * Closes the document, updating the file with the drawn contents
 */
pgPdfDocument.prototype.save = function(fileLocation) {
	pgPDF.createDocument(fileLocation);

	this.documentPages.forEach(function(page) {
		pgPDF.addPage(page.width, page.height);
		page.drawingElements.forEach(function(de) {
			pgPDF[de.drawFunc].apply(pgPDF, de.params);
		});
	});

	pgPDF.closeDocument();
};

/**
 * Sets the working color for line strokes
 *
 * @param {number} red   The red component of the color (0-255)
 * @param {number} green The green component of the color (0-255)
 * @param {number} blue  The blue component of the color (0-255)
 * @param {number} [alpha=1] The opacity (alpha channel) of the color (0.0-1.0)
 */
pgPdfPage.prototype.setStrokeColor = function(red, green, blue, alpha) {
	this.drawingElements.push({ drawFunc: "setStrokeColor", params: [ red, green, blue, alpha ] });
};

/**
 * Sets the working color for shape fill or text drawing
 *
 * @param {number} red   The red component of the color (0-255)
 * @param {number} green The green component of the color (0-255)
 * @param {number} blue  The blue component of the color (0-255)
 * @param {number} [alpha=1] The opacity (alpha channel) of the color (0.0-1.0)
 */
pgPdfPage.prototype.setFillColor = function(red, green, blue, alpha) {
	this.drawingElements.push({ drawFunc: "setFillColor", params: [ red, green, blue, alpha ] });
};

/**
 * Changes the font used for text drawing
 *
 * @param {string} fontName The name of the font to use
 */
pgPdfPage.prototype.setTextFont = function(fontName) {
	this.drawingElements.push({ drawFunc: "setTextFont", params: [ fontName ] });
};

/**
 * Changes the font size used for text drawing
 *
 * @param {number} pointSize The size of the font to use (in points)
 */
pgPdfPage.prototype.setTextSize = function(pointSize) {
	this.drawingElements.push({ drawFunc: "setTextSize", params: [ pointSize ] });
};

/**
 * Draw a rectangle with optional fill and varied join styles supported
 *
 * @param {number} x1 The x-coordinate of the upper-left corner of the rect in inches
 * @param {number} y1 The y-coordinate of the upper-left corner of the rect in inches
 * @param {number} width The width of the rect in inches
 * @param {number} height The height of the rect in inches
 * @param {number} strokeWidth The width of the line stroke around the rect in points
 * @param {boolean} [filled=false] Whether to fill the rectangle (use setFillColor to set a color)
 * @param {string} [joinStyle="bevel"] The style of box corners ("bevel", "round", "miter")
 */
pgPdfPage.prototype.drawRect = function(x1, y1, width, height, strokeWidth, filled, joinStyle) {
	this.drawingElements.push({ drawFunc: "drawRect", params: [ x1, y1, width, height, strokeWidth, filled, joinStyle ] });
};

/**
 * Draw a rectangle with rounded corners and optional fill
 *
 * @param {number} x1 The x-coordinate of the upper-left corner of the rect in inches
 * @param {number} y1 The y-coordinate of the upper-left corner of the rect in inches
 * @param {number} width The width of the rect in inches
 * @param {number} height The height of the rect in inches
 * @param {number} strokeWidth The width of the line stroke around the rect in points
 * @param {boolean} [filled=false] Whether to fill the rectangle (use setFillColor to set a color)
 */
pgPdfPage.prototype.drawRoundRect = function(x1, y1, width, height, radius, strokeWidth, filled) {
	this.drawingElements.push({ drawFunc: "drawRoundRect", params: [ x1, y1, width, height, radius, strokeWidth, filled ] });
};

/**
 * Draw an ellipse bounded by the specified coordinates with optional fill
 *
 * The function defines a rectangle and then draws an ellipse that inscribes
 * that rectangle
 *
 * This method should be replaced by a method to draw an ellispe at any angle
 * in the future
 *
 * @param {number} x1 The x-coordinate of the upper-left corner of the rect in inches
 * @param {number} y1 The y-coordinate of the upper-left corner of the rect in inches
 * @param {number} width The width of the rect in inches
 * @param {number} height The height of the rect in inches
 * @param {number} strokeWidth The width of the line stroke around the ellipse in points
 * @param {boolean} [filled=false] Whether to fill the ellipse (use setFillColor to set a color)
 */
pgPdfPage.prototype.drawEllipseInRect = function(x1, y1, width, height, strokeWidth, filled) {
	this.drawingElements.push({ drawFunc: "drawEllipseInRect", params: [ x1, y1, width, height, strokeWidth, filled ] });
};

/**
 * Draw a straight line segment between two points
 *
 * @param {number} startX X-coordinate of the starting point in inches
 * @param {number} startY Y-coordinate of the starting point in inches
 * @param {number} endX X-coordinate of the ending point in inches
 * @param {number} endY Y-coordinate of the ending point in inches
 * @param {number} width Width of the line stroke in points
 * @param {string} [capStyle="butt"] The style for the end of the line ("butt", "square", "round")
 */
pgPdfPage.prototype.drawLine = function(startX, startY, endX, endY, width, capStyle) {
	this.drawingElements.push({ drawFunc: "drawLine", params: [ startX, startY, endX, endY, width, capStyle ] });
};

/**
 * Draw an image with the specified dimensions
 *
 * @param {string} imagePath The file location of the image on the filesystem
 * @param {number} left X-coordinate of the upper-left corner of the image in inches
 * @param {number} top Y-coordinate of the upper-left corner of the image in inches
 * @param {number} width width of the image in inches
 * @param {number} height height of the image in inches
 */
pgPdfPage.prototype.drawImage = function(imagePath, left, top, width, height) {
	this.drawingElements.push({ drawFunc: "drawImage", params: [ imagePath, left, top, width, height ] });
};

/**
 * Draw some text in a box of the specified dimensions
 *
 * @param {string} text The text to draw
 * @param {number} left x1
 * @param {number} top  y1
 * @param {number} width  x2
 * @param {number} height y2
 * @param {boolean} [overflow=false] Whether the text should overflow the box
 * @param {string} [alignment="left"] - "left", "center", "right", "justify"
 */
pgPdfPage.prototype.drawTextInBox = function(text, left, top, width, height, overflow, alignment) {
	this.drawingElements.push({ drawFunc: "drawTextInBox", params: [ text, left, top, width, height, overflow, alignment ] });
};
