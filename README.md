DITA 1.3 Support for Open Toolkit 1.x
=====================================

The plugins in this project provide support for the
new DITA 1.3 vocabulary using the 1.x version of
the DITA Open Toolkit (the 2.x version of the Open Toolkit
has DITA 1.3 support built in).

Note that this support is only for vocabulary, it does
not include support for branch filtering or scoped keys,
which require significant enhancement to the pre-1.3 
DITA preprocessing.

## Installation

The project includes four Open Toolkit plugins. To
install them do:

1. Unzip the distribution package somewhere convenient
2. Copy the four plugin directories to your Open Toolkit's plugins/ directory
3. Run the Toolkit's integrator.xml Ant script

## Using the DITA 1.3 Document Types

Because the 1.x Open Toolkit always includes plugin-provided 
catalog entries after its built-in entries, you can't use
the version-independent public IDs for the OASIS-provided document
1.3 type shells as the public IDs will resolve to the built-in 
1.2 shells. 

Thus, if you want to use the OASIS-provided document type shells you
must use the DITA 1.3-specific public IDs, which include " 1.3" after
"DITA" in the public ID, e.g.:

````
<!DOCTYPE map PUBLIC "-//OASIS//DTD DITA 1.3 Map//EN" "map.dtd">
````

You *should* be using local document type shells. In those shells
you must likewise use the DITA 1.3-specific public IDs for
references to OASIS-provided vocabulary and constraint modules, e.g.:

````
<!ENTITY % hi-d-def
  PUBLIC "-//OASIS//ELEMENTS DITA 1.3 Highlight Domain//EN"
         "highlightDomain.mod"
>%hi-d-def;
````

## Learning Domain Support

The DITA 1.3 support includes PDF and HTML support for static
rendering of Learning 1 and Learning 2 interactions (questions 
and answers). Both plugins provide a number of run-time options
that control how questions are rendered:

* Just the questions and answer options
* With feedback
* With correct answers highlighted
* With only correct answers shown (e.g., for answer keys)

In addition, through your own extension XSLT you can dynamically
set these options during output processing so that you can, for
example, process the same questions once to produce a test and
again to produce an answer key or a teacher version of the test
with the correct answers and feedback shown.

See the learning2domainParams.xml in the HTML and PDF plugins
for the set of available parameters.

## MathML Support in HTML

The HTML MathML support outputs the MathML as inline MathML markup
in the generated HTML. 

It also provides the option of including
a reference to the open-source MathJax Javascript library in your
HTML pages (https://www.mathjax.org). The MathJax library provides high-quality MathML rendering
in all Javascript-enabled browsers. However, it is a large library and
if you're publishing your HTML behind a firewall or in a high-security
environment you may need to turn off the MathJax include or use a 
locally-served version. The plugin provides runtime options to control
how MathJax is used.

## MathML Support in PDF

Both Apache FOP and Antenna House XSL Formatter support direct rendering of inline
MathML in XSL-FO. XEP does not provide its own MathML renderer. For XEP you will need
to use a separate process to render MathML to SVG or another image format.

FOP depends on the Apache JEuclid library for MathML rendering.

XSL Formatter has its own MathML renderer.

The rendering of math in general and MathML in particular is always challenging.
If your readers require the highest quality of math rendering you will need to
explore commercial tools to render your math. 

### Apache FOP

FOP supports inline SVG rendering if the Apache JEuclid library is available, which it
is not by default. Installing it requires copying two Java jar files into the fop/lib 
directory in the org.dita.pdf2 plugin.

See http://jeuclid.sourceforge.net/jeuclid-fop/index.html

Note that as of May 2015 the JEuclid project appears to be dormant. The collective
opinion of math publishers is that JEuclid is not sufficient for professional
publishing applications.

### Antenna House XSL Formatter

XSL Formatter provides built-in MathML rendering as part of the full-priced
version (MathML rendering is not provided in the "Lite" version as of May 2015).
Antenna House claims that its MathML rendering is comparable to other commercial
offerings and meets all the MathML tests.

### RenderX XEP

XEP does not provide a built-in MathML rendering option. You will need to render
your MathML to an image format (e.g., SVG) in order to include the equations
in the PDF output. Options include using the Apache JEuclid package, the Design Science
MathFlow SDK, and WIRIS tools for converting MathML to images. Contact RenderX support
for guidance.

## SVG Support in HTML

For HTML output the SVG is copied to the HTML as inline SVG. All modern browsers
should rendering it well.

## SVG Support in PDF

For PDF output, the SVG is copied to the FO file as inline SVG. Antenna House XSL Formatter
and RenderX XEP both render inline SVG directly. FOP requires the Apache Batik library, which
is included by default in the org.dita.pdf2 plugin.

## Sizing SVG Graphics

Sizing SVG graphics is a bit tricky.

Within the SVG markup you can do any of the following:

1. Don't specify an absolute width or height nor a viewBox. In this case, the 
container entirely determines the rendered size of the graphic.
2. Specify a width or height but no viewBox. In this case, the graphic should
be rendered at the width and height specified. If the container (e.g., the DITA
`<image>` element) also specifies a width and height results may vary among
renderers.
3. Specify only a viewBox on the `<svg>` element. In this case, the graphic
should be scaled to fit the available size as determined by the container.
4. Specify an explicit width and/or height and a viewBox. This is essentially the same as
option (2) as the explicit width or height should determine the rendered size
of the graphic.

Option (1) is the most flexible: It allows the container (the DITA markup and
renderer) to determine the rendered size of the graphic. Use this option when
the size of the graphic can vary. You should probably use this option for most
graphics.

Option (2) is appropriate when the size of the graphic should be the same in
all rendering contexts. You should probably not use this option except when
the graphic really needs to always be a specific size.

Option (3) tends to result in unexpected results. In the normal DITA case it
means that the graphic will be scaled *up* to fill the available space, either
the browser window for HTML or the current column width for PDF. This is usually
not what you want.  

## Test Documents

The project and distribution package include a set of test documents, including
MathML and SVG samples, used to test the plugins.

The file test/dita/dita13vocabulary-test.ditamap is the root map for the test
documents.

You can use this map and its referenced topics and other resources to test
the 1.3 support and as a model for your own documents.