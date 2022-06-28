ALL_SEARCH = expand("results/search/{dataset}/{dataset}.mokapot.psms.txt",
                    dataset = SAMPLES_BY_DATASET.keys())

rule finalize_search:
    input:
        ALL_SEARCH
    output:
        touch(".pipeline_flags/files_searched.flag")

def get_mokapot_input(wildcards):
    sample_names = [os.path.splitext(s)[0] for s in SAMPLES_BY_DATASET[wildcards.dataset]["samples"]]
    return expand("results/search/{dataset}/{dataset}.{sample}.pin",
                  dataset = wildcards.dataset,
                  sample = sample_names)
           
rule mokapot:
    input:
        get_mokapot_input
    output:
        "results/search/{dataset}/{dataset}.mokapot.psms.txt",
    conda:
        SNAKEMAKE_DIR + "/envs/search.yaml"
    params:
        destination = "results/search/{dataset}/",
        decoy_prefix = "DECOY_",
        seed = 1221
    shell:
        """
        mokapot --dest_dir {params.destination} \
                --decoy_prefix {params.decoy_prefix} \
                --seed {params.seed} \
                --keep_decoys \
                --aggregate \
                {input}

        for FILE_PATH in $(ls {params.destination}mokapot*)
        do
          mv ${{FILE_PATH}} {params.destination}{wildcards.dataset}.$(basename ${{FILE_PATH}})
        done
        """

rule comet:
    input:
        spectra = "results/samples/{dataset}/{dataset}.{sample}.mzML",
        params = lambda w: SAMPLES_BY_DATASET[w.dataset]["search_params"]
    output:
        pepxml = "results/search/{dataset}/{dataset}.{sample}.pep.xml",
        mzid = "results/search/{dataset}/{dataset}.{sample}.mzid",
        pin = "results/search/{dataset}/{dataset}.{sample}.pin"
    conda:
        SNAKEMAKE_DIR + "/envs/search.yaml"
    shadow:
        "shallow"
    shell:
        """
        # Copy in
        cp {input.spectra} {input.params} ./

        # Run and fix search
        echo $PWD
        MATCH="\.snakemake\/shadow\/tmp.*\/"
        REPLACE_SEARCH="results\/search\/{wildcards.dataset}\/"
        REPLACE_RAW="results\/samples\/{wildcards.dataset}\/"
        comet -P{input.params} $(basename {input.spectra})
        sed -i "2s/${{MATCH}}/${{REPLACE_SEARCH}}/" $(basename {output.pepxml})
        sed -i "3s/${{MATCH}}/${{REPLACE_RAW}}/" $(basename {output.pepxml})

        # Copy out
        cp $(basename {output.pepxml}) {output.pepxml}
        cp $(basename {output.mzid}) {output.mzid}
        cp $(basename {output.pin}) {output.pin}
        """
