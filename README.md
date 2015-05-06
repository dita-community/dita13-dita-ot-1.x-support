DITA 1.3 Open Toolkit 1.x Plugins
=================================

Open Toolkit plugins for new DITA 1.3 vocabulary. For use with the 1.x Open Toolkit

This project provides a pair of DITA Open Toolkit plugins, one for HTML out and one for PDF output,
that implement the new DITA 1.3 vocabulary in the 1.x Open Toolkit (the 2.x Open Toolkit has
DITA 1.3 support built in).

The support for the Learning and Training interaction (assessment) elements includes a number of 
runtime options and XSLT extension points that you can use to control how questions and answers.

The plugins provide an extension point by which you can extend or override these transforms.
Because these transforms are provided through a plugin, they cannot be reliably overridden
by overrides to the base XSLT. The extension point for these plugins (xsl.dita13html and xsl.dita13pdf)
allows direct overriding of the XSLT templates in these plugins.

## Learning Domain Output Options

TBD: Describe the options.