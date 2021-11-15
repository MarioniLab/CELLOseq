"""
Copyright 2017 Ryan Wick (rrwick@gmail.com)
https://github.com/rrwick/Porechop

This module contains the class and sequences for known adapters used in Oxford Nanopore library
preparation kits.

This file is part of Porechop. Porechop is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by the Free Software Foundation,
either version 3 of the License, or (at your option) any later version. Porechop is distributed in
the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
details. You should have received a copy of the GNU General Public License along with Porechop. If
not, see <http://www.gnu.org/licenses/>.
"""


class Adapter(object):

    def __init__(self, name, start_sequence=None, end_sequence=None, both_ends_sequence=None):
        self.name = name
        self.start_sequence = start_sequence if start_sequence else []
        self.end_sequence = end_sequence if end_sequence else []
        if both_ends_sequence:
            self.start_sequence = both_ends_sequence
            self.end_sequence = both_ends_sequence
        self.best_start_score, self.best_end_score = 0.0, 0.0

    def best_start_or_end_score(self):
        return max(self.best_start_score, self.best_end_score)

    def is_barcode(self):
        return self.name.startswith('Barcode ')

    def barcode_direction(self):
        if '_rev' in self.start_sequence[0]:
            return 'reverse'
        else:
            return 'forward'

    def get_barcode_name(self):
        """
        Gets the barcode name for the output files. We want a concise name, so it looks at all
        options and chooses the shortest.
        """
        possible_names = [self.name]
        if self.start_sequence:
            possible_names.append(self.start_sequence[0])
        if self.end_sequence:
            possible_names.append(self.end_sequence[0])
        barcode_name = sorted(possible_names, key=lambda x: len(x))[0]
        return barcode_name.replace(' ', '_')


# INSTRUCTIONS FOR ADDING CUSTOM ADAPTERS
# ---------------------------------------
# If you need Porechop to remove adapters that aren't included, you can add your own my modifying
# the ADAPTERS list below.
#
# Here is the format for a normal adapter:
#     Adapter('Adapter_set_name',
#             start_sequence=('Start_adapter_name', 'AAAACCCCGGGGTTTTAAAACCCCGGGGTTTT'),
#             end_sequence=('End_adapter_name', 'AACCGGTTAACCGGTTAACCGGTTAACCGGTT'))
#
# You can exclude start_sequence and end_sequence as appropriate.
#
# If you have custom Barcodes, make sure that the adapter set name starts with 'Barcode '. Also,
# remove the existing barcode sequences from this file to avoid conflicts:
#     Adapter('Barcode 1',
#             start_sequence=('Barcode_1_start', 'AAAAAAAACCCCCCCCGGGGGGGGTTTTTTTT'),
#             end_sequence=('Barcode_1_end', 'AAAAAAAACCCCCCCCGGGGGGGGTTTTTTTT')),
#     Adapter('Barcode 2',
#             start_sequence=('Barcode_2_start', 'TTTTTTTTGGGGGGGGCCCCCCCCAAAAAAAA'),
#             end_sequence=('Barcode_2_end', 'TTTTTTTTGGGGGGGGCCCCCCCCAAAAAAAA'))


