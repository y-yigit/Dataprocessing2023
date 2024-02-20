# Snakefile

rule fastqc:
    input:
        "Data/{sample}.fastq.gz"
    output:
        html="Out/fastqc/{sample}.html",
        zip="Out/fastqc/{sample}_fastqc.zip" # the suffix _fastqc.zip is necessary for multiqc to find the file. If not using multiqc, you are free to choose an arbitrary filename
    params:
        extra = "--quiet"
    log:
        "logs/fastqc/{sample}.log"
    threads: 1
    resources:
        mem_mb = 1024
    wrapper:
        "v3.3.6/bio/fastqc"

rule trim_galore_se:
    input:
        "Data/{sample}.fastq.gz",
    output:
        fasta="Out/trimmed/{sample}_trimmed.fq.gz",
        report="Out/trimmed/report/{sample}.fastq.gz_trimming_report.txt",
    params:
        extra="--illumina -q 20",
    log:
        "logs/trim_galore/{sample}.log",
    wrapper:
        "v3.3.6/bio/trim_galore/se"

rule dereplicate:
    input:
        "Out/trimmed/{sample}_trimmed.fq.gz"
    output:
        "Out/dereplicated/{sample}_dereplicated.fasta"
    log:
        "logs/vsearch/fastx_uniques/{sample}.log",
    shell:
        "vsearch --strand both --minseqlength 5 --derep_fulllength {input} --output {output}"

rule sortmerna_se:
    input:
        ref="Data/SILVA_138.1_SSUParc_tax_silva.fasta.gz",
        reads="Out/dereplicated/{sample}_dereplicated.fasta",
    output:
        aligned="Out/sortmerna/aligned_{sample}.fastq",
        other="Out/sortmerna/unpaired_{sample}.fastq",
        stats="Out/sortmerna/sortmerna_se_stats_{sample}.log",
    log:
        "logs/sortmerna/reads_{sample}_se.log",
    shell:
        "sortmerna --idx-dir idx --ref {input.ref} -reads {input.reads} --aligned {out.aligned} --other {out.other} --stats {out.stats}"
