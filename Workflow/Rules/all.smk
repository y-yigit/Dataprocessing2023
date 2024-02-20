# -*- python -*-

workdir: "/home/ubuntu/Desktop/Dataprocessing_final/"

configfile: "Config/config.yaml"
SAMPLES = config["samples"]
reference = config["reference"]

include: "processing.smk"

rule all:
    input:
        expand("Out/sortmerna/aligned_{sample}.fastq", sample=SAMPLES)
