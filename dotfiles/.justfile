j_b := `tput bold`
j_n := `tput sgr0`

default:
    echo "Hello World!"

dbox:
    just dbox-git-commit-template
    just dbox-git-pre-commit-install
    just dbox-git-remote-rename-origin-upstream
    just dbox-vscode-workspace

dbox-git-commit-template:
    #!/usr/bin/env sh

    # this line is needed because calling just tasks
    # resets the path to ~ and I didn't find a better way to
    # set it
    cd {{ invocation_directory() }}

    DIRS=`find . -maxdepth 1 -mindepth 1 -type d -not -path '*/\.*'`
    for D in $DIRS; do
        pushd $D &> /dev/null

        # always exit if not a git directory
        if [ ! $(git -c $(pwd)/$(basename $D) rev-parse --quiet &> /dev/null) ]; then
            echo "info : omitting `basename $D`. Not a git dir."
            continue
        fi

        if [ -f ./.git-commit-template ]; then
            git config commit.template ./.git-commit-template
            echo "info : conifgured commit.template for `basename $D`"
        else
            echo "info : no file named .git-commit-template in `basename $D`"
        fi
        popd &> /dev/null
    done

dbox-git-pre-commit-install:
    #!/usr/bin/env sh

    # this line is needed because calling just tasks
    # resets the path to ~ and I didn't find a better way to
    # set it
    cd {{ invocation_directory() }}

    DIRS=`find . -maxdepth 1 -mindepth 1 -type d -not -path '*/\.*'`
    for D in $DIRS; do
        pushd $D &> /dev/null

        # always exit if not a git directory
        if [ ! $(git -c $(pwd)/$(basename $D) rev-parse --quiet &> /dev/null) ]; then
            echo "info : omitting `basename $D`. Not a git dir."
            continue
        fi

        if [ -f .pre-commit-config.yaml ]; then
            echo "info : installing pre-commit in `basename $D`"
            pre-commit install &> /dev/null
        else
            echo "info : no pre-commit file found in `basename $D`"
        fi
        popd &> /dev/null
    done

dbox-git-remote-rename-origin-upstream:
    #!/usr/bin/env sh

    # this line is needed because calling just tasks
    # resets the path to ~ and I didn't find a better way to
    # set it
    cd {{ invocation_directory() }}

    DIRS=`find . -maxdepth 1 -mindepth 1 -type d -not -path '*/\.*'`
    for D in $DIRS; do
        pushd $D &> /dev/null

        # always exit if not a git directory
        if [ ! $(git -c $(pwd)/$(basename $D) rev-parse --quiet &> /dev/null) ]; then
            echo "info : omitting `basename $D`. Not a git dir."
            continue
        fi

        GH_REMOTE=$(git remote -v | grep origin | awk 'END {print $2}')
        GH_REPO=`basename $GH_REMOTE | cut -f 1 -d '.'`
        GH_USER=inknos
        GH_URL=https://github.com/$GH_USER/$GH_REPO
        if [ $(curl -s -o /dev/null -I -w "%{http_code}" $GH_URL) -eq "200" ]; then
            if [ git ls-remote --exit-code upstream &> /dev/null ]; then
                if git remote rename origin upstream &> /dev/null; then
                    git remote add origin \
                        $(git remote -v | grep upstream | awk 'END {print $2}' | sed 's|.*/|git@github.com:inknos/|')
                    git fetch origin  2>&1 > /dev/null
                    echo "info :remote origin<->upstream set for `basename $D`"
                fi
            else
                echo "info : remote upstream exists for `basename $D`"
            fi
        else
            echo "error: remote $GH_URL unreachable"
        fi
        popd &> /dev/null
    done

dbox-vscode-workspace:
    #!/usr/bin/env sh

    # this line is needed because calling just tasks
    # resets the path to ~ and I didn't find a better way to
    # set it
    cd {{ invocation_directory() }}

    INVOCATION_DIR={{ invocation_directory() }}
    BASENAME=`basename $INVOCATION_DIR`
    WORKSPACE_FILENAME=$BASENAME.code-workspace

    if [ -f $WORKSPACE_FILENAME ]; then
        echo "info : file $WORKSPACE_FILENAME exists"
        exit
    fi

    : > $WORKSPACE_FILENAME
    cat <<EOT >> $WORKSPACE_FILENAME
    {
        "folders": [
    EOT
    for file in `find $(pwd -P) -mindepth 1 -maxdepth 1 -type d -not -name '.*'`; do
        if [ ! $(git -C ./$file rev-parse --quiet &> /dev/null) ]; then
            echo "        {" >> $WORKSPACE_FILENAME
            echo "            \"path\": \"$file\"," >> $WORKSPACE_FILENAME
            echo "        }," >> $WORKSPACE_FILENAME
        else
            echo "info : omitting `basename $file`. Not a git dir."
        fi
    done
    cat <<EOT >> $WORKSPACE_FILENAME
        ],
        "settings": {}
    }
    EOT

    if [ $( cat $WORKSPACE_FILENAME | wc -l ) -eq 5 ]; then
        rm $WORKSPACE_FILENAME
        echo "info : no git sub-directories found. No file created"
    else
        echo "info : wrote $WORKSPACE_FILENAME"
    fi

