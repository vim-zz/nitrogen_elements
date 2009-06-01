# Nitrogen Elements #

The simpler elements may be used as-is when nitrogen-elements is installed as an erlang lib (i.e. in the erlang libs path, see notice below).

The tabs control needs some additional changes to the javascript and css code.
For the time being, these changes needs to be applied manually.

## Install nitrogen elements as an Erlang library ##

Run:
   make

This should compile all elements and place the beam files in the ebin sub directory. Notice: you need to have nitrogen installed (needs to find the wf.inc file).

Add the nitrogen_elements directory to your ERL_LIBS environment variable (or place/clone it to a path already mentioned by ERL_LIBS), then -include_lib("nitrogen_elements/include/nitrogen_elements.hrl"). to use the elements and actions provided by this lib in your code.

N.B. that i.e. the tabs element needs additional changes to the js and css code. See the src/element_tabs/ directory.

# Notice #

The name must NOT begin with nitrogen- to avoid confusing the erlang code loader. That is why you should clone nitrogen-elements to nitrogen_elements or something else you might like. To make this usable (as an erlang lib), the project ought to be renamed accordinlgy.