ADAPTERS = [Adapter('SQK-NSK007',
                    start_sequence=('SQK-NSK007_Y_Top', 'AATGTACTTCGTTCAGTTACGTATTGCT'),
                    end_sequence=('SQK-NSK007_Y_Bottom', 'GCAATACGTAACTGAACGAAGT')),
                    
            Adapter('oligo-dT_left',
            		start_sequence=('dT_left',    'GAGCCCACGAGAC'),
            		end_sequence=  ('dT_left_rev', 'GTCTCGTGGGCTC')),
            
            Adapter('tso',
            		start_sequence=('tso',    'ACACTCTTTCCTC'),
            		end_sequence=  ('tso_rev', 'GAGGAAAGAGTGT')),
            		

            # Other barcoding kits (like the PCR and rapid barcodes) use the forward barcode at the
            # start of the read and the rev comp barcode at the end of the read.
            Adapter('Barcode 1 (forward)',
                    start_sequence=('BC01', 'AAGAAAGTTGTCGGTGTCTTTGTG'),
                    end_sequence=('BC01_rev', 'CACAAAGACACCGACAACTTTCTT')),
            Adapter('Barcode 2 (forward)',
                    start_sequence=('BC02', 'TCGATTCCGTTTGTAGTCGTCTGT'),
                    end_sequence=('BC02_rev', 'ACAGACGACTACAAACGGAATCGA')),
            Adapter('Barcode 3 (forward)',
                    start_sequence=('BC03', 'GAGTCTTGTGTCCCAGTTACCAGG'),
                    end_sequence=('BC03_rev', 'CCTGGTAACTGGGACACAAGACTC')),
            Adapter('Barcode 4 (forward)',
                    start_sequence=('BC04', 'TTCGGATTCTATCGTGTTTCCCTA'),
                    end_sequence=('BC04_rev', 'TAGGGAAACACGATAGAATCCGAA')),
            Adapter('Barcode 5 (forward)',
                    start_sequence=('BC05', 'CTTGTCCAGGGTTTGTGTAACCTT'),
                    end_sequence=('BC05_rev', 'AAGGTTACACAAACCCTGGACAAG')),
            Adapter('Barcode 6 (forward)',
                    start_sequence=('BC06', 'TTCTCGCAAAGGCAGAAAGTAGTC'),
                    end_sequence=('BC06_rev', 'GACTACTTTCTGCCTTTGCGAGAA')),
            Adapter('Barcode 7 (forward)',
                    start_sequence=('BC07', 'GTGTTACCGTGGGAATGAATCCTT'),
                    end_sequence=('BC07_rev', 'AAGGATTCATTCCCACGGTAACAC')),
            Adapter('Barcode 8 (forward)',
                    start_sequence=('BC08', 'TTCAGGGAACAAACCAAGTTACGT'),
                    end_sequence=('BC08_rev', 'ACGTAACTTGGTTTGTTCCCTGAA')),
            Adapter('Barcode 9 (forward)',
                    start_sequence=('BC09', 'AACTAGGCACAGCGAGTCTTGGTT'),
                    end_sequence=('BC09_rev', 'AACCAAGACTCGCTGTGCCTAGTT')),
            Adapter('Barcode 10 (forward)',
                    start_sequence=('BC10', 'AAGCGTTGAAACCTTTGTCCTCTC'),
                    end_sequence=('BC10_rev', 'GAGAGGACAAAGGTTTCAACGCTT')),
            Adapter('Barcode 11 (forward)',
                    start_sequence=('BC11', 'GTTTCATCTATCGGAGGGAATGGA'),
                    end_sequence=('BC11_rev', 'TCCATTCCCTCCGATAGATGAAAC')),
            Adapter('Barcode 12 (forward)',
                    start_sequence=('BC12', 'CAGGTAGAAAGAAGCAGAATCGGA'),
                    end_sequence=('BC12_rev', 'TCCGATTCTGCTTCTTTCTACCTG'))]


def make_full_native_barcode_adapter(barcode_num):
    barcode = [x for x in ADAPTERS if x.name == 'Barcode ' + str(barcode_num) + ' (reverse)'][0]
    start_barcode_seq = barcode.start_sequence[1]
    end_barcode_seq = barcode.end_sequence[1]

    start_full_seq = 'AATGTACTTCGTTCAGTTACGTATTGCTAAGGTTAA' + start_barcode_seq + 'CAGCACCT'
    end_full_seq = 'AGGTGCTG' + end_barcode_seq + 'TTAACCTTAGCAATACGTAACTGAACGAAGT'

    return Adapter('Native barcoding ' + str(barcode_num) + ' (full sequence)',
                   start_sequence=('NB' + '%02d' % barcode_num + '_start', start_full_seq),
                   end_sequence=('NB' + '%02d' % barcode_num + '_end', end_full_seq))


def make_old_full_rapid_barcode_adapter(barcode_num):  # applies to SQK-RBK001
    barcode = [x for x in ADAPTERS if x.name == 'Barcode ' + str(barcode_num) + ' (forward)'][0]
    start_barcode_seq = barcode.start_sequence[1]

    start_full_seq = 'AATGTACTTCGTTCAGTTACG' + 'TATTGCT' + start_barcode_seq + \
                     'GTTTTCGCATTTATCGTGAAACGCTTTCGCGTTTTTCGTGCGCCGCTTCA'

    return Adapter('Rapid barcoding ' + str(barcode_num) + ' (full sequence, old)',
                   start_sequence=('RB' + '%02d' % barcode_num + '_full', start_full_seq))


def make_new_full_rapid_barcode_adapter(barcode_num):  # applies to SQK-RBK004
    barcode = [x for x in ADAPTERS if x.name == 'Barcode ' + str(barcode_num) + ' (forward)'][0]
    start_barcode_seq = barcode.start_sequence[1]

    start_full_seq = 'AATGTACTTCGTTCAGTTACG' + 'GCTTGGGTGTTTAACC' + start_barcode_seq + \
                     'GTTTTCGCATTTATCGTGAAACGCTTTCGCGTTTTTCGTGCGCCGCTTCA'

    return Adapter('Rapid barcoding ' + str(barcode_num) + ' (full sequence, new)',
                   start_sequence=('RB' + '%02d' % barcode_num + '_full', start_full_seq))
