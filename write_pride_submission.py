import os
import json
import pandas as pd

submission_file = open("pride_submission_file.txt", "w")
metadata = json.load(open("metadata.json"))
sample_manifest = json.load(open("samples.json", "r"))

##########################
# Write Project Metadata #
##########################

for key in metadata["project"]:
    if not isinstance(metadata["project"][key], list):
        value_list = [metadata["project"][key]]
    else:
        value_list = metadata["project"][key]

    for value in value_list:
        line = "\t".join(["MTD", key, value])
        submission_file.write(line + "\n")

######################
# Write file mapping #
######################

submission_file.write("\n")
header = "\t".join(["FMH", "file_id", "file_type", "file_path", "file_mapping"])
submission_file.write(header + "\n")

file_ind = 0
for accession in sample_manifest:
    sample_names = [os.path.splitext(s)[0] for s in sample_manifest[accession]["samples"]]
    
    # BUILD: pyascore file info
    pyascore_narrow_files = []
    for file_ind, sample in enumerate(sample_names, file_ind + 1):
        info = (str(file_ind),
                "search",
                os.path.join("results", 
                             "localization",
                             accession, 
                             sample + ".pyascore.narrow.txt"))
        pyascore_narrow_files.append(info)

    pyascore_wide_files = []
    if accession in ["PXD000138-HCD", "PXD000138-ETD", "PXD000759"]:
        for file_ind, sample in enumerate(sample_names, file_ind + 1):
            info = (str(file_ind),
                    "search",
                    os.path.join("results",
                                 "localization",
                                 accession,
                                 sample + ".pyascore.wide.txt"))
            pyascore_wide_files.append(info) 

    # BUILD: mokapot file info
    file_ind += 1
    mokapot_file = (str(file_ind),
                    "search",
                    os.path.join("results",
                                 "search",
                                 accession,
                                 accession + ".mokapot.psms.txt"))

    # BUILD: comet file info
    comet_files = []
    for file_ind, sample in enumerate(sample_names, file_ind + 1):
        info = (str(file_ind),
                "search",
                os.path.join("results",
                             "search",
                             accession,
                             sample + ".comet.pin"))
        comet_files.append(info)

    # BUILD: raw file info
    raw_file_start = file_ind + 1
    raw_files = []
    for file_ind, sample in enumerate(sample_names, file_ind + 1):
        info = (str(file_ind),
                "raw",
                os.path.join("results",
                             "samples",
                             accession,
                             sample + ".raw"))
        raw_files.append(info)

    # WRITE: pyascore file info
    for ind, line in enumerate(pyascore_narrow_files):
        mapping = [mokapot_file[0], raw_file_start + ind]
        mapping = ",".join([str(m) for m in mapping])
        line = ["FME"] + list(line) + [mapping]
        line = "\t".join(line)
        submission_file.write(line + "\n")

    for ind, line in enumerate(pyascore_wide_files):
        mapping = [mokapot_file[0], raw_file_start + ind]
        mapping = ",".join([str(m) for m in mapping])
        line = ["FME"] + list(line) + [mapping]
        line = "\t".join(line)
        submission_file.write(line + "\n")

    # WRITE: mokapot file info
    mapping = range(int(mokapot_file[0]) + 1, raw_file_start + len(raw_files))
    mapping = ",".join([str(m) for m in mapping])
    line = ["FME"] + list(mokapot_file) + [mapping]
    line = "\t".join(line)
    submission_file.write(line + "\n")

    # WRITE: comet file info
    for ind, line in enumerate(comet_files):
        mapping = [raw_file_start + ind]
        mapping = ",".join([str(m) for m in mapping])
        line = ["FME"] + list(line) + [mapping] 
        line = "\t".join(line)
        submission_file.write(line + "\n")

    # WRITE: raw file info
    for ind, line in enumerate(raw_files):
        line = ["FME"] + list(line)
        line = "\t".join(line)
        submission_file.write(line + "\n")

# FASTA file info
file_ind += 1
line = (str(file_ind),
        "fasta",
        "config/uniprot-proteome-UP000005640.fasta")
line = ["FME"] + list(line)
line = "\t".join(line)
submission_file.write(line + "\n")

file_ind += 1
line = (str(file_ind),
        "fasta",
        "config/009606_IPI_v3_72_with_P_Lib_062111.fasta")
line = ["FME"] + list(line)
line = "\t".join(line)
submission_file.write(line + "\n")

# Metadata file info
file_ind += 1
line = (str(file_ind),
        "other",
        "file_metadata.csv")
line = ["FME"] + list(line)
line = "\t".join(line)
submission_file.write(line + "\n")
submission_file.close()

###########################
# Write file metadata csv #
###########################

descriptions = {
    "PXD007740"     : "Label-free human phosphoproteome",
    "PXD007145"     : "TMT-labeled human phosphoproteome",
    "MSV000079068"  : "Label-free human acetylome",
    "PXD000138-HCD" : "Synthetic peptides analyzed with HCD",
    "PXD000138-ETD" : "Synthetic peptides analyzed with ETD",
    "PXD000759"     : "Synthetic peptides analyzed with CID"
}

rows = []
for accession in sample_manifest:
    for raw_name in sample_manifest[accession]["samples"]:
       sample_name = os.path.splitext(raw_name)[0]
       cur_row = {"sample" : sample_name,
                  "accession" : accession.split("-")[0],
                  "rawFile" : raw_name,
                  "mokapotInputFile" : sample_name + ".pin",
                  "mokapotOutputFile" : accession + ".mokapot.psms.txt",
                  "pyascoreNarrowFile" : sample_name + ".pyascore.narrow.txt"}

       if accession in ["PXD000138-HCD", "PXD000138-ETD", "PXD000759"]:
           cur_row["pyascoreWideFile"] = sample_name + ".pyascore.wide.txt"

       cur_row["description"] = descriptions[accession]
       rows.append(cur_row)

pd.DataFrame.from_records(rows)[
    ["sample", "accession", "rawFile",
     "mokapotInputFile", "mokapotOutputFile",
     "pyascoreNarrowFile", "pyascoreWideFile",
     "description"]
].to_csv("sample_metadata.tsv", sep="\t", index=False)

