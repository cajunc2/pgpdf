pgpdf
=====

PhoneGap PDF Writer

Juuuuuuust barely getting started. This is a plugin to write out PDF files from javascript code in a PhoneGap application. This only supports iOS for now.

Enjoy!

--

### How to use
- Create your PhoneGap application
- Copy the .h and .m files from /src/iOS to your project's Classes folder in xcode
- Add the plugin to your config.xml:

        <feature name="PgPDF">
            <param name="ios-package" value="PgPDF"/>
        </feature>

- Copy pgPDF.js from /www to your project's /www folder
- Add the script to your index.html:

        <script src="pgPDF.js"></script>

That should do it! I'll add some exampley goodness soon.
