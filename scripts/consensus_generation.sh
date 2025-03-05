#!/usr/bin/env bash

# Created by argbash-init v2.10.0
# ARG_OPTIONAL_SINGLE([reads-consensus],[r],[Number of reads to subsample from a cluster to draft the consensus sequence],[40])
# ARG_OPTIONAL_SINGLE([threads],[t],[Number of threads to use],[8])
# ARG_POSITIONAL_SINGLE([WORK_DIR],[work directory])
# ARG_POSITIONAL_SINGLE([FASTQ_FILE],[FASTQ file])
# ARG_POSITIONAL_SINGLE([PRIMER_SET],[Should be a fasta file in which the head primer should have "head" in its name (case-insensitive). Likewise for the tail primer. Both sequences should be those that appear in the cDNA's sense strand. sequences are not limited to the primers itself but can also include anchor sequences. Longer sequences generally give better results])
# ARG_DEFAULTS_POS([])
# ARG_HELP([<The general help message of my script>])
# ARGBASH_GO()
# needed because of Argbash --> m4_ignore([
### START OF CODE GENERATED BY Argbash v2.10.0 one line above ###
# Argbash is a bash code generator used to get arguments parsing right.
# Argbash is FREE SOFTWARE, see https://argbash.io for more info


die()
{
	local _ret="${2:-1}"
	test "${_PRINT_HELP:-no}" = yes && print_help >&2
	echo "$1" >&2
	exit "${_ret}"
}


begins_with_short_option()
{
	local first_option all_short_options='rth'
	first_option="${1:0:1}"
	test "$all_short_options" = "${all_short_options/$first_option/}" && return 1 || return 0
}

# THE DEFAULTS INITIALIZATION - POSITIONALS
_positionals=()
_arg_work_dir=
_arg_fastq_file=
_arg_primer_set=
# THE DEFAULTS INITIALIZATION - OPTIONALS
_arg_reads_consensus="40"
_arg_threads="8"


print_help()
{
	printf '%s\n' "<The general help message of my script>"
	printf 'Usage: %s [-r|--reads-consensus <arg>] [-t|--threads <arg>] [-h|--help] <WORK_DIR> <FASTQ_FILE> <PRIMER_SET>\n' "$0"
	printf '\t%s\n' "<WORK_DIR>: work directory"
	printf '\t%s\n' "<FASTQ_FILE>: FASTQ file"
	printf '\t%s\n' "<PRIMER_SET>: Should be a fasta file in which the head primer should have \"head\" in its name (case-insensitive). Likewise for the tail primer. Both sequences should be those that appear in the cDNA's sense strand. sequences are not limited to the primers itself but can also include anchor sequences. Longer sequences generally give better results"
	printf '\t%s\n' "-r, --reads-consensus: Number of reads to subsample from a cluster to draft the consensus sequence (default: '40')"
	printf '\t%s\n' "-t, --threads: Number of threads to use (default: '8')"
	printf '\t%s\n' "-h, --help: Prints help"
}


parse_commandline()
{
	_positionals_count=0
	while test $# -gt 0
	do
		_key="$1"
		case "$_key" in
			-r|--reads-consensus)
				test $# -lt 2 && die "Missing value for the optional argument '$_key'." 1
				_arg_reads_consensus="$2"
				shift
				;;
			--reads-consensus=*)
				_arg_reads_consensus="${_key##--reads-consensus=}"
				;;
			-r*)
				_arg_reads_consensus="${_key##-r}"
				;;
			-t|--threads)
				test $# -lt 2 && die "Missing value for the optional argument '$_key'." 1
				_arg_threads="$2"
				shift
				;;
			--threads=*)
				_arg_threads="${_key##--threads=}"
				;;
			-t*)
				_arg_threads="${_key##-t}"
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
	local _required_args_string="'WORK_DIR', 'FASTQ_FILE' and 'PRIMER_SET'"
	test "${_positionals_count}" -ge 3 || _PRINT_HELP=yes die "FATAL ERROR: Not enough positional arguments - we require exactly 3 (namely: $_required_args_string), but got only ${_positionals_count}." 1
	test "${_positionals_count}" -le 3 || _PRINT_HELP=yes die "FATAL ERROR: There were spurious positional arguments --- we expect exactly 3 (namely: $_required_args_string), but got ${_positionals_count} (the last one was: '${_last_positional}')." 1
}


