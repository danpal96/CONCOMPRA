#!/usr/bin/env bash

# Created by argbash-init v2.10.0
# ARG_OPTIONAL_SINGLE([min-len],[l],[Minimal sequence length to retain],[1400])
# ARG_OPTIONAL_SINGLE([max-len],[L],[Maximal sequence length to retain],[1700])
# ARG_OPTIONAL_SINGLE([merge_consensus],[m],[Identity on which to cluster consensus sequences across samples],[1])
# ARG_OPTIONAL_SINGLE([reads-consensus],[r],[Number of reads to subsample from a cluster to draft the consensus sequence],[40])
# ARG_OPTIONAL_SINGLE([threads],[t],[Number of threads to use],[8])
# ARG_POSITIONAL_SINGLE([FASTQ_DIR],[Input directory with FASTQ files, optionally gzipped])
# ARG_POSITIONAL_SINGLE([OUTPUT_DIR],[Output directory])
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
	local first_option all_short_options='lLmrth'
	first_option="${1:0:1}"
	test "$all_short_options" = "${all_short_options/$first_option/}" && return 1 || return 0
}

# THE DEFAULTS INITIALIZATION - POSITIONALS
_positionals=()
_arg_fastq_dir=
_arg_output_dir=
_arg_primer_set=
# THE DEFAULTS INITIALIZATION - OPTIONALS
_arg_min_len="1400"
_arg_max_len="1700"
_arg_merge_consensus="1"
_arg_reads_consensus="40"
_arg_threads="8"


print_help()
{
	printf '%s\n' "<The general help message of my script>"
	printf 'Usage: %s [-l|--min-len <arg>] [-L|--max-len <arg>] [-m|--merge_consensus <arg>] [-r|--reads-consensus <arg>] [-t|--threads <arg>] [-h|--help] <FASTQ_DIR> <OUTPUT_DIR> <PRIMER_SET>\n' "$0"
	printf '\t%s\n' "<FASTQ_DIR>: Input directory with FASTQ files, optionally gzipped"
	printf '\t%s\n' "<OUTPUT_DIR>: Output directory"
	printf '\t%s\n' "<PRIMER_SET>: Should be a fasta file in which the head primer should have \"head\" in its name (case-insensitive). Likewise for the tail primer. Both sequences should be those that appear in the cDNA's sense strand. sequences are not limited to the primers itself but can also include anchor sequences. Longer sequences generally give better results"
	printf '\t%s\n' "-l, --min-len: Minimal sequence length to retain (default: '1400')"
	printf '\t%s\n' "-L, --max-len: Maximal sequence length to retain (default: '1700')"
	printf '\t%s\n' "-m, --merge_consensus: Identity on which to cluster consensus sequences across samples (default: '1')"
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
			-l|--min-len)
				test $# -lt 2 && die "Missing value for the optional argument '$_key'." 1
				_arg_min_len="$2"
				shift
				;;
			--min-len=*)
				_arg_min_len="${_key##--min-len=}"
				;;
			-l*)
				_arg_min_len="${_key##-l}"
				;;
			-L|--max-len)
				test $# -lt 2 && die "Missing value for the optional argument '$_key'." 1
				_arg_max_len="$2"
				shift
				;;
			--max-len=*)
				_arg_max_len="${_key##--max-len=}"
				;;
			-L*)
				_arg_max_len="${_key##-L}"
				;;
			-m|--merge_consensus)
				test $# -lt 2 && die "Missing value for the optional argument '$_key'." 1
				_arg_merge_consensus="$2"
				shift
				;;
			--merge_consensus=*)
				_arg_merge_consensus="${_key##--merge_consensus=}"
				;;
			-m*)
				_arg_merge_consensus="${_key##-m}"
				;;
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
	local _required_args_string="'FASTQ_DIR', 'OUTPUT_DIR' and 'PRIMER_SET'"
	test "${_positionals_count}" -ge 3 || _PRINT_HELP=yes die "FATAL ERROR: Not enough positional arguments - we require exactly 3 (namely: $_required_args_string), but got only ${_positionals_count}." 1
	test "${_positionals_count}" -le 3 || _PRINT_HELP=yes die "FATAL ERROR: There were spurious positional arguments --- we expect exactly 3 (namely: $_required_args_string), but got ${_positionals_count} (the last one was: '${_last_positional}')." 1
}


