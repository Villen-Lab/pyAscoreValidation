import os
import json
import shutil
import itertools
import urllib

SNAKEMAKE_DIR = os.path.dirname(workflow.snakefile)
WORKING_DIR = os.getcwd()

SAMPLES_BY_DATASET = json.load(open("samples.json", "r"))

def clean_temp_files():
    shutil.rmtree(".ppx_cache", ignore_errors=True)
    shutil.rmtree(".pipeline_flags", ignore_errors=True)

onsuccess:
    clean_temp_files()

onerror:
    clean_temp_files()

rule all:
    input:
        ".pipeline_flags/files_preprocessed.flag",
        ".pipeline_flags/files_searched.flag",
        ".pipeline_flags/ptms_localized.flag"

include: "rules/preprocess_data.smk"
include: "rules/search_data.smk"
include: "rules/localize_ptms.smk"
