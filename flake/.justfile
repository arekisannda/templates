import? '.just/base.just'

mod? nix '.just/nix.just'

_just_mod_dir := justfile_directory() / ".just"

nix := require('nix')

[confirm("Remove the existing module directory?")]
_remove-mod-dir:
    @rm -rf {{ quote(_just_mod_dir) }}

[doc('Update just modules')]
update:
    #!/usr/bin/env bash
    set -euo pipefail

    tmp=$(mktemp -d)
    trap 'rm -rf "$tmp"' EXIT

    {{ nix }} flake --refresh new -t github:arekisannda/templates#flake "$tmp/t"

    if [ -d {{ quote(_just_mod_dir) }} ]; then
        {{ just }} _remove-mod-dir
    fi

    cp -r "$tmp/t/.just" {{ quote(_just_mod_dir) }}
    chmod -R u+w {{ quote(_just_mod_dir) }}
