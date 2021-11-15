import re
from collections import defaultdict
from itertools import groupby

# assembled_annotation = "2cell_all_corrected_fixed.fastq_flair.bed_sjs_correct_all_corrected.psl_salmon_collapse_corrected.isoforms.gtf"
# repeat_exons_path = ["2cell_flair_corrected_isoforms_noTranscript_exons_noERCC_exon_repeat_isoforms_no_genic_100_nested.gtf",
#                      "2cell_flair_corrected_isoforms_noTranscript_exons_noERCC_exon_repeat_isoforms_no_genic_100_not_nested.gtf"]
assembled_annotation = "hipsci_96_all_corrected_fixed.fastq_flair.bed_sjs_correct_all_corrected.psl_salmon_collapse_corrected.isoforms.gtf"
repeat_exons_path = ["hipsci_flair_corrected_isoforms_noTranscript_exons_noERCC_exon_repeat_isoforms_no_genic_100_nested.gtf",
                     "hipsci_flair_corrected_isoforms_noTranscript_exons_noERCC_exon_repeat_isoforms_no_genic_100_not_nested.gtf"]

repeat_exons_sets = defaultdict(dict)
for repeat_exon_file in repeat_exons_path:
    with open(repeat_exon_file) as f:
        for line in f:
            line = line.strip()
            parts = line.split("\t")

            transcript_id = re.search(r'transcript_id "([^"]+)"', line).group(1)
            exon_location = f"{parts[0]}:{parts[3]}-{parts[4]}"

            repeat_exons_sets[transcript_id][exon_location] = line

repeat_isoform_full_entries = defaultdict(dict)
with open(assembled_annotation) as f:
    for line in f:
        line = line.strip()
        parts = line.split("\t")

        transcript_id = re.search(r'transcript_id "([^"]+)"', line).group(1)

        if transcript_id in repeat_exons_sets:
            if parts[2] == "transcript":
                repeat_isoform_full_entries[transcript_id]["entry"] = line
                repeat_isoform_full_entries[transcript_id]["direction"] = parts[6]
                repeat_isoform_full_entries[transcript_id]["exons"] = []
                repeat_isoform_full_entries[transcript_id]["exon_type"] = []
            elif parts[2] == "exon":
                exon_location = f"{parts[0]}:{parts[3]}-{parts[4]}"
                exon_type = "repeat" if exon_location in repeat_exons_sets[transcript_id] else "non-repeat"

                repeat_isoform_full_entries[transcript_id]["exons"].append((exon_location, line))
                repeat_isoform_full_entries[transcript_id]["exon_type"].append(exon_type)

irregular_repeat_isoform = []
repeat_only_isoform = []
proper_repeat_derived_isoform = []
final_classification = ["transcript_name,classification"]
for repeat_isoform in repeat_isoform_full_entries:
    exon_type_uniq = [k for k, g in groupby(repeat_isoform_full_entries[repeat_isoform]["exon_type"])]

    isoform_classification = ""
    if len(exon_type_uniq) > 2:
        irregular_repeat_isoform.append((repeat_isoform, exon_type_uniq))
        isoform_classification = "irregular-repeat"
    elif len(exon_type_uniq) == 2:
        repeat_isoform_type = "TSS"
        if repeat_isoform_full_entries[repeat_isoform]["direction"] == "+": # 5'->3'
            if exon_type_uniq[1] == "repeat":
                repeat_isoform_type = "TES"
        else: # 3'<-5'
            if exon_type_uniq[0] == "repeat":
                repeat_isoform_type = "TES"
        proper_repeat_derived_isoform.append((repeat_isoform, repeat_isoform_type))
        isoform_classification = repeat_isoform_type
    else:
        repeat_only_isoform.append((repeat_isoform, exon_type_uniq))
        isoform_classification = "repeat-only"

    final_classification.append(f"{repeat_isoform},{isoform_classification}")

with open(f"{assembled_annotation.rsplit('.', 1)[0]}_repeat_isoform_classification.csv", "w") as out:
    out.write("\n".join(final_classification))