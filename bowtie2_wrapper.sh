#!/bin/bash

usage() {
    echo ""
    echo "Usage : sh $0 -f FASTQ_FILE -r REFERENCE_GENOME_FOLDER -n REFERENCE_GENOME_NAME"
    echo ""

cat <<'EOF'
  -f </path/to/fastq file>
  -a </path/to/reference genome>
EOF
    exit 0
}

while getopts "f:hr:n:" opt; do
  case ${opt} in
    f)
     fastq_file=$OPTARG
     echo "$fastq_file"
      ;;
    h)
     usage
     exit 1
      ;;    
    r)
     ref_genome_folder=$OPTARG
     echo "$ref_genome_folder"
      ;;
    n)
     ref_genome_name=$OPTARG
     echo "$ref_genome_name"
      ;;
    \?)
     echo "Invalid option: -$OPTARG" >&2
     exit 1
      ;;
    :)
     echo "Option -$OPTARG requires an argument." >&2
     exit 1
      ;;
  esac
done

bowtie2 -x ${ref_genome_folder}/${ref_genome_name} -U $fastq_file -S ${fastq_file}.sam
