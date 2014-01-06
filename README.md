pgpdf
=====

PhoneGap PDF Writer

This is a plugin to write out PDF files from javascript code in a PhoneGap
application. It only supports iOS for now.

--

### How to use
- Create your PhoneGap application
- Copy the .h and .m files from /src/iOS to your project's Classes folder in xcode
- Add the plugin to your config.xml:

```xml
<feature name="PgPDF">
    <param name="ios-package" value="PgPDF"/>
</feature>
```
- Copy pgPDF.js from /www to your project's /www folder
- Add the script to your index.html:

```xml
<script src="pgPDF.js"></script>
```
That should do it!

--

### Example Code
```javascript
// Create a new document
var doc = new pgPdfDocument();

// Add the first page
var page1 = doc.addPage();

// Draw an image and some text under it
page1.drawImage("jpegfile.jpg", 1, 1, 6, 4);
page1.setFillColor(0, 255, 0);
page1.setTextFont("Baskerville");
page1.setTextSize(12);
page1.drawTextInBox("JPEG image", 1, 5.125, 3, 0.5);

// Add a second page
var page2 = doc.addPage();

// Draw a colored line
page2.setStrokeColor(255, 128, 0);
page2.drawLine(2, 1, 6, 8, 2, "round");

// Draw a colored, unfilled rectangle
page2.setStrokeColor(0, 255, 128);
page2.drawRect(1, 3, 4, 2.5, 14, false);

// Draw a colored, filled round-rectangle
page2.setStrokeColor(128, 0, 255);
page2.setFillColor(255, 192, 224);
page2.drawRoundRect(2, 7, 5, 2, 0.5, 1, true);

// Draw a colored, filled elipse
page2.setFillColor(64, 0, 64);
page2.setStrokeColor(128, 255, 0);
page2.drawEllipseInRect(5.5, 1, 2, 3, 1, true);

// This shows how you can go back and alter previous pages
page1.drawImage("pngfile.png", 3.5, 6, 4, 4);
page1.setFillColor(0, 0, 255);
page1.setTextFont("SnellRoundhand-Bold");
page1.setTextSize(36);
page1.drawTextInBox("PNG image", 1, 6.5, 3, 0.5);

var page3 = doc.addPage();
// Draw up some paragraph text
page1.setTextFont("AmericanTypewriter");
page3.setTextSize(12);
page3.drawTextInBox("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed eu risus sem. Aenean pretium lacus in accumsan iaculis. Nulla in accumsan nunc.\n\nNunc nisl justo, faucibus sed nibh sit amet, mollis ullamcorper arcu. Duis bibendum nulla in nisl vulputate, vitae ultricies velit mattis. Mauris imperdiet suscipit libero, at fringilla neque iaculis id. Ut blandit ipsum et nunc fermentum imperdiet. Curabitur gravida mollis tortor, ultrices hendrerit purus semper nec.", 0.5, 0.5, 7.5, 3, "left");

// Save the PDF file to the file system
doc.save("test.pdf");

```
