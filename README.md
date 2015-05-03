# dita13-dita-ot-1.x-support
Plugins that add support for DITA 1.3 vocabularies to the 1.x version of the DITA Open Toolkit.

NOTE: This is a "master project" that includes each plugin as a git submodule. If you clone this module you must then do the 
git commands `git submodule init` and `git submodule update` to check out the submodules. Likewise, if you pull a new version 
this module you just do `git submodule update` to update the submodules to the latest commit.

If you want to put the submodules on a specific branch do:

`git submodule foreach git checkout {branchname}`

Where `{brachname}` is the name of the branch you want (e.g., "master" or "develop").