assign_positional_args()
{
	local _positional_name _shift_for=$1
	_positional_names="_arg_work_dir _arg_fastq_file _arg_primer_set "

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
set -euo pipefail

TEMPLATE_DIR="$( dirname -- "$( readlink -f -- "$0"; )"; )"
WORK_DIR="$_arg_work_dir"
PRIMER_SET="$(realpath "$_arg_primer_set")"
READS_CONSENSUS="$_arg_reads_consensus"
THREADS="$_arg_threads"
FASTQ_FILE="$_arg_fastq_file" # name of the fastq to process
CLEAN_NAME="${FASTQ_FILE%.*}"

cd "$WORK_DIR"
echo "$CLEAN_NAME"
mkdir -p "$CLEAN_NAME"
cp "$FASTQ_FILE" "$CLEAN_NAME/."
cd "$CLEAN_NAME"

#skip fastq if the consensus fasta has already been created
if [ -f $CLEAN_NAME.all_consensus.fasta ]
then
    if [ -s $CLEAN_NAME.all_consensus.fasta ]
    then
        echo "File exists and not empty"
        exit
    else
        echo "File exists but empty"
    fi
fi

#total nr of reads/fastq
READ_COUNT=$(( $(awk '{print $1/4}' <(wc -l $FASTQ_FILE)) ))
echo -n "total;$READ_COUNT" > total.log

#searches and trims primers
$TEMPLATE_DIR/primer-chop/bin/primer-chop -q $PRIMER_SET $FASTQ_FILE primerchop_out

#retain only the highest quality reads
filtlong --keep_percent 80 primerchop_out/good-fwd.fq > primerchop_out/good-fwd.filt.fq

vsearch -fastq_filter primerchop_out/good-fwd.filt.fq --fastaout primerchop_out/good-fwd.filt.fa --fastq_qmax 90

#kmer count in the forward oriented reads with forward and reverse primers detected
python $TEMPLATE_DIR/kmer_umap_OPTICS.py primerchop_out/good-fwd.filt.fa $THREADS
CLUSTERS_CNT=$(awk '($2 ~ /[0-9]/) {print $2}' freqs.txthdbscan.output.tsv | sort -nr | uniq | head -n1)

echo "drafting consensus sequences for $CLEAN_NAME"

for ((i = 0 ; i <= $CLUSTERS_CNT ; i++));
do
    cluster_id=$i
    awk -v cluster="$cluster_id" '($2 == cluster) {print $1}' freqs.txthdbscan.output.tsv > $cluster_id\_ids.txt
done

process_cluster() {
    cluster_id=$1
    seqtk subseq primerchop_out/good-fwd.filt.fa "${cluster_id}_ids.txt" > "${cluster_id}.fas"
    READ_COUNT=$(( $(awk '{print $1/2}' <(wc -l "${cluster_id}.fas")) ))
    seqtk sample "${cluster_id}.fas" "${READS_CONSENSUS}"| lamassemble primerchop_out/train.txt - > "${CLEAN_NAME}${cluster_id}@size=${READ_COUNT}@.consensus.fasta"
}

j=0
for ((i = 0 ; i <= $CLUSTERS_CNT ; i++)); do
    process_cluster "$i" &
    ((j=j%THREADS)) || true
    ((j++==0)) && wait
done
wait


echo "consensus sequences generated for $CLEAN_NAME"

awk '/^>/ {gsub(/.consensus.fasta?$/,"",FILENAME);printf(">%s\n",FILENAME);next;} {print}' *.consensus.fasta > $CLEAN_NAME.all_consensus.fasta
sed -i 's/@/;/g' $CLEAN_NAME.all_consensus.fasta

vsearch --uchime_denovo $CLEAN_NAME.all_consensus.fasta --nonchimeras $CLEAN_NAME.nochim.consensus.fasta --chimeras $CLEAN_NAME.chim.consensus.fasta --xsize

# ] <-- needed because of Argbash
