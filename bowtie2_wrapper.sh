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

while getopts "p:t:s:f:hr:n:" opt; do
  case ${opt} in
    s)
      output_file=$OPTARG
      echo "$output_file"
      ;;
    t)
      num_threads=$OPTARG
      echo "$num_threads"
      ;;
    f)
      if [ -z "$fastq_files" ]
      then
        fastq_files=$OPTARG
      else
        fastq_files=$fastq_files','$OPTARG
      fi
      echo "$fastq_files"
      ;;
    p)
      if [ -z "$paired_files" ]
      then
        paired_files=$OPTARG
      else
        paired_files=$paired_files','$OPTARG
      fi
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

if [ -n "$paired_files" ]
then
  echo "bowtie2 -x ${ref_genome_folder}/${ref_genome_name} -1 $fastq_files -2 $paired_files -S ${output_file}.sam -p $num_threads"
  bowtie2 -x ${ref_genome_folder}/${ref_genome_name} -1 $fastq_files -2 $paired_files -S ${output_file}.sam -p $num_threads
else
  echo "bowtie2 -x ${ref_genome_folder}/${ref_genome_name} -U $fastq_files -S ${output_file}.sam -p $num_threads"
  bowtie2 -x ${ref_genome_folder}/${ref_genome_name} -U $fastq_files -S ${output_file}.sam -p $num_threads
fi


