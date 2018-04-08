case $(uname -s) in *MINGW*) 	sort () { 		/usr/bin/sort "$@"; 	}; 	find () { 		/usr/bin/find "$@"; 	} 	pwd () { 		builtin pwd -W; 	}; 	is_absolute_path () { 		case "$1" in 		[/\\]* | [A-Za-z]:*) 			return 0 ;; 		esac; 		return 1; 	}; 	;; *); 	is_absolute_path () { 		case "$1" in 		/*) 			return 0 ;; 		esac; 		return 1; 	}; esac
# Make sure we are in a valid repository of a vintage we understand,
# if we require to be in a git repository.
git_dir_init () { 	GIT_DIR=$(git rev-parse --git-dir) || exit; 	if [ -z "$SUBDIRECTORY_OK" ]; 	then 		test -z "$(git rev-parse --show-cdup)" || { 			exit=$?; 			gettextln "You need to run this command from the toplevel of the working tree." >&2; 			exit $exit; 		}; 	fi; 	test -n "$GIT_DIR" && GIT_DIR=$(cd "$GIT_DIR" && pwd) || { 		gettextln "Unable to determine absolute path of git directory" >&2; 		exit 1; 	}; 	: "${GIT_OBJECT_DIRECTORY="$(git rev-parse --git-path objects)"}"; }
if test -z "$NONGIT_OK"; then 	git_dir_init; fi
#!/bin/sh
# wrap-for-bin.sh: Template for git executable wrapper scripts
# to run test suite against sandbox, but with only bindir-installed
# executables in PATH.  The Makefile copies this into various
# files in bin-wrappers, substituting
# @@BUILD_DIR@@ and @@PROG@@.
GIT_EXEC_PATH='@@BUILD_DIR@@'
if test -n "$NO_SET_GIT_TEMPLATE_DIR"; then 	unset GIT_TEMPLATE_DIR; else 	GIT_TEMPLATE_DIR='@@BUILD_DIR@@/templates/blt'; 	export GIT_TEMPLATE_DIR; fi
GITPERLLIB='@@BUILD_DIR@@/perl/build/lib'"${GITPERLLIB:+:$GITPERLLIB}"
GIT_TEXTDOMAINDIR='@@BUILD_DIR@@/po/build/locale'
PATH='@@BUILD_DIR@@/bin-wrappers:'"$PATH"
export GIT_EXEC_PATH GITPERLLIB PATH GIT_TEXTDOMAINDIR
if test -n "$GIT_TEST_GDB"; then 	unset GIT_TEST_GDB; 	exec gdb --args "${GIT_EXEC_PATH}/@@PROG@@" "$@"; else 	exec "${GIT_EXEC_PATH}/@@PROG@@" "$@"; fi
#!/bin/sh
echo >&2 "fatal: git was built without support for $(basename $0) (@@REASON@@)."
exit 128
source 'https://rubygems.org'
gemspec :name => "github-linguist"
gem 'byebug' if RUBY_VERSION >= '2.0'
source 'https://rubygems.org'
gemspec :name => "github-linguist"
gem 'byebug' if RUBY_VERSION >= '2.0'
source 'https://rubygems.org'
gemspec :name => "github-linguist"
gem 'byebug' if RUBY_VERSION >= '2.0'
source 'https://rubygems.org'
gemspec :name => "github-linguist"
gem 'byebug' if RUBY_VERSION >= '2.0'
source 'https://rubygems.org'
gemspec :name => "github-linguist"
gem 'byebug' if RUBY_VERSION >= '2.0'
source 'https://rubygems.org'
gemspec :name => "github-linguist"
gem 'byebug' if RUBY_VERSION >= '2.0'
# psake
# Copyright (c) 2012 James Kovacs
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
#Requires -Version 2.0
#-- Public Module Functions --#
# .ExternalHelp  psake.psm1-help.xml
function Invoke-Task {     [CmdletBinding()]
// !$*UTF8*$!
{ 	archiveVersion = 1; 	classes = {; 	};
	objectVersion = 45;
	objects = {
/* Begin PBXBuildFile section */
		3327DE920E955E14001FCE4E /* Cocoa.framework in Frameworks */ = {isa = PBXBuildFile; fileRef = 3327DE910E955E14001FCE4E /* Cocoa.framework */; };
Manifest-Version: 1.0
Class-Path: minim.jar
Add-Exports: java.base/jdk.internal.module
Created-By: 1.7.0_65 (Oracle Corporation)
#! /usr/bin/env bash
# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
cd "$(dirname "$0")/.." || exit 1
scriptname=$(basename "$0")
# check for gpg2
hash gpg2 2>/dev/null && gpgCommand=gpg2 || gpgCommand=gpg
# check if running in a color terminal
terminalSupportsColor() {   local c; c=$(tput colors 2>/dev/null) || c=-1;   [[ -t 1 ]] && [[ $c -ge 8 ]]; }
terminalSupportsColor && doColor=1 || doColor=0
color() { local c; c=$1; shift; [[ $doColor -eq 1 ]] && echo -e "\\e[0;${c}m${*}\\e[0m" || echo "$@"; }
red() { color 31 "$@"; }
green() { color 32 "$@"; }
yellow() { color 33 "$@"; }
fail() { echo -e ' ' "$@"; exit 1; }
runLog() { local o; o=$1 && shift && echo "$(green Running) $(yellow "$@" '>>' "$o")" && echo Running "$@" >> "$o" && eval "$@" >> "$o"; }
run() { echo "$(green Running) $(yellow "$@")" && eval "$@"; }
runOrFail() { run "$@" || fail "$(yellow "$@")" "$(red failed)"; }
currentBranch() { local b; b=$(git symbolic-ref -q HEAD) && echo "${b##refs/heads/}"; }
cacheGPG() {   { hash gpg-connect-agent && gpg-connect-agent reloadagent /bye; } &>/dev/null   local TESTFILE; TESTFILE=$(mktemp --tmpdir "${USER}-gpgTestFile-XXXXXXXX.txt");   [[ -r $TESTFILE ]] && "$gpgCommand" --sign "${TESTFILE}" && rm -f "${TESTFILE}" "${TESTFILE}.gpg"; }
prompter() {   local x;   read -r -p "Enter the $1: " x;   until eval "[[ \$x =~ ^$2\$ ]]"; do     echo "  $(red "$x") is not a proper $1" 1>&2;     read -r -p "Enter the $1: " x;   done;   echo "$x"; }
pretty() { local f; f=$1; shift; git log "--pretty=tformat:$f" "$@"; }
gitCommits() { pretty %H "$@"; }
gitCommit()  { gitCommits -n1 "$@"; }
gitSubject() { pretty %s "$@"; }
createEmail() {   local ver; [[ -n $1 ]] && ver=$1 || ver=$(prompter 'version to be released (eg. x.y.z)' '[0-9]+[.][0-9]+[.][0-9]+');   local rc; [[ -n $2 ]] && rc=$2 || rc=$(prompter 'release candidate sequence number (eg. 1, 2, etc.)' '[0-9]+');   local stagingrepo; [[ -n $3 ]] && stagingrepo=$3 || stagingrepo=$(prompter 'staging repository number from https://repository.apache.org/#stagingRepositories' '[0-9]+');    local branch; branch=$ver-rc$rc;   local commit; commit=$(gitCommit "$branch") || exit 1;   local tag; tag=rel/$ver;   echo;   yellow  "IMPORTANT!! IMPORTANT!! IMPORTANT!! IMPORTANT!! IMPORTANT!! IMPORTANT!!";   echo;   echo    "    Don't forget to push a branch named $(green "$branch") with";   echo    "    its head at $(green "${commit:0:7}") so others can review using:";   echo    "      $(green "git push origin ${commit:0:7}:refs/heads/$branch")";   echo;   echo    "    Remember, $(red DO NOT PUSH) the $(red "$tag") tag until after the vote";   echo    "    passes and the tag is re-made with a gpg signature using:";   echo    "      $(red "git tag -f -m 'Apache Accumulo $ver' -s $tag ${commit:0:7}")";   echo;   yellow  "IMPORTANT!! IMPORTANT!! IMPORTANT!! IMPORTANT!! IMPORTANT!! IMPORTANT!!";   echo;   read -r -s -p 'Press Enter to generate the [VOTE] email...';   echo 1>&2;    local votedate; votedate=$(date -d "+3 days 30 minutes" "+%s")   local halfhour; halfhour=$((votedate - (votedate % 1800)));   votedate=$(date -u -d"1970-01-01 $halfhour seconds UTC");   export TZ="America/New_York";   local edtvotedate; edtvotedate=$(date -d"1970-01-01 $halfhour seconds UTC");   export TZ="America/Los_Angeles";   local pdtvotedate; pdtvotedate=$(date -d"1970-01-01 $halfhour seconds UTC");    local fingerprint; fingerprint=$("$gpgCommand" --list-secret-keys --with-colons --with-fingerprint 2>/dev/null | awk -F: '$1 == "fpr" {print $10}');   [[ -z $fingerprint ]] && fingerprint="UNSPECIFIED"; 
  cat <<EOF
$(yellow '============================================================')
Subject: $(green [VOTE] Accumulo "$branch")
$(yellow '============================================================')
Accumulo Developers,

Please consider the following candidate for Accumulo $(green "$ver").

Git Commit:
    $(green "$commit")
Branch:
    $(green "$branch")

If this vote passes, a gpg-signed tag will be created using:
    $(green "git tag -f -m 'Apache Accumulo $ver' -s $tag $commit")

Staging repo: $(green "https://repository.apache.org/content/repositories/orgapacheaccumulo-$stagingrepo")
Source (official release artifact): $(green "https://repository.apache.org/content/repositories/orgapacheaccumulo-$stagingrepo/org/apache/accumulo/accumulo/$ver/accumulo-$ver-src.tar.gz")
Binary: $(green "https://repository.apache.org/content/repositories/orgapacheaccumulo-$stagingrepo/org/apache/accumulo/accumulo/$ver/accumulo-$ver-bin.tar.gz")
(Append ".sha1", ".md5", or ".asc" to download the signature/hash for a given artifact.)

All artifacts were built and staged with:
    mvn release:prepare && mvn release:perform

Signing keys are available at https://www.apache.org/dist/accumulo/KEYS
(Expected fingerprint: $(green "$fingerprint"))

Release notes (in progress) can be found at: $(green "https://accumulo.apache.org/release_notes/$ver")

Please vote one of:
[ ] +1 - I have verified and accept...
[ ] +0 - I have reservations, but not strong enough to vote against...
[ ] -1 - Because..., I do not accept...
... these artifacts as the $(green "$ver") release of Apache Accumulo.

This vote will remain open until at least $(green "$votedate")
($(green "$edtvotedate") / $(green "$pdtvotedate")).
Voting continues until the release manager sends an email closing the vote.

Thanks!

P.S. Hint: download the whole staging repo with
    wget -erobots=off -r -l inf -np -nH \\
    $(green "https://repository.apache.org/content/repositories/orgapacheaccumulo-$stagingrepo/")
    # note the trailing slash is needed
$(yellow '============================================================')
EOF
 }
cleanUpAndFail() {   echo "  Failure in $(red "$1")!";   echo "  Check output in $(yellow "$2")";   echo "  Initiating clean up steps...";    run git checkout "$3";    local branches; branches=("$4");   local tags; tags=();   local x; local y;   for x in $(gitCommits "${cBranch}..${nBranch}"); do     for y in $(git branch --contains "$x" | cut -c3-); do       branches=("${branches[@]}" "$y");     done;     for y in $(git tag --contains "$x"); do       tags=("${tags[@]}" "$y");     done;   done;    local a;   branches=($(printf "%s\n" "${branches[@]}" | sort -u));   for x in "${branches[@]}"; do     echo "Do you wish to clean up (delete) the branch $(yellow "$x")?";     a=$(prompter "letter 'y' or 'n'" '[yn]');     [[ $a == 'y' ]] && git branch -D "$x";   done;   for x in "${tags[@]}"; do     echo "Do you wish to clean up (delete) the tag $(yellow "$x")?";     a=$(prompter "letter 'y' or 'n'" '[yn]');     [[ $a == 'y' ]] && git tag -d "$x";   done;   exit 1; }
createReleaseCandidate() {   yellow  "WARNING!! WARNING!! WARNING!! WARNING!! WARNING!! WARNING!!";   echo;   echo    "  This will modify your local git repository by creating";   echo    "  branches and tags. Afterwards, you may need to perform";   echo    "  some manual steps to complete the release or to rollback";   echo    "  in the case of failure.";   echo;   yellow  "WARNING!! WARNING!! WARNING!! WARNING!! WARNING!! WARNING!!";   echo;    local extraReleaseArgs; extraReleaseArgs=("$@");   if [[ ${#extraReleaseArgs[@]} -ne 0 ]]; then     red "CAUTION!! Extra release args may create a non-standard release!!";     red "You added '${extraReleaseArgs[*]}'";   fi;   [[ ${#extraReleaseArgs[@]} -eq 0 ]] && [[ $gpgCommand != 'gpg' ]] && extraReleaseArgs=("-Dgpg.executable=$gpgCommand");   extraReleaseArgs="-DextraReleaseArgs='${extraReleaseArgs[*]}'";    local ver
  ver=$(xmllint --shell pom.xml <<<'xpath /*[local-name()="project"]/*[local-name()="version"]/text()' | grep content= | cut -f2 -d=);   ver=${ver%%-SNAPSHOT};   echo "Building release candidate for version: $(green "$ver")";    local cBranch; cBranch=$(currentBranch) || fail "$(red Failure)" to get current branch from git;   local rc; rc=$(prompter 'release candidate sequence number (eg. 1, 2, etc.)' '[0-9]+');   local rcBranch; rcBranch=$ver-rc$rc;   local nBranch; nBranch=$rcBranch-next;    cacheGPG || fail "Unable to cache GPG credentials into gpg-agent";    {     run git branch "$nBranch" "$cBranch" && run git checkout "$nBranch";   } || fail "Unable to create working branch $(red "$nBranch") from $(red "$cBranch")!";    local oFile; oFile=$(mktemp --tmpdir "accumulo-build-$rcBranch-XXXXXXXX.log");   {     [[ -w $oFile ]] && runLog "$oFile" mvn clean release:clean;   } || cleanUpAndFail 'mvn clean release:clean' "$oFile" "$cBranch" "$nBranch";   runLog "$oFile" mvn -B release:prepare "${extraReleaseArgs}" ||     cleanUpAndFail "mvn release:prepare ${extraReleaseArgs}" "$oFile" "$cBranch" "$nBranch";   runLog "$oFile" mvn release:perform "${extraReleaseArgs}" ||     cleanUpAndFail "mvn release:perform ${extraReleaseArgs}" "$oFile" "$cBranch" "$nBranch";    run git checkout "${cBranch}";    {     [[ $(gitCommits "${cBranch}..${nBranch}" | wc -l) -eq 2 ]] &&       [[ $(gitCommit  "${nBranch}~2") ==  $(gitCommit "${cBranch}") ]] &&       [[ $(gitSubject "${nBranch}")   =~ ^\[maven-release-plugin\]\ prepare\ for\ next ]] &&       [[ $(gitSubject "${nBranch}~1") =~ ^\[maven-release-plugin\]\ prepare\ release\ rel[/]$ver ]];   } || cleanUpAndFail "verifying that $nBranch contains only logs from release plugin";    [[ $(gitCommit "${nBranch}~1") == $(gitCommit "refs/tags/rel/$ver") ]] ||     cleanUpAndFail "verifying that ${nBranch}~1 == refs/tags/rel/$ver";    run git tag -d "rel/$ver" ||     cleanUpAndFail "removing unused git tag rel/$ver";    run git branch "$rcBranch" "${nBranch}~1" ||     cleanUpAndFail "creating branch $rcBranch";    local origin; origin=$(git remote -v | grep ^origin | grep push | awk '{print $2}');   echo "Do you wish to push the following branches to origin ($(green "$origin"))?";   echo "  $(yellow "$rcBranch")      (for others to examine for the vote)";   echo "  $(yellow "$nBranch") (for merging into $cBranch if vote passes)";   local a; a=$(prompter "letter 'y' or 'n'" '[yn]');   {     [[ $a == 'y' ]] &&       run git push -u origin "refs/heads/$nBranch" "refs/heads/$rcBranch";   } || red "Did not push branches; you'll need to perform this step manually.";    echo "$(red Running)" "$(yellow "$scriptname" --create-email "$ver" "$rc")";   createEmail "$ver" "$rc"; }
if [[ $1 == '--create-release-candidate' ]]; then   shift;   createReleaseCandidate "$@"; elif [[ $1 == '--test' ]]; then   cacheGPG   runOrFail mvn clean install -P apache-release,accumulo-release,thrift; elif [[ $1 == '--create-email' ]]; then   shift;   createEmail "$@"; else   fail "Missing one of: $(red --create-release-candidate), $(red --test), $(red --create-email)"; fi
#! /usr/bin/env bash
# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# Start: Resolve Script Directory
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink    bin="$( cd -P "$( dirname "$SOURCE" )" && pwd )";    SOURCE="$(readlink "$SOURCE")";    [[ $SOURCE != /* ]] && SOURCE="$bin/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located; done
bin="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
# Stop: Resolve Script Directory
. "$bin"/config.sh
#! /usr/bin/env bash
# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
function usage {
  cat <<EOF
Usage: bootstrap_config.sh [-options]
where options include (long options not available on all platforms):
    -d, --dir        Alternate directory to setup config files
    -s, --size       Supported sizes: '1GB' '2GB' '3GB' '512MB'
    -n, --native     Configure to use native libraries
    -j, --jvm        Configure to use the jvm
    -o, --overwrite  Overwrite the default config directory
    -v, --version    Specify the Apache Hadoop version supported versions: '1' '2'
    -k, --kerberos   Configure for use with Kerberos
    -h, --help       Print this help message
EOF
 }
# Start: Resolve Script Directory
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink   bin="$( cd -P "$( dirname "$SOURCE" )" && pwd )";   SOURCE="$(readlink "$SOURCE")";   [[ $SOURCE != /* ]] && SOURCE="$bin/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located; done
bin="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
# Stop: Resolve Script Directory
#
# Resolve accumulo home for bootstrapping
#
ACCUMULO_HOME=$( cd -P ${bin}/.. && pwd )
TEMPLATE_CONF_DIR="${ACCUMULO_HOME}/conf/templates"
CONF_DIR="${ACCUMULO_HOME}/conf"
ACCUMULO_SITE=accumulo-site.xml
ACCUMULO_ENV=accumulo-env.sh
SIZE=
TYPE=
HADOOP_VERSION=
OVERWRITE="0"
BASE_DIR=
KERBEROS=
#Execute getopt
if [[ $(uname -s) == "Linux" ]]; then   args=$(getopt -o "b:d:s:njokv:h" -l "basedir:,dir:,size:,native,jvm,overwrite,kerberos,version:,help" -q -- "$@"); else # Darwin, BSD   args=$(getopt b:d:s:njokv:h $*); fi
#Bad arguments
if [[ $? != 0 ]]; then   usage 1>&2;   exit 1; fi
eval set -- $args
for i;do   case "$i" in     -b|--basedir) #Hidden option used to set general.maven.project.basedir for developers       BASE_DIR=$2; shift;       shift;;     -d|--dir)       CONF_DIR=$2; shift;       shift;;     -s|--size)       SIZE=$2; shift;       shift;;     -n|--native)       TYPE=native;       shift;;     -j|--jvm)       TYPE=jvm;       shift;;     -o|--overwrite)       OVERWRITE=1;       shift;;     -v|--version)       HADOOP_VERSION=$2; shift;       shift;;     -k|--kerberos)       KERBEROS="true";       shift;;     -h|--help)       usage;       exit 0;       shift;;     --)     shift;     break;;   esac; done
while [[ "${OVERWRITE}" = "0" ]]; do   if [[ -e "${CONF_DIR}/${ACCUMULO_ENV}" || -e "${CONF_DIR}/${ACCUMULO_SITE}" ]]; then     echo "Warning your current config files in ${CONF_DIR} will be overwritten!";     echo;     echo "How would you like to proceed?:";     select CHOICE in 'Continue with overwrite' 'Specify new conf dir'; do       if [[ "${CHOICE}" = 'Specify new conf dir' ]]; then         echo -n "Please specifiy new conf directory: ";         read CONF_DIR;       elif [[ "${CHOICE}" = 'Continue with overwrite' ]]; then         OVERWRITE=1;       fi;       break;     done;   else     OVERWRITE=1;   fi; done
echo "Copying configuration files to: ${CONF_DIR}"
#Native 1GB
native_1GB_tServer="-Xmx128m -Xms128m"
_1GB_master="-Xmx128m -Xms128m"
_1GB_monitor="-Xmx64m -Xms64m"
_1GB_gc="-Xmx64m -Xms64m"
_1GB_other="-Xmx128m -Xms64m"
_1GB_memoryMapMax="256M"
native_1GB_nativeEnabled="true"
_1GB_cacheDataSize="15M"
_1GB_cacheIndexSize="40M"
_1GB_sortBufferSize="50M"
_1GB_waLogMaxSize="256M"
#Native 2GB
native_2GB_tServer="-Xmx256m -Xms256m"
_2GB_master="-Xmx256m -Xms256m"
_2GB_monitor="-Xmx128m -Xms64m"
_2GB_gc="-Xmx128m -Xms128m"
_2GB_other="-Xmx256m -Xms64m"
_2GB_memoryMapMax="512M"
native_2GB_nativeEnabled="true"
_2GB_cacheDataSize="30M"
_2GB_cacheIndexSize="80M"
_2GB_sortBufferSize="50M"
_2GB_waLogMaxSize="512M"
#Native 3GB
native_3GB_tServer="-Xmx1g -Xms1g -XX:NewSize=500m -XX:MaxNewSize=500m"
_3GB_master="-Xmx1g -Xms1g"
_3GB_monitor="-Xmx1g -Xms256m"
_3GB_gc="-Xmx256m -Xms256m"
_3GB_other="-Xmx1g -Xms256m"
_3GB_memoryMapMax="1G"
native_3GB_nativeEnabled="true"
_3GB_cacheDataSize="128M"
_3GB_cacheIndexSize="128M"
_3GB_sortBufferSize="200M"
_3GB_waLogMaxSize="1G"
#Native 512MB
native_512MB_tServer="-Xmx48m -Xms48m"
_512MB_master="-Xmx128m -Xms128m"
_512MB_monitor="-Xmx64m -Xms64m"
_512MB_gc="-Xmx64m -Xms64m"
_512MB_other="-Xmx128m -Xms64m"
_512MB_memoryMapMax="80M"
native_512MB_nativeEnabled="true"
_512MB_cacheDataSize="7M"
_512MB_cacheIndexSize="20M"
_512MB_sortBufferSize="50M"
_512MB_waLogMaxSize="100M"
#JVM 1GB
jvm_1GB_tServer="-Xmx384m -Xms384m"
jvm_1GB_nativeEnabled="false"
#JVM 2GB
jvm_2GB_tServer="-Xmx768m -Xms768m"
jvm_2GB_nativeEnabled="false"
#JVM 3GB
jvm_3GB_tServer="-Xmx2g -Xms2g -XX:NewSize=1G -XX:MaxNewSize=1G"
jvm_3GB_nativeEnabled="false"
#JVM 512MB
jvm_512MB_tServer="-Xmx128m -Xms128m"
jvm_512MB_nativeEnabled="false"
if [[ -z "${SIZE}" ]]; then   echo "Choose the heap configuration:";   select DIRNAME in 1GB 2GB 3GB 512MB; do     echo "Using '${DIRNAME}' configuration";     SIZE=${DIRNAME};     break;   done; elif [[ "${SIZE}" != "1GB" && "${SIZE}" != "2GB"  && "${SIZE}" != "3GB" && "${SIZE}" != "512MB" ]]; then   echo "Invalid memory size";   echo "Supported sizes: '1GB' '2GB' '3GB' '512MB'";   exit 1; fi
if [[ -z "${TYPE}" ]]; then   echo;   echo "Choose the Accumulo memory-map type:";   select TYPENAME in Java Native; do     if [[ "${TYPENAME}" == "Native" ]]; then       TYPE="native";       echo "Don't forget to build the native libraries using the bin/build_native_library.sh script";     elif [[ "${TYPENAME}" == "Java" ]]; then       TYPE="jvm";     fi;     echo "Using '${TYPE}' configuration";     echo;     break;   done; fi
if [[ -z "${HADOOP_VERSION}" ]]; then   echo;   echo "Choose the Apache Hadoop version:";   select HADOOP in 'Hadoop 2' 'HDP 2.0/2.1' 'HDP 2.2' 'IOP 4.1'; do     if [ "${HADOOP}" == "Hadoop 2" ]; then       HADOOP_VERSION="2";     elif [ "${HADOOP}" == "HDP 2.0/2.1" ]; then       HADOOP_VERSION="HDP2";     elif [ "${HADOOP}" == "HDP 2.2" ]; then       HADOOP_VERSION="HDP2.2";     elif [ "${HADOOP}" == "IOP 4.1" ]; then       HADOOP_VERSION="IOP4.1";     fi;     echo "Using Hadoop version '${HADOOP_VERSION}' configuration";     echo;     break;   done; elif [[ "${HADOOP_VERSION}" != "2" && "${HADOOP_VERSION}" != "HDP2" && "${HADOOP_VERSION}" != "HDP2.2" ]]; then   echo "Invalid Hadoop version";   echo "Supported Hadoop versions: '2', 'HDP2', 'HDP2.2'";   exit 1; fi
TRACE_USER="root"
if [[ ! -z "${KERBEROS}" ]]; then   echo;   read -p "Enter server's Kerberos principal: " PRINCIPAL;   read -p "Enter server's Kerberos keytab: " KEYTAB;   TRACE_USER="${PRINCIPAL}"; fi
for var in SIZE TYPE HADOOP_VERSION; do   if [[ -z ${!var} ]]; then     echo "Invalid $var configuration";     exit 1;   fi; done
TSERVER="${TYPE}_${SIZE}_tServer"
MASTER="_${SIZE}_master"
MONITOR="_${SIZE}_monitor"
GC="_${SIZE}_gc"
OTHER="_${SIZE}_other"
MEMORY_MAP_MAX="_${SIZE}_memoryMapMax"
NATIVE="${TYPE}_${SIZE}_nativeEnabled"
CACHE_DATA_SIZE="_${SIZE}_cacheDataSize"
CACHE_INDEX_SIZE="_${SIZE}_cacheIndexSize"
SORT_BUFFER_SIZE="_${SIZE}_sortBufferSize"
WAL_MAX_SIZE="_${SIZE}_waLogMaxSize"
MAVEN_PROJ_BASEDIR=""
if [[ ! -z "${BASE_DIR}" ]]; then   MAVEN_PROJ_BASEDIR="\n  <property>\n    <name>general.maven.project.basedir</name>\n    <value>${BASE_DIR}</value>\n  </property>\n"; fi
#Configure accumulo-env.sh
mkdir -p "${CONF_DIR}" && cp ${TEMPLATE_CONF_DIR}/* ${CONF_DIR}/
sed -e "s/\${tServerHigh_tServerLow}/${!TSERVER}/"     -e "s/\${masterHigh_masterLow}/${!MASTER}/"     -e "s/\${monitorHigh_monitorLow}/${!MONITOR}/"     -e "s/\${gcHigh_gcLow}/${!GC}/"     -e "s/\${otherHigh_otherLow}/${!OTHER}/"     ${TEMPLATE_CONF_DIR}/$ACCUMULO_ENV > ${CONF_DIR}/$ACCUMULO_ENV
#Configure accumulo-site.xml
sed -e "s/\${memMapMax}/${!MEMORY_MAP_MAX}/"     -e "s/\${nativeEnabled}/${!NATIVE}/"     -e "s/\${cacheDataSize}/${!CACHE_DATA_SIZE}/"     -e "s/\${cacheIndexSize}/${!CACHE_INDEX_SIZE}/"     -e "s/\${sortBufferSize}/${!SORT_BUFFER_SIZE}/"     -e "s/\${waLogMaxSize}/${!WAL_MAX_SIZE}/"     -e "s=\${traceUser}=${TRACE_USER}="     -e "s=\${mvnProjBaseDir}=${MAVEN_PROJ_BASEDIR}=" ${TEMPLATE_CONF_DIR}/$ACCUMULO_SITE > ${CONF_DIR}/$ACCUMULO_SITE
# If we're not using kerberos, filter out the krb properties
if [[ -z "${KERBEROS}" ]]; then   sed -e 's/<!-- Kerberos requirements -->/<!-- Kerberos requirements --><!--/'       -e 's/<!-- End Kerberos requirements -->/--><!-- End Kerberos requirements -->/'       "${CONF_DIR}/$ACCUMULO_SITE" > temp;   mv temp "${CONF_DIR}/$ACCUMULO_SITE"; else   sed -e "s!\${keytab}!${KEYTAB}!"       -e "s!\${principal}!${PRINCIPAL}!"       ${CONF_DIR}/${ACCUMULO_SITE} > temp;   mv temp ${CONF_DIR}/${ACCUMULO_SITE}; fi
# Configure hadoop version
if [[ "${HADOOP_VERSION}" == "2" ]]; then   sed -e 's/<!-- HDP 2.0 requirements -->/<!-- HDP 2.0 requirements --><!--/'       -e 's/<!-- End HDP 2.0 requirements -->/--><!-- End HDP 2.0 requirements -->/'       "${CONF_DIR}/$ACCUMULO_SITE" > temp;   mv temp "${CONF_DIR}/$ACCUMULO_SITE";   sed -e 's/<!-- HDP 2.2 requirements -->/<!-- HDP 2.2 requirements --><!--/'       -e 's/<!-- End HDP 2.2 requirements -->/--><!-- End HDP 2.2 requirements -->/'       "${CONF_DIR}/$ACCUMULO_SITE" > temp;   mv temp "${CONF_DIR}/$ACCUMULO_SITE";   sed -e 's/<!-- IOP 4.1 requirements -->/<!-- IOP 4.1 requirements --><!--/'       -e 's/<!-- End IOP 4.1 requirements -->/--><!-- End IOP 4.1 requirements -->/'       "${CONF_DIR}/$ACCUMULO_SITE" > temp;   mv temp "${CONF_DIR}/$ACCUMULO_SITE"; elif [[ "${HADOOP_VERSION}" == "HDP2" ]]; then   sed -e 's/<!-- Hadoop 2 requirements -->/<!-- Hadoop 2 requirements --><!--/'       -e 's/<!-- End Hadoop 2 requirements -->/--><!-- End Hadoop 2 requirements -->/'       "${CONF_DIR}/$ACCUMULO_SITE" > temp;   mv temp "${CONF_DIR}/$ACCUMULO_SITE";   sed -e 's/<!-- HDP 2.2 requirements -->/<!-- HDP 2.2 requirements --><!--/'       -e 's/<!-- End HDP 2.2 requirements -->/--><!-- End HDP 2.2 requirements -->/'       "${CONF_DIR}/$ACCUMULO_SITE" > temp;   mv temp "${CONF_DIR}/$ACCUMULO_SITE";   sed -e 's/<!-- IOP 4.1 requirements -->/<!-- IOP 4.1 requirements --><!--/'       -e 's/<!-- End IOP 4.1 requirements -->/--><!-- End IOP 4.1 requirements -->/'       "${CONF_DIR}/$ACCUMULO_SITE" > temp;   mv temp "${CONF_DIR}/$ACCUMULO_SITE"; elif [[ "${HADOOP_VERSION}" == "HDP2.2" ]]; then   sed -e 's/<!-- Hadoop 2 requirements -->/<!-- Hadoop 2 requirements --><!--/'       -e 's/<!-- End Hadoop 2 requirements -->/--><!-- End Hadoop 2 requirements -->/'       "${CONF_DIR}/$ACCUMULO_SITE" > temp;   mv temp "${CONF_DIR}/$ACCUMULO_SITE";   sed -e 's/<!-- HDP 2.0 requirements -->/<!-- HDP 2.0 requirements --><!--/'       -e 's/<!-- End HDP 2.0 requirements -->/--><!-- End HDP 2.0 requirements -->/'       "${CONF_DIR}/$ACCUMULO_SITE" > temp;   mv temp "${CONF_DIR}/$ACCUMULO_SITE";   sed -e 's/<!-- IOP 4.1 requirements -->/<!-- IOP 4.1 requirements --><!--/'       -e 's/<!-- End IOP 4.1 requirements -->/--><!-- End IOP 4.1 requirements -->/'       "${CONF_DIR}/$ACCUMULO_SITE" > temp;   mv temp "${CONF_DIR}/$ACCUMULO_SITE"; elif [[ "${HADOOP_VERSION}" == "IOP4.1" ]]; then   sed -e 's/<!-- Hadoop 2 requirements -->/<!-- Hadoop 2 requirements --><!--/'       -e 's/<!-- End Hadoop 2 requirements -->/--><!-- End Hadoop 2 requirements -->/'       "${CONF_DIR}/$ACCUMULO_SITE" > temp;   mv temp "${CONF_DIR}/$ACCUMULO_SITE";   sed -e 's/<!-- HDP 2.0 requirements -->/<!-- HDP 2.0 requirements --><!--/'       -e 's/<!-- End HDP 2.0 requirements -->/--><!-- End HDP 2.0 requirements -->/'       "${CONF_DIR}/$ACCUMULO_SITE" > temp;   mv temp "${CONF_DIR}/$ACCUMULO_SITE";   sed -e 's/<!-- HDP 2.2 requirements -->/<!-- HDP 2.2 requirements --><!--/'       -e 's/<!-- End HDP 2.2 requirements -->/--><!-- End HDP 2.2 requirements -->/'       "${CONF_DIR}/$ACCUMULO_SITE" > temp;   mv temp "${CONF_DIR}/$ACCUMULO_SITE"; fi
#Additional setup steps for native configuration.
if [[ ${TYPE} == native ]]; then   if [[ $(uname) == Linux ]]; then     if [[ -z $HADOOP_PREFIX ]]; then       echo "WARNING: HADOOP_PREFIX not set, cannot automatically configure LD_LIBRARY_PATH to include Hadoop native libraries";     else       NATIVE_LIB=$(readlink -ef $(dirname $(for x in $(find $HADOOP_PREFIX -name libhadoop.so); do ld $x 2>/dev/null && echo $x && break; done) 2>>/dev/null) 2>>/dev/null);       if [[ -z $NATIVE_LIB ]]; then         echo -e "WARNING: The Hadoop native libraries could not be found for your sytem in: $HADOOP_PREFIX";       else         sed "/# Should the monitor/ i export LD_LIBRARY_PATH=${NATIVE_LIB}:\${LD_LIBRARY_PATH}" ${CONF_DIR}/$ACCUMULO_ENV > temp;         mv temp "${CONF_DIR}/$ACCUMULO_ENV";         echo -e "Added ${NATIVE_LIB} to the LD_LIBRARY_PATH";       fi;     fi;   fi;   echo -e "Please remember to compile the Accumulo native libraries using the bin/build_native_library.sh script and to set the LD_LIBRARY_PATH variable in the ${CONF_DIR}/accumulo-env.sh script if needed."; fi
echo "Setup complete"
#! /usr/bin/env bash
# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# Start: Resolve Script Directory
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink    bin="$( cd -P "$( dirname "$SOURCE" )" && pwd )";    SOURCE="$(readlink "$SOURCE")";    [[ $SOURCE != /* ]] && SOURCE="$bin/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located; done
bin="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
# Stop: Resolve Script Directory
. "$bin"/config.sh
#! /usr/bin/env bash
# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# Start: Resolve Script Directory
SOURCE="${BASH_SOURCE[0]}"
while [[ -h "$SOURCE" ]]; do # resolve $SOURCE until the file is no longer a symlink    bin=$( cd -P "$( dirname "$SOURCE" )" && pwd );    SOURCE="$(readlink "$SOURCE")";    [[ $SOURCE != /* ]] && SOURCE="$bin/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located; done
bin=$( cd -P "$( dirname "$SOURCE" )" && pwd )
script=$( basename "$SOURCE" )
# Stop: Resolve Script Directory
lib=${bin}/../lib
native_tarball=${lib}/accumulo-native.tar.gz
final_native_target="${lib}/native"
if [[ ! -f $native_tarball ]]; then     echo "Could not find native code artifact: ${native_tarball}";     exit 1; fi
#! /usr/bin/env python
# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# This script will check the configuration and uniformity of all the nodes in a cluster.
# Checks
#   each node is reachable via ssh
#   login identity is the same
#   the physical memory is the same
#   the mounts are the same on each machine
#   a set of writable locations (typically different disks) are in fact writable
# 
# In order to check for writable partitions, you must configure the WRITABLE variable below.
#
import subprocess
import time
import select
import os
import sys
import fcntl
import signal
if not sys.platform.startswith('linux'):
#! /usr/bin/env bash
# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# Start: Resolve Script Directory
SOURCE="${BASH_SOURCE[0]}"
while [ -h "${SOURCE}" ]; do # resolve $SOURCE until the file is no longer a symlink    bin="$( cd -P "$( dirname "${SOURCE}" )" && pwd )";    SOURCE="$(readlink "${SOURCE}")";    [[ "${SOURCE}" != /* ]] && SOURCE="${bin}/${SOURCE}" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located; done
bin="$( cd -P "$( dirname "${SOURCE}" )" && pwd )"
script=$( basename "${SOURCE}" )
# Stop: Resolve Script Directory
. "${bin}"/config.sh
#! /usr/bin/env bash
# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
###
### Configure these environment variables to point to your local installations.
###
### The functional tests require conditional values, so keep this style:
###
### test -z "$JAVA_HOME" && export JAVA_HOME=/usr/lib/jvm/java
###
###
### Note that the -Xmx -Xms settings below require substantial free memory:
### you may want to use smaller values, especially when running everything
### on a single machine.
###
if [[ -z $HADOOP_HOME ]] ; then    test -z "$HADOOP_PREFIX"      && export HADOOP_PREFIX=/path/to/hadoop; else    HADOOP_PREFIX="$HADOOP_HOME";    unset HADOOP_HOME; fi
# hadoop-2.0:
test -z "$HADOOP_CONF_DIR"       && export HADOOP_CONF_DIR="$HADOOP_PREFIX/etc/hadoop"
test -z "$JAVA_HOME"             && export JAVA_HOME=/path/to/java
test -z "$ZOOKEEPER_HOME"        && export ZOOKEEPER_HOME=/path/to/zookeeper
test -z "$ACCUMULO_LOG_DIR"      && export ACCUMULO_LOG_DIR=$ACCUMULO_HOME/logs
if [[ -f ${ACCUMULO_CONF_DIR}/accumulo.policy ]]; then    POLICY="-Djava.security.manager -Djava.security.policy=${ACCUMULO_CONF_DIR}/accumulo.policy"; fi
test -z "$ACCUMULO_TSERVER_OPTS" && export ACCUMULO_TSERVER_OPTS="${POLICY} ${tServerHigh_tServerLow} "
test -z "$ACCUMULO_MASTER_OPTS"  && export ACCUMULO_MASTER_OPTS="${POLICY} ${masterHigh_masterLow}"
test -z "$ACCUMULO_MONITOR_OPTS" && export ACCUMULO_MONITOR_OPTS="${POLICY} ${monitorHigh_monitorLow}"
test -z "$ACCUMULO_GC_OPTS"      && export ACCUMULO_GC_OPTS="${gcHigh_gcLow}"
test -z "$ACCUMULO_GENERAL_OPTS" && export ACCUMULO_GENERAL_OPTS="-XX:+UseConcMarkSweepGC -XX:CMSInitiatingOccupancyFraction=75 -Djava.net.preferIPv4Stack=true -XX:+CMSClassUnloadingEnabled"
test -z "$ACCUMULO_OTHER_OPTS"   && export ACCUMULO_OTHER_OPTS="${otherHigh_otherLow}"
# what do when the JVM runs out of heap memory
export ACCUMULO_KILL_CMD='kill -9 %p'
### Optionally look for hadoop and accumulo native libraries for your
### platform in additional directories. (Use DYLD_LIBRARY_PATH on Mac OS X.)
### May not be necessary for Hadoop 2.x or using an RPM that installs to
### the correct system library directory.
# export LD_LIBRARY_PATH=${HADOOP_PREFIX}/lib/native/${PLATFORM}:${LD_LIBRARY_PATH}
# Should the monitor bind to all network interfaces -- default: false
# export ACCUMULO_MONITOR_BIND_ALL="true"
# Should process be automatically restarted
# export ACCUMULO_WATCHER="true"
# What settings should we use for the watcher, if enabled
export UNEXPECTED_TIMESPAN="3600"
export UNEXPECTED_RETRIES="2"
export OOM_TIMESPAN="3600"
export OOM_RETRIES="5"
export ZKLOCK_TIMESPAN="600"
export ZKLOCK_RETRIES="5"
/*
 * Licensed to the Apache Software Foundation (ASF) under one or more
<?xml version="1.0" standalone="yes"?>
/c/REAPER/OSC/Default.ReaperOSC /c/REAPER/OSC/LogicPad.ReaperOSC /c/REAPER/OSC/LogicTouch.ReaperOSC
/c/Users/Lex/Desktop/reaper_extension_sdk/jmde/reaper_ninjamloop/reaper_ninjamloop.xcodeproj/project.pbxproj
/c/Users/Lex/Desktop/reaper_extension_sdk/jmde/reaper_ninjamloop/mac_resgen.php/c/Users/Lex/Desktop/reaper_extension_sdk/jmde/reaper_ninjamloop/mac_resgen.php/c/Users/Lex/Desktop/reaper_extension_sdk/jmde/reaper_ninjamloop/mac_resgen.php
/c/Users/Lex/Desktop/reaper_extension_sdk/jmde/reaper_ninjamloop/res.rc
/c/Users/Lex/Desktop/reaper_extension_sdk/jmde/reaper_ninjamloop/mac_resgen.php /c/Users/Lex/Desktop/reaper_extension_sdk/jmde/reaper_ninjamloop/main.cpp /c/Users/Lex/Desktop/reaper_extension_sdk/jmde/reaper_ninjamloop/projectconfig_example.cpp /c/Users/Lex/Desktop/reaper_extension_sdk/jmde/reaper_ninjamloop/RCa02224 /c/Users/Lex/Desktop/reaper_extension_sdk/jmde/reaper_ninjamloop/reaper_ninjamloop.dsp /c/Users/Lex/Desktop/reaper_extension_sdk/jmde/reaper_ninjamloop/reaper_ninjamloop.dsw /c/Users/Lex/Desktop/reaper_extension_sdk/jmde/reaper_ninjamloop/res.rc /c/Users/Lex/Desktop/reaper_extension_sdk/jmde/reaper_ninjamloop/resource.h
/c/Users/Lex/Desktop/reaper_extension_sdk/jmde/reaper_ninjamloop/reaper_ninjamloop.xcodeproj/project.pbxproj
/c/REAPER/MIDINoteNames/note_name_sample.txt
/c/REAPER/MIDINoteNames/note_name_sample.txt
