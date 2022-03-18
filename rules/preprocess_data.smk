ALL_RAW = list(itertools.chain.from_iterable(
    [expand("results/samples/{dataset}/{sample}",
            dataset = it[0], sample = it[1]["samples"])
     for it in SAMPLES_BY_DATASET.items()]
))

ALL_MZML = [os.path.splitext(samp)[0] + ".mzML" for samp in ALL_RAW]

rule finalize_preprocess:
    input:
        ALL_MZML
    output:
        touch(".pipeline_flags/files_preprocessed.flag")

rule convert_raw:
    input:
        "results/samples/{dataset}/{basename}.raw"
    output:
        "results/samples/{dataset}/{basename}.mzML"
    conda:
        SNAKEMAKE_DIR + "/envs/preprocess.yaml"
    group:
        "preprocess"
    shell:
        """
        ThermoRawFileParser.sh --input={input} \
                               --output_file={output} \
                               --format=2 \
                               --metadata=1
        """

rule download_raw:
    output:
        "results/samples/{dataset}/{basename}.raw"
    params:
        src = lambda wildcards: SAMPLES_BY_DATASET[wildcards.dataset]["ftp"] + wildcards.basename + ".raw"
    group:
        "preprocess"
    shell:
        """
        echo Retrieving {params.src}
        for i in {{1..5}}; 
          do curl {params.src} --output {output} && break || sleep 30; 
        done
        """
