ALL_LOCAL = list(itertools.chain.from_iterable([
              expand("results/localization/{dataset}/{dataset}.{sample}.pyascore.{type}.txt",
                     dataset = d,
                     sample = [os.path.splitext(s)[0] for s in SAMPLES_BY_DATASET[d]["samples"]], 
                     type=["wide", "narrow"])
              for d in SAMPLES_BY_DATASET.keys()
            ]))

rule finalize_localization:
    input:
        ALL_LOCAL
    output:
        touch(".pipeline_flags/ptms_localized.flag")

rule pyascore:
    input:
        spectra = "results/samples/{dataset}/{dataset}.{sample}.mzML",
        ids = "results/localization/{dataset}/{dataset}.{sample}.mokapot.psms.txt",
        params = lambda w: SAMPLES_BY_DATASET[w.dataset]["pyascore_params"]
    output:
        "results/localization/{dataset}/{dataset}.{sample}.pyascore.{type}.txt"
    conda:
        SNAKEMAKE_DIR + "/envs/pyascore.yaml"
    params:
        mz_error = lambda w: {"wide" : .5, "narrow" : .02}[w.type],
    shell:
        """
        pyascore --parameter_file {input.params} \
                 --mz_error {params.mz_error} \
                 --ident_file_type mokapotTXT \
                 {input.spectra} \
                 {input.ids} \
                 {output}
        """

rule make_pyascore_input:
    input:
        "results/search/{dataset}/{dataset}.mokapot.psms.txt"
    output:
        temp("results/localization/{dataset}/{sample}.mokapot.psms.txt")
    run:
        import pandas as pd

        data = pd.read_csv(input[0], sep="\t")
        data = data[data.SpecId.str.contains("^" + wildcards.sample + "_", regex=True)]
        data.to_csv(output[0], sep="\t", index=False)