assign_positional_args()
{
	local _positional_name _shift_for=$1
	_positional_names="_arg_fastq_dir _arg_output_dir _arg_primer_set "

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
shopt -s nullglob

TEMPLATE_DIR="$( dirname -- "$( readlink -f -- "$0"; )"; )"
PRIMER_SET="$(realpath "$_arg_primer_set")"
MIN="$_arg_min_len"
MAX="$_arg_max_len"
MERGE_CONSENSUS="$_arg_merge_consensus"
READS_CONSENSUS="$_arg_reads_consensus"
THREADS="$_arg_threads"
FASTQ_DIR="$_arg_fastq_dir"
OUTPUT_DIR="$_arg_output_dir"

echo 'This is CONCOMPRA 0.0.2'
echo 'for additional information and help, visit: https://github.com/willem-stock/CONCOMPRA'

mkdir -p "$OUTPUT_DIR"/temporary/filteredPAFs
for file in  "$FASTQ_DIR"/*.{fastq,fastq.gz}; do
	NO_DIR_NAME="$(basename "$file")"
    if [[ "$file" == *.fastq.gz ]]; then
        zcat "$file" | awk -v min=$MIN -v max=$MAX 'BEGIN {FS = "\t"; OFS = "\n"}
        {
            header = $0; getline seq; getline qheader; getline qseq;
            if (length(seq) >= min && length(seq) <= max) {
                print header, seq, qheader, qseq
            }
        }' | tr -d " " > "$OUTPUT_DIR/temporary/${NO_DIR_NAME%.gz}"
    else
        # Use regular cat for .fastq files
        cat "$file" | awk -v min=$MIN -v max=$MAX 'BEGIN {FS = "\t"; OFS = "\n"}
        {
            header = $0; getline seq; getline qheader; getline qseq;
            if (length(seq) >= min && length(seq) <= max) {
                print header, seq, qheader, qseq
            }
		}' | tr -d " " > "$OUTPUT_DIR/temporary/$NO_DIR_NAME"
    fi
done

#remove empty files after filtering
find "$OUTPUT_DIR"/temporary -type f -empty -delete
# Run consensus generation in parallel
i=0
for file in "$OUTPUT_DIR"/temporary/*.fastq; do
    ((i=i%THREADS)) || true
    ((i++==0)) && wait
    bash "$TEMPLATE_DIR/consensus_generation.sh" \
    	--reads-consensus "$READS_CONSENSUS" \
    	--threads "$THREADS" \
    	"$OUTPUT_DIR"/temporary "$(basename "$file")" "$PRIMER_SET" &
done
wait

mkdir -p "$OUTPUT_DIR"/results

find "$OUTPUT_DIR"/temporary -name '*.all_consensus.fasta' -exec cat {} + > "$OUTPUT_DIR"/results/all_consensus.fasta


# join consensus sequences across samples
vsearch \
	-cluster_fast "$OUTPUT_DIR"/results/all_consensus.fasta \
	-id $MERGE_CONSENSUS \
	--relabel_keep \
	-consout "$OUTPUT_DIR"/results/clustered_consensus.fasta
awk -i inplace '/^>/ {
    split($0, a, ";");
    split(a[1], b, "=");
    print ">" b[2];
    next;
}
{print}' "$OUTPUT_DIR"/results/clustered_consensus.fasta #return headers of the fasta to the original format, remove additional info from cluster_fast


minimap2 -d "$OUTPUT_DIR"/temporary/across_sample_consensus_sequences.mmi "$OUTPUT_DIR"/results/clustered_consensus.fasta
mkdir -p "$OUTPUT_DIR"/unmapped # folder for any unmapped reads

#map reads to the consensus sequences
for file in "$OUTPUT_DIR"/temporary/*.fastq;
do
	cd "$OUTPUT_DIR"/temporary
	NO_DIR_NAME="$(basename "$file")"
	CLEAN_NAME="${NO_DIR_NAME%.*}"
	minimap2 -x map-ont -t $THREADS -K 20M across_sample_consensus_sequences.mmi $CLEAN_NAME/$NO_DIR_NAME > $CLEAN_NAME.paf
	RES=$(awk "BEGIN {printf \"%.4f\",$MIN * 0.9}")
	$TEMPLATE_DIR/filterPAF_strict.py -i $CLEAN_NAME.paf -b $RES -m 10 > $CLEAN_NAME.CONCOMPRA.paf

	#split of the unmapped reads
	cut  -f1 $CLEAN_NAME.CONCOMPRA.paf |uniq > $CLEAN_NAME.CONCOMPRA.ls
	awk '{if(NR%4==1) print $1, $5}' $CLEAN_NAME/$NO_DIR_NAME | sed -e "s/^@//" | awk '{$1=$1};1' > $CLEAN_NAME.all.ls
	sort $CLEAN_NAME.CONCOMPRA.ls | uniq > $CLEAN_NAME.CONCOMPRA.ls.sorted
	sort $CLEAN_NAME.all.ls | uniq  > $CLEAN_NAME.all.ls.sorted
	comm -1 -3 $CLEAN_NAME.CONCOMPRA.ls.sorted $CLEAN_NAME.all.ls.sorted > $CLEAN_NAME.unmapped.ls
	seqtk subseq $CLEAN_NAME/$NO_DIR_NAME $CLEAN_NAME.unmapped.ls > "../unmapped/$NO_DIR_NAME"
	cd -
done

mv "$OUTPUT_DIR"/temporary/*.CONCOMPRA.paf "$OUTPUT_DIR"/temporary/filteredPAFs
$TEMPLATE_DIR/merfePAF.py -i "$OUTPUT_DIR"/temporary/filteredPAFs/ > "$OUTPUT_DIR"/results/otu_table.csv

# creates a pdf of the umpa-hdbscan graphical output
bash $TEMPLATE_DIR/cluster_pictures.sh "$OUTPUT_DIR"

# detect chimeric sequences from the concat consensus sequence file
# add sequence counts to the consensus sequences
# obtain the total sequence counts after mapping
awk -F, 'NR > 1 {
  sum = 0;   # Initialize a variable to store the sum
  for (i = 2; i <= NF; i++) {  # Loop through all fields from the 2nd column to the last
    if ($i ~ /^[0-9]+(\.[0-9]+)?$/) {  # Check if the field is numeric
      sum += $i;  # Add the numeric field to the sum
    }
  }
  print $1, sum;  # Print the first column and the sum
}' OFS=, "$OUTPUT_DIR"/results/otu_table.csv > "$OUTPUT_DIR"/temporary/otu_sum.csv

##add the total sequence counts to the sequence identifier
awk '
NR==1   { next }
BEGIN   { FS="," }                         # set the field separator to semicolon
FNR==NR { id[$1]=$2 }                      # load id[] with ID to header field mapping
FNR!=NR {
    if (/^>/) {
        ndx=substr($1,2)                  # strip off ">"
        if (ndx in id) {                  # if 1st field (sans ">") is an index in id[] then ...
            $1 = ">" ndx ";size=" id[ndx]  # rewrite 1st field to include our id[] value
        }
    }
    print                                  # print current line (of 2nd file)
}
' "$OUTPUT_DIR"/temporary/otu_sum.csv "$OUTPUT_DIR"/results/clustered_consensus.fasta > "$OUTPUT_DIR"/temporary/across_sample_consensus_sequences_size.fas

# identify chimeric sequences and write them to a seperate fasta file - alternative options for output are possible
vsearch \
	--uchime_denovo "$OUTPUT_DIR"/temporary/across_sample_consensus_sequences_size.fas \
	--nonchimeras "$OUTPUT_DIR"/results/nonglobal.consensus.sequences.fas \
	--chimeras "$OUTPUT_DIR"/results/chimeric_consensus.sequences.fas \
	--xsize


# remove previously detected chimeras
find "$OUTPUT_DIR"/temporary -name '*nochim.consensus.fasta' -exec cat {} + | grep '>'  | cut -f 1 -d ' ' |  sed 's/>//g' > "$OUTPUT_DIR"/temporary/no_chim_OTUs.txt
seqtk subseq "$OUTPUT_DIR"/results/nonglobal.consensus.sequences.fas "$OUTPUT_DIR"/temporary/no_chim_OTUs.txt > "$OUTPUT_DIR"/results/noglobal_nolocalchim.consensus.sequences.fas

seqtk subseq "$OUTPUT_DIR"/results/clustered_consensus.fasta "$OUTPUT_DIR"/temporary/no_chim_OTUs.txt > "$OUTPUT_DIR"/results/nolocalchim.consensus.sequences.fas


rm -rf "$OUTPUT_DIR"/clusterplots
rm -rf "$OUTPUT_DIR"/temporary  # hash out if any of the intermediate output would be of interest to you
# r import to phyloseq object or other workflow for post processing

# ] <-- needed because of Argbash
