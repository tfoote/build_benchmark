#!/bin/bash
#
# This is a rather minimal example Argbash potential
# Example taken from http://argbash.readthedocs.io/en/stable/example.html
#
# ARG_OPTIONAL_SINGLE([count],[c],[Number of rounds per repos file. default: 3],[3])
# ARG_POSITIONAL_INF([repos],[repos file],[1])
# ARG_HELP([Benchmarking tool])
# ARGBASH_GO()
# needed because of Argbash --> m4_ignore([
### START OF CODE GENERATED BY Argbash v2.9.0 one line above ###
# Argbash is a bash code generator used to get arguments parsing right.
# Argbash is FREE SOFTWARE, see https://argbash.io for more info
# Generated online by https://argbash.io/generate


TOP_PACKAGE=common_interfaces
TEST_PACKAGE=sensor_msgs

die()
{
	local _ret="${2:-1}"
	test "${_PRINT_HELP:-no}" = yes && print_help >&2
	echo "$1" >&2
	exit "${_ret}"
}


begins_with_short_option()
{
	local first_option all_short_options='ch'
	first_option="${1:0:1}"
	test "$all_short_options" = "${all_short_options/$first_option/}" && return 1 || return 0
}

# THE DEFAULTS INITIALIZATION - POSITIONALS
_positionals=()
_arg_repos=('' )
# THE DEFAULTS INITIALIZATION - OPTIONALS
_arg_count="3"


print_help()
{
	printf '%s\n' "Benchmarking tool"
	printf 'Usage: %s [-c|--count <arg>] [-h|--help] <repos-1> [<repos-2>] ... [<repos-n>] ...\n' "$0"
	printf '\t%s\n' "<repos>: repos file"
	printf '\t%s\n' "-c, --count: Number of rounds per repos file. default: 3 (default: '3')"
	printf '\t%s\n' "-h, --help: Prints help"
}


parse_commandline()
{
	_positionals_count=0
	while test $# -gt 0
	do
		_key="$1"
		case "$_key" in
			-c|--count)
				test $# -lt 2 && die "Missing value for the optional argument '$_key'." 1
				_arg_count="$2"
				shift
				;;
			--count=*)
				_arg_count="${_key##--count=}"
				;;
			-c*)
				_arg_count="${_key##-c}"
				;;
			-h|--help)
				print_help
				exit 0
				;;
			-h*)
				print_help
				exit 0
				;;
			*)
				_last_positional="$1"
				_positionals+=("$_last_positional")
				_positionals_count=$((_positionals_count + 1))
				;;
		esac
		shift
	done
}


handle_passed_args_count()
{
	local _required_args_string="'repos'"
	test "${_positionals_count}" -ge 1 || _PRINT_HELP=yes die "FATAL ERROR: Not enough positional arguments - we require at least 1 (namely: $_required_args_string), but got only ${_positionals_count}." 1
}


assign_positional_args()
{
	local _positional_name _shift_for=$1
	_positional_names="_arg_repos "
	_our_args=$((${#_positionals[@]} - 1))
	for ((ii = 0; ii < _our_args; ii++))
	do
		_positional_names="$_positional_names _arg_repos[$((ii + 1))]"
	done

	shift "$_shift_for"
	for _positional_name in ${_positional_names}
	do
		test $# -gt 0 || break
		eval "$_positional_name=\${1}" || die "Error during argument parsing, possibly an Argbash bug." 1
		shift
	done
}

parse_commandline "$@"
handle_passed_args_count
assign_positional_args 1 "${_positionals[@]}"

# OTHER STUFF GENERATED BY Argbash


### END OF CODE GENERATED BY Argbash (sortof) ### ])
# [ <-- needed because of Argbash

pull_code () 
{
    echo "$1: Pulling in $PWD"
    mkdir -p src
    vcs import --input $1 src &> /dev/null
    rosdep install --from-paths src --ignore-src -y --skip-keys "fastcdr rti-connext-dds-6.0.1 urdfdom_headers"
}

run_benchmark ()
{
    echo "Cleaning and rebuilding in $PWD"
    rm -rf build/ install/ log/
    rm -f out.txt
    # Workaround for first build of rosidl_generator_py not finding python on first build
    colcon build --executor sequential --packages-up-to rosidl_generator_py &> out.txt
    colcon build --executor sequential --packages-up-to $TOP_PACKAGE &> out.txt
}

parse_and_print ()
{
	grep -R "Finished <<< $TEST_PACKAGE" out.txt
	grep -R "Summary" out.txt
}

for repo in "${_positionals[@]}"
do
    echo "-----------------"
    echo "Preparing repos file: $repo"
    echo "-----------------"
    mkdir -p $repo-src
    cd $repo-src
    pull_code ../$repo
    cd ..
done


for repo in "${_positionals[@]}"
do
    echo "-----------------"
    echo "Benchmarking repos file: $repo"
    echo "-----------------"
    cd $repo-src
    for ((ii = 0; ii < _arg_count; ii++))
    do
	echo "Running benchmark: $((ii + 1))"
	run_benchmark
	parse_and_print
    done
    cd ..
done
