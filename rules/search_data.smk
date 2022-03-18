ALL_SEARCH = expand("results/search/{dataset}/mokapot.psms.txt",
                    dataset = SAMPLES_BY_DATASET.keys())

rule finalize_search:
    input:
        ALL_SEARCH
    output:
        touch(".pipeline_flags/files_searched.flag")

def get_mokapot_input(wildcards):
    sample_names = [os.path.splitext(s)[0] for s in SAMPLES_BY_DATASET[wildcards.dataset]["samples"]]
    return expand("results/search/{dataset}/{sample}.pin",
                  dataset = wildcards.dataset,
                  sample = sample_names)
           

rule mokapot:
    input:
        get_mokapot_input
    output:
        "results/search/{dataset}/mokapot.psms.txt",
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
        """

rule comet:
    input:
        spectra = "results/samples/{dataset}/{sample}.mzML",
        params = lambda w: SAMPLES_BY_DATASET[w.dataset]["search_params"]
    output:
        pepxml = "results/search/{dataset}/{sample}.pep.xml",
        mzid = "results/search/{dataset}/{sample}.mzid",
        pin = "results/search/{dataset}/{sample}.pin"
    conda:
        SNAKEMAKE_DIR + "/envs/search.yaml"
    shadow:
        "shallow"
    shell:
        """
        cp {input.spectra} {input.params} ./
        comet -P{input.params} $(basename {input.spectra})
        cp *.pep.xml {output.pepxml}
        cp *.mzid {output.mzid}
        cp *.pin {output.pin}
        """
