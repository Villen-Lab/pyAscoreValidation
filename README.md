## Validation experiments for pyAscore

Here you can find the pipeline and notebooks of results from our validation experiments for the
[pyAscore](https://pyascore.readthedocs.io/) python package. All experiments were performed with
Snakemake, and the pipeline should reproduce all search and scoring results from our manuscript.
If you are intersted in re-creating the analysis, please see the Snakemake documentation at this
[link](https://snakemake.readthedocs.io/en/stable/) for information on installation and running.
Regardless of how you decide to set up Snakemake, please be sure to add the `--use-conda` flag
to be sure that Snakemake uses the provided conda environments for individual rules. The results
of the pipeline will be output into a `results` directory which will appear at runtime.

If you simply would like to know which PRIDE or MassIVE datasets were analyzed, and the specific
files which were downloaded from each, please see the contained file `samples.json`.

### Description of notebooks:

Original results and figures which were included in the manuscript are available in the following
notebook files. These can be directly viewed in Github or downloaded and re-run with the re-created
analysis on your own machine.

- [**Comparison of pyAscore with original:**](https://github.com/AnthonyOfSeattle/pyAscoreValidation/blob/main/notebook/comparison_of_ascore_implementations.ipynb)
  Here we look at how well the scores and localized sequences from the new pyAscore match up to the original.
  **Gotcha:** Data for this analysis is currently downloaded seperately in the `/Mouse` folder.
- [**Evaluation of pyAscore's speed:**](https://github.com/AnthonyOfSeattle/pyAscoreValidation/blob/main/notebook/evaluating_scoring_times.ipynb)
  Here we analyze the data from PXD007740 from scratch with pyAscore and time the scoring times for
  individual scans. This notebook is also a great place to see the command line interface of pyAscore
  in action.
- [**Evaluation of pyAscore's versitility:**](https://github.com/AnthonyOfSeattle/pyAscoreValidation/blob/main/notebook/evaluating_application_versitility.ipynb)
  Here we analyze results of running pyAscore on a label free phosphoproteome (PXD007740), a
  TMT-labeled phosphoproteome (PXD007145), and a label free acetylome (MSV000079068). This is
  meant to show pyAscore's ability to analyze data from many different types of experiments.
- [**Evaluation of pyAscore's accuracy:**](https://github.com/AnthonyOfSeattle/pyAscoreValidation/blob/main/notebook/evaluation_of_false_localization_on_marx_synthetic_peptides.ipynb)
  Here we analyze pyAscore's performance on phosphopeptides where we know the correct localization.
  The underlying peptides all come from [Marx *et al.* (2013)](https://pubmed.ncbi.nlm.nih.gov/23685481/),
  and we analyzed with 3 different fragementation modes. The HCD and ETD data come from the PRIDE
  accession, PXD000138, and the CID data comes from the PRIDE accession, PXD000759.
- [**Comparison of pyAscore to PTMProphet:**](https://github.com/AnthonyOfSeattle/pyAscoreValidation/blob/main/notebook/comparison_of_pyascore_with_ptmprophet.ipynb)
  Here we look at how well pyAscore performs compared to PTMProphet using data from the latter's papers.
  **Gotcha:** Data for this analysis is currently downloaded seperately in the `/TPP` folder.

  
