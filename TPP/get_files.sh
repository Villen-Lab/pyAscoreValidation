FTP_LINK=http://ftp.ebi.ac.uk/pride-archive/2019/09/PXD007058/
FILE_LIST=(SF_200217_pPeptideLibrary_pool1_HCDOT_rep1.raw
           SF_200217_pPeptideLibrary_pool1_HCDOT_rep2.raw
           SF_200217_pPeptideLibrary_pool2_HCDOT_rep1.raw
           SF_200217_pPeptideLibrary_pool2_HCDOT_rep2.raw
           SF_200217_pPeptideLibrary_pool3_HCDOT_rep1.raw
           SF_200217_pPeptideLibrary_pool3_HCDOT_rep2.raw
           SF_200217_pPeptideLibrary_pool4_HCDOT_rep1.raw
           SF_200217_pPeptideLibrary_pool4_HCDOT_rep2.raw
           SF_200217_pPeptideLibrary_pool5_HCDOT_rep1.raw
           SF_200217_pPeptideLibrary_pool5_HCDOT_rep2.raw)

for FILE in "${FILE_LIST[@]}"
do
    if [ ! -f $FILE ]; then
        wget $FTP_LINK/$FILE $FILE
    fi
done
