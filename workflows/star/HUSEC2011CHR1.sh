#!/usr/bin/env bash

mkdir tmp cache

cwltool --debug --cachedir cache/ --tmpdir-prefix tmp/ ~/gdc-rnaseq-cwl/tools/gtftogenepred.cwl ~/gdc-rnaseq-cwl/tools/gtftogenepred_HUSEC2011CHR1.json

cwltool --debug --cachedir cache/ --tmpdir-prefix tmp/ ~/gdc-rnaseq-cwl/tools/star_generate_genome.cwl ~/gdc-rnaseq-cwl/tools/star_generate_genome_HUSEC2011CHR1.json

cwltool --debug --cachedir cache/ --tmpdir-prefix tmp/ ~/gdc-rnaseq-cwl/workflows/gtf2rrnainterval/transform.cwl ~/gdc-rnaseq-cwl/workflows/gtf2rrnainterval/transform_HUSEC2011CHR1.json

cwltool --debug --cachedir cache/ --tmpdir-prefix tmp/ ~/gdc-rnaseq-cwl/workflows/star/transform.cwl ~/gdc-rnaseq-cwl/workflows/star/transform_HUSEC2011CHR1.json
